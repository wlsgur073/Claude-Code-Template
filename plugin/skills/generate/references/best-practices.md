# Generation Best Practices

Follow these rules when generating configuration files.

- **Be specific and verifiable** — "Use 2-space indentation" not "Format code properly"
- **Omit obvious information** — don't state what Claude can infer from reading the code
- **All commands must be copy-pasteable** — use actual project commands, not placeholders
- **Use actual directory names** — reference the project's real structure, not generic examples
- **CLAUDE.md must stay under 200 lines** — be concise
- **Merge, don't overwrite** — if a config file already exists, merge new content in
- **Skills should use `$ARGUMENTS`** — if the skill accepts parameters, parse them from `$ARGUMENTS` in Step 1 instead of asking the user
- **Skills should bundle reference files** — when a skill needs project context (conventions, examples), put them in a `references/` directory alongside SKILL.md
- **Hooks should use `statusMessage`** — every hook entry must include a `statusMessage` so the user sees feedback while it runs
