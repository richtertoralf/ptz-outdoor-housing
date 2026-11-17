// SPDX-License-Identifier: CERN-OHL-S-2.0
use <bodenplatte_hdkatov_V4.scad>
use <gehaeuseschale_hdkatov_V4.scad>
use <abdeckplatte_kuppelaufnahme_hdkatov_V4.scad>

$vpr = [58, 0, 25];
$vpt = [0, 140, 45];
$vpd = 650;

// Z-Stapel: Boden 17 mm, Schale 70 mm, Deckel 8 mm.
color("steelblue") bodenplatte_v4();
color("lightgray") translate([0, 0, 17]) gehaeuseschale_v4();
color("orange") translate([0, 0, 87]) abdeckplatte_v4();
