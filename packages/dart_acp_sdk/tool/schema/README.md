# ACP schema generation

The checked snapshots in `snapshots/` are the only inputs used by ordinary
builds. Public models and method descriptors are generated from the official
`agent-client-protocol` v1/v2 baseline and unstable-overlay schemas. The
TypeScript SDK snapshots are compatibility evidence and are structurally
compared with the official unstable schemas.

From the workspace root, run the complete offline deterministic pipeline with:

```sh
dart run melos run codegen
```

That command regenerates schema sources, runs `json_serializable`, and formats
all generated protocol output. CI can verify the schema-emitted portion without
changing it:

```sh
dart run melos run schema:check
```

The same generator emits platform-neutral executable conformance matrices
under `test/protocol/generated/conformance/generated/`. They exercise every
named definition, serializer branch, and method descriptor in all four lanes.
`conformance_report.json` is the checked machine-readable inventory linking
every emitted model/codec declaration to its cases and proving that the
uncovered declaration and method sets are empty. Run the matrix on both
supported runtimes with:

```sh
dart test test/protocol/generated/generated_conformance_test.dart
dart test -p chrome test/protocol/generated/generated_conformance_test.dart
```

The VM matrix can emit LCOV and enforce at least 95% line coverage separately
for every physical generated lane and for their aggregate:

```sh
dart test \
  --coverage-path=coverage/generated-lcov.info \
  test/protocol/generated/generated_conformance_test.dart
dart run tool/schema/check_generated_coverage.dart \
  --lcov=coverage/generated-lcov.info \
  --minimum=95
```

The gate includes every executable line reported beneath the four committed
generated directories. Whole-file and range ignores are forbidden. Any
line-level ignore must carry a generator justification and match the exact
count and detail inventory in `conformance_report.json`; the current count is
zero.

Network access is explicit. `sync.dart` first resolves both GitHub `main`
branches to immutable commits, downloads the complete SDK `schema/` tree and
all eight official baseline/overlay schema and metadata files, verifies drift,
and records immutable URLs and SHA-256 hashes:

```sh
dart run tool/schema/sync.dart --check
dart run tool/schema/sync.dart --update
```

`--check` reports upstream movement without writing. `--update` replaces the
snapshots and manifest only after the candidate inputs pass digest and drift
validation, then runs both generation stages and formats their output. Any
structural difference not listed in `drift_allowlist.json` fails.
`drift_report.json` is regenerated from the snapshots and records the reviewed
elicitation, removed `env_var`, and unstable terminal-auth evidence.
