<?xml version="1.0" encoding="UTF-8"?>

<!--
    HTML Scenario 02: Exhibition Calendar

    Purpose:
    Display museum exhibitions in chronological order.

    Information displayed:
    - Exhibition title
    - Start date
    - End date
    - Curator
    - Location
    - Number of artifacts
-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://dsti.example/museum"
    exclude-result-prefixes="m">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Exhibition Calendar</title>
                <meta charset="UTF-8"/>
            </head>

            <body>
                <h1>Exhibition Calendar</h1>

                <p>
                    <strong>Museum:</strong>
                    <xsl:value-of select="m:museum/m:metadata/m:name"/>
                </p>

                <table border="1">
                    <thead>
                        <tr>
                            <th>Exhibition</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                            <th>Curator</th>
                            <th>Location</th>
                            <th>Artifact Count</th>
                        </tr>
                    </thead>

                    <tbody>
                        <xsl:for-each select="m:museum/m:exhibitions/m:exhibition">
                            <xsl:sort select="m:startDate" data-type="text" order="ascending"/>

                            <tr>
                                <td>
                                    <xsl:value-of select="m:title"/>
                                </td>

                                <td>
                                    <xsl:value-of select="m:startDate"/>
                                </td>

                                <td>
                                    <xsl:value-of select="m:endDate"/>
                                </td>

                                <td>
                                    <xsl:value-of select="m:curatorRef"/>
                                </td>

                                <td>
                                    <xsl:value-of select="normalize-space(m:location)"/>
                                </td>

                                <td>
                                    <xsl:value-of select="count(m:artifactRef)"/>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </tbody>
                </table>

            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
