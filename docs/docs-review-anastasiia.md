# Quality-Review: Anastasiia HR-Docs

**Datum:** 2026-05-17
**Hochgeladen:** 09.05.2026 (übersehen bis 17.05.)
**Pfad:** `company-docs/anastasiia/` (.docx + .md konvertiert)
**Status:** Geprüft, NICHT in Ingestion eingebunden (Konflikt-Risiko)

---

## Was Anastasiia geliefert hat

5 BergTech HR-Docs als .docx, gleiche Themen wie rustam/:

| # | Anastasiia | Wörter | rustam/ Vergleich | Wörter |
|---|------------|--------|-------------------|--------|
| 1 | Onboarding_Guide_BergTech | 339 | 01-onboarding-guide | 588 |
| 2 | Vacation_Policy_BergTech | 256 | 02-vacation-policy | 521 |
| 3 | Compliance_Policy_BergTech | 197 | 03-training-compliance-policy | 543 |
| 4 | HR_FAQ_BergTech | 136 | 04-hr-faq | 761 |
| 5 | Offboarding_Checklist_BergTech | 139 | 05-offboarding-checklist | 626 |
| | **Total** | **1.067** | **Total** | **3.039** |

---

## Was gut ist

- ✅ **Spezifische Details**: 30 Tage Urlaub, Personio, SAP ERP, 25. Gehalt, Geschenke max 25 EUR, 14 Tage Vorlauf, 08:30 Krankmeldung, etc.
- ✅ **Strukturiert**: klare Sections mit Headlines + Bullet-Listen
- ✅ **FAQ als Q&A-Format** (Doc 4) — sehr RAG-tauglich
- ✅ **Metadaten-Header** auf jedem Doc ("DOKUMENTEN-METADATEN: ...")
- ✅ **Inhaltlich plausibel und konsistent intern**
- ✅ **Bergtech-spezifisch** (nicht generisch)

---

## Was problematisch ist

### 1. Saile-Pflicht "at least one page" knapp / verletzt

Saile-Aufgabe: *"Each document should have at least one page of content"*.

Standard ist ~250-300 Wörter pro Seite. Anastasiia-Docs:
- Doc 4 HR-FAQ: **136 Wörter** = ~0.5 Seiten ❌
- Doc 5 Offboarding: **139 Wörter** = ~0.5 Seiten ❌
- Doc 3 Compliance: **197 Wörter** = ~0.7 Seiten ❌
- Doc 2 Vacation: **256 Wörter** = ~1 Seite ⚠️
- Doc 1 Onboarding: **339 Wörter** = ~1.3 Seiten ✅

→ 3 von 5 verletzen die "at least one page"-Vorgabe. Saile könnte das in Q&A monieren.

### 2. Inhalts-Konflikte zu rustam/-Docs

**Beispiel Urlaubsfrage (Demo-Frage #2!):**

| Quelle | Antwort |
|--------|---------|
| Anastasiia | Standard: min. **14 Tage** vorher; Kurz (≤2 Tage): 3 Arbeitstage vorher |
| rustam | 1-2 Tage: **5 Werktage**; 3-9 Tage: **14 Tage**; ab 10 Tage: **6 Wochen** |

→ **Bei beiden Sets im RAG würde der Bot zufällig eine der beiden Antworten geben.** Saile-Demo-Killer.

**Weitere Konflikte zu prüfen:**
- Krankmeldung-Zeitpunkt
- Onboarding-Pflichttrainings (Liste unterschiedlich)
- Offboarding-Prozess-Schritte

---

## Empfehlungen

### Option A — Anastasiia-Set parken, rustam/ als Primary nutzen
- Anastasiia-Docs in `company-docs/anastasiia/` belassen, nicht ingesten
- Demo läuft mit rustam/-Set, das ist konsistent und ausführlicher
- Anastasiia bekommt Credit für die Arbeit, kann sie für Doku-Cross-Reference nutzen

### Option B — Konflikte resolven + mergen
- Mit Anastasiia gemeinsam **eine** kanonische Antwort pro Konfliktfrage festlegen
- Längen-Defizit ausgleichen (Docs 3, 4, 5 erweitern auf min. 250 Wörter)
- Beide Sets mergen oder rustam/-Set mit Anastasiia-Details anreichern
- Aufwand: 2-3h gemeinsam

### Option C — Anastasiia-Set als Primary, rustam/ archivieren
- Wenn Anastasiia ihre Docs lieber sieht: ihres nehmen, Längen ausgleichen
- Rustam-Set in `_archiv/` für Cross-Reference
- Aufwand: 2h Längen-Erweiterung

---

## Meine Empfehlung

**Option A für jetzt** (Demo-Stabilität), **Option B als Folgearbeit** wenn Zeit übrig.

Begründung:
- Saile-Submission 31.05. ist eng — Konfliktauflösung ist Bonus, nicht Pflicht
- rustam/-Set ist bereits in PDF konvertiert + Symlink für n8n-Ingestion gesetzt
- Anastasiia-Set zeigt dass Anastasiia mitgearbeitet hat (wichtig für Individual Grading Report)
- Wir können in Doku transparent dokumentieren: "Cross-Validation durchgeführt, Konflikte identifiziert, primäres Set ist rustam/"

---

## Konkrete Schritte (wenn Option A)

1. ✅ Dateien sind in `company-docs/anastasiia/` (Original .docx + .md)
2. ⏳ Ingestion bleibt unverändert (liest nur `company-docs/rustam/`)
3. ⏳ Mit Anastasiia + Juliana beim Sync besprechen
4. ⏳ In Doku-Section "Methodik" erwähnen: Cross-Validation gemacht
5. ⏳ Konflikt-Liste in Implementation-Reflection als What-Went-Wrong dokumentieren

---

## Konkrete Schritte (wenn Option B nach Sync)

1. Konflikt-Liste durchgehen, pro Frage **eine** Antwort festlegen
2. Drei kurze Docs (Compliance, FAQ, Offboarding) auf min. 250 Wörter erweitern
3. Master-Set bauen in `company-docs/gruppe/` (oder rustam/ updaten)
4. PDFs neu generieren
5. Re-Ingestion in Supabase nach Setup
