<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://www.example.org/museum"
    exclude-result-prefixes="m">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <xsl:template match="/">

        <museumCatalogue>

            <museum>
                <name>
                    <xsl:value-of select="m:museum/m:name"/>
                </name>

                <location>
                    <city>
                        <xsl:value-of select="m:museum/m:location/m:city"/>
                    </city>
                    <country>
                        <xsl:value-of select="m:museum/m:location/m:country"/>
                    </country>
                </location>
            </museum>

            <artifacts>

                <xsl:for-each select="m:museum/m:artifacts/m:artifact">

                    <artifact>
                        <id>
                            <xsl:value-of select="@id"/>
                        </id>

                        <inventoryNumber>
                            <xsl:value-of select="m:inventoryNumber"/>
                        </inventoryNumber>

                        <title>
                            <xsl:value-of select="m:title"/>
                        </title>

                        <creationDate>
                            <xsl:value-of select="m:creationDate"/>
                        </creationDate>

                        <medium>
                            <xsl:value-of select="m:medium"/>
                        </medium>

                        <artist>
                            <xsl:value-of select="m:artist"/>
                        </artist>

                        <collection>
                            <xsl:value-of select="m:collectionRef"/>
                        </collection>

                        <historicalPeriod>
                            <xsl:value-of select="m:historicalPeriodRef"/>
                        </historicalPeriod>

                        <culturalSite>
                            <xsl:value-of select="m:culturalSiteRef"/>
                        </culturalSite>

                        <status>
                            <xsl:value-of select="m:currentStatus"/>
                        </status>

                        <location>
                            <xsl:value-of select="m:location"/>
                        </location>

                        <description>
                            <xsl:value-of select="normalize-space(m:description)"/>
                        </description>

                    </artifact>

                </xsl:for-each>

            </artifacts>

        </museumCatalogue>

    </xsl:template>

</xsl:stylesheet>