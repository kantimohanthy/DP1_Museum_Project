<?xml version="1.0" encoding="UTF-8"?>

<!--
    DP1 Museum Project - YAML Transformation 10

    Scenario:
    Generate a YAML summary of the museum collections.

    The transformation groups artifacts by collection and outputs:
    - collection name
    - number of artifacts
    - artifact ID
    - artifact title
    - artist name
    - creation year

    XPath references are used to resolve collection and artist IDs.
-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://dsti.example/museum"
    exclude-result-prefixes="m">

    <xsl:output method="text" encoding="UTF-8"/>

    <!--
        Key used to group artifacts by their collection reference.
    -->
    <xsl:key name="artifacts-by-collection"
             match="m:artifact"
             use="m:collectionRef"/>

    <xsl:template match="/">

museum:
  collections:
    <xsl:for-each select="m:museum/m:collections/m:collection">

      <xsl:variable name="collectionId" select="@id"/>

    - name: "<xsl:value-of select="normalize-space(m:name)"/>"
      artifact_count: <xsl:value-of
        select="count(/m:museum/m:artifacts/m:artifact[m:collectionRef = $collectionId])"/>
      artifacts:
<xsl:for-each select="/m:museum/m:artifacts/m:artifact[m:collectionRef = $collectionId]">

        <xsl:variable name="artistId" select="m:artistRef"/>

        - id: "<xsl:value-of select="@id"/>"
          title: "<xsl:value-of select="normalize-space(m:title)"/>"
          artist: "<xsl:value-of
            select="normalize-space(/m:museum/m:artists/m:artist[@id = $artistId]/m:name)"/>"
          year: <xsl:value-of select="m:creationDate"/>

</xsl:for-each>

    </xsl:for-each>

    </xsl:template>

</xsl:stylesheet>
