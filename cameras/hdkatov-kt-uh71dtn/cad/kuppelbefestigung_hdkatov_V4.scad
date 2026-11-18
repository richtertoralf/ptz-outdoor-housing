// SPDX-License-Identifier: CERN-OHL-S-2.0
use <kontur_hdkatov_V4.scad>

// Freigegebener M3-Durchgang zu den drei Schaleneinsätzen.
function kuppel_durchgang_d() = 3.7;

// Bisherige Schalenaufnahme, auch für die drei Kuppeleinsätze.
// Prüfen: realen Einsatzdurchmesser und Druckpassung bestätigen.
function schalen_einsatz_d() = 4.2;
function schalen_einsatz_tiefe() = 6.5;
function schalen_einsatz_einfuehrung_d() = 5.2;
function schalen_einsatz_einfuehrung_tiefe() = 0.6;

// Hinten nur ein Sackloch. Durchmesser vom Schalen-Pilotloch übernommen,
// bis der kurze M3-Einsatz am Probedruck geprüft ist. Der 1-mm-Restboden
// und die mechanische Eignung sind nach dem Probedruck zu überprüfen.
function kuppel_einsatz_hinten_d() = schalen_einsatz_d();
function kuppel_einsatz_hinten_tiefe() = 3;
function kuppel_restboden_hinten_min() = 1;
// Geometrische Schutzgrenze. Eignung für Einsatz und Druck prüfen.
function kuppel_randsteg_min() = 1;

function kuppel_lochkreis_radius() = 186.5 / 2;

function kuppel_punkte_schale() =
    let(r = kuppel_lochkreis_radius(), y = kuppel_y())
    [[0, y + r], [-r, y], [r, y]];

function kuppel_punkt_hinten() =
    [0, kuppel_y() - kuppel_lochkreis_radius()];

// Konservative Abstände zur Innen- und Außenkontur im vorderen Bogen.
function kuppel_randabstand_schale() =
    let(r_aussen = gehaeuse_breite() / 2, r = kuppel_lochkreis_radius())
    min(r - (r_aussen - schalenwand()), r_aussen * cos(180 / 128) - r);
