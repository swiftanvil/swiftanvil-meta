# Agent Diagnostics

Use this document when agent commands fail during planning, review, or enforcement.

## Reviewer Authentication Failures

If an installed reviewer CLI reports an authentication error, first check whether the current session is running with a sandboxed or redirected `HOME`.

### Symptoms

- A reviewer CLI works in the user's normal terminal but fails from an agent session.
- Claude reports invalid authentication credentials.
- Gemini reports missing auth configuration.
- The error path points into an agent-specific home directory instead of the user's login home.

### Required Diagnosis

Run:

```sh
env | sort | grep -E '^(HOME|USER|SHELL|CODEX|CLAUDE|GEMINI|KIMI)='
printf 'tilde=%s\n' ~
```

If `HOME` points to a sandbox home such as a tool-specific runtime directory, do not conclude that the reviewer is unauthenticated.

### Fix

Use the enforcement review runner:

```sh
../swiftanvil-enforcement/scripts/run-agent-review.sh \
  --agent claude \
  --request Reviews/<request>.md \
  --output Reviews/<review>.md
```

The runner resolves the user's login home and runs the reviewer CLI with that home so it can find its normal credentials.

To override the home directory explicitly:

```sh
SWIFTANVIL_AGENT_HOME="$HOME" ../swiftanvil-enforcement/scripts/run-agent-review.sh \
  --agent claude \
  --request Reviews/<request>.md \
  --output Reviews/<review>.md
```

Use the actual login home in `SWIFTANVIL_AGENT_HOME` when the current `HOME` is sandboxed.

### Gemini Headless Mode

Gemini may also require trusted-folder configuration in non-interactive mode. The review runner sets the required headless trust flags for Gemini.

### Genuine Fallbacks

Only after home-directory diagnosis and at least one corrected-home retry should a reviewer be treated as unavailable.

If the corrected-home retry still fails, document the concrete failure:

- usage limit exhausted
- account not authenticated
- missing executable
- provider outage
- network failure
- model unavailable

Then try another independent reviewer before falling back to self-review.

## Review Artifact Rules

- Capture full reviewer output to a file.
- Preserve failed attempts if they explain why fallback was needed.
- Sanitize local absolute paths, credentials, and account-specific details before committing public artifacts.
- Never claim independent review succeeded unless the artifact contains actual independent output.
