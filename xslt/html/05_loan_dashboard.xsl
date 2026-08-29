<?xml version="1.0" encoding="UTF-8"?>
<!--
    ===================================================================
    S26 Data Pipeline Project - XSLT Stylesheet 05 (HTML)
    Scenario: Loan Management Dashboard
    ===================================================================
    Description:
    This stylesheet processes international artifact loans, categorizing them into 
    active, scheduled, and completed loans. It calculates summary indicators and 
    renders structured tables containing borrowing institutions, purpose, loan durations, 
    and insurance values, dereferencing artifact titles via key lookups.

    Implementation Style:
    - Recursive template-matching style (<xsl:apply-templates>).
    - Corrects schema element queries (<m:status>, <m:borrower>, <m:endDate>).
    - Key-based artifact dereferencing.
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
                <title>Loan Management Dashboard</title>
                <style>
                    body { font-family: 'Segoe UI', Arial, sans-serif; margin: 30px; background: #f4f6f9; color: #2c3e50; }
                    h1 { color: #2c3e50; border-bottom: 3px solid #e67e22; padding-bottom: 8px; }
                    .stats-container { display: flex; gap: 20px; margin-bottom: 25px; }
                    .stat-card { background: #fff; padding: 15px 25px; border-radius: 8px; border-left: 4px solid #e67e22; box-shadow: 0 2px 4px rgba(0,0,0,0.05); flex: 1; }
                    .stat-number { font-size: 1.8em; font-weight: bold; color: #d35400; }
                    .table-card { background: #fff; padding: 20px; border-radius: 8px; margin-bottom: 25px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
                    table { width: 100%; border-collapse: collapse; margin-top: 10px; }
                    th, td { padding: 10px 12px; border: 1px solid #ecf0f1; text-align: left; }
                    th { background: #fdf2e9; color: #d35400; }
                    .badge { padding: 3px 8px; border-radius: 4px; font-weight: bold; font-size: 0.85em; text-transform: uppercase; }
                    .badge-active { background: #e74c3c; color: #fff; }
                    .badge-scheduled { background: #f39c12; color: #fff; }
                    .badge-completed { background: #2ecc71; color: #fff; }
                </style>
            </head>
            <body>
                <h1>Artifact Loan &amp; Exchange Dashboard</h1>
                
                <div class="stats-container">
                    <div class="stat-card">
                        <div class="stat-number"><xsl:value-of select="count(m:museum/m:loans/m:loan[m:status='active'])"/></div>
                        <div>Active Loans</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number"><xsl:value-of select="count(m:museum/m:loans/m:loan[m:status='scheduled'])"/></div>
                        <div>Scheduled Loans</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number"><xsl:value-of select="count(m:museum/m:loans/m:loan[m:status='completed'])"/></div>
                        <div>Completed Loans</div>
                    </div>
                </div>

                <div class="table-card">
                    <h2>Active &amp; Ongoing Loans</h2>
                    <xsl:choose>
                        <xsl:when test="count(m:museum/m:loans/m:loan[m:status='active']) &gt; 0">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Loan ID</th>
                                        <th>Artifact</th>
                                        <th>Lender</th>
                                        <th>Borrower</th>
                                        <th>Purpose</th>
                                        <th>Start Date</th>
                                        <th>End Date</th>
                                        <th>Insurance Value</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <xsl:apply-templates select="m:museum/m:loans/m:loan[m:status='active']"/>
                                </tbody>
                            </table>
                        </xsl:when>
                        <xsl:otherwise>
                            <p>No active loans registered.</p>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>

                <div class="table-card">
                    <h2>Scheduled &amp; Completed Loans</h2>
                    <table>
                        <thead>
                            <tr>
                                <th>Loan ID</th>
                                <th>Artifact</th>
                                <th>Lender</th>
                                <th>Borrower</th>
                                <th>Status</th>
                                <th>Duration</th>
                                <th>Insurance Value</th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:apply-templates select="m:museum/m:loans/m:loan[m:status!='active']"/>
                        </tbody>
                    </table>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="m:loan">
        <tr>
            <td><code><xsl:value-of select="@id"/></code></td>
            <td><strong><xsl:value-of select="key('artifact-by-id', m:artifactRef)/m:title"/></strong></td>
            <td><xsl:value-of select="m:lender"/></td>
            <td><xsl:value-of select="m:borrower"/></td>
            <td><xsl:value-of select="m:purpose"/></td>
            <td><xsl:value-of select="m:startDate"/></td>
            <td><xsl:value-of select="m:endDate"/></td>
            <td><xsl:value-of select="format-number(m:insuranceValue, '#,##0')"/><xsl:text> </xsl:text><xsl:value-of select="m:insuranceValue/@currency"/></td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
