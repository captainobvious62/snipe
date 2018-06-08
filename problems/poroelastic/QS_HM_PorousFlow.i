# Modified test for 2D using fully saturated action
#

# Same as pp_generation.i, but using an Action
#
# A sample is constrained on all sides and its boundaries are
# also impermeable.  Fluid is pumped into the sample via a
# volumetric source (ie kg/second per cubic meter), and the
# rise in porepressure is observed.
#
# Source = s  (units = kg/m^3/second)
#
# Expect:
# fluid_mass = mass0 + s*t
# stress = 0 (remember this is effective stress)
# Porepressure = fluid_bulk*log(fluid_mass_density/density_P0), where fluid_mass_density = fluid_mass*porosity
# porosity = biot+(phi0-biot)*exp(pp(biot-1)/solid_bulk)
#
# Parameters:
# Biot coefficient = 0.3
# Phi0 = 0.1
# Solid Bulk modulus = 2
# fluid_bulk = 13
# density_P0 = 1

[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 100
  ny = 1
  nz = 100
  xmin = 0.0 # m
  xmax = 100.0 # m
  ymin = 0.0
  ymax = 1.0
  zmin = 0.0
  zmax = 100.0 # m
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
  PorousFlowDictator = dictator
  block = 0
[]

[UserObjects]
  [./dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'porepressure disp_x disp_y disp_z'
    number_fluid_phases = 1
    number_fluid_components = 1
  [../]
[]

[Variables]
  [./porepressure]
  [../]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
[]

[Modules]
  [./FluidProperties]
    [./simple_fluid]
      type = SimpleFluidProperties
      thermal_expansion = 0.0
      bulk_modulus = 2.15e9 # Pa = N / m**2
      viscosity = 0.001     # Pa * s = N / m**2 * s
      density0 = 1000.0     # kg / m**3
    [../]
  [../]
[]


[BCs]
  [./confinex]
    type = PresetBC
    variable = disp_x
    value = 0
    boundary = 'left right'
  [../]
  [./confiney]
    type = PresetBC
    variable = disp_y
    value = 0
    boundary = 'bottom top'
  [../]
  [./basefixed]
    type = PresetBC
    variable = disp_z
    value = 0
    boundary = back
  [../]
  [./topdrained]
    type = DirichletBC
    variable = porepressure
    value = 0
    boundary = front
  [../]
[]


[Kernels]
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
  [./grad_stress_z]
    type = StressDivergenceTensors
    variable = disp_z
    component = 2
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
  [./poro_z]
    type = PorousFlowEffectiveStressCoupling
    biot_coefficient = 0.6
    component = 2
    variable = disp_z
  [../]
  [./mass0]
    type = PorousFlowFullySaturatedMassTimeDerivative
    coupling_type = HydroMechanical
    biot_coefficient = 0.6
    multiply_by_density = false
    variable = porepressure
  [../]
  [./flux]
    type = PorousFlowFullySaturatedDarcyBase
    multiply_by_density = false
    variable = porepressure
    gravity = '0 0 -9.8'
  [../]
[]

[AuxVariables]
  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./stress_xx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xx
    index_i = 0
    index_j = 0
  [../]
  [./stress_xy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xy
    index_i = 0
    index_j = 1
  [../]
  [./stress_xz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xz
    index_i = 0
    index_j = 2
  [../]
  [./stress_yy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yy
    index_i = 1
    index_j = 1
  [../]
  [./stress_yz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yz
    index_i = 1
    index_j = 2
  [../]
  [./stress_zz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_zz
    index_i = 2
    index_j = 2
  [../]
[]

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
    at_nodes = false
  [../]
  [./visc_all]
    type = PorousFlowJoiner
    material_property = PorousFlow_viscosity_qp
  [../]
  [./porosity]
    type = PorousFlowPorosityConst # only the initial value of this is used
    porosity = 0.1
  [../]
  [./biot_modulus]
    type = PorousFlowConstantBiotModulus
    biot_coefficient = 0.6
    fluid_bulk_modulus = 2.15e9 # Pa = N / m**2
    solid_bulk_compliance = 1.43e-9 # 1/Ks, 1/Pa
  [../]
  [./permeability]
    type = PorousFlowPermeabilityConst
    permeability = '9.8692327e-14 0.0 0.0  0 9.8692327e-14 0  0 0 9.8692327e-14' # m**2
  [../]
[]

[Preconditioning]
  [./andy]
    type = SMP
    full = true
    petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it'
    petsc_options_value = 'bcgs bjacobi 1E-14 1E-10 10000'
  [../]
[]

[Executioner]
  type = Transient
  solve_type = Newton
  start_time = 0  # s
  end_time = 10   # s
  dt = 0.1          # s
  verbose = true
[]

[Outputs]
  exodus = true
  print_perf_log = true
  execute_on = 'timestep_end'
  file_base = QS_HM_PorousFlow
  csv = true
[]
