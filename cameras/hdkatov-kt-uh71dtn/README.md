# HDKATOV KT-UH71DTN – mobiles Wetterschutzgehäuse

Für kurzzeitige Außeneinsätze auf mobilen Stativen. Kabel vor dem Aufsetzen der Schale anschließen und nach unten führen.

**Einsatz und Praxiserfahrungen**

- **Einsatzzweck:** Die HDKATOV KT-UH71DTN mit NDI und 25-fachem optischem Zoom für mobile Sport-Livestreams im Freien nutzbar machen. Mit montiertem Wetterschutz müssen **mindestens 300° horizontaler Schwenkbereich mit freier Sicht** nutzbar bleiben.
- **Kosten und Alternativen:** Die Kamera kostet rund **1.500 €**, der erste Satz aus drei PETG-Druckteilen **48,31 € inklusive Versand**. Kuppel, Befestigungsmaterial und Stativadapter kommen hinzu. Die [BirdDog O4](https://birddog.tv/o4/) ist mit rund **6.050 €** eine vergleichbare Outdoor-Produktionskamera. [Dotworkz](https://shop.dotworkz.com/) kommt als Kaufgehäuse für teurere Indoor-PTZ infrage, sofern Kamera und Montage passen. [PTZOptics dokumentiert Dotworkz-Gehäuse für seine Kameras](https://ptzoptics.com/wp-content/uploads/2021/01/PTZOptics-Outdoor-Camera-Enclosure-Quick-Start-Guide.pdf). Die bisher eingesetzten günstigen Outdoor-Überwachungskameras erfüllen unsere Anforderungen an Bildqualität und NDI nicht.
- **Bildqualität:** Bei ungünstigem Lichteinfall können Kuppelreflexionen das Bild beeinträchtigen, besonders bei starkem Zoom. Eine Blende am Objektiv scheidet wegen des wechselnden Abstands zur Kuppel aus. Die [Porta-Brace-Hülle RS-PTZOPTICS30X](https://www.portabrace.com/product-page/rs-ptzoptics) lässt sich mangels Befestigungsmöglichkeit am Objektiv der HDKATOV nicht verwenden. Die [RS-FR7PTZ](https://www.portabrace.com/product-page/rs-fr7ptz) ist eine vergleichbare Regenhülle für die Sony ILME-FR7 und nutzt ebenfalls eine Neoprenmanschette am Objektiv. Eine Lösung für die Reflexionen ist offen. [Optik und Reflexionen #6](https://github.com/richtertoralf/ptz-outdoor-housing/issues/6)
- **Regen und Schnee:** Starker Niederschlag auf der obenliegenden Kuppel verschlechtert das Bild. Eine hängende Variante mit Kuppel nach unten soll die Niederschlagsbelastung reduzieren. Ihre Wirkung und die Eignung für die mobile Stativmontage müssen noch geprüft werden. [Einbaulage #7](https://github.com/richtertoralf/ptz-outdoor-housing/issues/7)

**Befestigung und offene Prüfungen**

- **Kamera, M3 von unten (#25):** Ø4-mm-Durchgänge bei (±53,5; 154) und (0; 227) mm.
  Schraubenköpfe, Einschraubtiefe und spannungsfreie Montage aller drei Schrauben am Druck prüfen.
- **Kamera, Laschen von oben (#26, Prototyp):** Bei (±31; 80) mm kommen kurze ruthex RX-M3Sx4,0
  infrage (Ø4 × 5 mm Sackloch von oben). CAD: 12 mm Restboden, mindestens 7 mm von der Achse
  zum oberen Kabelraumrand und mindestens 4,7 mm vom Buchsenaußenrand bis dorthin.
  Langlochbreite und -länge, Laschenstärke, Auflage, Scheiben- und Werkzeugfreiraum messen.
  Schraubenlänge aus Klemmstrecke und nutzbarer Einschraubtiefe bestimmen. Buchsen bündig einsetzen.
- **Zentrierung (#26):** Zapfen bei (0; 217) mm, Ø4,5 × 6 mm mit 0,5-mm-Fase. Nominales
  Durchmesserspiel zur gemessenen Ø5-mm-Öffnung: 0,5 mm. Die gemessene Öffnungstiefe
  von 10 mm lässt bei voller Einführung 4 mm nominale Reserve zum Lochgrund.
  Eingriff und spannungsfreie Auflage bei beiden Montagevarianten am Druck prüfen.
  Der Zapfen positioniert. Gegen Abheben sichern die Schrauben der gewählten Befestigung.
  [Kamerahandbuch, Pos. 20 auf PDF-S. 4](KT-UH71KT-71DT_UserManual-20241115.pdf#page=4).
- **Probedruck:** Platte flach drucken. Als Startwerte 0,20 mm Schichthöhe und vier
  Außenlinien, im Slicer lokal Vollmaterial um Laschenbuchsen und Zapfen samt Ansatz vorsehen.
  Sacklöcher und Zapfen am Probedruck vermessen, beide Befestigungen einzeln montieren und
  die gesamte Kette auf Auszug, Verdrehen, Kippen und unabhängige Sicherung prüfen.
- **Schale:** Je sechs M3-Schrauben zu Boden und Deckel greifen in Messing-Einschmelzeinsätze.
  Einsatzmaße und nutzbare Gewindetiefe prüfen. Schraubenlängen und Kamerafreiraum am Aufbau
  prüfen. Die zwei vorderen Deckelschrauben brauchen flache Köpfe und werden vor der Kuppel montiert.
- **Kuppel:** Vier M3-Achsen auf Ø186,5 mm. Drei Ø3,7-mm-Durchgänge zu Schaleneinsätzen.
  Hinten vorläufig Ø4,2 × 3 mm tief im 4-mm-Sitzboden. Kurzen Einsatz und den verbleibenden
  1-mm-Restboden und Eignung des kurzen M3-Einsatzes nach dem Probedruck prüfen. Die Konstruktion darf als Prototyp gedruckt werden; die mechanische Eignung wird erst im Test beurteilt.
- **Stativ:** Zwei zur bündigen Montage vorgesehene RX-1/4"-20 × 12,7 mm bei X = 0, Y = 170 und 195 mm (25 mm Abstand, Bezug zu #22).
  Das [ruthex-Datenblatt](https://www.igo3d.com/mediafiles/Sonstiges/Ruthex/ruthex_Datenblatt_RX-Serie.pdf)
  nennt Ø8,0 mm für die Aufnahme. V4 hat dort 13,7 mm Sacklochtiefe und nominal 3,3 mm Restboden.
  Zapfenachse 22 mm vor dem nächsten Stativeinsatz. Bündigkeit, Schraubüberstand und
  Festigkeit am Druck prüfen. Für #22 bleiben Schnellwechselplatte und Schraubenzugang offen.

**Aluminiumadapter als Prototyp**

- 60 × 60 × 8 mm als Startmaß. Zwei symmetrische Ø7-mm-Durchgänge mit 25 mm Abstand.
  Lochbild am Druck prüfen. Adapter satt auflegen, Schrauben ohne Grundkontakt auslegen
  und unten Freiraum für Schraubenköpfe, Werkzeug und Stativanschluss lassen.
- Passende 16-mm-Aufnahme oder verriegelten 28-mm-Zapfenanschluss mit Zweipunktflansch
  versetzt zu den Gehäuseschrauben montieren. Den Walimex-28/16-Spigot über 1/4"-Gewinde
  nur mit bestätigter Tragfähigkeit und Verdrehsicherung einsetzen. [Walimex-Anleitung](https://www.fotokoch.de/bilddaten/betriebsanleitungen/36540-bedienungsanleitung-walimex-pro-air-jumbo-730-lampenstativ.pdf).
  Ein späterer Schnellwechsel zwischen Adapter und Aufnahme braucht Verdreh- und Aushebesicherung.
- Der kurze Schraubenabstand begrenzt die Abstützung von Kippmomenten. Gesamtmasse,
  Schwerpunkt, Wind- und Kabelzug am Aufbau prüfen (Kamera ca. 2 kg, Handbuch PDF-S. 19–20).
  Bei Bedarf breitere Drei- oder Vierpunktbefestigung mit Gegenplatten und Kollisionsprüfung erwägen.

**Bohr- und Konturschablone V4 (1:1)**

[A3-PDF](schablonen/bodenplatte_hdkatov_V4_1zu1_A3.pdf) ·
[A4-PDF](schablonen/bodenplatte_hdkatov_V4_1zu1_A4.pdf).
Mit „Tatsächliche Größe“ (100 %) drucken und die 100-mm-Strecke nachmessen.
Bei unbedruckbaren Seitenrändern über etwa 5,4 mm A3 wählen.

Wetterfestigkeit, Stabilität und freier PTZ-Betrieb sind durch Praxistests zu bestätigen.
Das Kamerahandbuch ist Fremdmaterial und fällt nicht unter die Hardwarelizenz des Projekts.
