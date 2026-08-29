<?xml version="1.0" encoding="UTF-8"?>
<!--
    ===================================================================
    S26 Data Pipeline Project - XSLT Stylesheet 03 (HTML)
    Scenario: Artist Directory & Explorer
    ===================================================================
    Description:
    This stylesheet generates a comprehensive artist directory, listing biographies, 
    nationalities, lifespan dates, and dynamically computing the total number 
    of works held in the museum repository for each artist using XPath aggregation.

    Implementation Style:
    - Recursive template-matching style (<xsl:apply-templates>).
    - Dynamic cross-referencing for artifact collection counts.
    ===================================================================
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://dsti.example/museum"
    exclude-result-prefixes="m">

    <xsl:output method="html" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compat"/>

    <xsl:template match="/">
        <html>
            <head>
                <meta charset="UTF-8"/>
                <title>Artist Explorer</title>
                <style>
                    body { font-family: 'Segoe UI', Arial, sans-serif; margin: 30px; background: #f8fafc; color: #1e293b; }
                    h1 { color: #0f172a; border-bottom: 3px solid #0284c7; padding-bottom: 8px; }
                    .artist-card { background: #fff; border: 1px solid #e2e8f0; border-radius: 8px; padding: 20px; margin-bottom: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
                    .artist-name { margin: 0 0 10px 0; color: #0369a1; }
                    .meta { color: #64748b; font-size: 0.95em; margin-bottom: 12px; }
                    .bio { line-height: 1.6; }
                    .count-pill { display: inline-block; background: #e0f2fe; color: #0369a1; padding: 4px 12px; border-radius: 15px; font-weight: bold; font-size: 0.9em; }
                </style>
            </head>
            <body>
                <h1>Museum Artists &amp; Biographical Explorer</h1>
                <xsl:apply-templates select="m:museum/m:artists"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="m:artists">
        <xsl:apply-templates select="m:artist">
            <xsl:sort select="m:name" order="ascending"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="m:artist">
        <xsl:variable name="artistId" select="@id"/>
        <xsl:variable name="worksCount" select="count(/m:museum/m:artifacts/m:artifact[m:artistRef = $artistId])"/>

        <article class="artist-card">
            <h2 class="artist-name"><xsl:value-of select="m:name"/></h2>
            <div class="meta">
                <strong>Nationality:</strong> <xsl:value-of select="m:nationality"/><xsl:text> | </xsl:text>
                <strong>Lifespan:</strong> <xsl:value-of select="m:birthDate"/> — <xsl:value-of select="m:deathDate"/><xsl:text> | </xsl:text>
                <span class="count-pill"><xsl:value-of select="$worksCount"/> Work(s) in Museum</span>
            </div>
            <p class="bio"><xsl:value-of select="normalize-space(m:biography)"/></p>
        </article>
    </xsl:template>

</xsl:stylesheet>
