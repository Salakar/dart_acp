# Benchmarks

The benchmark suite measures codec/framing work, application turns, JSON-RPC
dispatch, session routing, bounded fan-out, registry cleanup, and end-to-end
transports. Results are measurements, not contractual performance guarantees.

The committed baseline was measured on 2026-07-29 with Dart 3.12.2 on macOS
ARM64, using 16 logical processors. Full machine-readable values are in
[`results.json`](results.json).

## Codec, application, and routing results

`benchmark_harness` values are microseconds per benchmark operation.

| Workload                                          | Microseconds |
| ------------------------------------------------- | -----------: |
| Decode a 100-message JSON-RPC batch               |      194.847 |
| Generated plan/open-union round trip              |      520.688 |
| Stable-v1 prompt turn, 1 session                  |       15.626 |
| Stable-v1 prompt turn, 100 sessions               |       14.594 |
| Dispatch 1 pending response                       |        2.194 |
| Dispatch 100 pending responses                    |      160.039 |
| Dispatch 1,000 pending responses                  |    1,617.534 |
| Dispatch 50 requests + 50 notifications           |      142.378 |
| Route lookup with 1 session                       |      336.065 |
| Route lookup with 100 sessions                    |      393.394 |
| Route lookup with 10,000 sessions                 |      553.139 |
| Fan-out with capacity 1,024 and a paused consumer |      176.987 |
| Close a 100-connection registry                   |      196.799 |
| Decode 100 multiline SSE events                   |      164.043 |

## NDJSON partition results

These cases encode and decode the same payload under different stream
partitioning. Values are microseconds.

| Payload        | Chunks | Microseconds |
| -------------- | -----: | -----------: |
| 1 KiB          |      1 |        4.075 |
| 1 KiB          |     64 |        8.714 |
| 1 KiB          |  1,024 |       83.331 |
| 1 MiB          |      1 |    2,777.767 |
| 1 MiB          |     64 |    2,916.016 |
| 1 MiB          |  1,024 |    2,880.753 |
| 10 MiB Unicode |  1,024 |   25,574.570 |

## End-to-end transport latency

Each transport completed 20 request/response iterations. Values are
microseconds and include setup work performed by the benchmark scenario.

| Transport           |     p50 |     p95 |
| ------------------- | ------: | ------: |
| In-process          |   1,895 |   2,835 |
| stdio child process | 568,016 | 600,019 |
| HTTP/SSE loopback   |   5,128 |   8,164 |
| WebSocket loopback  |   2,809 |   3,550 |

The stdio scenario includes launching a fresh child process, so it should not
be compared with steady-state socket latency.

## Run

From the package directory:

```console
dart run benchmark/codec_benchmark.dart
dart run benchmark/application_benchmark.dart
dart run benchmark/connection_benchmark.dart
dart run benchmark/routing_benchmark.dart
dart run benchmark/transport_benchmark.dart
```

For a fast functional check of every benchmark entrypoint:

```console
dart run tool/smoke_benchmarks.dart
```

Record hardware, operating system, Dart version, iteration count, and any
changed workload parameters when comparing results.
