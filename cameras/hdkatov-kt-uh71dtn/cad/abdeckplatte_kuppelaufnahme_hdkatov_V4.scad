// SPDX-License-Identifier: CERN-OHL-S-2.0
/*
  HDKATOV KT-UH71DTN Wetterschutzgehäuse
  Abdeckplatte / Kuppelaufnahme V4 · Maße in mm

  Die Unterseite liegt auf der Schalenwand auf. Der Flanschsitz
  ist von oben eingesenkt; die lichte Öffnung bleibt Ø176 mm.

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

$fn = 160;

// Kleine Überlappung für zuverlässige Differenzen
eps = 0.02;


// --------------------
// Grundparameter
// --------------------

staerke = 8;
kantenradius = 0.75; // Äußere Oberkante.
kuppel_mitte_y = kuppel_y();

// --------------------
// Kuppelaufnahme
// --------------------

kuppel_sitz_d       = 200;
lichte_oeffnung_d   = 176;

kuppel_sitz_tiefe   = 3.6;
dichtung_reserve    = 0.4;

sitz_tiefe_total    = kuppel_sitz_tiefe
                    + dichtung_reserve;


// --------------------
// Befestigung der Abdeckplatte
// --------------------

befestigungen_aktiv = true;

// Durchgangsloch für M3
deckel_schraube_d   = 3.5;

// Zylindrische Kopftasche für
// M3-Innensechskant-Zylinderkopfschrauben
deckel_kopf_d       = 6.5;
deckel_kopf_tiefe   = 3.2;

befestigungspunkte = deckel_befestigungspunkte();


// --------------------
// Kuppelausschnitt
// --------------------

module kuppel_ausschnitt() {

    // Durchgehende lichte Öffnung
    translate([
        0,
        kuppel_mitte_y,
        -eps
    ])
        cylinder(
            h = staerke + 2 * eps,
            d = lichte_oeffnung_d
        );

    // Abgestufte Aufnahme für den Kuppelflansch
    // von der Oberseite
    translate([
        0,
        kuppel_mitte_y,
        staerke - sitz_tiefe_total
    ])
        cylinder(
            h = sitz_tiefe_total + eps,
            d = kuppel_sitz_d
        );
}


// --------------------
// Schraubenlöcher für die
// Verbindung zur Gehäuseschale
// --------------------

module deckel_befestigungsbohrungen() {
    for (p = befestigungspunkte) {

        // Durchgehendes M3-Loch
        translate([
            p[0],
            p[1],
            -eps
        ])
            cylinder(
                h = staerke + 2 * eps,
                d = deckel_schraube_d
            );

        // Zylindrische Kopftasche von oben
        translate([
            p[0],
            p[1],
            staerke - deckel_kopf_tiefe
        ])
            cylinder(
                h = deckel_kopf_tiefe + eps,
                d = deckel_kopf_d
            );
    }
}


// --------------------
// Modell
// --------------------

module abdeckplatte_v4() {
    difference() {

        kantenrohling(staerke, kantenradius, oben = true);

        kuppel_ausschnitt();

        if (befestigungen_aktiv)
            deckel_befestigungsbohrungen();
    }
}

abdeckplatte_v4();
