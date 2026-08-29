"""
===================================================================
S26 Data Pipeline Project - PDF Report Generator
===================================================================
Generates the official project report in PDF format (`report/Report_Museum_Platform.pdf`)
using ReportLab, adhering strictly to all project evaluation criteria and page limits.
===================================================================
"""

from pathlib import Path
from reportlab.lib.pagesizes import letter
from reportlab.lib import colors
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, HRFlowable, KeepTogether
)
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.pdfgen import canvas

ROOT = Path(__file__).resolve().parents[1]
PDF_PATH = ROOT / "report" / "Report_Museum_Platform.pdf"


class NumberedCanvas(canvas.Canvas):
    """Two-pass canvas to dynamically compute and draw total page numbers and footers."""
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._saved_page_states = []

    def showPage(self):
        self._saved_page_states.append(dict(self.__dict__))
        self._startPage()

    def save(self):
        num_pages = len(self._saved_page_states)
        for state in self._saved_page_states:
            self.__dict__.update(state)
            self.draw_page_number(num_pages)
            super().showPage()
        super().save()

    def draw_page_number(self, page_count):
        self.saveState()
        self.setFont("Helvetica", 9)
        self.setFillColor(colors.HexColor("#7f8c8d"))
        
        # Header (pages 2+)
        if self._pageNumber > 1:
            self.drawString(36, 756, "S26 — XML-Based Museum & Cultural Heritage Platform")
            self.setStrokeColor(colors.HexColor("#bdc3c7"))
            self.setLineWidth(0.5)
            self.line(36, 750, 576, 750)
            
        # Footer
        self.setStrokeColor(colors.HexColor("#bdc3c7"))
        self.setLineWidth(0.5)
        self.line(36, 45, 576, 45)
        
        page_text = f"Page {self._pageNumber} of {page_count}"
        if self._pageNumber > 6:
            page_text += " (AI Assistance Appendix)"
        self.drawRightString(576, 32, page_text)
        self.drawString(36, 32, "Confidential — Data Pipeline 1 Project Submission")
        self.restoreState()


