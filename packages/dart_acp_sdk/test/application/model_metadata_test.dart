import 'package:dart_acp_sdk/dart_acp_sdk.dart';
import 'package:test/test.dart';

void main() {
  test('model input modalities round-trip through generic option metadata', () {
    const video = AcpModelInputModality('video');
    final option = SessionConfigSelectOption(
      value: SessionConfigValueId('multimodal'),
      name: 'Multimodal',
      meta: acpModelOptionMeta(
        inputModalities: const <AcpModelInputModality>[
          AcpModelInputModality.text,
          AcpModelInputModality.image,
          video,
        ],
      ),
    );

    expect(option.meta?.toObject(), <String, Object?>{
      'inputModalities': <Object?>['text', 'image', 'video'],
    });
    final decoded = SessionConfigSelectOption.fromJson(option.toJson());
    expect(decoded.modelInputModalities, <AcpModelInputModality>{
      AcpModelInputModality.text,
      AcpModelInputModality.image,
      video,
    });
  });

  test('malformed model modality metadata is treated as unpublished', () {
    final option = SessionConfigSelectOption(
      value: SessionConfigValueId('text'),
      name: 'Text',
      meta: AcpJsonObject.fromObject(<String, Object?>{
        'inputModalities': 'image',
      }),
    );

    expect(option.modelInputModalities, isNull);
  });

  test('an explicit empty modality inventory remains distinguishable', () {
    final option = SessionConfigSelectOption(
      value: SessionConfigValueId('none'),
      name: 'None',
      meta: acpModelOptionMeta(
        inputModalities: const <AcpModelInputModality>[],
      ),
    );

    expect(option.modelInputModalities, isEmpty);
  });

  test('generic metadata is preserved and input modalities stay canonical', () {
    final meta = acpModelOptionMeta(
      inputModalities: const <AcpModelInputModality>[
        AcpModelInputModality.text,
      ],
      additionalMetadata: AcpJsonObject.fromObject(<String, Object?>{
        'provider.example/quality': 'fast',
        'inputModalities': <Object?>['image'],
      }),
    );

    expect(meta.toObject(), <String, Object?>{
      'provider.example/quality': 'fast',
      'inputModalities': <Object?>['text'],
    });
  });
}
