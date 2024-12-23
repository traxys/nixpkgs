{
  python3Packages,
  fetchFromGitHub,
  lib,
  bash,
  hatch,
  scdoc,
  replaceVars,
}:
python3Packages.buildPythonPackage rec {
  pname = "umu-launcher-unwrapped";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "Open-Wine-Components";
    repo = "umu-launcher";
    rev = "refs/tags/${version}";
    hash = "sha256-TOsVK6o2V8D7CLzVOkLs8AClrZmlVQTfeii32ZIQCu4=";
  };

  patches = [
    ./makefile-installer-prefix.patch
    (replaceVars ./no-umu-version-json.patch { inherit version; })
  ];

  nativeBuildInputs = [
    python3Packages.build
    hatch
    scdoc
    python3Packages.installer
  ];

  pythonPath = [
    python3Packages.filelock
    python3Packages.xlib
  ];

  pyproject = false;
  configureScript = "./configure.sh";

  # The Makefile variables are a big mess, but this combination (and the patches) more or less do what we want
  preBuild = ''
    makeFlagsArray+=(
      "PYTHON_INTERPRETER=${lib.getExe python3Packages.python}"
      "SHELL_INTERPRETER=${lib.getExe bash}"
      "PREFIX="
      "PYTHONDIR=/${python3Packages.python.sitePackages}"
      "DESTDIR=$out"
    )
  '';

  meta = {
    description = "Unified launcher for Windows games on Linux using the Steam Linux Runtime and Tools";
    changelog = "https://github.com/Open-Wine-Components/umu-launcher/releases/tag/${version}";
    homepage = "https://github.com/Open-Wine-Components/umu-launcher";
    license = lib.licenses.gpl3;
    mainProgram = "umu-run";
    maintainers = with lib.maintainers; [ diniamo MattSturgeon fuzen ];
    platforms = lib.platforms.linux;
  };
}
