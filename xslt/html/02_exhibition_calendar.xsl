<?xml version="1.0" encoding="UTF-8"?>
<!--
    ===================================================================
    S26 Data Pipeline Project - XSLT Stylesheet 02 (HTML)
    Scenario: Exhibition Calendar Visualization
    ===================================================================
    Description:
    This stylesheet processes museum exhibition schedules, sorting events 
    chronologically by start date. It dereferences curator references to display 
    full curator names, maps location galleries, and counts featured artifacts.

    Implementation Style:
    - Idiomatic recursive template-matching style (<xsl:apply-templates>).
    - Relational dereferencing via <xsl:key name="curator-by-id">.
    ===================================================================
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://dsti.example/museum"
    exclude-result-prefixes="m">

    <xsl:output method="html" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compat"/>

    <xsl:key name="curator-by-id" match="m:curator" use="@id"/>
    <xsl:key name="artifact-by-id" match="m:artifact" use="@id"/>

    <xsl:template match="/">
        <html>
            <head>
                <meta charset="UTF-8"/>
                <title>Museum Exhibition Calendar</title>
                <style>
                    body { font-family: 'Segoe UI', Arial, sans-serif; margin: 30px; background: #fafafa; color: #2c3e50; }
                    h1 { color: #1a252f; border-bottom: 3px solid #3498db; padding-bottom: 8px; }
                    table { width: 100%; border-collapse: collapse; margin-top: 20px; background: #fff; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
                    th, td { padding: 12px 15px; border: 1px solid #e2e8f0; text-align: left; }
                    th { background: #34495e; color: #fff; font-weight: 600; }
                    tr:nth-child(even) { background: #f8fafc; }
                    .badge { display: inline-block; padding: 3px 8px; border-radius: 4px; font-size: 0.85em; font-weight: bold; }
                    .badge-active { background: #2ecc71; color: #fff; }
                    .badge-scheduled { background: #f39c12; color: #fff; }
                </style>
            </head>
            <body>
                <h1>Exhibition Schedule &amp; Calendar</h1>
                <p><strong>Institution:</strong> <xsl:value-of select="m:museum/m:metadata/m:name"/></p>
                
                <table>
                    <thead>
                        <tr>
                            <th>Exhibition Title</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                            <th>Curator</th>
                            <th>Location</th>
                            <th>Status</th>
                            <th>Featured Artifacts</th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:apply-templates select="m:museum/m:exhibitions/m:exhibition">
                            <xsl:sort select="m:startDate" data-type="text" order="ascending"/>
                        </xsl:apply-templates>
                    </tbody>
                </table>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="m:exhibition">
        <tr>
            <td><strong><xsl:value-of select="m:title"/></strong><br/><small><xsl:value-of select="normalize-space(m:description)"/></small></td>
            <td><xsl:value-of select="m:startDate"/></td>
            <td><xsl:value-of select="m:endDate"/></td>
            <td><xsl:value-of select="key('curator-by-id', m:curatorRef)/m:name"/> (<xsl:value-of select="key('curator-by-id', m:curatorRef)/m:specialization"/>)</td>
            <td><xsl:value-of select="m:location"/></td>
            <td>
                <span class="badge badge-{m:status}">
                    <xsl:value-of select="m:status"/>
                </span>
            </td>
            <td><xsl:value-of select="count(m:artifactRef)"/> Artifact(s)</td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
