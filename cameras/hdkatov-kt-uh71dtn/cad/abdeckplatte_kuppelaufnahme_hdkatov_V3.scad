// SPDX-License-Identifier: CERN-OHL-S-2.0
/*
  HDKATOV KT-UH71DTN Wetterschutzgehäuse
  Bauteil 3: Abdeckplatte / Kuppelaufnahme
  Einheit: mm

  V3 zu Issue #8: Hintere Außenradien passend zur V3-Schale vergrößert.
  Vorderer D-Bogen und großzügiger Kuppelsitz bleiben unverändert (#1).
  Vier reale Kuppellöcher sind noch zu vermessen; keine Lochlage erfinden.
  Das unpassende optionale Achtlochbild aus V2 entfällt deshalb in V3.
  Die vier Schrauben zur Schale bleiben davon unabhängig unverändert.

  Funktion:
  - liegt auf der Gehäuseschale
  - nimmt die Plexiglas-Kuppel auf
  - hat eine lichte Öffnung Ø176 mm
  - hat einen Kuppelsitz Ø200 mm für den Flansch der Kuppel
  - wird mit vier M3-Schrauben an der Gehäuseschale befestigt

  Koordinaten:
  - y=0 hintere Außenkante der Abdeckplatte
  - y=70 entspricht hinterer Kante der Bodenplatte
  - Kuppelmittelpunkt liegt bei y=180.5
  - z=0 Unterseite der Abdeckplatte
  - z=8 Oberseite der Abdeckplatte
*/

$fn = 160;

// Kleine Überlappung für zuverlässige Differenzen
eps = 0.02;


// --------------------
// Grundparameter
// --------------------

breite              = 199;
bodenplatte_laenge  = 210;
kabel_ueberstand    = 70;
laenge_gesamt       = bodenplatte_laenge
                    + kabel_ueberstand;

staerke             = 8;

// Entspricht der Wandstärke der Gehäuseschale.
// Wird zur Berechnung der Schraubenpositionen verwendet.
wandauflage         = 10;


// --------------------
// Außenkontur
// --------------------

// Nur die rückwärtige Außenkontur ändern, vor dem Beginn der Bodenplatte.
// Obergrenze erhält Wandreserve und Material um die hinteren Kopftaschen.
eckenradius         = 30; // [20:0.5:30]
assert(eckenradius >= 20 && eckenradius <= 30,
       "V3: Hinterer Außenradius muss zwischen 20 und 30 mm liegen.");

radius_vorne        = breite / 2;

kuppel_mitte_y      = kabel_ueberstand
                    + (bodenplatte_laenge - radius_vorne);


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

// Zwei hintere Schrauben
befestigung_hinten_x = 70;
befestigung_hinten_y = wandauflage / 2;

// Zwei seitliche Schrauben
befestigung_seite_x = breite / 2
                    - wandauflage / 2;

befestigung_seite_y = 100;

// Diese Punkte müssen identisch zu den Punkten
// in der Datei der Gehäuseschale sein.
befestigungspunkte = [
    [-befestigung_hinten_x, befestigung_hinten_y],
    [ befestigung_hinten_x, befestigung_hinten_y],

    [-befestigung_seite_x,  befestigung_seite_y],
    [ befestigung_seite_x,  befestigung_seite_y]
];


// --------------------
// Rechteck mit zwei
// abgerundeten hinteren Ecken
// --------------------

module rechteck_unten_rund_2d(b, h, r) {
    union() {

        // Mittelteil bis an die hintere Kante
        translate([-b / 2 + r, 0])
            square(
                [b - 2 * r, h],
                center = false
            );

        // Bereich oberhalb der Rundungen
        translate([-b / 2, r])
            square(
                [b, h - r],
                center = false
            );

        // Rundung hinten links
        translate([-b / 2 + r, r])
            circle(r = r);

        // Rundung hinten rechts
        translate([b / 2 - r, r])
            circle(r = r);
    }
}


// --------------------
// 2D-Außenkontur
// --------------------

module aussenkontur_2d() {
    union() {

        rechteck_unten_rund_2d(
            breite,
            kuppel_mitte_y,
            eckenradius
        );

        translate([0, kuppel_mitte_y])
            circle(r = radius_vorne);
    }
}


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

difference() {

    linear_extrude(height = staerke)
        aussenkontur_2d();

    kuppel_ausschnitt();

    if (befestigungen_aktiv)
        deckel_befestigungsbohrungen();
}
