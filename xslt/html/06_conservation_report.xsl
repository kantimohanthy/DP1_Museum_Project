<?xml version="1.0" encoding="UTF-8"?>

<!--
    HTML Scenario 06: Conservation Report

    Purpose:
    Provide a conservation-management report based on restoration projects.

    Calculations:
    - Total restoration projects
    - Completed projects
    - Total restoration cost
    - Average restoration cost

    This is the most computationally complex HTML scenario.
-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://dsti.example/museum"
    exclude-result-prefixes="m">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Conservation Report</title>
                <meta charset="UTF-8"/>
            </head>

            <body>
                <h1>Conservation Report</h1>

                <h2>Conservation Statistics</h2>

                <ul>
                    <li>
                        Total Projects:
                        <xsl:value-of select="count(m:museum/m:restorationProjects/m:restorationProject)"/>
                    </li>

                    <li>
                        Planned:
                        <xsl:value-of select="count(m:museum/m:restorationProjects/m:restorationProject[@status='planned'])"/>
                    </li>

                    <li>
                        In Progress:
                        <xsl:value-of select="count(m:museum/m:restorationProjects/m:restorationProject[@status='in_progress'])"/>
                    </li>

                    <li>
                        Completed:
                        <xsl:value-of select="count(m:museum/m:restorationProjects/m:restorationProject[@status='completed'])"/>
                    </li>

                    <li>
                        Suspended:
                        <xsl:value-of select="count(m:museum/m:restorationProjects/m:restorationProject[@status='suspended'])"/>
                    </li>

                    <li>
                        Total Cost:
                        <xsl:value-of select="sum(m:museum/m:restorationProjects/m:restorationProject/m:cost)"/>
                    </li>

                    <li>
                        Average Cost:
                        <xsl:choose>
                            <xsl:when test="count(m:museum/m:restorationProjects/m:restorationProject) &gt; 0">
                                <xsl:value-of select="format-number(sum(m:museum/m:restorationProjects/m:restorationProject/m:cost) div count(m:museum/m:restorationProjects/m:restorationProject), '0.00')"/>
                            </xsl:when>

                            <xsl:otherwise>
                                0.00
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                </ul>

                <h2>Restoration Projects</h2>

                <table border="1">
                    <thead>
                        <tr>
                            <th>Project</th>
                            <th>Artifact</th>
                            <th>Conservator</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                            <th>Status</th>
                            <th>Cost</th>
                            <th>Result</th>
                        </tr>
                    </thead>

                    <tbody>
                        <xsl:for-each select="m:museum/m:restorationProjects/m:restorationProject">
                            <xsl:sort select="m:startDate" data-type="text" order="ascending"/>

                            <tr>
                                <td><xsl:value-of select="m:title"/></td>
                                <td><xsl:value-of select="m:artifactRef"/></td>
                                <td><xsl:value-of select="m:conservator"/></td>
                                <td><xsl:value-of select="m:startDate"/></td>
                                <td><xsl:value-of select="m:endDate"/></td>
                                <td><xsl:value-of select="@status"/></td>
                                <td><xsl:value-of select="m:cost"/></td>
                                <td><xsl:value-of select="m:result"/></td>
                            </tr>
                        </xsl:for-each>
                    </tbody>
                </table>

            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
