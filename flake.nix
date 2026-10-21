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
          renderWiring = pkgs.writeShellApplication {
            name = "render-wiring";
            runtimeInputs = [ wireviz pkgs.coreutils ];
            text = ''
              shopt -s nullglob
              for source in wiring/*.yaml wiring/*/*.yaml; do
                output="wiring/output/$(dirname "''${source#wiring/}")"
                mkdir -p "$output"
                wireviz -f hpst -o "$output" "$source"
              done
            '';
          };
        in
        { inherit pkgs fontConfig wireviz renderWiring; };
    in
    {
      packages = forAllSystems (system:
        let tools = toolsFor system;
        in {
          default = tools.wireviz;
          wireviz = tools.wireviz;
          render-wiring = tools.renderWiring;
        });

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${(toolsFor system).wireviz}/bin/wireviz";
          meta.description = "Render WireViz harness YAML with Graphviz and fonts";
        };
        render-wiring = {
          type = "app";
          program = "${(toolsFor system).renderWiring}/bin/render-wiring";
          meta.description = "Render all wiring diagrams from the repository root";
        };
      });

      devShells = forAllSystems (system:
        let tools = toolsFor system;
        in {
          default = tools.pkgs.mkShell {
            packages = [ tools.wireviz tools.renderWiring tools.pkgs.graphviz ];
            FONTCONFIG_FILE = tools.fontConfig;
          };
        });
    };
}
