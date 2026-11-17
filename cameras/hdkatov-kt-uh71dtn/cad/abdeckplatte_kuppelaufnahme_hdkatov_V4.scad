// SPDX-License-Identifier: CERN-OHL-S-2.0
/*
  HDKATOV KT-UH71DTN Wetterschutzgehäuse
  Abdeckplatte / Kuppelaufnahme V4 · Maße in mm

  Die Unterseite liegt auf der Schalenwand auf. Der Flanschsitz
  ist von oben eingesenkt; die lichte Öffnung bleibt Ø176 mm.
  Die beiden vorderen M3-Schrauben der Schale vor dem Kuppelflansch montieren.
  Der Kuppel-Lochkreis ist erst nach Bestätigung der Einsatzmaße aktiv.

  Koordinaten:
  - x=0 Gehäusemittelachse
  - y=0 hinterste Außenkante, +y Richtung Kuppel
  - y=280 vorderster Punkt
  - z=0 Unterseite des Druckbauteils
*/

use <kontur_hdkatov_V4.scad>
use <kuppelbefestigung_hdkatov_V4.scad>

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
// Vorne M3 mit flachem Kopf (max. Ø6 mm, 2 mm hoch).
// 4 mm Sitzboden minus 2,2 mm Tasche = 1,8 mm Klemmstärke.
// Bei 6 mm Schaftlänge ergibt das 4,2 mm Einschraubweg.
deckel_kopf_tiefe_vorne = 2.2;

befestigungspunkte = schalen_befestigungspunkte();


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
        vorne = p[1] > kuppel_mitte_y;
        kopf_oberkante = vorne ? staerke - sitz_tiefe_total : staerke;
        taschen_tiefe = vorne ? deckel_kopf_tiefe_vorne : deckel_kopf_tiefe;

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

        // Vorne liegt die Tasche im Sitzboden, unter dem Kuppelflansch.
        translate([
            p[0],
            p[1],
            kopf_oberkante - taschen_tiefe
        ])
            cylinder(
                h = taschen_tiefe + eps,
                d = deckel_kopf_d
            );
    }
}


// Drei Durchgänge zu den oberen Schaleneinsätzen und hinten ein Sackloch.
module kuppelbohrungen_deckel() {
    sitzboden = staerke - sitz_tiefe_total;
    hinten = kuppel_punkt_hinten();
    hinten_tiefe = kuppel_einsatz_hinten_tiefe();
    randsteg = kuppel_randsteg_min();
    lichter_rand = kuppel_lochkreis_radius() - lichte_oeffnung_d / 2;
    sitzrand = kuppel_sitz_d / 2 * cos(180 / $fn) - kuppel_lochkreis_radius();
    assert(sitzboden - hinten_tiefe >= kuppel_restboden_hinten_min(),
           "Kuppeleinsatz hinten: Restboden im Flanschsitz zu dünn.");
    assert(kuppel_einsatz_hinten_d() / 2 + randsteg <= min(lichter_rand, sitzrand),
           "Kuppeleinsatz hinten: zu wenig Abstand im Flanschsitz.");
    assert(kuppel_durchgang_d() >= 3 &&
           kuppel_durchgang_d() / 2 + randsteg <=
               min(lichter_rand, sitzrand, kuppel_randabstand_schale()),
           "Kuppeldurchgang: Durchmesser oder Randsteg passt nicht.");

    for (p = kuppel_punkte_schale())
        translate([p[0], p[1], -eps])
            cylinder(h = sitzboden + 2 * eps, d = kuppel_durchgang_d());

    translate([hinten[0], hinten[1], sitzboden - hinten_tiefe])
        cylinder(h = hinten_tiefe + eps, d = kuppel_einsatz_hinten_d());
}

// --------------------
// Modell
// --------------------

module abdeckplatte_v4() {
    difference() {

        kantenrohling(staerke, kantenradius, oben = true);

        kuppel_ausschnitt();

        if (kuppel_bohrungen_aktiv())
            kuppelbohrungen_deckel();

        if (befestigungen_aktiv)
            deckel_befestigungsbohrungen();
    }
}

abdeckplatte_v4();
