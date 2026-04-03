# AGENTS

## Project Direction

- Build this project as a local CLI first.
- Use Jane Street libraries by default.
- Use `Command` for the command-line interface.
- Keep the first end-to-end version focused on a single problem: `Two Sum`.

## Implementation Preferences

- Prefer `Base` and `Stdio` over the OCaml standard library when practical.
- Structure new code so the judging logic can later be reused by a TUI or web app.
- Optimize first for a clean local developer workflow: read a submission, compile it, run tests, and print a clear result.

## Initial Scope

- Accept an OCaml submission file from the CLI.
- Compile the submission together with a generated test harness.
- Run the resulting executable against sample and hidden test cases.
- Report `Accepted`, `Wrong Answer`, `Runtime Error`, or `Compile Error`.

## Out Of Scope
- Using Async to judge multiple test cases concurrently
- GUI

## Near-Term Architecture

- `bin/main.ml`: `Command` entrypoint and CLI wiring.
- `lib/problem.ml`: problem definitions and test cases.
- `lib/judge.ml`: compilation, execution, and result collection.
- `lib/report.ml`: user-facing result formatting.

## Notes

- Before adding more problems, make the `Two Sum` path feel solid and pleasant to use.
- Prefer small, composable modules over one large runner file.
