<?xml version="1.0" encoding="UTF-8"?>
<!--
    ===================================================================
    S26 Data Pipeline Project - XSLT Stylesheet 09 (JSON)
    Scenario: REST API JSON Payload Export
    ===================================================================
    Description:
    This stylesheet transforms the XML database into a clean JSON API representation. 
    It embeds museum metadata and serializes artifacts into JSON objects with nested 
    artist, collection, location, and dimensions data.

    Implementation Style:
    - Text output method for valid JSON generation.
    - Resolves referenced entity names using XPath keys.
    ===================================================================
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://dsti.example/museum"
    exclude-result-prefixes="m">

    <xsl:output method="text" encoding="UTF-8"/>

    <xsl:key name="artist-by-id" match="m:artist" use="@id"/>
    <xsl:key name="collection-by-id" match="m:collection" use="@id"/>
    <xsl:key name="period-by-id" match="m:period" use="@id"/>

    <xsl:template match="/">
{
  "museum": {
    "name": "<xsl:value-of select="m:museum/m:metadata/m:name"/>",
    "location": "<xsl:value-of select="m:museum/m:metadata/m:city"/>, <xsl:value-of select="m:museum/m:metadata/m:country"/>",
    "established": <xsl:value-of select="m:museum/m:metadata/m:established"/>
  },
  "artifacts": [
    <xsl:apply-templates select="m:museum/m:artifacts/m:artifact"/>
  ]
}
    </xsl:template>

    <xsl:template match="m:artifact">
    {
      "id": "<xsl:value-of select="@id"/>",
      "inventoryNumber": "<xsl:value-of select="m:inventoryNumber"/>",
      "title": "<xsl:value-of select="m:title"/>",
      "creationYear": <xsl:value-of select="m:creationDate"/>,
      "medium": "<xsl:value-of select="m:medium"/>",
      "artist": {
        "id": "<xsl:value-of select="m:artistRef"/>",
        "name": "<xsl:value-of select="key('artist-by-id', m:artistRef)/m:name"/>"
      },
      "collection": {
        "id": "<xsl:value-of select="m:collectionRef"/>",
        "name": "<xsl:value-of select="key('collection-by-id', m:collectionRef)/m:name"/>"
      },
      "period": "<xsl:value-of select="key('period-by-id', m:historicalPeriodRef)/m:name"/>",
      "status": "<xsl:value-of select="m:currentStatus"/>",
      "location": "<xsl:value-of select="m:location/m:building"/> — <xsl:value-of select="m:location/m:gallery"/>"
    }<xsl:if test="position() != last()">,</xsl:if>
    </xsl:template>

</xsl:stylesheet>
