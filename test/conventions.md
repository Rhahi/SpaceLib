# SpaceLib Test conventions

## Filename
- test_ when connection to spacecraft is not required.
- krpc_ when KRPC connection is needed.
- once_ when test has assumptions that cannot be used repeatedly (implies krpc_).
- end with _ex.jl for external tests, that will not be committed to the repository.

## Importing
- Always use exported names for the module it is testing, if possible.
- Always use full SpaceLib.ModuleName.functionmame for code that's not under test.

## Collecting
- Collect krpc_ tests under `runKrpcTests.jl`.
- Collect test_ tests under `runDryTests.jl`.

## Misc
- Do not use logging functions, unless the logger is under test.
- Do not leave files after test.
