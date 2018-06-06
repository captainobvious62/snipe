[Mesh]
  type = GeneratedMesh # Can generate simple lines, rectangles and rectangular prisms
  dim = 2 # Dimension of the mesh
  nx = 100 # Number of elements in the x direction
  ny = 100 # Number of elements in the y direction
  xmax = 1000  # Length of test chamber, metres
  ymax = 1000  # Test chamber radius, metres
[]

[Variables]
  [./pressure]
    order = FIRST
    family = LAGRANGE
    #Adds a Linear Lagrange variable by default
  [../]
  [./temperature]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  [./diff]
    type = Diffusion # A Laplacian operator
    variable = pressure # Operate on the "pressure" variable from above
  [../]
[]

[BCs]
  [./inlet]
    type = DirichletBC # Simple u=value BC
    variable = pressure
    boundary = bottom # Name of a sideset in the mesh
    value = 4000 # (Pa) From Figure 2 from paper.  First data point for 1mm spheres.
  [../]
  [./outlet]
    type = DirichletBC
    variable = pressure
    boundary = top
    value = 0 # (Pa) Gives the correct pressure drop from Figure 2 for 1mm spheres
  [../]
[]

[Executioner]
  type = Steady
  solve_type = PJFNK #Preconditioned Jacobian Free Newton Krylov
  petsc_options_iname = '-pc_type -pc_hypre_type' #Matches with the values below
  petsc_options_value = 'hypre boomeramg'
[]

[Outputs]
  exodus = true # Output Exodus format
[]
