// SPDX-License-Identifier: CERN-OHL-S-2.0
/*
  HDKATOV KT-UH71DTN Wetterschutzgehäuse
  Bodenplatte V4 · Maße in mm

  Die Kabelöffnung liegt innerhalb der Schaleninnenkontur.
  Der umlaufende Auflagerand trägt die Schalenwand.

  Koordinaten:
  - x=0 Gehäusemittelachse
  - y=0 hinterste Außenkante, +y Richtung Kuppel
  - y=280 vorderster Punkt
  - z=0 Unterseite des Druckbauteils

  Besonderheiten:
  - M3-Durchgangsbohrungen mit Kopftaschen von unten
  - Sacklochaufnahme für ruthex RX-1/4"-20x12.7
  - Gewindeeinsatz wird von unten eingeschmolzen
*/

use <kontur_hdkatov_V4.scad>

$vpr = [0, 0, 0];
$vpt = [0, 140, 0];
$vpd = 650;

$fn = 128;

// --------------------
// Parameter
// --------------------

staerke = 17;
kabel_ueberstand = kabelraum_laenge();
seiten_auflage = 20;
kabeloeffnung_breite = gehaeuse_breite() - 2 * seiten_auflage;
kabeloeffnung_laenge = kabel_ueberstand - schalenwand();

// --------------------
// M3-Kamera-Befestigung
// --------------------

// Durchgangsbohrung mit etwas Spiel für M3
m3_hole_d           = 3.5;

// Zylindrische Kopftasche für
// M3-Innensechskant-Zylinderkopfschrauben
m3_kopf_d           = 6.5;
m3_kopf_tiefe       = 3.2;

// Positionen
m3_abstand_x        = 107;
m3_hinten_y         = 84;
m3_vorne_y          = m3_hinten_y + 81;


// --------------------
// 1/4"-20-Fotogewindeeinsatz
// ruthex RX-1/4"-20x12.7
// --------------------

foto_y_vorne  = 140;
foto_y_hinten = foto_y_vorne - 25;

// Startwert für die Aufnahmebohrung.
// Vor dem Hauptdruck am besten mit einem Probestück testen.
foto_einsatz_d          = 8;

// Übernommene Aufnahme: 12,7-mm-Einsatz plus 1,0 mm Tiefenreserve
foto_einsatz_tiefe      = 13.7;

// Kleine Einführschräge an der Unterseite
foto_einfuehrung_d      = 8.8;
foto_einfuehrung_tiefe  = 0.8;


// --------------------
// 2D-Außenkontur
// --------------------

module kabelausgang_2d() {
    innenradius = 25;
    intersection() {
        translate([-kabeloeffnung_breite / 2, schalenwand()])
            offset(r = innenradius)
                offset(delta = -innenradius)
                    square([kabeloeffnung_breite, kabeloeffnung_laenge]);
        innenkontur_2d();
    }
}

module bodenplatte_2d() {
    difference() {
        aussenkontur_2d();
        kabelausgang_2d();
    }
}


// --------------------
// M3-Bohrung mit Kopftasche
// --------------------

module m3_bohrung_mit_kopftasche(x, y) {

    // Durchgehende M3-Bohrung
    translate([x, y, -1])
        cylinder(
            h = staerke + 2,
            d = m3_hole_d
        );

    // Zylindrische Kopftasche an der Unterseite
    translate([x, y, -0.01])
        cylinder(
            h = m3_kopf_tiefe + 0.02,
            d = m3_kopf_d
        );
}


// --------------------
// Aufnahme für Fotogewindeeinsatz
// --------------------

module foto_einsatzaufnahme(y_pos) {

    // Zylindrisches Sackloch von der Unterseite
    translate([0, y_pos, -0.01])
        cylinder(
            h = foto_einsatz_tiefe + 0.01,
            d = foto_einsatz_d
        );

    // Konische Einführschräge
    translate([0, y_pos, -0.01])
        cylinder(
            h  = foto_einfuehrung_tiefe + 0.01,
            d1 = foto_einfuehrung_d,
            d2 = foto_einsatz_d
        );
}


// --------------------
// Alle Bohrungen
// --------------------

module bohrungen() {

    // M3 hinten links und rechts
    for (x = [
        -m3_abstand_x / 2,
         m3_abstand_x / 2
    ]) {
        m3_bohrung_mit_kopftasche(
            x,
            m3_hinten_y
        );
    }

    // M3 vorne mittig
    m3_bohrung_mit_kopftasche(
        0,
        m3_vorne_y
    );

    // Vorderes Fotogewinde
    foto_einsatzaufnahme(foto_y_vorne);

    // Zweites Fotogewinde, weiter hinten
    foto_einsatzaufnahme(foto_y_hinten);
}


// --------------------
// Sicherheitsprüfung
// --------------------

assert(
    foto_einsatz_tiefe < staerke,
    "Fehler: Die Aufnahme des Gewindeeinsatzes ist tiefer als die Bodenplatte."
);

assert(
    m3_kopf_tiefe < staerke,
    "Fehler: Die M3-Kopftasche ist tiefer als die Bodenplatte."
);


// --------------------
// Modell
// --------------------

module bodenplatte_v4() {
    difference() {
        linear_extrude(height = staerke) bodenplatte_2d();
        // Bohrkoordinaten beziehen sich auf die Vorderkante des Kabelraums.
        translate([0, kabel_ueberstand, 0]) bohrungen();
    }
}

bodenplatte_v4();
