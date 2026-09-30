---
description: Implement feature or fix via failing test first
---

# Test-Driven Development (TDD)

Write the test first. Watch it fail. Write minimal code to pass.

**Core principle:** If you didn't watch the test fail, you don't know if it tests the right thing.

RED (watch it fail) → GREEN minimal → REFACTOR.

## When to Use

**Always:** new features, bug fixes, refactoring, behavior changes.

**Exceptions (ask your human partner):** throwaway prototypes, generated code, configuration files.

## The Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

Write code before the test? Delete it. Start over. No keeping it as "reference", no adapting — delete means delete.

### RED - Write Failing Test

One minimal test, one behavior, clear name, real code (no mocks unless unavoidable).

### Verify RED - Watch It Fail

**MANDATORY. Never skip.** Confirm: test fails (not errors), failure message expected, fails because feature missing (not typos). Passes already? You're testing existing behavior — fix the test.

### GREEN - Minimal Code

Simplest code to pass. No extra features, no refactoring other code, no "improvements" beyond the test.

### Verify GREEN - Watch It Pass

**MANDATORY.** Confirm: test passes, full suite still green, output pristine (no errors, warnings). Other tests fail? Fix now. "Other tests" means the project's whole suite (`pytest`, `npm test`, `cargo test`) — a red test you ignore is a report falsified by omission.

### REFACTOR - Clean Up

After green only: remove duplication, improve names, extract helpers. Keep tests green. Don't add behavior. Then repeat with the next failing test.

## Good Tests

| Quality          | Good                                | Bad                                                 |
| ---------------- | ----------------------------------- | --------------------------------------------------- |
| **Minimal**      | One thing. "and" in name? Split it. | `test('validates email and domain and whitespace')` |
| **Clear**        | Name describes behavior             | `test('test1')`                                     |
| **Shows intent** | Demonstrates desired API            | Obscures what code should do                        |

Rules that keep tests honest:

- Name the production change that would make the test fail — before writing it
- Assert on real behavior, never on mock behavior
- Keep test-only code in test utilities, out of production classes
- Understand a dependency's side effects before mocking it

## Red Flags - STOP and Start Over

Code before test. Test after implementation. Test passes immediately. "Keep as reference". "Just this once". "Already manually tested". **All mean: delete code, start over with TDD.**

## Verification Checklist

- [ ] Every new function/method has a test
- [ ] Watched each test fail before implementing, for the expected reason
- [ ] Wrote minimal code to pass each test
- [ ] All tests pass, output pristine
- [ ] Tests use real code, edge cases and errors covered

## When Stuck

| Problem                | Solution                                                             |
| ---------------------- | -------------------------------------------------------------------- |
| Don't know how to test | Write wished-for API. Write assertion first. Ask your human partner. |
| Test too complicated   | Design too complicated. Simplify interface.                          |
| Must mock everything   | Code too coupled. Use dependency injection.                          |
| Test setup huge        | Extract helpers. Still complex? Simplify design.                     |

Bug found? Write failing test reproducing it first. Never fix bugs without a test.

## Final Rule

```
Production code → test exists and failed first
Otherwise → not TDD
```

No exceptions without your human partner's permission.

Target: `$ARGUMENTS`. No production code without a failing test first. Run full suite before done.
