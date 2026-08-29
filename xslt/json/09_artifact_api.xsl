<?xml version="1.0" encoding="UTF-8"?>

<!--
    XML Scenario 09: Artifact API

    Transforms the museum XML database into a JSON-style
    API representation containing artifacts and their
    referenced entities.
-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://dsti.example/museum"
    exclude-result-prefixes="m">

    <xsl:output method="text" encoding="UTF-8"/>

    <xsl:template match="/">

{
  "artifacts": [
    <xsl:for-each select="m:museum/m:artifacts/m:artifact">

    {
      "id": "<xsl:value-of select="@id"/>",
      "title": "<xsl:value-of select="m:title"/>",
      "year": <xsl:value-of select="substring(m:creationDate, 1, 4)"/>,
      "artist": {
        "id": "<xsl:value-of select="m:artistRef"/>",
        "name": "<xsl:value-of select="/m:museum/m:artists/m:artist[@id = current()/m:artistRef]/m:name"/>"
      },
      "collection": {
        "id": "<xsl:value-of select="m:collectionRef"/>",
        "name": "<xsl:value-of select="/m:museum/m:collections/m:collection[@id = current()/m:collectionRef]/m:name"/>"
      },
      "status": "<xsl:value-of select="m:currentStatus"/>"
    }<xsl:if test="position() != last()">,</xsl:if>
    </xsl:for-each>
  ]
}

    </xsl:template>

</xsl:stylesheet>
