<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://dsti.example/museum"
    exclude-result-prefixes="m">

    <!-- =========================================================
         OUTPUT
         ========================================================= -->

    <xsl:output
        method="html"
        encoding="UTF-8"
        indent="yes"
        doctype-system="about:legacy-compat"/>


    <!-- =========================================================
         KEYS
         Used to resolve references such as artistRef and
         collectionRef.
         ========================================================= -->

    <xsl:key
        name="artist-by-id"
        match="m:artist"
        use="@id"/>

    <xsl:key
        name="collection-by-id"
        match="m:collection"
        use="@id"/>


    <!-- =========================================================
         ROOT TRANSFORMATION
         ========================================================= -->

    <xsl:template match="/">

        <html>

            <head>

                <meta charset="UTF-8"/>

                <title>Museum Artifact Catalogue</title>

                <style>

                    body {
                        font-family: Arial, Helvetica, sans-serif;
                        margin: 0;
                        padding: 0;
                        background: #f4f4f4;
                        color: #222;
                    }

                    header {
                        background: #222;
                        color: white;
                        padding: 30px;
                    }

                    header h1 {
                        margin: 0 0 10px 0;
                    }

                    header p {
                        margin: 0;
                        opacity: 0.85;
                    }

                    main {
                        max-width: 1200px;
                        margin: 30px auto;
                        padding: 0 20px;
                    }

                    .summary {
                        background: white;
                        padding: 20px;
                        margin-bottom: 25px;
                        border-radius: 8px;
                    }

                    .artifact {
                        background: white;
                        margin-bottom: 25px;
                        padding: 25px;
                        border-radius: 8px;
                        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
                    }

                    .artifact h2 {
                        margin-top: 0;
                    }

                    .artifact-grid {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 12px 30px;
                    }

                    .field {
                        padding: 8px 0;
                        border-bottom: 1px solid #eee;
                    }

                    .label {
                        font-weight: bold;
                    }

                    .status {
                        display: inline-block;
                        padding: 5px 10px;
                        border-radius: 4px;
                        background: #eee;
                    }

                    .description {
                        margin-top: 20px;
                        padding-top: 15px;
                        border-top: 1px solid #ddd;
                    }

                    footer {
                        text-align: center;
                        padding: 30px;
                        color: #666;
                    }

                    @media (max-width: 700px) {

                        .artifact-grid {
                            grid-template-columns: 1fr;
                        }

                    }

                </style>

            </head>


            <body>

                <!-- =================================================
                     HEADER
                     ================================================= -->

                <header>

                    <h1>
                        <xsl:value-of select="m:museum/m:metadata/m:name"/>
                    </h1>

                    <p>
                        Artifact Catalogue
                    </p>

                </header>


                <!-- =================================================
                     MAIN CONTENT
                     ================================================= -->

                <main>

                    <!-- =================================================
                         SUMMARY
                         ================================================= -->

                    <div class="summary">

                        <h2>Catalogue Overview</h2>

                        <p>
                            Total artifacts:
                            <strong>
                                <xsl:value-of
                                    select="count(m:museum/m:artifacts/m:artifact)"/>
                            </strong>
                        </p>

                        <p>
                            Museum location:
                            <strong>
                                <xsl:value-of
                                    select="m:museum/m:metadata/m:city"/>
                            </strong>,
                            <xsl:value-of
                                select="m:museum/m:metadata/m:country"/>
                        </p>

                    </div>


                    <!-- =================================================
                         ARTIFACT LIST
                         ================================================= -->

                    <xsl:for-each
                        select="m:museum/m:artifacts/m:artifact">

                        <xsl:sort
                            select="m:title"
                            data-type="text"
                            order="ascending"/>


                        <article class="artifact">

                            <h2>
                                <xsl:value-of select="m:title"/>
                            </h2>


                            <div class="artifact-grid">

                                <!-- Inventory Number -->

                                <div class="field">

                                    <span class="label">
                                        Inventory Number:
                                    </span>

                                    <xsl:text> </xsl:text>

                                    <xsl:value-of
                                        select="m:inventoryNumber"/>

                                </div>


                                <!-- Creation Date -->

                                <div class="field">

                                    <span class="label">
                                        Creation Date:
                                    </span>

                                    <xsl:text> </xsl:text>

                                    <xsl:value-of
                                        select="m:creationDate"/>

                                </div>


                                <!-- Medium -->

                                <div class="field">

                                    <span class="label">
                                        Medium:
                                    </span>

                                    <xsl:text> </xsl:text>

                                    <xsl:value-of
                                        select="m:medium"/>

                                </div>


                                <!-- Artist -->

                                <div class="field">

                                    <span class="label">
                                        Artist:
                                    </span>

                                    <xsl:text> </xsl:text>

                                    <xsl:variable
                                        name="artistId"
                                        select="m:artistRef"/>

                                    <xsl:value-of
                                        select="key('artist-by-id', $artistId)/m:name"/>

                                </div>


                                <!-- Collection -->

                                <div class="field">

                                    <span class="label">
                                        Collection:
                                    </span>

                                    <xsl:text> </xsl:text>

                                    <xsl:variable
                                        name="collectionId"
                                        select="m:collectionRef"/>

                                    <xsl:value-of
                                        select="key('collection-by-id', $collectionId)/m:name"/>

                                </div>


                                <!-- Historical Period -->

                                <div class="field">

                                    <span class="label">
                                        Historical Period ID:
                                    </span>

                                    <xsl:text> </xsl:text>

                                    <xsl:value-of
                                        select="m:historicalPeriodRef"/>

                                </div>


                                <!-- Cultural Site -->

                                <div class="field">

                                    <span class="label">
                                        Cultural Site ID:
                                    </span>

                                    <xsl:text> </xsl:text>

                                    <xsl:value-of
                                        select="m:culturalSiteRef"/>

                                </div>


                                <!-- Status -->

                                <div class="field">

                                    <span class="label">
                                        Current Status:
                                    </span>

                                    <xsl:text> </xsl:text>

                                    <span class="status">

                                        <xsl:value-of
                                            select="m:currentStatus"/>

                                    </span>

                                </div>


                                <!-- Location -->

                                <div class="field">

                                    <span class="label">
                                        Location:
                                    </span>

                                    <xsl:text> </xsl:text>

                                    <xsl:value-of
                                        select="m:location/m:building"/>

                                    <xsl:text> — </xsl:text>

                                    <xsl:value-of
                                        select="m:location/m:gallery"/>

                                </div>

                            </div>


                            <!-- =================================================
                                 DESCRIPTION
                                 ================================================= -->

                            <div class="description">

                                <h3>Description</h3>

                                <p>
                                    <xsl:value-of
                                        select="m:description"/>
                                </p>

                            </div>


                            <!-- =================================================
                                 DIMENSIONS
                                 ================================================= -->

                            <div class="description">

                                <h3>Dimensions</h3>

                                <p>

                                    Height:
                                    <xsl:value-of
                                        select="m:dimensions/m:height"/>

                                    <xsl:text> </xsl:text>

                                    <xsl:value-of
                                        select="m:dimensions/m:height/@unit"/>

                                    <xsl:text> × </xsl:text>

                                    Width:
                                    <xsl:value-of
                                        select="m:dimensions/m:width"/>

                                    <xsl:text> </xsl:text>

                                    <xsl:value-of
                                        select="m:dimensions/m:width/@unit"/>

                                </p>

                            </div>


                            <!-- =================================================
                                 ACQUISITION
                                 ================================================= -->

                            <div class="description">

                                <h3>Acquisition</h3>

                                <p>

                                    Date:
                                    <xsl:value-of
                                        select="m:acquisition/m:date"/>

                                </p>

                                <p>

                                    Method:
                                    <xsl:value-of
                                        select="m:acquisition/m:method"/>

                                </p>

                                <p>

                                    Price:
                                    <xsl:value-of
                                        select="m:acquisition/m:price"/>

                                    <xsl:text> </xsl:text>

                                    <xsl:value-of
                                        select="m:acquisition/m:price/@currency"/>

                                </p>

                            </div>

                        </article>

                    </xsl:for-each>

                </main>


                <!-- =================================================
                     FOOTER
                     ================================================= -->

                <footer>

                    Generated from museum.xml using XSLT 1.0.

                </footer>

            </body>

        </html>

    </xsl:template>

</xsl:stylesheet>