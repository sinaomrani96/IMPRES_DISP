[Mesh]
  [gen]
  type = GeneratedMeshGenerator
  dim = 2
  nx = 600
  ny = 600
  xmax = 0.06
  ymax = 0.06
  []
[]

    [GlobalParams]
      PorousFlowDictator = 'dictator'
      gravity = '0 0 0'
    []

    [AuxVariables]
      [viscosity_liq]
        order = CONSTANT
        family = MONOMIAL
      []
      [mfp0c0]
        order = CONSTANT
        family = MONOMIAL
      []
      [mfp0c1]
        order = CONSTANT
        family = MONOMIAL
      []
      [perm_field]
          family = MONOMIAL
          order = CONSTANT
      []
      [porosity_field]
        family = MONOMIAL
        order = CONSTANT
      []
      [density]
        family = MONOMIAL
        order = CONSTANT
      []
      [porosityn]
        family = MONOMIAL
        order = CONSTANT
      []
      [permeability]
        family = MONOMIAL
        order = CONSTANT
      []
      [liq_velocityx]
        family = MONOMIAL
        order = CONSTANT
        initial_condition = 0
      []
      [liq_velocityy]
        family = MONOMIAL
        order = CONSTANT
        initial_condition = 0
      []
      [shearratepropvar]
        family = MONOMIAL
        order = CONSTANT
        initial_condition = 0
      []
      [shearrateviscosityvar]
        family = MONOMIAL
        order = CONSTANT
        initial_condition = 0
      []
      [flux_in1]
      []
      [flux_in2]
      []
      [flux_in0]
      []
    []

    [AuxKernels]
      [material_for_shearrate]
        type = MaterialRealAux
        variable = shearratepropvar
        property = shearrateprop
        execute_on = 'TIMESTEP_END LINEAR'
      []
      [material_for_viscosity]
        type = MaterialRealAux
        variable = shearrateviscosityvar
        property = shearrateviscosity
        execute_on = 'TIMESTEP_BEGIN LINEAR'
      []
      [viscosity_liq]
        type = PorousFlowPropertyAux
        variable = viscosity_liq
        property = viscosity
        phase = 0
        execute_on = 'TIMESTEP_END'
      []
      [mfp0c0]
        type = PorousFlowPropertyAux
        variable = mfp0c0
        property = mass_fraction
        phase = 0
        fluid_component = 0
        execute_on = 'timestep_end'
      []
      [mfp0c1]
        type = PorousFlowPropertyAux
        variable = mfp0c1
        property = mass_fraction
        phase = 0
        fluid_component = 1
        execute_on = 'timestep_end'
      []
      [Density]
        type = PorousFlowPropertyAux
        variable = density
        property = density
        phase = 0
        #fluid_component = 2
        execute_on = 'timestep_end'
      []
      [Porosityn]
        type = PorousFlowPropertyAux
        variable = porosityn
        property = porosity
        execute_on = 'TIMESTEP_BEGIN'
      []
      [permeability]
        type = PorousFlowPropertyAux
        variable = permeability
        property = permeability
        execute_on = 'TIMESTEP_BEGIN'
      []
      [liq_velocityx]
        type = PorousFlowDarcyVelocityComponent
        variable = liq_velocityx
        component = x
        fluid_phase = 0
        execute_on = 'TIMESTEP_END LINEAR NONLINEAR'
      []
      [liq_velocityy]
        type = PorousFlowDarcyVelocityComponent
        variable = liq_velocityy
        component = y
        fluid_phase = 0
        execute_on = 'TIMESTEP_END LINEAR NONLINEAR'
      []
    []

    [Variables]
      [pwater]
        initial_condition = 20e6
      []
      [tracer]
        initial_condition =  0
      []
    []


    [Kernels]
      [mass0]
        type = PorousFlowMassTimeDerivative
        fluid_component = 1
        variable = pwater
      []
      [flux0]
        type = PorousFlowAdvectiveFlux
        fluid_component = 1
        variable = pwater
      []
      [diff0]
        type = ImpresDispDispersion
        fluid_component = 1
        variable = pwater
        disp_long = 'disp_long'
        disp_trans = 'disp_trans'
      []
      [mass1]
        type = PorousFlowMassTimeDerivative
        fluid_component = 0
        variable = tracer
      []
      [flux1]
        type = PorousFlowAdvectiveFlux
        fluid_component = 0
        variable = tracer
      []
      [diff1]
        type = ImpresDispDispersion
        fluid_component = 0
        variable = tracer
        disp_long = 'disp_long'
        disp_trans = 'disp_trans'
      []
    []

    [UserObjects]
      [dictator]
        type = PorousFlowDictator
        porous_flow_vars = 'pwater tracer'
        number_fluid_phases = 1
        number_fluid_components = 2
      []
      [pc]
        type = PorousFlowCapillaryPressureConst
        pc = 0
      []
      [injected_mass]
        type = PorousFlowSumQuantity
      []
      [produced_mass]
        type = PorousFlowSumQuantity
      []
    []

    [FluidProperties]
      [fp1]
        type = ImpresDispSimpleFluid
        density0 = 1000
        bulk_modulus = 1e50
        thermal_expansion = 0
      []
    []

    [ICs]
      [apertureval]
        type = ImpresDispFileInitialCondition
        variable = perm_field
        file_name = perm.txt
      []
      [apertureval2]
        type = ImpresDispFileInitialCondition
        variable = porosity_field
        file_name = poro.txt
      []
    []

    [Materials]
      [temperature]
        type = PorousFlowTemperature
        temperature = '323'
      []
      [water]
        type = ImpresDispConstantDensityFluid
        fp = fp1
        phase = 0
      []
      [newvis]
        type = ParsedMaterial
        coupled_variables = 'shearrateviscosityvar'
        expression = 'shearrateviscosityvar'
        # expression = 0.001
        property_name = 'viscosity1'
      []
      [shearrateprop]
        type = ParsedMaterial
        coupled_variables = 'liq_velocityx liq_velocityy'
        expression = 'sqrt(liq_velocityx^2 + liq_velocityy^2)'
        property_name = 'shearrateprop'
      []
      [shearrateviscosity]
        type = ParsedMaterial
        coupled_variables = 'tracer'
        # expression = '0.0062 + 93.9938/(1+60*shearratepropvar)^0.85'
        expression = 0.02*exp(-3*tracer)
        property_name = 'shearrateviscosity'
      []
      [disp_long]
        type = ParsedMaterial
        coupled_variables = 'liq_velocityx liq_velocityy'
        expression = '0.0'
          # expression = 'abs(0.03968*sqrt(liq_velocityx^2 + liq_velocityy^2))'
        property_name = 'disp_long'
        # outputs = 'exodus'
      []
      [disp_trans]
        type = ParsedMaterial
        coupled_variables = 'shearratepropvar'
        expression = '0'
        property_name = 'disp_trans'
      []
      [massfrac1]
        type = PorousFlowMassFraction
        mass_fraction_vars = 'tracer'
      []
       [saturation_calculator]
         type = PorousFlow1PhaseP
         porepressure = pwater
         capillary_pressure = pc
       []
      [porosity]
        type = PorousFlowPorosity
        # porosity = 1
        porosity_zero = porosity_field
      []
      [permeability]
        type = PorousFlowPermeabilityConstFromVar
        perm_xx = perm_field
        perm_yy = perm_field
        perm_zz = perm_field
        # type = PorousFlowPermeabilityConst
        # permeability = '1e-14 0 0 0 1e-14 0 0 0 1e-14'
      []
      [relperm]
        type = PorousFlowRelativePermeabilityConst
        phase = 0
      []
      [diffusivity]
        type = PorousFlowDiffusivityConst
        diffusion_coeff = '1e-9 1e-9'
        tortuosity = '1'
      []
    []

    [Functions]
      [tracerfunc]
        type = PiecewiseConstant
        x = '-10000  0     5e15'
        y = '0  -1e-1    0'
        direction = LEFT_INCLUSIVE
      []
      [waterfunc]
          type = PiecewiseConstant
          x = '-10000  0     5e15'
          y = '-1e-1    0    0'
          direction = LEFT_INCLUSIVE
      []
	  [time]
        type = ParsedFunction
        symbol_values = 'mean'
        symbol_names = 'mean'
        expression = '((mean >= 0.09)&(mean < 0.11))|((mean >= 0.19)&(mean < 0.21))|((mean >= 0.29)&(mean < 0.31))|((mean >= 0.39)&(mean < 0.41))|((mean >= 0.49)&(mean < 0.51))|((mean >= 0.59)&(mean < 0.61))|((mean >= 0.69)&(mean < 0.71))|((mean >= 0.79)&(mean < 0.81))|((mean >= 0.89)&(mean < 0.91))'
      []
    []



    [BCs]
      [injection2]
        type = PorousFlowSink
        variable = tracer
        flux_function = tracerfunc
        boundary = 'left'
        save_in = flux_in0
      []
      [injection3]
        type = PorousFlowSink
        variable = pwater
        flux_function = waterfunc
        boundary = 'left'
        save_in = flux_in1
      []
    [outp]
      type = ImpresDispLinearSink
      variable = pwater
      boundary = right
      fluid_phase = 0
      PT_shift = 20e6
      pt_vals = '-2E7 2E7'
      multipliers = '-2E7 2E7'
      mass_fraction_component = 1
      flux_function = 10 # 1/L
    []
      [outt]
        type = ImpresDispLinearSink
        variable = tracer
        boundary = right
        fluid_phase = 0
        PT_shift = 20e6
        pt_vals = '-2E7 2E7'
        multipliers = '-2E7 2E7'
        mass_fraction_component = 0
        flux_function = 10 # 1/L
      []
    []

     [Postprocessors]
       [tracer_mass]
         type = PorousFlowFluidMass
         phase = 0
         fluid_component = 0
         execute_on = TIMESTEP_END
         outputs = 'csv'
       []
       [water_mass]
         type = PorousFlowFluidMass
         phase = 0
         fluid_component = 1
         execute_on = TIMESTEP_END
         outputs = 'csv'
       []
       [density_water]
         type = ElementAverageValue
         variable = density
         execute_on = 'timestep_end'
         outputs = 'csv'
       []
       [porosity]
         type = ElementAverageValue
         variable = porosityn
         execute_on = 'INITIAL timestep_end'
         outputs = 'csv console'
       []
       [permeability]
        type = ElementAverageValue
        variable = permeability
        execute_on = 'INITIAL timestep_end'
        outputs = 'csv console'
       []
       [mean]
         type = ElementAverageValue
         variable = mfp0c0
         execute_on = 'timestep_end'
         outputs = 'csv'
       []
       [massfractionwater]
         type = ElementAverageValue
         variable = mfp0c1
         execute_on = 'timestep_end'
         outputs = 'csv'
       []
       [vis_liq]
         type = ElementAverageValue
         variable = viscosity_liq
         execute_on = 'timestep_end'
         outputs = 'csv'
       []
       [vis_liqb]
        type = ElementAverageValue
        variable = viscosity_liq
        execute_on = 'TIMESTEP_BEGIN'
        outputs = 'csv'
      []
      [pvxb]
        type = ElementAverageValue
        variable = liq_velocityx
        execute_on = 'TIMESTEP_BEGIN'
        outputs = 'csv'
      []
      [pvyb]
        type = ElementAverageValue
        variable = liq_velocityy
        execute_on = 'TIMESTEP_BEGIN'
        outputs = 'csv'
      []
      [pvxe]
        type = ElementAverageValue
        variable = liq_velocityx
        execute_on = 'timestep_end'
        outputs = 'csv'
      []
      [pvye]
        type = ElementAverageValue
        variable = liq_velocityy
        execute_on = 'timestep_end'
        outputs = 'csv'
      []
    []


    [Preconditioning]
      active = 'preferred'
      [basic]
        type = SMP
        full = true
        petsc_options = '-snes_converged_reason -ksp_diagonal_scale -ksp_diagonal_scale_fix -ksp_gmres_modifiedgramschmidt -snes_linesearch_monitor'
        petsc_options_iname = '-ksp_type -pc_type -sub_pc_type -sub_pc_factor_shift_type -pc_asm_overlap'
        petsc_options_value = 'gmres asm lu NONZERO 2'
      []
      [preferred]
        type = SMP
        full = true
        petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -snes_type -pc_factor_shift_type -snes_linesearch_type'
        petsc_options_value = 'lu mumps vinewtonssls nonzero l2'
      []
      [bounded]
        # must use --use-petsc-dm command line argument
          type = SMP
          full = true
          petsc_options = '-snes_linesearch_monitor'
          petsc_options_iname = '-snes_type -pc_factor_shift_type -snes_linesearch_type'
          petsc_options_value = 'vinewtonssls nonzero l2'
        []
    []

    [VectorPostprocessors]
      [concentration]
        type = ElementValueSampler
        variable = 'mfp0c0'
        sort_by = id
      []
	  [velocity]
        type = ElementValueSampler
        variable = 'shearratepropvar'
        sort_by = id
      []
    []

    [Executioner]

      type = Transient
      solve_type = NEWTON
      start_time = 0
      end_time = 2381
      dtmax = 2

      [TimeStepper]
        type = IterationAdaptiveDT
        time_t = '0.0  10.0 300 2000'
        time_dt = '0.1 0.5 0.5 2'
        dt = 0.1
      []

    # controls for linear iterations
      l_max_its = 40
      l_abs_tol = 1e-20





    # controls for nonlinear iterations
      nl_max_its = 15
      nl_rel_tol = 1e-6
      nl_abs_tol = 5e-8
    []

    [Outputs]
      # exodus = true
	  checkpoint = false
      [csv]
        type = CSV
        sync_times = '
1
5
10
30
50
70
90
110
130
150
170
190
210
230
250
270
290
350
410
470
530
590
650
710
770
830
890
950
1010
1070
1130
1190
1250
1310
1370
1430
1490
1600
1710
1820
1930
2040
2150
2260
2370
2500
2630
2760
2890
3020
3150
3280
3410
3540
3670
3800
3930
4060
4190
4320
4450
4580
4710
4840
4970
5100
5230
5360
5490
5620
  '
        sync_only = true
      []
    []

    [Debug]
      show_var_residual_norms = true
     # show_top_residuals = 2
     # show_execution_order = 'INITIAL TIMESTEP_BEGIN'
    []
