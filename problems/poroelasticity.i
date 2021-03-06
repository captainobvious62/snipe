# 2D Poroelastic Example with Gravity
[Mesh]
  displacements = 'disp_x disp_y' #Define displacements for deformed mesh
  type = GeneratedMesh # Can generate simple lines, rectangles and rectangular prisms
  dim = 2 # Dimension of the mesh
  nx = 100 # Number of elements in the x direction
  ny = 100 # Number of elements in the y direction
  xmax = 100  # Length of test chamber, metres
  ymax = 100  # Test chamber radius, metres
  elem_type = QUAD4
[]
# ------------------------------------------------------------------------------
[GlobalParams]
  displacements = 'disp_x disp_y'
  PorousFlowDictator = dictator
  block = 0
[]
# ------------------------------------------------------------------------------
[UserObjects]
  [./dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'porepressure disp_x disp_y'
    number_fluid_phases = 1
    number_fluid_components = 1
  [../]
[]
# ------------------------------------------------------------------------------
[Variables]
  [./disp_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./disp_y]
    order = FIRST
    family = LAGRANGE
    #Adds a Linear Lagrange variable by default
  [../]
  [./porepressure]
    #    scaling = 1E9  # Notice the scaling, to make porepressure's kernels roughly of same magnitude as disp's kernels
  [../]
[]
# ------------------------------------------------------------------------------
[BCs]
  [./roller_xmin]
    # X direction zero displacement BC
    type = PresetBC
    variable = disp_x
    boundary = 'left'
    value = 0.0   # m
  [../]
  [./roller_xmax]
    # X direction zero displacement BC
    type = PresetBC
    variable = disp_x
    boundary = 'right'
    value = 0.0   # m
  [../]
  [./roller_ymin]
    # Z direction zero displacement BC
    type = PresetBC
    variable = disp_y
    boundary = 'bottom'
    value = 0.0   # m
  [../]
  [./free_surface]
    type = DirichletBC
    variable = porepressure
    boundary = top
    value = 0.0
  [../]
[]
# ------------------------------------------------------------------------------
[Kernels]
  [./gravity]
    # Apply gravity in -y direction
    type = Gravity
    variable = disp_y
    value = -9.80       # m / s**2
  [../]
  [./grad_stress_x]
    type = StressDivergenceTensors
    variable = disp_x
    component = 0
  [../]
  [./grad_stress_y]
    type = StressDivergenceTensors
    variable = disp_y
    component = 1
  [../]
  [./poro_x]
    type = PorousFlowEffectiveStressCoupling
    biot_coefficient = 0.6
    variable = disp_x
    component = 0
  [../]
  [./poro_y]
    type = PorousFlowEffectiveStressCoupling
    biot_coefficient = 0.6
    variable = disp_y
    component = 1
  [../]
  [./mass0]
    type = PorousFlowFullySaturatedMassTimeDerivative
    biot_coefficient = 0.6
    coupling_type = HydroMechanical
    variable = porepressure
  [../]
  [./flux]
    type = PorousFlowFullySaturatedDarcyBase
    variable = porepressure
    gravity = '0 -9.8' # m / s**2
  [../]
[]
# ------------------------------------------------------------------------------

[AuxVariables]
  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]
# ------------------------------------------------------------------------------
[AuxKernels]
  [./stress_xx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xx
    index_j = 0
    index_i = 0
  [../]
  [./stress_xy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xy
    index_j = 1
    index_i = 0
  [../]
  [./stress_yy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yy
    index_j = 1
    index_i = 1
  [../]

  [./strain_xx]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = strain_xx
    index_j = 0
    index_i = 0
  [../]
  [./strain_xy]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = strain_xy
    index_j = 1
    index_i = 0
  [../]
  [./strain_yy]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = strain_yy
    index_j = 1
    index_i = 1
  [../]
[]
# ------------------------------------------------------------------------------
[Materials]
  [./temperature]
    type = PorousFlowTemperature
  [../]
  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    block = 0
    poissons_ratio = 0.25
    youngs_modulus = 2.8e10  # Pa = kg / m / s**2
  [../]
  [./density]
    type = GenericConstantMaterial
    block = 0
    prop_names = density
    prop_values = 2300    # kg / m**3
  [../]

  [./strain]
    type = ComputeSmallStrain
  [../]
  [./stress]
    type = ComputeLinearElasticStress
  [../]
  [./eff_fluid_pressure_qp]
    type = PorousFlowEffectiveFluidPressure
  [../]
  [./vol_strain]
    type = PorousFlowVolumetricStrain
    consistent_with_displaced_mesh = false
  [../]
  [./ppss]
    type = PorousFlow1PhaseFullySaturated
    porepressure = porepressure
  [../]
  [./massfrac]
    type = PorousFlowMassFraction
  [../]
  [./simple_fluid_qp]
    type = PorousFlowSingleComponentFluid
    fp = simple_fluid
    phase = 0
  [../]
  [./dens_all_at_quadpoints]
    type = PorousFlowJoiner
    material_property = PorousFlow_fluid_phase_density_qp
  [../]
  [./visc_all]
    type = PorousFlowJoiner
    material_property = PorousFlow_viscosity_qp
  [../]
  [./porosity]
    type = PorousFlowPorosityConst # only the initial value of this is ever used
    porosity = 0.1
  [../]
  [./biot_modulus]
    type = PorousFlowConstantBiotModulus
    biot_coefficient = 0.6
    solid_bulk_compliance = 1
    fluid_bulk_modulus = 8
  [../]
  [./permeability]
    type = PorousFlowPermeabilityConst
    permeability = '1.5 0   0 1.5'
  [../]
[]
# ------------------------------------------------------------------------------
[Preconditioning]
  [./SMP]
    #Creates the entire Jacobian, for the Newton solve
    type = SMP
    full = true
  [../]
[]
# ------------------------------------------------------------------------------
[Executioner]
  type = Transient
  solve_type = Newton
  start_time = 0
  end_time = 0.7
  [./TimeStepper]
    type = PostprocessorDT
    postprocessor = dt
    dt = 0.001
  [../]
[]
# ------------------------------------------------------------------------------
[Outputs]
  exodus = true
  print_perf_log = true
[]
