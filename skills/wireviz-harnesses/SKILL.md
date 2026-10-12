---
name: wireviz-harnesses
description: Create, edit and validate WireViz cable and wiring-harness YAML, diagrams and BOMs from verified connector pinouts. Use for cable assemblies, sensor leads and WireViz build or release workflows; use KiCad for board circuitry.
---

# WireViz harnesses

Use one YAML source per distinct cable design, documenting repeated instances
without duplicating identical diagrams. Inspect existing sources,
build commands and CI before introducing a new structure. WireViz documents
cables and connector terminations; it does not automatically synchronise KiCad
nets or describe PCB traces.

## Establish the electrical mapping

- Obtain board references, contact numbers and net names from saved schematics
  or freshly exported netlists. Record the source of device-side pinouts and
  distinguish numbered physical contacts from functional signal labels.
- Ask about ambiguous electrical destinations, supply voltages, signal direction
  and connector orientation. Do not infer RX/TX versus trigger/echo, connector
  cavity order, or cable straight-through wiring from appearance.
- Distinguish PCB headers, mating cable housings, intermediate joints and
  sensor-side connectors. A connector's pitch alone does not identify its series.
  Identify the viewing face before assigning physical cavity numbers.
- Show unconnected and spare contacts separately from fitted conductors. Do not
  connect an uncertain spare conductor or shield merely to complete a diagram.
- Keep unprovided colours, lengths, gauges, genders and part numbers explicitly
  TBD. Omit numeric length/gauge fields when unknown; do not insert guessed
  construction values. Explain any BOM defaults caused by omitted fields.

## Author and render

Use `connectors`, `cables` and `connections`; add `metadata` and diagram-visible
`notes` for source context and unresolved details. Define `pins` explicitly for
non-sequential contacts or functional endpoints. Connections reference those IDs,
not assumed list positions. Use `==` for a connector mating interface and wire
segments for cable conductors. Avoid representing a set of independent device
leads as one physical connector; identify logical endpoint groups and exclude
pure functional placeholders from the BOM.

Prefer the repository's locked Nix environment when present:

```sh
nix develop
wireviz --version
dot -V
```

Render directly with WireViz; a separate build script is unnecessary here.
WireViz 0.4.1 accepts multiple input files:

```sh
mkdir -p wiring/output
wireviz -f hpst -o wiring/output wiring/*.yaml
```

`hpst` produces HTML, PNG, SVG and TSV BOM outputs. Do not request native PDF or
CSV output from 0.4.1. Graphviz binaries are required in addition to the Python
package. Keep generated files outside source globs and ignore local build output.

For VS Code, recommend `NanangP.vscode-wireviz-preview`. Launch VS Code from the
development shell so preview inherits WireViz and Graphviz. Saving YAML refreshes
the preview; F8 opens it.

## Verify and integrate

- Render every changed harness and inspect its diagram and BOM. Check legibility,
  swapped contact positions, polarity, unexpected joins and disconnected pins.
- Compare board-side pin labels and connections against fresh netlist exports.
  Trace continuity through intermediate joints to the device endpoint; matching
  labels alone do not prove the connections are correct.
- Distinguish rendered/netlist validation from physical continuity or fit tests.
  List unresolved physical details when delivering the result.
- Reuse the repository build command in CI. Pin WireViz, install Graphviz and
  fonts, fail on missing outputs, and package only outputs from the current run.
  Match existing release conventions and route independent components so wiring
  paths never enter a board-only build matrix.

Consult [WireViz 0.4.1 syntax](https://github.com/wireviz/WireViz/blob/v0.4.1/docs/syntax.md)
when a requested feature is not covered by existing examples. In this project,
read `wiring/README.md` for harness inventory, verified sensor mappings and TBDs.
