// SPDX-License-Identifier: CERN-OHL-S-2.0
/*
  HDKATOV KT-UH71DTN Wetterschutzgehäuse
  Gehäuseschale V4 · Maße in mm

  Die Innenkontur ist ringsum 10 mm nach innen versetzt.
  Hinten ergibt sich nominal R10 aus R20 außen.
  Je sechs M3-Einsätze sitzen oben und unten auf gemeinsamen Achsen.

  Koordinaten:
  - x=0 Gehäusemittelachse
  - y=0 hinterste Außenkante, +y Richtung Kuppel
  - y=280 vorderster Punkt
  - z=0 Unterseite des Druckbauteils
*/

use <kontur_hdkatov_V4.scad>

$vpr = [0, 0, 0];
$vpt = [0, 140, 0];
$vpd = 650;

$fn = 128;

// Kleine Überlappung für zuverlässige Differenzen
eps = 0.02;


// --------------------
// Grundparameter
// --------------------

hoehe = 70;
wandstaerke = schalenwand();

// --------------------
// M3-Schmelzgewindeeinsätze
// --------------------

befestigungen_aktiv = true;

// Für M3 × 6 × 5 mm Schmelzgewindeeinsatz.
// Der genaue Lochdurchmesser hängt vom realen Einsatz
// und vom Drucker ab.
einsatz_loch_d      = 4.2;

// Einsatzlänge 6 mm plus etwas Tiefenreserve
einsatz_loch_tiefe  = 6.5;

// Leichte Einführöffnung an der Oberkante
einsatz_einfuehrung_d     = 5.2;
einsatz_einfuehrung_tiefe = 0.6;


// --------------------
// Befestigungspositionen
// --------------------

befestigungspunkte = schalen_befestigungspunkte();


// --------------------
// Optionale Öffnung durch die Rückwand (standardmäßig deaktiviert)
// --------------------

kabeloeffnung_aktiv = false;

kabel_slot_breite   = 40;
kabel_slot_hoehe    = 22;
kabel_slot_z        = 25;


// --------------------
// Rohe Gehäuseschale
// --------------------

module schale_roh() {
    linear_extrude(height = hoehe)
        difference() {

            aussenkontur_2d();

            innenkontur_2d();
        }
}


// --------------------
// Sacklöcher für die
// M3-Schmelzgewindeeinsätze
// --------------------

module gewindeeinsatzbohrungen_oben() {
    for (p = befestigungspunkte) {

        // Zylindrisches Sackloch von oben
        translate([
            p[0],
            p[1],
            hoehe - einsatz_loch_tiefe
        ])
            cylinder(
                h = einsatz_loch_tiefe + eps,
                d = einsatz_loch_d
            );

        // Leichte konische Einführung an der Oberkante
        translate([
            p[0],
            p[1],
            hoehe - einsatz_einfuehrung_tiefe
        ])
            cylinder(
                h  = einsatz_einfuehrung_tiefe + eps,
                d1 = einsatz_loch_d,
                d2 = einsatz_einfuehrung_d
            );
    }
}


// --------------------
// Optionale Öffnung durch die Rückwand (standardmäßig deaktiviert)
// --------------------

module kabeloeffnung() {

    translate([
        -kabel_slot_breite / 2,
        -wandstaerke - 1,
        kabel_slot_z
    ])
        cube(
            [
                kabel_slot_breite,
                2 * wandstaerke + 1 + eps,
                kabel_slot_hoehe
            ],
            center = false
        );
}


// --------------------
// Sicherheitsprüfungen
// --------------------

assert(
    2 * einsatz_loch_tiefe < hoehe,
    "Fehler: Obere und untere Sacklöcher dürfen sich nicht treffen."
);

assert(
    einsatz_loch_d < wandstaerke,
    "Fehler: Das Loch für den Gewindeeinsatz ist breiter als die Gehäusewand."
);

assert(
    einsatz_einfuehrung_d < wandstaerke,
    "Fehler: Die Einführöffnung ist breiter als die Gehäusewand."
);


// --------------------
// Modell
// --------------------

module gehaeuseschale_v4() {
    difference() {

        schale_roh();

        if (befestigungen_aktiv) {
            gewindeeinsatzbohrungen_oben();
            translate([0, 0, hoehe])
                mirror([0, 0, 1]) gewindeeinsatzbohrungen_oben();
        }

        if (kabeloeffnung_aktiv)
            kabeloeffnung();
    }
}

gehaeuseschale_v4();
