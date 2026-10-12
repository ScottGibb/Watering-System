# Wiring harnesses

One WireViz diagram per distinct cable design. Repeated pumps and capacitive
sensors share a diagram; each BOM describes one cable instance.

## Build

Graphviz and uv are required:

```sh
uv tool install wireviz==0.4.1
mkdir -p wiring/output
wireviz -f hpst -o wiring/output wiring/*.yaml
```

With Nix, run `nix develop` instead of installing tools, then use the WireViz
command above. Launch `code .` from that shell for the recommended WireViz Preview
extension (F8). You can also use `nix run . -- -o wiring/output wiring/pump.yaml`.

Outputs are HTML, SVG, PNG and TSV BOMs in `output/` (ignored by Git).
CI uses uv and attaches `wiring.zip` to independent `wiring-v*` releases.

## Cables

| Diagram source                                  | Connections                             |
| ----------------------------------------------- | --------------------------------------- |
| [Inter-board](inter-board.yaml)                 | Main J3 ↔ Connector J1, HD15            |
| [Pump](pump.yaml)                               | Connector J2/J3, pumps 0/1              |
| [Water level](water-level.yaml)                 | Connector J4, RCWL-1670                 |
| [Temperature](temperature.yaml)                 | Connector J5, DS18B20                   |
| [Outdoor LDR](light-outdoor.yaml)               | Connector J6                            |
| [Capacitive moisture](capacitive-moisture.yaml) | Connector J7–J10, channels 0–3          |
| [Indoor sensors](auxiliary-indoor.yaml)         | Main J2, LDR/AM312/resistive moisture   |
| [Power](power.yaml)                             | Main J1 screw terminal ↔ barrel adapter |

Board pins follow KiCad; sensor pinouts follow confirmed wiring and pinout images.
AM312 pins 1/2/3 are VCC/OUT/GND.
PCB sensor headers use JST 2.54 mm. PIR and resistive moisture sensor ends use
Dupont; capacitive sensor ends use JST 2.54 mm. LDR leads are soldered directly
to the wires. Pumps and DS18B20 have direct leads. HD15 cable plugs are male.
Indoor 3V3 splits into separate cables at the PCB connector.
Water-level cable uses a male [SM 4-pin connector](https://www.amazon.co.uk/dp/B08JV9DXM6).
Capacitive cable maps PCB 3V3/signal/GND to sensor VCC/AOUT/GND;
[photo reference](https://thepihut.com/products/capacitive-soil-moisture-sensor).
Pump and moisture diagrams show J2 and J7 as examples;
other instances keep the same pin order with their channel-specific signal names.

Colours: 3V3 red; ground black; analogue and DS18B20 data yellow; PIR white;
pump power blue. Ultrasonic signal colours remain TBD.
28 AWG stranded copper for sensor, pump and HD15 ribbon wiring.
The separate 6 V supply cable uses 22 AWG.
6 V positive colour remains N/A. Lengths, SM cavity numbering, ultrasonic signal colours,
exact screw-terminal pitch, barrel size and ferrule part remain TBD.
The 6 V power cable joins PCB VCC/GND screw terminals to adapter +/− terminals.
[Adapter polarity](https://www.pololu.com/product/2449): + centre / − outer barrel.
Barrel CAD reference: [female screw-terminal adapter](https://grabcad.com/library/dc-barrel-jack-adapter-female-with-screw-terminals-1)
(previous chat identified 5.5 × 2.1 mm; physical size unverified).

HD15 pins 1–15 are wired straight-through; Connector Board pin 15 is NC. Unknown cable lengths appear as zero in WireViz BOMs.

Reusable skill: [wireviz-harnesses](../skills/wireviz-harnesses/SKILL.md).
