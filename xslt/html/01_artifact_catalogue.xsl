<?xml version="1.0" encoding="UTF-8"?>
<!--
    ===================================================================
    S26 Data Pipeline Project - XSLT Stylesheet 01 (HTML)
    Scenario: Artifact Catalogue Visualization
    ===================================================================
    Description:
    This XSLT stylesheet transforms the museum XML database into an interactive, 
    fully-styled HTML catalogue of all artifacts. It computes aggregate 
    statistics (total count, location metadata) and formats individual artifact 
    cards including inventory numbers, dimensions, acquisition details, current 
    exhibition status, and location.

    Implementation Style:
    - Idiomatic, recursive template-matching style (<xsl:apply-templates>).
    - Uses <xsl:key> definitions to dereference artist, collection, period, and site IDs.
    - Includes responsive CSS styling for web publication.
    ===================================================================
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://dsti.example/museum"
    exclude-result-prefixes="m">

    <xsl:output method="html" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compat"/>

    <!-- Key Definitions for Relational Dereferencing -->
    <xsl:key name="artist-by-id" match="m:artist" use="@id"/>
    <xsl:key name="collection-by-id" match="m:collection" use="@id"/>
    <xsl:key name="period-by-id" match="m:period" use="@id"/>
    <xsl:key name="site-by-id" match="m:site" use="@id"/>

    <!-- Root Template -->
    <xsl:template match="/">
        <html>
            <head>
                <meta charset="UTF-8"/>
                <title>Museum Artifact Catalogue</title>
                <style>
                    body { font-family: 'Segoe UI', Arial, sans-serif; margin: 0; padding: 0; background: #f4f6f9; color: #333; }
                    header { background: #1a252f; color: #fff; padding: 30px; text-align: center; }
                    header h1 { margin: 0 0 10px 0; font-size: 2.2em; }
                    header p { margin: 0; opacity: 0.85; font-size: 1.1em; }
                    main { max-width: 1100px; margin: 30px auto; padding: 0 20px; }
                    .summary-card { background: #fff; border-left: 5px solid #2980b9; padding: 20px; margin-bottom: 30px; border-radius: 6px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
                    .artifact-card { background: #fff; margin-bottom: 25px; padding: 25px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
                    .artifact-card h2 { margin-top: 0; color: #2c3e50; border-bottom: 2px solid #ecf0f1; padding-bottom: 10px; }
                    .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px 30px; }
                    .field { padding: 6px 0; border-bottom: 1px dashed #eee; }
                    .label { font-weight: bold; color: #7f8c8d; }
                    .status { display: inline-block; padding: 4px 10px; border-radius: 12px; font-weight: bold; font-size: 0.85em; text-transform: uppercase; }
                    .status-on_display { background: #d4edda; color: #155724; }
                    .status-in_restoration { background: #fff3cd; color: #856404; }
                    .status-on_loan { background: #cce5ff; color: #004085; }
                    .status-in_storage { background: #e2e3e5; color: #383d41; }
                    .section-box { margin-top: 15px; padding: 12px; background: #fafafa; border-radius: 6px; border: 1px solid #eee; }
                    .section-box h3 { margin: 0 0 8px 0; font-size: 1em; color: #34495e; }
                    footer { text-align: center; padding: 25px; color: #7f8c8d; font-size: 0.9em; }
                </style>
            </head>
            <body>
                <xsl:apply-templates select="m:museum"/>
            </body>
        </html>
    </xsl:template>

    <!-- Museum Master Template -->
    <xsl:template match="m:museum">
        <header>
            <h1><xsl:value-of select="m:metadata/m:name"/></h1>
            <p>Official Cultural Heritage Artifact Catalogue</p>
        </header>
        <main>
            <div class="summary-card">
                <h2>Catalogue Summary</h2>
                <p><strong>Total Artifacts:</strong><xsl:text> </xsl:text><xsl:value-of select="count(m:artifacts/m:artifact)"/></p>
                <p><strong>Institution Location:</strong><xsl:text> </xsl:text><xsl:value-of select="m:metadata/m:city"/>, <xsl:value-of select="m:metadata/m:country"/> (Est. <xsl:value-of select="m:metadata/m:established"/>)</p>
            </div>
            <xsl:apply-templates select="m:artifacts"/>
        </main>
        <footer>
            Generated automatically via XSLT 1.0 Pipeline — DP1 Museum Management Platform
        </footer>
    </xsl:template>

    <!-- Artifacts Container Template -->
    <xsl:template match="m:artifacts">
        <xsl:apply-templates select="m:artifact">
            <xsl:sort select="m:title" order="ascending"/>
        </xsl:apply-templates>
    </xsl:template>

    <!-- Individual Artifact Template -->
    <xsl:template match="m:artifact">
        <article class="artifact-card">
            <h2><xsl:value-of select="m:title"/></h2>
            
            <div class="grid">
                <div class="field">
                    <span class="label">Inventory Number:</span><xsl:text> </xsl:text>
                    <code><xsl:value-of select="m:inventoryNumber"/></code>
                </div>
                <div class="field">
                    <span class="label">Creation Date:</span><xsl:text> </xsl:text>
                    <xsl:value-of select="m:creationDate"/>
                </div>
                <div class="field">
                    <span class="label">Medium:</span><xsl:text> </xsl:text>
                    <xsl:value-of select="m:medium"/>
                </div>
                <div class="field">
                    <span class="label">Artist:</span><xsl:text> </xsl:text>
                    <strong><xsl:value-of select="key('artist-by-id', m:artistRef)/m:name"/></strong>
                </div>
                <div class="field">
                    <span class="label">Collection:</span><xsl:text> </xsl:text>
                    <xsl:value-of select="key('collection-by-id', m:collectionRef)/m:name"/>
                </div>
                <div class="field">
                    <span class="label">Historical Period:</span><xsl:text> </xsl:text>
                    <xsl:value-of select="key('period-by-id', m:historicalPeriodRef)/m:name"/>
                </div>
                <div class="field">
                    <span class="label">Cultural Origin Site:</span><xsl:text> </xsl:text>
                    <xsl:value-of select="key('site-by-id', m:culturalSiteRef)/m:name"/>
                </div>
                <div class="field">
                    <span class="label">Current Status:</span><xsl:text> </xsl:text>
                    <span class="status status-{m:currentStatus}">
                        <xsl:value-of select="translate(m:currentStatus, '_', ' ')"/>
                    </span>
                </div>
                <div class="field">
                    <span class="label">Location:</span><xsl:text> </xsl:text>
                    <xsl:value-of select="m:location/m:building"/> — <xsl:value-of select="m:location/m:gallery"/>
                </div>
                <div class="field">
                    <span class="label">Dimensions:</span><xsl:text> </xsl:text>
                    <xsl:value-of select="m:dimensions/m:height"/> <xsl:value-of select="m:dimensions/m:height/@unit"/> × 
                    <xsl:value-of select="m:dimensions/m:width"/> <xsl:value-of select="m:dimensions/m:width/@unit"/>
                </div>
            </div>

            <div class="section-box">
                <h3>Description</h3>
                <p><xsl:value-of select="normalize-space(m:description)"/></p>
            </div>

            <div class="section-box">
                <h3>Acquisition Record</h3>
                <p>
                    Acquired on <strong><xsl:value-of select="m:acquisition/m:date"/></strong> via 
                    <strong><xsl:value-of select="m:acquisition/m:method"/></strong>
                    <xsl:if test="m:acquisition/m:price &gt; 0">
                        (Price: <xsl:value-of select="format-number(m:acquisition/m:price, '#,##0')"/><xsl:text> </xsl:text><xsl:value-of select="m:acquisition/m:price/@currency"/>)
                    </xsl:if>.
                </p>
            </div>
        </article>
    </xsl:template>

</xsl:stylesheet>