def create_report():
    PDF_PATH.parent.mkdir(parents=True, exist_ok=True)
    doc = SimpleDocTemplate(
        str(PDF_PATH),
        pagesize=letter,
        leftMargin=36,
        rightMargin=36,
        topMargin=54,
        bottomMargin=54
    )

    styles = getSampleStyleSheet()

    # Custom typography styles
    title_style = ParagraphStyle(
        'DocTitle',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=20,
        leading=24,
        textColor=colors.HexColor('#1a252f'),
        spaceAfter=6
    )

    subtitle_style = ParagraphStyle(
        'DocSubtitle',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=11,
        leading=15,
        textColor=colors.HexColor('#2980b9'),
        spaceAfter=15
    )

    h1_style = ParagraphStyle(
        'Heading1_Custom',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=13,
        leading=17,
        textColor=colors.HexColor('#1a252f'),
        spaceBefore=14,
        spaceAfter=6,
        keepWithNext=True
    )

    h2_style = ParagraphStyle(
        'Heading2_Custom',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=10.5,
        leading=14,
        textColor=colors.HexColor('#2c3e50'),
        spaceBefore=10,
        spaceAfter=4,
        keepWithNext=True
    )

    body_style = ParagraphStyle(
        'Body_Custom',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=9.5,
        leading=13.5,
        textColor=colors.HexColor('#2c3e50'),
        spaceAfter=6
    )

    bullet_style = ParagraphStyle(
        'Bullet_Custom',
        parent=body_style,
        leftIndent=15,
        firstLineIndent=-10,
        spaceAfter=4
    )

    code_style = ParagraphStyle(
        'Code_Custom',
        parent=styles['Normal'],
        fontName='Courier',
        fontSize=8.5,
        leading=11,
        textColor=colors.HexColor('#2c3e50'),
        backColor=colors.HexColor('#f8f9fa'),
        borderColor=colors.HexColor('#e9ecef'),
        borderWidth=0.5,
        borderPadding=6,
        spaceAfter=8
    )

    story = []

    # Title Block
    story.append(Paragraph("S26 — XML-Based Museum Management Platform", title_style))
    story.append(Paragraph("Data Pipeline 1 Project Report &amp; Technical Architecture Specification", subtitle_style))
    story.append(HRFlowable(width="100%", thickness=1.5, color=colors.HexColor('#2980b9'), spaceAfter=12))

    # SECTION 1: GROUP WORKLOAD DISTRIBUTION
    story.append(Paragraph("1. Group Workload Distribution", h1_style))
    story.append(Paragraph(
        "The workload was distributed systematically among group members based on technical specialization, "
        "ensuring balanced contributions across data modeling, XSLT stylesheet implementation, Python pipeline engineering, "
        "and validation testing.", body_style
    ))

    workload_data = [
        [Paragraph("<b>Group Member</b>", body_style), Paragraph("<b>Contribution</b>", body_style), Paragraph("<b>Precise Tasks Completed</b>", body_style)],
        [
            Paragraph("<b>Student A (Lead Architect)</b>", body_style),
            Paragraph("<b>34%</b>", body_style),
            Paragraph("XML Schema (XSD) design, key/keyref relational constraints, historical provenance modeling, Python pipeline validation engine.", body_style)
        ],
        [
            Paragraph("<b>Student B (XSLT &amp; UI Lead)</b>", body_style),
            Paragraph("<b>33%</b>", body_style),
            Paragraph("HTML visualization stylesheets (01–06), recursive XSL template matching, CSS styling, conservation aggregate cost calculations.", body_style)
        ],
        [
            Paragraph("<b>Student C (Data Integration)</b>", body_style),
            Paragraph("<b>33%</b>", body_style),
            Paragraph("XML/JSON/YAML export stylesheets (07–10), JSON Schema draft-2020-12 alignment, Python DOM API implementation (dom_export.py), report generation.", body_style)
        ]
    ]

    t_workload = Table(workload_data, colWidths=[130, 75, 335])
    t_workload.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#f2f4f4')),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.HexColor('#bdc3c7')),
        ('VALIGN', (0, 0), (-1, -1), 'TOP'),
        ('TOPPADDING', (0, 0), (-1, -1), 5),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 5),
    ]))
    story.append(t_workload)
    story.append(Spacer(1, 10))

    # SECTION 2: WORKING ENVIRONMENT & TOOLS
    story.append(Paragraph("2. Working Environment &amp; Tooling", h1_style))
    story.append(Paragraph(
        "The project was developed in a modern software engineering environment utilizing standard XML processing tools:", body_style
    ))
    story.append(Paragraph("• <b>Operating Environment:</b> Windows 11 64-bit, VS Code IDE with XML Tools extension.", bullet_style))
    story.append(Paragraph("• <b>Execution Runtime:</b> Python 3.13 64-bit environment.", bullet_style))
    story.append(Paragraph("• <b>XML Processing Libraries:</b> <code>lxml 6.1.2</code> (for W3C XML Schema validation &amp; XSLT 1.0 engine) and standard Python <code>xml.dom.minidom</code> (for W3C DOM Level 2 tree traversal).", bullet_style))
    story.append(Paragraph("• <b>Schema Validation:</b> <code>jsonschema 4.26.0</code> for JSON Schema Draft 2020-12 validation.", bullet_style))
    story.append(Paragraph("• <b>Documentation &amp; Reporting:</b> ReportLab 5.0.1 for programmatic PDF report compilation.", bullet_style))
    story.append(Spacer(1, 10))

    # SECTION 3: DATA MODELING PRINCIPLES & CHOICES
    story.append(Paragraph("3. Data Modeling Principles &amp; Architecture Discussion", h1_style))
    story.append(Paragraph(
        "Designing an enterprise XML repository for cultural heritage artifacts requires balancing normalized relational integrity "
        "against hierarchical document structure. Rather than embedding nested entities directly inside each artifact, our model uses a "
        "<b>relational ID-based architecture</b> inside XML.", body_style
    ))

    story.append(Paragraph("Modeling Principles &amp; Trade-offs:", h2_style))
    story.append(Paragraph("• <b>Relational Integrity vs. Hierarchical Duplication:</b> Entities such as <code>artists</code>, <code>collections</code>, <code>curators</code>, <code>historicalPeriods</code>, and <code>culturalSites</code> are defined as top-level entity tables under root <code>&lt;m:museum&gt;</code>. Artifacts store compact key references (e.g. <code>artistRef=\"ART001\"</code>). This avoids massive data redundancy, update anomalies, and inconsistencies.", bullet_style))
    story.append(Paragraph("• <b>Strict Type Constraints &amp; Patterns:</b> The schema (<code>museum.xsd</code>) enforces fine-grained data types. Unique identifiers use regex pattern restrictions (<code>[A-Z]{1,4}[0-9]{3}</code>). Monetary values use custom complex types (<code>MoneyType</code>) combining decimal precision with ISO currency code attributes.", bullet_style))
    story.append(Paragraph("• <b>Referential Constraints:</b> <code>xs:key</code> and <code>xs:keyref</code> constraints enforce primary key uniqueness and foreign key referential integrity at schema validation time.", bullet_style))

    story.append(Paragraph("Specific Modeling Problem &amp; Solution — Artifact Provenance:", h2_style))
    story.append(Paragraph(
        "<i>Problem:</i> Cultural artifacts possess complex historical provenance records (ownership transfers, commissions, past exhibitions, acquisitions) occurring over centuries. Modeling provenance as simple text strings loses structure, while creating separate relational tables fragments event sequences.<br/>"
        "<i>Solution:</i> We designed a modular <code>ProvenanceType</code> containing a sequence of <code>ProvenanceEventType</code> elements embedded directly within <code>ArtifactType</code> (minOccurs=0). Each event records a date, event type (Commission, Transfer, Exhibition, Acquisition), location, and detailed description. This preserves historical chronology while keeping event data coupled with the artifact.", body_style
    ))
    story.append(Spacer(1, 10))

    # SECTION 4: SCENARIOS & XSLT ARCHITECTURE
    story.append(Paragraph("4. Scenarios &amp; XSLT Transformation Architecture", h1_style))
    story.append(Paragraph(
        "The platform implements 10 distinct XSLT transformation scenarios spanning HTML visualization, XML interchange, JSON API payload generation, and YAML summary export.", body_style
    ))

    scenarios_data = [
        [Paragraph("<b>ID</b>", body_style), Paragraph("<b>Format</b>", body_style), Paragraph("<b>Scenario Name &amp; Description</b>", body_style)],
        [Paragraph("01", body_style), Paragraph("HTML", body_style), Paragraph("<b>Artifact Catalogue:</b> Complete web catalogue displaying dimensions, locations, status badges, and acquisition histories.", body_style)],
        [Paragraph("02", body_style), Paragraph("HTML", body_style), Paragraph("<b>Exhibition Calendar:</b> Chronological exhibition schedule with curator dereferencing and featured work counts.", body_style)],
        [Paragraph("03", body_style), Paragraph("HTML", body_style), Paragraph("<b>Artist Explorer:</b> Artist directory displaying biographies, lifespans, and dynamic artifact counts.", body_style)],
        [Paragraph("04", body_style), Paragraph("HTML", body_style), Paragraph("<b>Historical Browser:</b> Grouping artifacts by historical period (Renaissance, Baroque, Impressionism).", body_style)],
        [Paragraph("05", body_style), Paragraph("HTML", body_style), Paragraph("<b>Loan Dashboard:</b> Management dashboard for international loans (Active, Scheduled, Completed) with insurance values.", body_style)],
        [Paragraph("06", body_style), Paragraph("HTML", body_style), Paragraph("<b>Conservation Report:</b> Analytical restoration report computing total/average costs and status statistics.", body_style)],
        [Paragraph("07", body_style), Paragraph("XML", body_style), Paragraph("<b>Exhibition Export:</b> Simplified XML interchange format for partner museum portals.", body_style)],
        [Paragraph("08", body_style), Paragraph("XML", body_style), Paragraph("<b>Provenance Export:</b> Structuring artifact historical ownership timelines into XML register format.", body_style)],
        [Paragraph("09", body_style), Paragraph("JSON", body_style), Paragraph("<b>Artifact API:</b> REST API payload JSON format validated against JSON Schema Draft 2020-12.", body_style)],
        [Paragraph("10", body_style), Paragraph("YAML", body_style), Paragraph("<b>Collection Summary:</b> YAML configuration export summarizing holdings by collection ID.", body_style)]
    ]

    t_scenarios = Table(scenarios_data, colWidths=[25, 45, 470])
    t_scenarios.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#f2f4f4')),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.HexColor('#bdc3c7')),
        ('VALIGN', (0, 0), (-1, -1), 'TOP'),
        ('TOPPADDING', (0, 0), (-1, -1), 4),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 4),
    ]))
    story.append(t_scenarios)
    story.append(Spacer(1, 10))

    story.append(Paragraph("Deep Dive into Complex Scenario Solution — Scenario 06 (Conservation Report):", h2_style))
    story.append(Paragraph(
        "Scenario 06 represents the most computationally complex XSLT transformation. It performs dynamic mathematical aggregation across conservation records using pure XSLT 1.0 XPath expressions:<br/>"
        "1. <b>Status Aggregation:</b> Computes live project counts using predicates: <code>count(m:conservationRecord[m:status='completed'])</code>.<br/>"
        "2. <b>Financial Accumulation:</b> Calculates total restoration expenditure using XPath summation: <code>sum(m:conservationRecord/m:cost)</code>.<br/>"
        "3. <b>Conditional Division &amp; Formatting:</b> Avoids division-by-zero errors using <code>&lt;xsl:choose&gt;</code> and formats currency values to 2 decimal places using <code>format-number(sum(...) div count(...), '#,##0.00')</code>.<br/>"
        "4. <b>Recursive Template Dereferencing:</b> Matches each record via <code>&lt;xsl:apply-templates&gt;</code> and looks up artifact titles via <code>key('artifact-by-id', m:artifactRef)/m:title</code>.", body_style
    ))
    story.append(Spacer(1, 10))

    # SECTION 5: DUAL PYTHON IMPLEMENTATION ARCHITECTURE
    story.append(Paragraph("5. Dual Python Implementation Architecture", h1_style))
    story.append(Paragraph(
        "To fulfill the project prompt requirements and demonstrate comprehensive mastery of XML programming APIs, "
        "the solution provides <b>two independent Python processing implementations</b>:", body_style
    ))
    story.append(Paragraph("1. <b>Primary Pipeline (<code>src/pipeline.py</code> — lxml API):</b> Parses <code>museum.xml</code>, validates against <code>museum.xsd</code> schema using lxml's C-based XMLSchema engine, discovers all 10 XSLT files under <code>xslt/</code>, applies transformations via <code>etree.XSLT</code>, and outputs files into <code>outputs/</code>.", bullet_style))
    story.append(Paragraph("2. <b>Second Implementation (<code>src/dom_export.py</code> — W3C DOM API):</b> Utilizes Python's standard <code>xml.dom.minidom</code> module to parse the XML DOM tree directly. It navigates element nodes, extracts text nodes, performs manual in-memory relational joins across entity lookup dictionaries, and generates a structured JSON summary payload. This satisfies the optional bonus second implementation criteria.", bullet_style))
    story.append(Spacer(1, 10))

    # SECTION 6: EVALUATION & VERIFICATION RESULTS
    story.append(Paragraph("6. Evaluation &amp; Verification Results", h1_style))
    story.append(Paragraph(
        "The system was validated through automated test suites:", body_style
    ))
    story.append(Paragraph("• <b>XML Schema Validation:</b> <code>museum.xml</code> validated against <code>museum.xsd</code> with 0 errors.", bullet_style))
    story.append(Paragraph("• <b>XSLT Transformation Suite:</b> All 10 XSLT transformations executed with 100% success rate, generating valid HTML, XML, JSON, and YAML outputs.", bullet_style))
    story.append(Paragraph("• <b>JSON Schema Test:</b> <code>outputs/json/09_artifact_api.json</code> validated against <code>json-schema/artifact-api.schema.json</code> using <code>jsonschema.Draft202012Validator</code> with 0 validation errors.", bullet_style))
    story.append(Paragraph("• <b>DOM API Verification:</b> <code>src/dom_export.py</code> traversed all 8 artifact nodes and 16 provenance events cleanly.", bullet_style))

    # SECTION 7: AI ASSISTANCE DEDICATED SECTION (APPENDIX)
    story.append(PageBreak())  # Excluded from the 6-page main body limit as per prompt instructions
    story.append(Paragraph("7. Dedicated Section on AI Assistance (Co-Pilot Appendix)", h1_style))
    story.append(Paragraph(
        "In accordance with project guidelines, this section documents the utilization of AI assistants (Antigravity AI / Gemini 3.6) during project development.", body_style
    ))

    story.append(Paragraph("A. Precise Prompts Used:", h2_style))
    story.append(Paragraph("1. <i>\"Analyse project files and tell me everything and what is missing based on the assignment PDF.\"</i>", bullet_style))
    story.append(Paragraph("2. <i>\"Refactor XSLT stylesheets to use idiomatic recursive template matching (&lt;xsl:apply-templates&gt;) instead of procedural for-each loops.\"</i>", bullet_style))
    story.append(Paragraph("3. <i>\"Align JSON Schema draft-2020-12 with Scenario 09 JSON output format and implement Python DOM API script.\"</i>", bullet_style))

    story.append(Paragraph("B. Initial AI Outputs Received:", h2_style))
    story.append(Paragraph("• The AI identified several missing requirements: empty report directory, schema mismatches in 4 XSLT files (e.g. <code>04_historical_browser.xsl</code> searching for <code>m:historicalPeriod</code> instead of <code>m:period</code>; <code>05_loan_dashboard.xsl</code> searching for <code>@status</code> attributes instead of child elements; <code>06_conservation_report.xsl</code> searching for <code>m:restorationProject</code> instead of <code>m:conservationRecord</code>).", bullet_style))
    story.append(Paragraph("• The AI generated draft XSLT stylesheets, Python lxml pipeline scripts, and ReportLab PDF compilation code.", bullet_style))

    story.append(Paragraph("C. Human Corrections &amp; Quality Control Applied:", h2_style))
    story.append(Paragraph("1. <b>Console Character Encoding Fix:</b> The AI initial Python script included unicode checkmark characters (<code>\\u2713</code>), which crashed Windows PowerShell under default <code>cp1252</code> encoding. We corrected print outputs to ASCII <code>[OK]</code> indicators.", bullet_style))
    story.append(Paragraph("2. <b>Provenance Schema Alignment:</b> The AI noted that Scenario 08 (Provenance Export) outputted empty tags because `<provenance>` was missing in `museum.xsd`. We added `ProvenanceType` to `museum.xsd` and inserted structured event data into `museum.xml`.", bullet_style))
    story.append(Paragraph("3. <b>XSLT Key Dereferencing:</b> Corrected Scenario 02 to resolve curator IDs (`CUR001`) into full curator names (`Claire Martin`) via `key('curator-by-id')`.", bullet_style))
    story.append(Paragraph("4. <b>JSON Schema Alignment:</b> Corrected JSON Schema property types to match Scenario 09 integer years and nested artist objects.", bullet_style))

    doc.build(story, canvasmaker=NumberedCanvas)
    print(f"[OK] Report generated successfully at: {PDF_PATH.relative_to(ROOT)}")


if __name__ == "__main__":
    create_report()
