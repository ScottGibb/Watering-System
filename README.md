# Watering System

This repository contains the Watering System project hardware files

## KiCad libraries

The project registers the vendor ESP8266 symbol and footprint libraries as
`ESP8266` through `sym-lib-table` and `fp-lib-table`. Both use `${KIPRJMOD}`
paths, so no machine-specific library configuration is required.

After cloning the repository, initialise the pinned library submodule:

```sh
git submodule update --init --recursive
```

Open `watering-system.kicad_pro` in KiCad. If the editors were already open
when the library tables were added, close and reopen the project to reload them.

- Symbol library: `ESP8266` (legacy `.lib`, including `NodeMCU1.0(ESP-12E)`
  and `NodeMCU_1.0_(ESP-12E)`).
- LOLIN V3 footprint: `ESP8266:NodeMCU-LoLinV3`.

The vendor library has a LOLIN V3 footprint but no dedicated LOLIN V3 symbol.
Verify the symbol pin mapping against the actual board before assigning that
footprint; registering the libraries does not place or connect a module.
