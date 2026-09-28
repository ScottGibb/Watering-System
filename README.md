# Watering System

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

The KiCad workflow runs a separate job for each board on pull requests, pushes to
`main` or `master`, and manual runs. Each job checks ERC and exports a schematic
PDF, SVGs, a BOM, and a netlist. The pinned vendor submodule is checked out in CI.
ERC violations fail the job; its ERC report is uploaded even when checks fail.

Artifacts are named `main-board-schematic`, `connector-board-schematic`,
`main-board-erc-report`, and `connector-board-erc-report`. They expire after
seven days. MegaLinter checks repository documentation, YAML, JSON, and workflows;
its reports are uploaded on failure and also expire after seven days.

To run ERC locally from the repository root:

```sh
kicad-cli sch erc --exit-code-violations -o /tmp/main-board-erc.rpt \
  main-board/main-board.kicad_sch
kicad-cli sch erc --exit-code-violations -o /tmp/connector-board-erc.rpt \
  connector-board/connector-board.kicad_sch
```

## Independent board releases

Release Please uses `release-please-config.json` and
`.release-please-manifest.json` to track the boards independently. Each board
gets its own release PR, `CHANGELOG.md`, `version.txt`, and GitHub release.
The first release of each board starts at `1.0.0`; tags use
`main-board-v1.0.0` and `connector-board-v1.0.0` formats.

Use conventional commits, for example `fix(main-board): correct sensor wiring`
or `feat(connector-board): add another connector`. Release Please determines
which board changed from the file paths, not the commit scope. A change to both
board folders can release both; changes only to root documentation or workflows
do not create a board release. Shared library or drawing-sheet changes that need
a board release should also include a relevant change in that board's folder.

Merging a board's release PR creates its release and runs the reusable KiCad
workflow for the released board paths. After successful checks, each release
receives only its own PDF, SVGs, BOM, netlist, and ERC report.

GitHub must allow Actions to create pull requests under **Settings → Actions →
General → Workflow permissions**, or the `MY_RELEASE_PLEASE_TOKEN` secret must
provide suitable access. Artifact storage must have available capacity for CI
uploads and release attachments; shorter retention does not remove older
artifacts immediately.
