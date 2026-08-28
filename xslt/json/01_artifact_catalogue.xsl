<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://www.example.org/museum"
    exclude-result-prefixes="m">

    <xsl:output method="text" encoding="UTF-8"/>

    <xsl:template match="/">

{
  "museum": {
    "name": "<xsl:value-of select="m:museum/m:name"/>",
    "location": "<xsl:value-of select="m:museum/m:location/m:city"/>, <xsl:value-of select="m:museum/m:location/m:country"/>"
  },
  "artifacts": [
    <xsl:for-each select="m:museum/m:artifacts/m:artifact">
    {
      "id": "<xsl:value-of select="@id"/>",
      "inventoryNumber": "<xsl:value-of select="m:inventoryNumber"/>",
      "title": "<xsl:value-of select="m:title"/>",
      "creationDate": "<xsl:value-of select="m:creationDate"/>",
      "medium": "<xsl:value-of select="m:medium"/>",
      "artist": "<xsl:value-of select="m:artist"/>",
      "collection": "<xsl:value-of select="m:collectionRef"/>",
      "historicalPeriod": "<xsl:value-of select="m:historicalPeriodRef"/>",
      "culturalSite": "<xsl:value-of select="m:culturalSiteRef"/>",
      "status": "<xsl:value-of select="m:currentStatus"/>",
      "location": "<xsl:value-of select="m:location"/>",
      "description": "<xsl:value-of select="normalize-space(m:description)"/>"
    }<xsl:if test="position() != last()">,</xsl:if>
    </xsl:for-each>
  ]
}

    </xsl:template>

</xsl:stylesheet>