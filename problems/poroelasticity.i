# 2D Elastic Example with Gravity
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

# [GlobalParams]
#   displacements = 'disp_x disp_z' #Define displacements for deformed mesh
# []

[Variables]
  [./porepressure]
  [../]
  [./disp_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./disp_y]
    order = FIRST
    family = LAGRANGE
    #Adds a Linear Lagrange variable by default
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

[Kernels]
  [./gravity_y]
    # Apply gravity in -y direction
    type = Gravity
    variable = disp_y
    value = -9.80       # m / s**2
  [../]
  [./TensorMechanics]
    # Stress divergence kernel
    displacements = 'disp_x disp_y'
  [../]
[]

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
[Materials]
  [./small_strain]
    type = ComputePlaneSmallStrain
    block = 0
    displacements = 'disp_x disp_y'
  [../]
  [./linear_stress]
    type = ComputeLinearElasticStress
    block = 0
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
[]

[Preconditioning]
  [./SMP]
    #Creates the entire Jacobian, for the Newton solve
    type = SMP
    full = true
  [../]
[]

[Executioner]
  #We solve a steady state problem using Newton's iteration
  type = Steady
  solve_type = NEWTON
  nl_rel_tol = 1e-9
  l_max_its = 30
  l_tol = 1e-4
  nl_max_its = 10
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre boomeramg 31'
[]

[Outputs]
  exodus = true
  print_perf_log = true
[]
