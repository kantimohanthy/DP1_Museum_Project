<?xml version="1.0" encoding="UTF-8"?>

<!--
    HTML Scenario 03: Artist Explorer

    Purpose:
    Display artists represented in the museum.

    Information displayed:
    - Artist name
    - Nationality
    - Birth date
    - Death date
    - Number of museum artifacts associated with the artist
-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://dsti.example/museum"
    exclude-result-prefixes="m">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Artist Explorer</title>
                <meta charset="UTF-8"/>
            </head>

            <body>
                <h1>Artist Explorer</h1>

                <table border="1">
                    <thead>
                        <tr>
                            <th>Artist</th>
                            <th>Nationality</th>
                            <th>Birth Date</th>
                            <th>Death Date</th>
                            <th>Works in Museum</th>
                        </tr>
                    </thead>

                    <tbody>
                        <xsl:for-each select="m:museum/m:artists/m:artist">
                            <xsl:sort select="m:name" data-type="text" order="ascending"/>

                            <tr>
                                <td>
                                    <xsl:value-of select="m:name"/>
                                </td>

                                <td>
                                    <xsl:value-of select="m:nationality"/>
                                </td>

                                <td>
                                    <xsl:value-of select="m:birthDate"/>
                                </td>

                                <td>
                                    <xsl:value-of select="m:deathDate"/>
                                </td>

                                <td>
                                    <xsl:value-of select="count(/m:museum/m:artifacts/m:artifact[m:artistRef = current()/@id])"/>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </tbody>
                </table>

            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
