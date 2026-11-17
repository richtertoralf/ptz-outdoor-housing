/*
  HDKATOV KT-UH71DTN Wetterschutzgehäuse
  Bauteil 2: Gehäuseschale / Untergehäuse
  Einheit: mm

  Funktion:
  - sitzt auf der Bodenplatte
  - bildet eine 70 mm hohe Seitenwand
  - steht nach hinten 70 mm über die Bodenplatte hinaus
  - nimmt vier M3-Schmelzgewindeeinsätze auf
  - trägt die Abdeckplatte / Kuppelaufnahme

  Koordinaten:
  - y=0 hintere Außenkante der Gehäuseschale
  - y=70 entspricht hinterer Kante der Bodenplatte
  - vorne = 180°-Halbkreis
  - z=0 Unterkante der Gehäuseschale
  - z=70 Oberkante der Gehäuseschale
*/

$fn = 128;

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

hoehe               = 70;
wandstaerke         = 10;


// --------------------
// Außenkontur
// --------------------

eckenradius         = 20; // [0:0.5:30]

radius_vorne        = breite / 2;

bogen_mitte_y       = kabel_ueberstand
                    + (bodenplatte_laenge - radius_vorne);


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

// Zwei hintere Gewindeeinsätze
befestigung_hinten_x = 70;
befestigung_hinten_y = wandstaerke / 2;

// Zwei seitliche Gewindeeinsätze
befestigung_seite_x = breite / 2
                    - wandstaerke / 2;

befestigung_seite_y = 100;

// Diese Punkte müssen identisch zu den Punkten
// in der Datei der Abdeckplatte sein.
befestigungspunkte = [
    [-befestigung_hinten_x, befestigung_hinten_y],
    [ befestigung_hinten_x, befestigung_hinten_y],

    [-befestigung_seite_x,  befestigung_seite_y],
    [ befestigung_seite_x,  befestigung_seite_y]
];


// --------------------
// Optionale Kabelöffnung
// --------------------

kabeloeffnung_aktiv = false;

kabel_slot_breite   = 40;
kabel_slot_hoehe    = 22;
kabel_slot_z        = 25;


// --------------------
// Rechteck mit zwei
// abgerundeten hinteren Ecken
// --------------------

module rechteck_unten_rund_2d(b, h, r) {
    union() {

        // Hinterer Mittelteil
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
            bogen_mitte_y,
            eckenradius
        );

        translate([0, bogen_mitte_y])
            circle(r = radius_vorne);
    }
}


// --------------------
// 2D-Innenkontur
// --------------------

module innenkontur_2d() {
    offset(delta = -wandstaerke)
        aussenkontur_2d();
}


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

module gewindeeinsatzbohrungen() {
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
// Optionale Kabelöffnung
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
                wandstaerke + 4,
                kabel_slot_hoehe
            ],
            center = false
        );
}


// --------------------
// Sicherheitsprüfungen
// --------------------

assert(
    einsatz_loch_tiefe < hoehe,
    "Fehler: Die Sacklochtiefe ist größer als die Gehäusehöhe."
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

difference() {

    schale_roh();

    if (befestigungen_aktiv)
        gewindeeinsatzbohrungen();

    if (kabeloeffnung_aktiv)
        kabeloeffnung();
}
