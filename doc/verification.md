# Verification: 2 November 2026

The application compiled with `make -j2` against official `idaholab/moose`
revision `9e3f8b1b61b71b867d87edc071300d38794106f7`, a `next` snapshot dated
2 November 2026. That source requires `moose-dev=2026.10.19=mpich`, recorded in
`environment.yml`. The compatibility build used the exact pinned libMesh revision
`342ad76b0c867273316a8a00f8e583810ece759e`. Framework, FluidProperties,
PorousFlow, all custom application sources, the test library, and
`impres_disp-opt` compiled and linked successfully. No IMPRES_KIN library is linked.

`./run_tests -j2` passed all four focused tests, with no skips or failures:

1. Point setup and object registration.
2. Two converged transient steps on an 8x8 mesh.
3. The same model with nonzero longitudinal/transverse mechanical dispersion.
4. The expected heterogeneous field averages, positive tracer influx and viscosity,
   and total component mass conservation for both short transient runs.

The synthetic test grid has permeability averaging `1.25e-12 m^2` and porosity
averaging `0.25`. Both short runs recover those averages, density `1000 kg/m^3`,
and total component mass `0.9` for this 2D unit-depth domain, at times 0.1 and 0.2.
C++ formatting and staged whitespace checks passed.

The production `Point.i` uses a 1200x400 mesh over 0.12x0.04 m and final time
2381. The uploaded production `perm.txt` and `poro.txt` are included, and
`Point.i --check-input` reports `Syntax OK`. The production-scale transient was
not run. The 8x8 smoke input explicitly uses its separate 0.06x0.06 m synthetic
domain and fixtures.

Only nine custom source/header pairs were migrated, preserving their numerical
implementations and replacing `My...` / `ImpresKin...` names with `ImpresDisp...`.
The selected code has no custom kinetic, equilibrium salt, evaporation, or halite
objects. MOOSE supplies its existing module functionality.
