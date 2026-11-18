// SPDX-License-Identifier: CERN-OHL-S-2.0
/*
  HDKATOV KT-UH71DTN Wetterschutzgehäuse
  Bodenplatte V4 · Maße in mm

  Die Kabelöffnung liegt innerhalb der Schaleninnenkontur.
  Die Schalenwand steht auf dem ebenen 10-mm-Rand.
  Die inneren Seitenstreifen fallen quer um 1 mm zur Kabelöffnung ab.

  Koordinaten:
  - x=0 Gehäusemittelachse
  - y=0 hinterste Außenkante, +y Richtung Kuppel
  - y=280 vorderster Punkt
  - z=0 Unterseite des Druckbauteils

  Besonderheiten:
  - M3-Durchgangsbohrungen mit Kopftaschen von unten
  - Laschenbefestigung von oben und Zentrierzapfen als Prototyp
  - Sacklochaufnahmen für ruthex RX-1/4"-20x12.7 von unten
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
kantenradius = 0.75; // Äußere Unterkante.
kabel_ueberstand = kabelraum_laenge();
seiten_auflage = 20;
kabelradius = 25;
kabeloeffnung_breite = gehaeuse_breite() - 2 * seiten_auflage;
kabeloeffnung_laenge = kabel_ueberstand - schalenwand();

// Querprofil und Übergang zur Kabelöffnung.
gefaelle = 1;
lippen_breite = 3;
lippen_tiefe = 3;
schnittzugabe = 0.02;

// M3 von unten: 17 - 3,2 mm Klemmstrecke, bei 18 mm Schraubenlänge
// bleiben 4,2 mm Einschraubweg im bündigen 6-mm-Einsatz.
schalen_schraube_d = 3.5;
schalen_kopf_d = 6.5;
schalen_kopftiefe = 3.2;

// --------------------
// M3-Kamera-Befestigung
// --------------------

// Durchgangsbohrung mit etwas Spiel für M3
m3_hole_d           = 4;

// Zylindrische Kopftasche für
// M3-Innensechskant-Zylinderkopfschrauben
m3_kopf_d           = 6.5;
m3_kopf_tiefe       = 3.2;

// Positionen
m3_abstand_x        = 107;
m3_hinten_y         = 154;
m3_vorne_y          = 227;

// Zweite Kamerabefestigung, alle Achsen ab hinterer Außenkante.
// Prototyp für ruthex RX-M3Sx4,0: Ø4 mm und 1 mm Tiefenreserve
// laut RX-Datenblatt. Langloch, Schraube und Werkzeug am Gerät prüfen.
laschen_abstand_x   = 62;
laschen_y           = 80;
laschen_aufnahme_d  = 4;
laschen_aufnahme_t  = 5;

zapfen_y            = 217;
zapfen_d            = 4.5;
zapfen_h            = 6;
zapfen_fase         = 0.5;


// --------------------
// 1/4"-20-Fotogewindeeinsatz
// ruthex RX-1/4"-20x12.7
// --------------------

foto_y_vorne  = 195;
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
    innenradius = kabelradius;
    intersection() {
        translate([-kabeloeffnung_breite / 2, schalenwand()])
            offset(r = innenradius)
                offset(delta = -innenradius)
                    square([kabeloeffnung_breite, kabeloeffnung_laenge]);
        innenkontur_2d();
    }
}

module quergefaelle_schnitt() {
    innenkante = gehaeuse_breite() / 2 - seiten_auflage;
    wandkante = gehaeuse_breite() / 2 - schalenwand();
    // X/Z-Profil. Das 1-mm-Niveau reicht bis zur Öffnung.
    translate([0, kabel_ueberstand, 0])
        rotate([90, 0, 0])
            linear_extrude(height = kabeloeffnung_laenge)
                polygon([
                    [0, staerke - gefaelle],
                    [innenkante, staerke - gefaelle],
                    [wandkante, staerke],
                    [wandkante, staerke + schnittzugabe],
                    [0, staerke + schnittzugabe]
                ]);
}

module auslauf_schnitt() {
    // Y/Z-Begrenzung: an den geraden Stücken volles Quergefälle,
    // zu den R25-Enden hin stetiger Übergang zur Plattenoberseite.
    radius = kabelradius;
    y0 = schalenwand();
    y1 = kabel_ueberstand;
    translate([-gehaeuse_breite() / 2, 0, 0])
        rotate([90, 0, 90])
            linear_extrude(height = gehaeuse_breite())
                polygon([
                    [y0, staerke],
                    [y0 + radius, staerke - gefaelle],
                    [y1 - radius, staerke - gefaelle],
                    [y1, staerke],
                    [y1, staerke + schnittzugabe],
                    [y0, staerke + schnittzugabe]
                ]);
}

module entwaesserung_schnitt() {
    intersection() {
        // Hält Rücksteg und die gesamte Schalenauflage eben.
        linear_extrude(height = staerke + 1) innenkontur_2d();
        union() {
            intersection() {
                auslauf_schnitt();
                union() {
                    quergefaelle_schnitt();
                    mirror([1, 0, 0]) quergefaelle_schnitt();
                }
            }
            // Fase an den gerundeten Enden. Die geraden Seitenstreifen
            // behalten bis zur Kabelkante ihr vollständiges Querprofil.
            intersection() {
                translate([-kabeloeffnung_breite / 2, 0, 0])
                    cube([kabeloeffnung_breite, kabelraum_laenge() + lippen_breite,
                          staerke + 1]);
                hull() {
                    translate([0, 0, staerke - lippen_tiefe])
                        linear_extrude(height = schnittzugabe) kabelausgang_2d();
                    translate([0, 0, staerke])
                        linear_extrude(height = schnittzugabe)
                            offset(r = lippen_breite) kabelausgang_2d();
                }
            }
        }
    }
}

module schalenbefestigungsbohrungen() {
    // Sechs Achsen gemeinsam mit Deckel und unteren Schalen-Einsätzen.
    for (p = schalen_befestigungspunkte())
        translate([p[0], p[1], -schnittzugabe]) {
            cylinder(h = staerke + 2 * schnittzugabe, d = schalen_schraube_d);
            cylinder(h = schalen_kopftiefe + schnittzugabe, d = schalen_kopf_d);
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
// Kameralaschen und Zentrierung
// --------------------

module laschen_einsatzaufnahmen() {
    for (x = [-laschen_abstand_x / 2, laschen_abstand_x / 2])
        translate([x, laschen_y, staerke - laschen_aufnahme_t])
            cylinder(h = laschen_aufnahme_t + schnittzugabe, d = laschen_aufnahme_d);
}

module zentrierzapfen() {
    // Überlappung in Z für einen Körper, ohne Aufdickung an der Auflage.
    // Zum Positionieren; die Laschenschrauben sichern gegen Abheben.
    translate([0, zapfen_y, staerke]) {
        translate([0, 0, -schnittzugabe])
            cylinder(h = zapfen_h - zapfen_fase + schnittzugabe, d = zapfen_d);
        translate([0, 0, zapfen_h - zapfen_fase])
            cylinder(h = zapfen_fase, d1 = zapfen_d, d2 = zapfen_d - 2 * zapfen_fase);
    }
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

    laschen_einsatzaufnahmen();
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
        union() {
            kantenrohling(staerke, kantenradius);
            zentrierzapfen();
        }
        translate([0, 0, -schnittzugabe])
            linear_extrude(height = staerke + 2 * schnittzugabe)
                kabelausgang_2d();
        entwaesserung_schnitt();
        schalenbefestigungsbohrungen();
        bohrungen();
    }
}

bodenplatte_v4();
