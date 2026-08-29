<?xml version="1.0" encoding="UTF-8"?>

<!--
    HTML Scenario 04: Historical Collection Browser

    Purpose:
    Organize museum artifacts by historical period.

    Information displayed:
    - Historical period
    - Artifact title
    - Artist
    - Collection
-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://dsti.example/museum"
    exclude-result-prefixes="m">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Historical Collection Browser</title>
                <meta charset="UTF-8"/>
            </head>

            <body>
                <h1>Historical Collection Browser</h1>

                <xsl:for-each select="m:museum/m:historicalPeriods/m:historicalPeriod">
                    <xsl:sort select="m:name" data-type="text" order="ascending"/>

                    <h2>
                        <xsl:value-of select="m:name"/>
                    </h2>

                    <p>
                        <xsl:value-of select="m:description"/>
                    </p>

                    <table border="1">
                        <thead>
                            <tr>
                                <th>Artifact</th>
                                <th>Artist</th>
                                <th>Collection</th>
                                <th>Creation Date</th>
                            </tr>
                        </thead>

                        <tbody>
                            <xsl:variable name="periodId" select="@id"/>

                            <xsl:for-each select="/m:museum/m:artifacts/m:artifact[m:historicalPeriodRef = $periodId]">
                                <xsl:sort select="m:creationDate" data-type="text"/>

                                <tr>
                                    <td>
                                        <xsl:value-of select="m:title"/>
                                    </td>

                                    <td>
                                        <xsl:value-of select="m:artistRef"/>
                                    </td>

                                    <td>
                                        <xsl:value-of select="m:collectionRef"/>
                                    </td>

                                    <td>
                                        <xsl:value-of select="m:creationDate"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>

                </xsl:for-each>

            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
