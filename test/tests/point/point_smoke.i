# Reduced mesh and short transient with synthetic fields for automated verification.
!include ../../../examples/point/Point.i

[Mesh/gen]
  nx := 8
  ny := 8
  xmax := 0.06
  ymax := 0.06
[]

[Executioner]
  end_time := 0.2
  num_steps = 2
[]

[Outputs/csv]
  sync_only := false
  execute_on = 'INITIAL TIMESTEP_END'
[]
