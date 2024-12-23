{ buildFHSEnv, umu-launcher-unwrapped }:
buildFHSEnv {
  pname = "umu-launcher";
  inherit (umu-launcher-unwrapped) version meta;

  targetPkgs = pkgs: [ pkgs.umu-launcher-unwrapped ];

  executableName = "umu-run";
  runScript = "${umu-launcher-unwrapped}/bin/umu-run";

  extraInstallCommands = ''
    ln -s ${umu-launcher-unwrapped}/lib $out/lib
    ln -s ${umu-launcher-unwrapped}/share $out/share
  '';
}
