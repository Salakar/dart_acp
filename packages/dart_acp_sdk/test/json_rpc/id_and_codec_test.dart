import 'dart:convert';

import 'package:dart_acp_sdk/src/json_rpc/batch.dart';
import 'package:dart_acp_sdk/src/json_rpc/codec.dart';
import 'package:dart_acp_sdk/src/json_rpc/error.dart';
import 'package:dart_acp_sdk/src/json_rpc/id.dart';
import 'package:dart_acp_sdk/src/json_rpc/message.dart';
import 'package:dart_acp_sdk/src/json_rpc/params.dart';
import 'package:test/test.dart';

void main() {
  group('JsonRpcId', () {
    test('preserves string, numeric, and null identity', () {
      const JsonRpcId stringId = JsonRpcId.string('1');
      final JsonRpcId numberId = JsonRpcId.number(1);
      const JsonRpcId nullId = JsonRpcId.nullValue();

      expect(stringId, isNot(numberId));
      expect(stringId.correlationKey, 'string:1');
      expect(numberId.correlationKey, 'number:1');
      expect(nullId.correlationKey, 'null');
      expect(<JsonRpcId, String>{
        stringId: 'string',
        numberId: 'number',
        nullId: 'null',
      }, hasLength(3));
    });

    test('accepts only signed 64-bit integer numeric ids', () {
      final int minimum = int.parse(NumberJsonRpcId.minimumValueText);
      expect(JsonRpcId.number(minimum).toJson(), minimum);
      expect(JsonRpcId.fromJson(1.0), JsonRpcId.number(1));
      expect(() => JsonRpcId.fromJson(1.5), throwsFormatException);
      expect(() => JsonRpcId.fromJson(double.infinity), throwsFormatException);
      expect(
        () => JsonRpcId.fromJson(jsonDecode('9223372036854775808')),
        throwsFormatException,
      );
      expect(
        () => JsonRpcId.fromJson(<String, Object?>{}),
        throwsFormatException,
      );
    });
  });

  group('JsonRpcCodec', () {
    const JsonRpcCodec codec = JsonRpcCodec();

    test('distinguishes omitted params from explicit null', () {
      final JsonRpcRequest omitted =
          codec.decodeMessage(<String, Object?>{
                'jsonrpc': '2.0',
                'id': 1,
                'method': 'example/omitted',
              })
              as JsonRpcRequest;
      final JsonRpcRequest present =
          codec.decodeMessage(<String, Object?>{
                'jsonrpc': '2.0',
                'id': 2,
                'method': 'example/null',
                'params': null,
              })
              as JsonRpcRequest;

      expect(omitted.params.isPresent, isFalse);
      expect(omitted.toJson(), isNot(contains('params')));
      expect(present.params.isPresent, isTrue);
      expect(present.toJson(), containsPair('params', null));
    });

    test('requires exactly one response result member', () {
      expect(
        codec.isResponse(<String, Object?>{
          'jsonrpc': '2.0',
          'id': 1,
          'result': null,
        }),
        isTrue,
      );
      expect(
        codec.isResponse(<String, Object?>{
          'jsonrpc': '2.0',
          'id': 1,
          'error': <String, Object?>{
            'code': -32603,
            'message': 'Internal error',
          },
        }),
        isTrue,
      );
      expect(
        codec.isResponse(<String, Object?>{
          'jsonrpc': '2.0',
          'id': 1,
          'error': <String, Object?>{
            'code': -32603.0,
            'message': 'Internal error',
          },
        }),
        isTrue,
      );
      expect(
        codec.isResponse(<String, Object?>{
          'jsonrpc': '2.0',
          'id': 1,
          'error': <String, Object?>{
            'code': -32603.5,
            'message': 'Internal error',
          },
        }),
        isFalse,
      );
      expect(
        codec.isResponse(<String, Object?>{'jsonrpc': '2.0', 'id': 1}),
        isFalse,
      );
      expect(
        codec.isResponse(<String, Object?>{
          'jsonrpc': '2.0',
          'id': 1,
          'result': true,
          'error': <String, Object?>{
            'code': -32603,
            'message': 'Internal error',
          },
        }),
        isFalse,
      );
      expect(
        codec.isResponse(<String, Object?>{
          'jsonrpc': '2.0',
          'id': 1,
          'error': null,
        }),
        isFalse,
      );
    });

    test('rejects empty and mixed strict batches', () {
      expect(() => codec.decodeWireMessage(<Object?>[]), throwsFormatException);
      expect(
        () => codec.decodeWireMessage(<Object?>[
          <String, Object?>{
            'jsonrpc': '2.0',
            'id': 1,
            'method': 'example/call',
          },
          <String, Object?>{'jsonrpc': '2.0', 'id': 1, 'result': true},
        ]),
        throwsFormatException,
      );
    });

    test(
      'classifies malformed response batches without reply amplification',
      () {
        expect(
          codec.isResponseBatch(<Object?>[
            <String, Object?>{'jsonrpc': '2.0', 'id': 1, 'result': true},
            17,
            <String, Object?>{'jsonrpc': '2.0', 'error': null},
          ]),
          isTrue,
        );
        expect(
          codec.isResponseBatch(<Object?>[
            <String, Object?>{
              'jsonrpc': '2.0',
              'id': 1,
              'method': 'example/call',
            },
            <String, Object?>{'jsonrpc': '2.0', 'id': 2, 'result': true},
          ]),
          isFalse,
        );
      },
    );

    test('encodes homogeneous non-empty batches', () {
      final JsonRpcBatch batch = JsonRpcBatch(<JsonRpcMessage>[
        const JsonRpcNotification(
          method: 'example/one',
          params: JsonRpcParams.value(<String, Object?>{'ok': true}),
        ),
        const JsonRpcNotification(method: 'example/two'),
      ]);

      expect(batch.isResponseBatch, isFalse);
      expect(batch.toJson(), hasLength(2));
      expect(
        () => JsonRpcBatch(<JsonRpcMessage>[
          const JsonRpcNotification(method: 'example/call'),
          const JsonRpcSuccessResponse(id: JsonRpcId.nullValue(), result: true),
        ]),
        throwsArgumentError,
      );
    });

    test('round-trips error data presence', () {
      final JsonRpcErrorResponse response =
          codec.decodeMessage(<String, Object?>{
                'jsonrpc': '2.0',
                'id': 'request',
                'error': <String, Object?>{
                  'code': -32000,
                  'message': 'Authentication required',
                  'data': null,
                },
              })
              as JsonRpcErrorResponse;

      expect(response.error.hasData, isTrue);
      expect(response.error.data, isNull);
      expect(response.toJson()['error'], containsPair('data', null));
      expect(JsonRpcRequestException(response.error).code, -32000);
    });

    test('accepts every signed 32-bit error code', () {
      expect(
        codec.decodeError(<String, Object?>{
          'code': JsonRpcErrorObject.minimumCode,
          'message': 'minimum',
        }).code,
        JsonRpcErrorObject.minimumCode,
      );
      expect(
        codec.decodeError(<String, Object?>{
          'code': JsonRpcErrorObject.maximumCode,
          'message': 'maximum',
        }).code,
        JsonRpcErrorObject.maximumCode,
      );
      expect(
        () => codec.decodeError(<String, Object?>{
          'code': JsonRpcErrorObject.minimumCode - 1,
          'message': 'too small',
        }),
        throwsFormatException,
      );
      expect(
        () => JsonRpcErrorObject(
          code: JsonRpcErrorObject.maximumCode + 1,
          message: 'too large',
        ),
        throwsRangeError,
      );
    });
  });
}
