## Summary

## Protocol impact

- ACP surface/version:
- Transport(s):
- Public API or wire-format change:

## Verification

- [ ] `dart run melos run codegen` leaves no diff.
- [ ] `dart run melos run schema:check`
- [ ] `dart run melos run format`
- [ ] `dart run melos run analyze`
- [ ] `dart run melos run test`
- [ ] `dart run tool/check_web_compile.dart`
- [ ] `dart run melos run test:web`
- [ ] `dart test test`
- [ ] `dart run tool/check_file_sizes.dart`
- [ ] Coverage remains at or above 95%.
- [ ] Examples, benchmarks, docs, and publish dry-run pass when affected.

## Checklist

- [ ] Public APIs have Dartdoc.
- [ ] Tests cover success, failure, malformed input, and lifecycle edges.
- [ ] Generated sources are current.
- [ ] Stable and experimental boundaries remain explicit.
- [ ] VM and browser conditional imports remain isolated.
- [ ] Security-sensitive captures are redacted.
- [ ] `CHANGELOG.md` reflects user-visible changes.
- [ ] Changes are focused and contain no unrelated edits.
