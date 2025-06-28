{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    (pkgs.python313.withPackages (
      ps: with ps; [
        pip
        uv # Fast package installer and resolver (pip alternative)
        virtualenv
        jupyterlab
        black
        # sympy          # Symbolic mathematics library
        # pygame         # Game development and multimedia library
        # numpy          # Fundamental package for numerical computations
        # scipy          # Scientific computing library (builds on numpy)
        # pandas         # Data analysis and manipulation library
        # scikit-learn   # General-purpose machine learning toolkit
        # matplotlib     # Plotting and visualization library
        # torch          # Deep learning and neural network library
      ]
    ))
    pyright # Static type checker
    ruff # Python linter and code formatter
  ];
}
