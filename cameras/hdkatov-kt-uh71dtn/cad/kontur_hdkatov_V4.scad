// SPDX-License-Identifier: CERN-OHL-S-2.0
// Gemeinsame Kontur in Druckkoordinaten, Maße in mm.
function gehaeuse_breite() = 199;
function gehaeuse_laenge() = 280;
function schalenwand() = 10;
function kabelraum_laenge() = 70;
function kuppel_y() = gehaeuse_laenge() - gehaeuse_breite() / 2;

module aussenkontur_2d() {
    b = gehaeuse_breite();
    r = 20; // Erhält den bisherigen Innenraum, innen nominal R10.
    h = kuppel_y();
    union() {
        translate([-b / 2 + r, 0]) square([b - 2 * r, h]);
        translate([-b / 2, r]) square([b, h - r]);
        for (x = [-b / 2 + r, b / 2 - r])
            translate([x, r]) circle(r = r, $fn = 128);
        translate([0, h]) circle(r = b / 2, $fn = 128);
    }
}

module innenkontur_2d() {
    // Senkrechter Versatz jeder Konturkante, einschließlich der Facetten.
    offset(delta = -schalenwand()) aussenkontur_2d();
}

function deckel_befestigungspunkte() =
    let(x = (gehaeuse_breite() - schalenwand()) / 2, y = schalenwand() / 2)
    [[-70, y], [70, y], [-x, 100], [x, 100]];

// Viertelkreisprofil am Ende eines Rohlings mit konvexer Außenkontur.
module kantenrohling(hoehe, radius, oben = false) {
    segmente = 16;
    scheibe = 0.001;
    translate([0, 0, oben ? hoehe : 0])
        scale([1, 1, oben ? -1 : 1])
            hull() {
                for (i = [0 : segmente - 1]) {
                    winkel = 90 * i / segmente;
                    z = radius * (1 - cos(winkel));
                    einzug = radius * (1 - sin(winkel));
                    translate([0, 0, z])
                        linear_extrude(height = scheibe)
                            offset(delta = -einzug) aussenkontur_2d();
                }
                translate([0, 0, radius])
                    linear_extrude(height = hoehe - radius)
                        aussenkontur_2d();
            }
}
