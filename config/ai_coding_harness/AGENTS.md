## Before coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick one silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## Code style

- Use comments sparingly. Explaining why something was done in comments is more useful than what is done. Only explain what code is doing when the code is very complex.
- Minimize call-stack depth. If understanding a piece of code requires chasing through many methods — and especially many files — that's a problem. Prefer flat, explicit code over multi-layer dispatch.
- Prefer boring and explicit over clever and magical. Small surfaces beat big ones (a method that does one thing beats a method with seven optional parameters). If a solution feels clever, ask whether a boring version would work — boring wins.
- Match the style of the surrounding code, even if you'd do it differently.

## Scope and design

**Minimum code that solves the problem. Nothing speculative.**

- Keep code changes small and focused - aim for atomic commits that address one specific issue or feature at a time. Break larger tasks into smaller, separable tasks that can be reviewed, tested, and committed independently. Each change should be self-contained and have a clear purpose.
- Touch only what you must. Every changed line should trace directly to the request — no features beyond what was asked, no drive-by refactors of things that aren't broken, no speculative changes.
- Default to YAGNI (You Aren't Gonna Need It):
  - No abstractions for single-use code.
  - No "flexibility" or "configurability" that wasn't requested.
  - No error handling for impossible scenarios.
  - If you write 200 lines and it could be 50, rewrite it.
- The wrong abstraction is worse than no abstraction — if you don't yet know the right shape, duplicate the code. Three concrete side-by-side implementations will teach you the correct abstraction more reliably than a premature one everyone has to bend around.
- Before you finish, ask: "Would a senior engineer say this is overcomplicated?" If yes, simplify.
- For non-trivial design decisions, discuss the approach before implementing. Lay out the tradeoffs, propose a recommendation, and wait for a green light. Terse command-style "just build it" is fine for small changes; anything with architectural implications deserves a short design conversation first.

## Making changes

**Touch only what you must. Clean up only your own mess.**

- When removing code (methods, classes, constants, etc.), always identify and handle all references to that code. This includes: updating imports, removing method calls, updating tests, cleaning up configuration files, and addressing any dependencies. Don't leave dangling references that would cause compilation errors or runtime issues.
- Clean up after yourself: remove the imports, variables, and functions your own edits orphaned. Leave anything that existed before your change untouched unless the request explicitly calls for it — if you notice unrelated dead code, mention it, don't delete it.

## Execution

**Define success criteria. Loop until verified.**

- Transform vague tasks into verifiable goals:
  - "Add validation" → "Write tests for invalid inputs, then make them pass"
  - "Fix the bug" → "Write a test that reproduces it, then make it pass"
  - "Refactor X" → "Ensure tests pass before and after"
- For multi-step tasks, state a brief plan with a verification step for each:
  ```
  1. [Step] → verify: [check]
  2. [Step] → verify: [check]
  ```
- Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

## Testing

- When we update code, we should run tests for that file (if they exist) to ensure we didn't break anything
- When testing, avoid mocking unless we need to make a call to an external service.
