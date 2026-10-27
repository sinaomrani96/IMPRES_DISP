# Contributing

Use the MOOSE revision in `MOOSE_REVISION`, build with `make -j2`, and run
`./run_tests -j2`. Keep extensions limited to the Point/dispersion model and register
new runtime types to `ImpresDispApp`. Preserve standard PorousFlow property names.
Format C++ with the repository `.clang-format`. Add focused numerical regressions
when changing model behavior. Generated outputs and build products stay out of Git.
The small synthetic test fields are only verification fixtures.
