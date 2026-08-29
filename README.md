# DP1 Museum & Cultural Heritage Platform

An XML-based database platform for museum and cultural heritage collection management, featuring XSD schema validation, 10 recursive XSLT transformation scenarios (HTML, XML, JSON, YAML), dual Python XML API implementations (lxml and W3C DOM), JSON Schema Draft 2020-12 validation, and PDF report compilation.

---

## 🚀 Quick Execution Guide

### 1. Execute XML Validation & All 10 XSLT Transformations (lxml API)
```bash
python src/pipeline.py
```

### 2. Execute W3C DOM API Traversal (Optional Bonus Implementation)
```bash
python src/dom_export.py
```

### 3. Run JSON Schema Draft 2020-12 Validation Test
```bash
python tests/test_json_schema.py
```

### 4. Compile Project PDF Report
```bash
python src/generate_report.py
```

### 5. Automated One-Command Master Build & Submission ZIP Packaging
```bash
python src/build_submission.py
```

---

## 📁 Repository Structure

```text
DP1_Museum_Project/
├── data/
│   └── museum.xml                      # Representative XML database extract
├── schema/
│   ├── museum.xsd                      # W3C XML Schema with key/keyref constraints
│   └── artifact_catalogue.schema.json  # JSON Schema specification
├── json-schema/
│   └── artifact-api.schema.json        # JSON Schema Draft 2020-12 definition
├── xslt/                               # 10 XSLT transformation stylesheets
│   ├── html/                           # 6 HTML visualization scenarios (01-06)
│   ├── xml/                            # 2 XML interchange scenarios (07-08)
│   ├── json/                           # 1 JSON REST API scenario (09)
│   └── yaml/                           # 1 YAML summary scenario (10)
├── outputs/                            # Generated transformation outputs
│   ├── html/                           # HTML web pages (01-06)
│   ├── xml/                            # XML exports (07-08)
│   ├── json/                           # JSON API payload (09) & DOM export
│   └── yaml/                           # YAML collection config (10)
├── src/                                # Python application source files
│   ├── pipeline.py                     # Main lxml processing pipeline
│   ├── dom_export.py                   # W3C DOM minidom API implementation
│   ├── generate_report.py              # ReportLab PDF report compiler
│   └── build_submission.py             # Packaging & verification runner
├── tests/
│   └── test_json_schema.py             # Automated JSON schema test suite
├── report/
│   └── Report_Museum_Platform.pdf      # PDF Project Report (with AI Appendix)
└── submission_museum_platform.zip      # Final submission package
```

---

## 📊 Summary of 10 XSLT Scenarios

| ID | Format | Scenario Name | Highlights & Features |
|---|---|---|---|
| 01 | HTML | Artifact Catalogue | Complete web catalogue with key lookups for artist/collection |
| 02 | HTML | Exhibition Calendar | Chronological schedule with curator dereferencing & artifact counts |
| 03 | HTML | Artist Explorer | Artist directory with lifespans, bios, and work count aggregations |
| 04 | HTML | Historical Browser | Period-grouped artifact tables (Renaissance, Baroque, Impressionism) |
| 05 | HTML | Loan Dashboard | Loan management dashboard (Active, Scheduled, Completed) with insurance values |
| 06 | HTML | Conservation Report | Restoration analytics computing total/average costs using XPath sum() |
| 07 | XML | Exhibition Export | Simplified XML interchange format for partner museum portals |
| 08 | XML | Provenance Export | Structuring artifact historical ownership timelines into XML register |
| 09 | JSON | Artifact API | REST API payload validated against JSON Schema Draft 2020-12 |
| 10 | YAML | Collection Summary | YAML configuration export summarizing holdings by collection |
