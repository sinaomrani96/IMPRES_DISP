# IMPRES_DISP

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
