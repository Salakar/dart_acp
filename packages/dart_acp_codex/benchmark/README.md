# Benchmarks

Run the reproducible suite:

```sh
dart run benchmark/adapter_benchmark.dart
```

Run one untimed operation of every scenario in CI or during development:

```sh
dart run benchmark/adapter_benchmark.dart --smoke
```

The suite measures 1,000 message/terminal/mixed event mappings, 100-item
history replay, 10,000 lookups across 1,000 sessions, and a 100-entry
serialized steering queue. Timing depends on the host, so release notes should
record the Dart version, operating system, CPU, and complete output together.

## Reference run

Measured on 2026-07-30 with Dart 3.12.2 on macOS arm64. Values are per
benchmark iteration and are indicative rather than performance guarantees.

| Scenario | Runtime |
| --- | ---: |
| `event.message_delta.1000` | 11,818 µs |
| `event.mixed.1000` | 48,776.9 µs |
| `history.replay.items_100` | 1,691.7 µs |
| `session.routing.sessions_1000` | 5,280.6 µs |
| `steering.queue.entries_100` | 21.1 µs |
