# Watering System

[![KiCad](https://github.com/ScottGibb/Watering-System/actions/workflows/kicad.yaml/badge.svg?branch=main)](https://github.com/ScottGibb/Watering-System/actions/workflows/kicad.yaml)
[![MegaLinter](https://github.com/ScottGibb/Watering-System/actions/workflows/mega-linter.yaml/badge.svg?branch=main)](https://github.com/ScottGibb/Watering-System/actions/workflows/mega-linter.yaml)
[![Release Please](https://github.com/ScottGibb/Watering-System/actions/workflows/release-please.yaml/badge.svg?branch=main)](https://github.com/ScottGibb/Watering-System/actions/workflows/release-please.yaml)

Hardware for a watering system split across two boards, linked by a multicore
cable:

- **Main Board** contains the controller and main watering-system circuitry.
  Open [main-board/main-board.kicad_pro](main-board/main-board.kicad_pro).
- **Connector Board** breaks out the multicore cable to the external connections.
  Open [connector-board/connector-board.kicad_pro](connector-board/connector-board.kicad_pro).

Each folder contains a matching `.kicad_pro`, `.kicad_sch`, and `.kicad_pcb`.
Use KiCad 10 to open the projects. CI currently checks and releases schematics;
PCB checks and fabrication outputs are not enabled.

## KiCad libraries and drawing sheets

After cloning the repository, initialise the pinned library submodule:

```sh
git submodule update --init --recursive
```

Main Board registers the vendor ESP8266 symbol and footprint libraries as
`ESP8266` through its project-local `sym-lib-table` and `fp-lib-table`.
Both use `${KIPRJMOD}/../vendor/` paths, so no machine-specific library
configuration is required. Close and reopen the project if its editors were
already open when the library tables changed.

- Symbol library: `ESP8266` (legacy `.lib`, including `NodeMCU1.0(ESP-12E)`
  and `NodeMCU_1.0_(ESP-12E)`).
- LOLIN V3 footprint: `ESP8266:NodeMCU-LoLinV3`.

The vendor library has a LOLIN V3 footprint but no dedicated LOLIN V3 symbol.
Verify the symbol pin mapping against the actual board before assigning that
footprint; registering the libraries does not place or connect a module.

Main Board references the shared drawing sheet in
`templates/scott-gibb-template.kicad_wks` using a project-relative path.
Connector Board retains its embedded copy of the drawing sheet.

## Continuous integration

CI runs ERC for both boards and exports schematic PDFs, SVGs, BOMs, and netlists.
Artifacts are named per board and retained for seven days. MegaLinter checks
Markdown, YAML, JSON, and workflows.

## Independent board releases

Release Please manages separate versions, changelogs, release PRs, and GitHub
releases for each board. Tags use `main-board-v1.0.0` and
`connector-board-v1.0.0` formats. Both boards start at version `1.0.0`.

Use conventional commits such as `fix(main-board): correct sensor wiring`.
Changed file paths determine which board is released. After successful KiCad
checks, each release receives its own schematic exports and ERC report.
