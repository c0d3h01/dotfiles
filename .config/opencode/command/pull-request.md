---
description: Generate pull request body from branch diff
---

Use this template for writing the PR body:

```markdown
## Summary

<diagram, diff-sketch, or tree>

## Evidence

- **Before:** <screenshot/output/failing test run>
  **After:** <screenshot/output/passing test run>

## Merge Danger

**Door:** <one-way or two-way>

<optional: description>

**Blast Radius:** <one-word description>

<optional: potential ramifications of merge>
```

## Sections

Skip all preambles and keep prose brief. Use the user's domain language from `CONTEXT.md`.

### Summary

Pick the smallest view that makes the key point clear.

- Show logic or an algorithm as pseudocode.
- Show runtime control flow as a call tree.
- Show UI structure as a component tree, including state and module boundaries that matter.
- Show file responsibility or a broad refactor as a shallow file tree.
- Show component interaction, control flow, or data flow with Mermaid.
- Use `diff` when the point is what changes and the surrounding shape already exists. Match the diff shape to the topic.
- Show the whole block when most of it is new, when omitted context would hide ownership or order, or when the user needs a copyable target shape.

#### Guidance

Place each visual next to the short text it supports. Keep only the calls, files, props, states, and boundaries needed to answer the user's current question or the options to resolve the current discussion point.

You may use one of these, you may use several, it is unlikely you will use all of them. Use your judgement and don't overwhelm the user.

### Evidence

Concrete evidence that the change works. Show a before and after.

Screenshots are S-tier - when the environment is set up for it and the change is visual.

Execution-based evidence is A-tier. Test results, console output. Show the exact test that now fails and passes, using pseudocode.

### Merge Danger

Describe whether it's a one-way or two-way door. You can walk back through two-way doors, but not one-way doors. A PR that is cheap to roll back is lower risk. Changes that involve destructive actions or hard-to-reverse decisions are one-way doors.

The blast radius is the potential impact or scope of the changes introduced by this PR. Consider all possibilities. Examples are layout shift, breakages for consumers, mobile responsiveness, etc.

Diff source: `$ARGUMENTS` if given (base ref), else `git diff origin/main...HEAD`, fallback to `git diff --staged`.

Output PR body ready to paste. Do not push, do not create PR.
