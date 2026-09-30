---
description: Debug bug or failure following systematic-debugging phases
---

# Systematic Debugging

**Core principle:** ALWAYS find root cause before attempting fixes. Symptom fixes are failure.

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

If you haven't completed Phase 1, you cannot propose fixes.

## The Four Phases

You MUST complete each phase before proceeding to the next.

### Phase 1: Root Cause Investigation

**BEFORE attempting ANY fix:**

1. **Read Error Messages Carefully** — don't skip errors or warnings, read stack traces completely, note line numbers, file paths, error codes.
2. **Reproduce Consistently** — exact steps, every time? If not reproducible → gather more data, don't guess.
3. **Check Recent Changes** — git diff, recent commits, new dependencies, config changes, environmental differences.
4. **Gather Evidence in Multi-Component Systems** — for EACH component boundary log what enters, what exits, verify env/config propagation:

   ```
   For EACH component boundary:
     - Log what data enters component
     - Log what data exits component
     - Verify environment/config propagation
     - Check state at each layer

   Run once to gather evidence showing WHERE it breaks
   THEN analyze evidence to identify failing component
   THEN investigate that specific component
   ```

5. **Trace Data Flow** — where does bad value originate? What called this with bad value? Keep tracing up until you find the source. Fix at source, not at symptom.

### Phase 2: Pattern Analysis

1. **Find Working Examples** — locate similar working code in same codebase.
2. **Compare Against References** — read reference implementation COMPLETELY, don't skim.
3. **Identify Differences** — list every difference, however small. Don't assume "that can't matter".
4. **Understand Dependencies** — settings, config, environment, assumptions.

### Phase 3: Hypothesis and Testing

1. **Form Single Hypothesis** — "I think X is the root cause because Y". Specific, not vague.
2. **Test Minimally** — SMALLEST possible change, one variable at a time.
3. **Verify Before Continuing** — worked? → Phase 4. Failed? NEW hypothesis. DON'T stack fixes.
4. **When You Don't Know** — say so, don't pretend. Ask, research more.

### Phase 4: Implementation

1. **Create Failing Test Case** — simplest reproduction, MUST have before fixing.
2. **Implement Single Fix** — root cause, ONE change, no bundled refactoring.
3. **Verify Fix** — test passes? Nothing else broken? Issue resolved?
4. **If Fix Doesn't Work** — count tries. < 3: return to Phase 1. **≥ 3: STOP, question architecture:**
   - Each fix reveals new problem elsewhere? Massive refactoring needed? Fixes create new symptoms?
   - Is this pattern fundamentally sound, or inertia? Refactor vs. more symptom fixes?
   - Discuss with your human partner before attempting more fixes.

## Red Flags - STOP and Follow Process

- "Quick fix for now", "just try X", "skip the test", "probably X", "one more fix attempt" (after 2+)
- Proposing solutions before tracing data flow
- **ALL mean: STOP. Return to Phase 1.**

## Quick Reference

| Phase                 | Key Activities                                         | Success Criteria            |
| --------------------- | ------------------------------------------------------ | --------------------------- |
| **1. Root Cause**     | Read errors, reproduce, check changes, gather evidence | Understand WHAT and WHY     |
| **2. Pattern**        | Find working examples, compare                         | Identify differences        |
| **3. Hypothesis**     | Form theory, test minimally                            | Confirmed or new hypothesis |
| **4. Implementation** | Create test, fix, verify                               | Bug resolved, tests pass    |

## When Process Reveals "No Root Cause"

Environmental, timing-dependent, or external: document what you investigated, implement handling (retry, timeout, error message), add monitoring. **But:** 95% of "no root cause" cases are incomplete investigation.

Symptom: `$ARGUMENTS`. Reproduce, trace to source, one hypothesis at a time.

After 3 failed fixes → stop, question architecture with user.
