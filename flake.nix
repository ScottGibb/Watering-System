{
  description = "Watering System WireViz development tools";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { nixpkgs, ... }:
    let
      systems = [ "aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      toolsFor = system:
        let
          pkgs = import nixpkgs { inherit system; };
          fontConfig = pkgs.makeFontsConf { fontDirectories = [ pkgs.dejavu_fonts ]; };
          wireviz = pkgs.writeShellApplication {
            name = "wireviz";
            runtimeInputs = [ pkgs.graphviz ];
            text = ''
              export FONTCONFIG_FILE=${fontConfig}
              exec ${pkgs.wireviz}/bin/wireviz "$@"
            '';
          };
        in
        { inherit pkgs fontConfig wireviz; };
    in
    {
      packages = forAllSystems (system:
        let tools = toolsFor system;
        in { default = tools.wireviz; wireviz = tools.wireviz; });

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${(toolsFor system).wireviz}/bin/wireviz";
          meta.description = "Render WireViz harness YAML with Graphviz and fonts";
        };
      });

      devShells = forAllSystems (system:
        let tools = toolsFor system;
        in {
          default = tools.pkgs.mkShell {
            packages = [ tools.wireviz tools.pkgs.graphviz ];
            FONTCONFIG_FILE = tools.fontConfig;
          };
        });
    };
}
