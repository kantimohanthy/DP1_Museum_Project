<?xml version="1.0" encoding="UTF-8"?>

<!--
    XML Scenario 08: Provenance Export

    Transforms artifact provenance information into
    a simplified XML document.
-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://dsti.example/museum"
    exclude-result-prefixes="m">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/">
        <provenanceCatalog>

            <xsl:for-each select="m:museum/m:artifacts/m:artifact">

                <artifact id="{@id}">

                    <inventoryNumber>
                        <xsl:value-of select="m:inventoryNumber"/>
                    </inventoryNumber>

                    <title>
                        <xsl:value-of select="m:title"/>
                    </title>

                    <provenance>

                        <xsl:for-each select="m:provenance/m:event">

                            <event>

                                <date>
                                    <xsl:value-of select="m:date"/>
                                </date>

                                <type>
                                    <xsl:value-of select="m:type"/>
                                </type>

                                <description>
                                    <xsl:value-of select="normalize-space(m:description)"/>
                                </description>

                                <location>
                                    <xsl:value-of select="normalize-space(m:location)"/>
                                </location>

                            </event>

                        </xsl:for-each>

                    </provenance>

                </artifact>

            </xsl:for-each>

        </provenanceCatalog>
    </xsl:template>

</xsl:stylesheet>
