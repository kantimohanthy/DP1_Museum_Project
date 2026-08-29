<?xml version="1.0" encoding="UTF-8"?>
<!--
    ===================================================================
    S26 Data Pipeline Project - XSLT Stylesheet 10 (YAML)
    Scenario: Collection Summary YAML Configuration Export
    ===================================================================
    Description:
    This stylesheet transforms the XML database into a YAML file summarizing museum 
    collections. It groups artifacts by their collection reference, computes total 
    artifact counts per collection, and serializes artifact metadata into YAML structure.

    Implementation Style:
    - Text output method for valid YAML syntax serialization.
    - Template matching for collections and nested artifact resolution.
    ===================================================================
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://dsti.example/museum"
    exclude-result-prefixes="m">

    <xsl:output method="text" encoding="UTF-8"/>

    <xsl:key name="artist-by-id" match="m:artist" use="@id"/>
    <xsl:key name="curator-by-id" match="m:curator" use="@id"/>

    <xsl:template match="/">
# DP1 Museum Platform - Collection Summary Configuration
museum:
  name: "<xsl:value-of select="m:museum/m:metadata/m:name"/>"
  location: "<xsl:value-of select="m:museum/m:metadata/m:city"/>, <xsl:value-of select="m:museum/m:metadata/m:country"/>"
  total_collections: <xsl:value-of select="count(m:museum/m:collections/m:collection)"/>
  collections:
<xsl:apply-templates select="m:museum/m:collections/m:collection"/>
    </xsl:template>

    <xsl:template match="m:collection">
        <xsl:variable name="collId" select="@id"/>
        <xsl:variable name="artifacts" select="/m:museum/m:artifacts/m:artifact[m:collectionRef = $collId]"/>

    - collection_id: "<xsl:value-of select="$collId"/>"
      name: "<xsl:value-of select="normalize-space(m:name)"/>"
      type: "<xsl:value-of select="m:type"/>"
      curator: "<xsl:value-of select="key('curator-by-id', m:curatorRef)/m:name"/>"
      artifact_count: <xsl:value-of select="count($artifacts)"/>
      artifacts:
<xsl:apply-templates select="$artifacts"/>
    </xsl:template>

    <xsl:template match="m:artifact">
        - id: "<xsl:value-of select="@id"/>"
          title: "<xsl:value-of select="normalize-space(m:title)"/>"
          artist: "<xsl:value-of select="key('artist-by-id', m:artistRef)/m:name"/>"
          year: <xsl:value-of select="m:creationDate"/>
          status: "<xsl:value-of select="m:currentStatus"/>"
    </xsl:template>

</xsl:stylesheet>
