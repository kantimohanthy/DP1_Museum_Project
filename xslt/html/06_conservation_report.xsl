<?xml version="1.0" encoding="UTF-8"?>
<!--
    ===================================================================
    S26 Data Pipeline Project - XSLT Stylesheet 06 (HTML)
    Scenario: Conservation & Restoration Analytical Report
    ===================================================================
    Description:
    This stylesheet generates a comprehensive conservation and restoration project report. 
    It computes aggregate financial metrics (total investment, average project cost) 
    and breakdown counts across project statuses (completed, in progress, scheduled). 
    Artifact titles are dereferenced using key lookups.

    Implementation Style:
    - Idiomatic recursive template-matching style (<xsl:apply-templates>).
    - Advanced XPath aggregations (sum, count, div, format-number).
    - Corrects schema element queries (<m:conservationRecords/m:conservationRecord>).
    ===================================================================
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://dsti.example/museum"
    exclude-result-prefixes="m">

    <xsl:output method="html" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compat"/>

    <xsl:key name="artifact-by-id" match="m:artifact" use="@id"/>

    <xsl:template match="/">
        <html>
            <head>
                <meta charset="UTF-8"/>
                <title>Conservation Report</title>
                <style>
                    body { font-family: 'Segoe UI', Arial, sans-serif; margin: 30px; background: #fdfefe; color: #2c3e50; }
                    h1 { color: #16a085; border-bottom: 3px solid #1abc9c; padding-bottom: 8px; }
                    .kpi-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; margin-bottom: 30px; }
                    .kpi-card { background: #e8f8f5; border: 1px solid #a3e4d7; border-radius: 8px; padding: 15px; text-align: center; }
                    .kpi-val { font-size: 1.6em; font-weight: bold; color: #117864; margin-top: 5px; }
                    .kpi-title { font-size: 0.85em; color: #16a085; text-transform: uppercase; font-weight: 600; }
                    table { width: 100%; border-collapse: collapse; margin-top: 15px; background: #fff; box-shadow: 0 2px 5px rgba(0,0,0,0.04); }
                    th, td { padding: 12px 15px; border: 1px solid #e5e7e9; text-align: left; }
                    th { background: #16a085; color: #fff; }
                    tr:nth-child(even) { background: #f4f6f7; }
                    .status-pill { display: inline-block; padding: 3px 8px; border-radius: 12px; font-size: 0.85em; font-weight: bold; }
                    .status-completed { background: #d4efdf; color: #196f3d; }
                    .status-in_progress { background: #fcf3cf; color: #b7950b; }
                    .status-scheduled { background: #ebdef0; color: #76448a; }
                </style>
            </head>
            <body>
                <h1>Artifact Conservation &amp; Preservation Report</h1>
                <p><strong>Reporting Entity:</strong> <xsl:value-of select="m:museum/m:metadata/m:name"/></p>

                <xsl:variable name="records" select="m:museum/m:conservationRecords/m:conservationRecord"/>
                <xsl:variable name="totalProjects" select="count($records)"/>
                <xsl:variable name="totalCost" select="sum($records/m:cost)"/>

                <div class="kpi-grid">
                    <div class="kpi-card">
                        <div class="kpi-title">Total Projects</div>
                        <div class="kpi-val"><xsl:value-of select="$totalProjects"/></div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-title">Completed</div>
                        <div class="kpi-val"><xsl:value-of select="count($records[m:status='completed'])"/></div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-title">Total Conservation Cost</div>
                        <div class="kpi-val">€<xsl:value-of select="format-number($totalCost, '#,##0.00')"/></div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-title">Average Cost / Project</div>
                        <div class="kpi-val">
                            <xsl:choose>
                                <xsl:when test="$totalProjects &gt; 0">
                                    €<xsl:value-of select="format-number($totalCost div $totalProjects, '#,##0.00')"/>
                                </xsl:when>
                                <xsl:otherwise>€0.00</xsl:otherwise>
                            </xsl:choose>
                        </div>
                    </div>
                </div>

                <h2>Detailed Conservation Activities</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Record ID</th>
                            <th>Artifact Title</th>
                            <th>Treatment Type</th>
                            <th>Conservator</th>
                            <th>Institution</th>
                            <th>Timeline</th>
                            <th>Status</th>
                            <th>Cost</th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:apply-templates select="$records">
                            <xsl:sort select="m:startDate" order="descending"/>
                        </xsl:apply-templates>
                    </tbody>
                </table>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="m:conservationRecord">
        <tr>
            <td><code><xsl:value-of select="@id"/></code></td>
            <td><strong><xsl:value-of select="key('artifact-by-id', m:artifactRef)/m:title"/></strong></td>
            <td><xsl:value-of select="m:type"/></td>
            <td><xsl:value-of select="m:conservator"/></td>
            <td><xsl:value-of select="m:institution"/></td>
            <td><xsl:value-of select="m:startDate"/> to <xsl:value-of select="m:endDate"/></td>
            <td>
                <span class="status-pill status-{m:status}">
                    <xsl:value-of select="translate(m:status, '_', ' ')"/>
                </span>
            </td>
            <td>€<xsl:value-of select="format-number(m:cost, '#,##0.00')"/></td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
