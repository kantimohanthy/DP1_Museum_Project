<?xml version="1.0" encoding="UTF-8"?>
<!--
    ===================================================================
    S26 Data Pipeline Project - XSLT Stylesheet 08 (XML)
    Scenario: Artifact Provenance Timeline Export
    ===================================================================
    Description:
    This stylesheet extracts the historical provenance chain of all museum artifacts 
    and transforms it into a specialized XML document structured for UNESCO and 
    international provenance registers. It formats ownership transfers, commissions, 
    and acquisition events chronologically.

    Implementation Style:
    - Recursive template-matching style (<xsl:apply-templates>).
    - Dereferences artist and period names via <xsl:key>.
    ===================================================================
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://dsti.example/museum"
    exclude-result-prefixes="m">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:key name="artist-by-id" match="m:artist" use="@id"/>
    <xsl:key name="period-by-id" match="m:period" use="@id"/>

    <xsl:template match="/">
        <provenanceExportRegister>
            <exportHeader>
                <institution><xsl:value-of select="m:museum/m:metadata/m:name"/></institution>
                <totalArtifactsProcessed><xsl:value-of select="count(m:museum/m:artifacts/m:artifact)"/></totalArtifactsProcessed>
            </exportHeader>
            <artifactHistories>
                <xsl:apply-templates select="m:museum/m:artifacts/m:artifact"/>
            </artifactHistories>
        </provenanceExportRegister>
    </xsl:template>

    <xsl:template match="m:artifact">
        <artifactProvenance id="{@id}">
            <inventoryNumber><xsl:value-of select="m:inventoryNumber"/></inventoryNumber>
            <title><xsl:value-of select="m:title"/></title>
            <creator><xsl:value-of select="key('artist-by-id', m:artistRef)/m:name"/></creator>
            <historicalPeriod><xsl:value-of select="key('period-by-id', m:historicalPeriodRef)/m:name"/></historicalPeriod>
            <timeline>
                <xsl:apply-templates select="m:provenance/m:event"/>
            </timeline>
        </artifactProvenance>
    </xsl:template>

    <xsl:template match="m:event">
        <historicalEvent>
            <date><xsl:value-of select="m:date"/></date>
            <eventType><xsl:value-of select="m:type"/></eventType>
            <location><xsl:value-of select="m:location"/></location>
            <details><xsl:value-of select="normalize-space(m:description)"/></details>
        </historicalEvent>
    </xsl:template>

</xsl:stylesheet>
