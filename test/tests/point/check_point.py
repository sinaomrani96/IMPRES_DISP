"""Check actual short-run results for the explicitly synthetic Point fixtures."""
import csv
import math
from pathlib import Path


def close(actual, expected, label, absolute=1e-10):
    if not math.isclose(float(actual), expected, rel_tol=1e-8, abs_tol=absolute):
        raise AssertionError(f"{label}: expected {expected}, received {actual}")


for stem in ("point_transient", "point_dispersion"):
    with Path(f"{stem}.csv").open(newline="") as stream:
        rows = list(csv.DictReader(stream))
    evolved = [row for row in rows if float(row["time"]) > 0]
    assert len(evolved) == 2, (stem, "expected two converged steps")
    close(evolved[-1]["time"], 0.2, stem + " final time")
    for row in evolved:
        close(row["porosity"], 0.25, stem + " mean porosity")
        close(row["permeability"], 1.25e-12, stem + " mean permeability", 1e-22)
        close(row["density_water"], 1000.0, stem + " density")
        # Initial total mass: area 0.06*0.06 * mean porosity 0.25 * density 1000.
        close(float(row["tracer_mass"]) + float(row["water_mass"]), 0.9, stem + " mass")
        assert float(row["tracer_mass"]) > 0, (stem, "tracer must enter the domain")
        assert float(row["vis_liq"]) > 0, (stem, "viscosity must remain positive")
print("Point field averages, tracer transport, and component mass checks passed")
