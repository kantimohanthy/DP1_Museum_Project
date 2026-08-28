<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://dsti.example/museum"
    exclude-result-prefixes="m">

    <xsl:output
        method="text"
        encoding="UTF-8"/>

    <xsl:template match="/">

museum:
  name: "<xsl:value-of select="m:museum/m:metadata/m:name"/>"
  city: "<xsl:value-of select="m:museum/m:metadata/m:city"/>"
  country: "<xsl:value-of select="m:museum/m:metadata/m:country"/>"
  established: "<xsl:value-of select="m:museum/m:metadata/m:established"/>"

artifacts:
<xsl:for-each select="m:museum/m:artifacts/m:artifact">
  - id: "<xsl:value-of select="@id"/>"
    inventoryNumber: "<xsl:value-of select="m:inventoryNumber"/>"
    title: "<xsl:value-of select="normalize-space(m:title)"/>"
    creationDate: "<xsl:value-of select="m:creationDate"/>"
    medium: "<xsl:value-of select="normalize-space(m:medium)"/>"
    artistRef: "<xsl:value-of select="m:artistRef"/>"
    collectionRef: "<xsl:value-of select="m:collectionRef"/>"
    historicalPeriodRef: "<xsl:value-of select="m:historicalPeriodRef"/>"
    culturalSiteRef: "<xsl:value-of select="m:culturalSiteRef"/>"
    status: "<xsl:value-of select="m:currentStatus"/>"
    description: "<xsl:value-of select="normalize-space(m:description)"/>"
    location:
      building: "<xsl:value-of select="m:location/m:building"/>"
      gallery: "<xsl:value-of select="m:location/m:gallery"/>"
    dimensions:
      height:
        value: <xsl:value-of select="m:dimensions/m:height"/>
        unit: "<xsl:value-of select="m:dimensions/m:height/@unit"/>"
      width:
        value: <xsl:value-of select="m:dimensions/m:width"/>
        unit: "<xsl:value-of select="m:dimensions/m:width/@unit"/>"
</xsl:for-each>

    </xsl:template>

</xsl:stylesheet>