<?xml version="1.0" encoding="UTF-8"?>
<!--
    ===================================================================
    S26 Data Pipeline Project - XSLT Stylesheet 07 (XML)
    Scenario: Exhibition Data Interchange Export
    ===================================================================
    Description:
    This stylesheet transforms the internal museum XML representation into a simplified 
    data-interchange XML schema tailored for partner institutions and regional 
    exhibition portals. It dereferences curator references and artifact IDs into 
    human-readable titles.

    Implementation Style:
    - Recursive template-matching style (<xsl:apply-templates>).
    - Outputs XML with UTF-8 encoding and indented elements.
    ===================================================================
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://dsti.example/museum"
    exclude-result-prefixes="m">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:key name="curator-by-id" match="m:curator" use="@id"/>
    <xsl:key name="artifact-by-id" match="m:artifact" use="@id"/>

    <xsl:template match="/">
        <exhibitionExportCatalogue>
            <exportMetadata>
                <sourceMuseum><xsl:value-of select="m:museum/m:metadata/m:name"/></sourceMuseum>
                <location><xsl:value-of select="m:museum/m:metadata/m:city"/>, <xsl:value-of select="m:museum/m:metadata/m:country"/></location>
                <totalExhibitions><xsl:value-of select="count(m:museum/m:exhibitions/m:exhibition)"/></totalExhibitions>
            </exportMetadata>
            <exhibitions>
                <xsl:apply-templates select="m:museum/m:exhibitions/m:exhibition">
                    <xsl:sort select="m:startDate" order="ascending"/>
                </xsl:apply-templates>
            </exhibitions>
        </exhibitionExportCatalogue>
    </xsl:template>

    <xsl:template match="m:exhibition">
        <exhibition id="{@id}">
            <title><xsl:value-of select="m:title"/></title>
            <description><xsl:value-of select="normalize-space(m:description)"/></description>
            <schedule>
                <startDate><xsl:value-of select="m:startDate"/></startDate>
                <endDate><xsl:value-of select="m:endDate"/></endDate>
            </schedule>
            <curator>
                <name><xsl:value-of select="key('curator-by-id', m:curatorRef)/m:name"/></name>
                <specialization><xsl:value-of select="key('curator-by-id', m:curatorRef)/m:specialization"/></specialization>
            </curator>
            <location><xsl:value-of select="m:location"/></location>
            <status><xsl:value-of select="m:status"/></status>
            <featuredArtifacts>
                <xsl:apply-templates select="m:artifactRef"/>
            </featuredArtifacts>
        </exhibition>
    </xsl:template>

    <xsl:template match="m:artifactRef">
        <artifact id="{.}">
            <title><xsl:value-of select="key('artifact-by-id', .)/m:title"/></title>
            <medium><xsl:value-of select="key('artifact-by-id', .)/m:medium"/></medium>
        </artifact>
    </xsl:template>

</xsl:stylesheet>
