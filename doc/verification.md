# Verification: 27 October 2026

The application compiled with `make -j2` using the environment in `environment.yml`
and the MOOSE revision in `MOOSE_REVISION`. It was compiled against the clean
PorousFlow and FluidProperties source snapshots prepared for the previous migration.
Dynamic linkage was checked: clean module libraries are used, and no IMPRES_KIN
library is linked. No compiler warnings or errors were reported for this build.

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

The supplied production `Point.i` retains its 600x600 mesh and final time 2381.
It was migrated by replacing only the custom type names and whitespace; numerical
settings were not changed. Production permeability and porosity files are external
user inputs and are intentionally not included. The production-scale transient was
not run. Small synthetic fixtures are confined to the regression test directory.

Only nine custom source/header pairs were migrated, preserving their numerical
implementations and replacing `My...` / `ImpresKin...` names with `ImpresDisp...`.
The selected code has no custom kinetic, equilibrium salt, evaporation, or halite
objects. MOOSE supplies its existing module functionality.
