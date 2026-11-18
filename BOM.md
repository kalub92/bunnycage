# Bunnycage — bill of materials

Prices and stock as seen 2026-11-16. Interactive build guide: see `guide/index.html` (published link in the session notes).

| # | Part | Qty used | Product | Vendor | Key size | Price | Link | Link status |
|---|---|---|---|---|---|---|---|---|
| 1 | Qi receiver | 1 of 2 | Acxico 2Pcs Wireless Charger Receiver Module PCBA Board Coil Universal Qi DIY (5 V / 1 A out, red/black leads) | Amazon | coil 41 × 29 mm (listing); ferrite sheet ≈ 42 × 34 mm and board 34 × 14 mm (measured by owner) | $9.99 | https://www.amazon.com/s?k=Acxico+2Pcs+Wireless+Charger+Receiver+Module+PCBA+Board+Coil+Universal+Qi+DIY | Title search link (product ID not in the saved listing). Listing PDF in `reference/Amazon/` showed In Stock on 16 Nov 2026; Amazon not fetched |
| 2 | MagSafe magnet ring | 1 of 5 | 54 × 46 × 1.5 mm N52 ring assembly with alignment magnet, 5-pack | TotalElement | 54 OD / 46 ID / 1.5 mm. **The case is now sized for the owner's 53.9 / 45.8 / 2.6 mm ring** (listing not supplied); for this 1.5 mm ring set `ring_t = 1.5; bt = 2.6` and rebuild | $24.99 | https://totalelement.com/products/54-x-46-x-1-5mm-magsafe-neodymium-rare-earth-magnet-phone-attachment-ring-assembly-with-alignment-magnet-5-pack | Live: product data fetched HTTP 200, `available: true`, $24.99 |
| 3 | USB-C plug + socket | 1 + 1 | ANMBEST USB 3.1 Type C 24-pin connectors on solder boards. The pack has both: green male plug (to the r1) and blue female socket (side port) | Amazon | plug 8.4 × 2.6 mm | $7.49 | https://www.amazon.com/dp/B091CRLJM2?th=1 | Listing PDF in `reference/Amazon/` showed In Stock on 16 Nov 2026; Amazon not fetched |
| 4 | Filament | 29 g (sliced) | Polymaker PolyLite PETG grey 1.75 mm, 1 kg | MatterHackers | 1.75 mm | $19.99 | https://matterhackers.com/store/l/polymaker-polylite-petg-grey-175mm-1kg/sk/MUR5Z8PG | Live, in stock |
| 5 | Adhesive sheet | 1 | 3M 468MP transfer adhesive 305 × 305 mm | Spool3D (Canada) | 0.13 mm | CA$8.00 | https://spool3d.ca/3m-468mp-adhesive-sheet-305mm-x-305mm/ | Live, 18 in stock; ships from Canada |
| 6 | Kapton tape | 1 | Polyimide tape 10 mm × 33 yd | ProtoSupplies | 10 mm | $1.95 | https://protosupplies.com/product/polyimide-kapton-tape-10mm-x-33yds/ | Live, 5 in stock |
| 7 | Schottky diode | 1 | 1N5817 (or any 1 A+ Schottky, e.g. SS14), in the receiver's red wire so cable power cannot flow back into the receiver | DigiKey | DO-41, 5 × 2.7 mm | ≈ $0.40 | https://www.digikey.com/en/products/result?keywords=1N5817 | Search link, not fetched |

Charging hardware (rows 1–3): about **$42** ($9.99 + $24.99 + $7.49). Everything: about **$72** before shipping.

Also needed, not sourced: soldering iron, about 15 cm of 28–30 AWG hook-up wire, heat-shrink, CA or hot glue, a USB-A-to-C cable, a MagSafe / Qi2 charger.

## Sourcing notes
- Receiver and plug board were chosen by the owner on 16 Nov 2026, replacing Adafruit 1901 and Adafruit 5978. Those still fit the case if the Amazon parts disappoint (the 5978 needs its 5.1 kΩ CC resistor removed).
- No finished USB-C Qi receiver patch shorter than 82 mm was found, so the design uses a bare receiver module plus a plug board (5V→V pad, GND→G pad). The ANMBEST plug board has no CC pad but ships with two 56 kΩ resistors fitted (measured on receipt, 17 Nov 2026), so no CC resistor needs adding.
- Rejected after review: DFRobot DFR0362. Its product photo shows an XKT-412 resonant transmitter/receiver pair, not a Qi receiver, so a MagSafe or Qi charger would not power it.
- No verified in-stock magnet ring thinner than 1.5 mm was found. The pocket is sized for 1.5 mm.
- Also rejected: Nillkin Magic Tag Type-C Short (82 × 48 mm, too long), Tinkersphere USB-C patch (106 mm, pre-order).
- Side socket added 18 Nov 2026: the blue female board is wired V/D+/D−/G straight to the green plug board. It has no CC resistors or CC pads, so it works with USB-A-to-C cables only (no C-to-C, no PD).
- USB-C boards measured by the owner on 18 Nov 2026: neither has a collar usefully wider than its metal shell, so the print backs each board at its tail (lid gates) and a drop of glue resists pull-out. Overall lengths (`m_len` 16.0, `f_len` 14.6) are the listing values; the owner's port-test print confirmed both boards and the lid gates fit (18 Nov 2026).
