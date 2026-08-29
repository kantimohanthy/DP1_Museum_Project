<?xml version="1.0" encoding="UTF-8"?>
<!--
    ===================================================================
    S26 Data Pipeline Project - XSLT Stylesheet 04 (HTML)
    Scenario: Historical Collection Browser
    ===================================================================
    Description:
    This stylesheet categorizes museum holdings by historical period (e.g., Renaissance, 
    Baroque, Impressionism). It displays period descriptions and groups associated 
    artifacts in structured tables, dereferencing artist and collection references.

    Implementation Style:
    - Recursive template-matching style (<xsl:apply-templates>).
    - Fixes tag matching to correctly match <m:period> elements.
    - Relational dereferencing using <xsl:key>.
    ===================================================================
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://dsti.example/museum"
    exclude-result-prefixes="m">

    <xsl:output method="html" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compat"/>

    <xsl:key name="artist-by-id" match="m:artist" use="@id"/>
    <xsl:key name="collection-by-id" match="m:collection" use="@id"/>

    <xsl:template match="/">
        <html>
            <head>
                <meta charset="UTF-8"/>
                <title>Historical Collection Browser</title>
                <style>
                    body { font-family: 'Segoe UI', Arial, sans-serif; margin: 30px; background: #fdfdfd; color: #2c3e50; }
                    h1 { color: #2c3e50; border-bottom: 3px solid #8e44ad; padding-bottom: 8px; }
                    .period-section { background: #fff; border: 1px solid #e1e8ed; border-radius: 8px; margin-bottom: 30px; padding: 25px; box-shadow: 0 2px 6px rgba(0,0,0,0.04); }
                    .period-header { color: #8e44ad; margin-top: 0; }
                    .period-dates { color: #7f8c8d; font-weight: bold; }
                    table { width: 100%; border-collapse: collapse; margin-top: 15px; }
                    th, td { padding: 10px 12px; border: 1px solid #ecf0f1; text-align: left; }
                    th { background: #f4ecf7; color: #6c3483; }
                    tr:nth-child(even) { background: #faf5fc; }
                </style>
            </head>
            <body>
                <h1>Historical Collection Browser</h1>
                <p>Browse museum holdings organized by cultural and historical movements.</p>

                <xsl:apply-templates select="m:museum/m:historicalPeriods/m:period">
                    <xsl:sort select="m:startYear" data-type="number" order="ascending"/>
                </xsl:apply-templates>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="m:period">
        <xsl:variable name="periodId" select="@id"/>
        <xsl:variable name="artifactsInPeriod" select="/m:museum/m:artifacts/m:artifact[m:historicalPeriodRef = $periodId]"/>

        <section class="period-section">
            <h2 class="period-header">
                <xsl:value-of select="m:name"/>
                <xsl:text> </xsl:text>
                <span class="period-dates">(<xsl:value-of select="m:startYear"/> – <xsl:value-of select="m:endYear"/>)</span>
            </h2>
            <p><xsl:value-of select="normalize-space(m:description)"/></p>

            <xsl:choose>
                <xsl:when test="count($artifactsInPeriod) &gt; 0">
                    <table>
                        <thead>
                            <tr>
                                <th>Inventory #</th>
                                <th>Artifact Title</th>
                                <th>Artist</th>
                                <th>Collection</th>
                                <th>Creation Year</th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:apply-templates select="$artifactsInPeriod">
                                <xsl:sort select="m:creationDate" data-type="text"/>
                            </xsl:apply-templates>
                        </tbody>
                    </table>
                </xsl:when>
                <xsl:otherwise>
                    <p><em>No artifacts currently registered for this historical period.</em></p>
                </xsl:otherwise>
            </xsl:choose>
        </section>
    </xsl:template>

    <xsl:template match="m:artifact">
        <tr>
            <td><code><xsl:value-of select="m:inventoryNumber"/></code></td>
            <td><strong><xsl:value-of select="m:title"/></strong></td>
            <td><xsl:value-of select="key('artist-by-id', m:artistRef)/m:name"/></td>
            <td><xsl:value-of select="key('collection-by-id', m:collectionRef)/m:name"/></td>
            <td><xsl:value-of select="m:creationDate"/></td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
