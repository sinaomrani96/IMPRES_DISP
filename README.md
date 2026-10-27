# IMPRES_DISP

A small MOOSE/PorousFlow application containing only the custom code needed by
`examples/point/Point.i`: tracer dispersion, variable-viscosity/constant-density
fluid behavior, grid-file initial conditions, and pressure-dependent sink boundaries.
It is independent of IMPRES_KIN and contains no custom salt, evaporation, or halite code.

## Build

Install Conda/Miniforge using the
[MOOSE installation guide](https://mooseframework.inl.gov/getting_started/installation/conda.html),
then run:

```bash
conda env create -f environment.yml  # once; reuse an existing matching environment if present
conda activate moose
./scripts/checkout_moose.sh          # optional if a compatible ../moose already exists
make -j2
./run_tests -j2
```

For another MOOSE location, set `MOOSE_DIR=/absolute/path/to/moose` before building
and running tests. Only `POROUS_FLOW := yes` is enabled explicitly; MOOSE selects its
module dependencies. The tested dependency revision is in `MOOSE_REVISION`.
The checkout helper retrieves that exact revision from `cpgr/moose`.

## Point input and field data

`examples/point/Point.i` preserves the supplied mesh, constitutive expressions,
boundary conditions, and time settings. Custom `type` names were updated using
[`doc/class_names.json`](doc/class_names.json).

The production case requires the user's **perm.txt** and **poro.txt** in the same
directory as the input. They are user-provided input data and are intentionally not bundled with the application source. Each file uses this format:

```text
# Description
nx = 2, ny = 2, nz = 1
dx = 0.03, dy = 0.03, dz = 1
value_at_x0_y0_z0
value_at_x1_y0_z0
value_at_x0_y1_z0
value_at_x1_y1_z0
```

There must be `nx*ny*nz` values with x varying fastest, then y, then z. The grid
must cover the input domain: x and y from 0 to 0.06 m. Porosity is dimensionless;
permeability uses the units expected by the PorousFlow model (m^2).

After supplying the production data:

```bash
cd examples/point
../../impres_disp-opt -i Point.i --check-input
../../impres_disp-opt -i Point.i
```

Run from the input directory because the migrated file reader resolves data paths
against the current working directory. The production mesh is 600 by 600 cells,
and the final time is 2381; a complete run can require substantial resources.

## Verification

`test/tests/point` contains explicitly **synthetic** 2x2 permeability/porosity
fields and a separate 8x8, two-step Point smoke input. The fixtures are not replacements
for the production datasets. Tests check model setup, transient convergence, nonzero mechanical dispersion,
field averages, and component mass conservation.
See `doc/verification.md` for the recorded results and limits.

## Custom source set

Five object types are used directly by Point.i:

| Original name | IMPRES_DISP name |
| --- | --- |
| MyDispersion | ImpresDispDispersion |
| MySimpleFluid | ImpresDispSimpleFluid |
| MyIC | ImpresDispFileInitialCondition |
| MyFluid | ImpresDispConstantDensityFluid |
| MyLinearSink | ImpresDispLinearSink |

Four supporting classes complete their dependency closure:
`ImpresDispSinglePhaseFluidProperties`, `ImpresDispGridField`,
`ImpresDispSinkPTDefiner`, and `ImpresDispSink`.
There are nine custom `.C`/`.h` pairs, plus the standard application scaffold.
All custom runtime registrations use `ImpresDispApp`; framework names and material
property names retain their MOOSE interface names. The original license/attribution
and numerical implementations are retained.
