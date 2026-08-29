<?xml version="1.0" encoding="UTF-8"?>

<!--
    XML Scenario 07: Exhibition Export

    Transforms the museum database into a simplified
    XML format containing exhibition information.
-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://dsti.example/museum"
    exclude-result-prefixes="m">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/">
        <exhibitionCatalog>

            <xsl:for-each select="m:museum/m:exhibitions/m:exhibition">

                <xsl:sort select="m:startDate"
                          data-type="text"
                          order="ascending"/>

                <exhibition id="{@id}">

                    <title>
                        <xsl:value-of select="m:title"/>
                    </title>

                    <dates>
                        <start>
                            <xsl:value-of select="m:startDate"/>
                        </start>

                        <end>
                            <xsl:value-of select="m:endDate"/>
                        </end>
                    </dates>

                    <curator>
                        <xsl:value-of select="m:curatorRef"/>
                    </curator>

                    <location>
                        <xsl:value-of select="normalize-space(m:location)"/>
                    </location>

                    <status>
                        <xsl:value-of select="m:status"/>
                    </status>

                    <artifacts>

                        <xsl:for-each select="m:artifactRef">

                            <artifact>
                                <xsl:value-of select="."/>
                            </artifact>

                        </xsl:for-each>

                    </artifacts>

                </exhibition>

            </xsl:for-each>

        </exhibitionCatalog>
    </xsl:template>

</xsl:stylesheet>
