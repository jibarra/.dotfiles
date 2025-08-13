- Use comments sparingly. Only explain what code is doing when the code is very complex.
- Keep code changes small and focused - aim for atomic commits that address one specific issue or feature at a time. Break larger tasks into smaller, separable tasks that can be reviewed, tested, and committed independently. Each change should be self-contained and have a clear purpose.
- When removing code (methods, classes, constants, etc.), always identify and handle all references to that code. This includes: updating imports, removing method calls, updating tests, cleaning up configuration files, and addressing any dependencies. Don't leave dangling references that would cause compilation errors or runtime issues.
- When we update code, we should run tests for that file (if they exist) to ensure we didn't break anything
- When we run tests for ruby files, we should use bin/rspec instead of just rspec.


- When writing tests, don't use mocks unless we're accessing an external service.
- When testing, avoid mocking unless we need to make a call to an external service.
- When we update code, we should run linters to ensure that the code matches our rules. For ruby, we use rubocop and can use bin/rubocop for to run it.