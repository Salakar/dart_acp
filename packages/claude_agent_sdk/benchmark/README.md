# Benchmarks

`model_benchmark.dart` measures construction and immutable copying of the
high-frequency tool-use message model.

```console
dart run benchmark/model_benchmark.dart
dart run tool/smoke_benchmark.dart
```

Benchmarks intentionally exclude Claude CLI and model latency.
