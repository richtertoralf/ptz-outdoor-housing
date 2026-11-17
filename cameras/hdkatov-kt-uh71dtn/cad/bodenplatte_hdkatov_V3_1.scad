// SPDX-License-Identifier: CERN-OHL-S-2.0
/*
  HDKATOV KT-UH71DTN Wetterschutzgehäuse
  Bauteil 1: Bodenplatte
  Einheit: mm

  V3.1 zu Issue #11: Die hintere Verlängerung trägt die V3-Schale,
  lässt aber den nach unten geführten Kabeln ihren geprüften Biegeraum.
  Kabel vor dem Aufsetzen des vormontierten Oberteils anschließen.
  Keine neuen Schalenbefestigungsbohrungen: Positionen und versenkte
  vordere Schraubenköpfe sind noch am realen Aufbau zu prüfen (#10).
  Vorhandene Kamera- und Stativaufnahmen bleiben unverändert.

  Koordinaten:
  - Draufsicht
  - Hinten = gerade Kante
  - Vorne = 180°-Halbkreis
  - x=0 Mittelachse
  - y=0 bisherige hintere Kante der Bodenplatte (Bezug aus V2/V3)
  - y=-70 neue hintere Außenkante, passend zu y=0 der V3-Schale
  - z=0 Unterseite der Bodenplatte

  Besonderheiten:
  - M3-Durchgangsbohrungen mit Kopftaschen von unten
  - Sacklochaufnahme für ruthex RX-1/4"-20x12.7
  - Gewindeeinsatz wird von unten eingeschmolzen
*/

$fn = 128;

// --------------------
// Parameter
// --------------------

breite              = 199;
laenge              = 210;

// Stärkere Bodenplatte für den 12,7-mm-Gewindeeinsatz
staerke             = 17.0;

radius_vorne        = breite / 2;
bogen_mitte_y       = laenge - radius_vorne;


// --------------------
// Hintere Auflage für die V3-Schale
// --------------------

kabel_ueberstand     = 70;
hinten_auflage       = 10;
seiten_auflage       = 20;
eckenradius_hinten   = 30;

kabeloeffnung_breite = breite - 2 * seiten_auflage;
kabeloeffnung_laenge = kabel_ueberstand - hinten_auflage;

// y=0 bleibt erhalten: Kamera- und Stativlochlagen nicht verschieben.
// Der hintere Steg liegt nur unter der V3-Wand; deren ursprüngliche
// Innenrundung hat ihren Mittelpunkt 20 mm vor der Schalenhinterkante.
// Nennmaße der Öffnung bleiben erhalten; keine einragenden Führungen.
assert(seiten_auflage >= eckenradius_hinten - hinten_auflage,
       "Kabelöffnung würde die hintere Außenrundung durchbrechen.");
assert(kabeloeffnung_breite > 0 && kabeloeffnung_laenge > 0,
       "Kabelöffnung muss in beide Richtungen frei bleiben.");


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
foto_y_hinten = foto_y_vorne - 25; // 115 mm von der hinteren Kante

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

module rechteck_hinten_rund_2d(b, h, r) {
    union() {
        translate([-b / 2 + r, 0]) square([b - 2 * r, h]);
        translate([-b / 2, r]) square([b, h - r]);
        for (x = [-b / 2 + r, b / 2 - r])
            translate([x, r]) circle(r = r);
    }
}

module aussenkontur_2d(r = eckenradius_hinten) {
    union() {
        translate([0, -kabel_ueberstand])
            rechteck_hinten_rund_2d(
                breite, kabel_ueberstand + bogen_mitte_y,
                r
            );
        translate([0, bogen_mitte_y]) circle(r = radius_vorne);
    }
}


module kabelausgang_2d() {
    innenradius = 25;

    intersection() {
        // Kabelöffnung mit vier abgerundeten Innenecken
        translate([
            -kabeloeffnung_breite / 2,
            -kabeloeffnung_laenge
        ])
        offset(r = innenradius)
            offset(delta = -innenradius)
                square([
                    kabeloeffnung_breite,
                    kabeloeffnung_laenge
                ]);

        // Originaler V3-Innenraum:
        // Basisradius 20 mm, Wandversatz 10 mm.
        // Erhält die Auflage an den Rundungsübergängen.
        offset(delta = -10)
            aussenkontur_2d(20);
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

difference() {

    linear_extrude(height = staerke)
        bodenplatte_2d();

    bohrungen();
}
