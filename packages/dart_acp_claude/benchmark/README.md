# Benchmarks

Run the reproducible suite:

```sh
dart run benchmark/adapter_benchmark.dart
```

Run one untimed operation of every scenario in CI or during development:

```sh
dart run benchmark/adapter_benchmark.dart --smoke
```

The suite measures a 1,000-block prompt, 100 mixed assistant blocks, a 64 KiB
tool result with a trailing usage block, and a 100-question form. Timings vary
by machine and should be treated as indicative rather than guarantees.

## Reference run

Measured on 2026-07-30 with Dart 3.12.2 on macOS arm64. Values are per
benchmark iteration and are indicative rather than performance guarantees.

| Scenario | Runtime |
| --- | ---: |
| `prompt.blocks_1000` | 6,909.2 µs |
| `message.mixed_blocks_100` | 2,188.2 µs |
| `tool_result.text_64k` | 1,393.6 µs |
| `elicitation.questions_100` | 11,244.4 µs |
