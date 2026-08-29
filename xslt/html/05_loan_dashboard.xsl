<?xml version="1.0" encoding="UTF-8"?>

<!--
    HTML Scenario 05: Loan Dashboard

    Purpose:
    Provide a management dashboard for museum loans.

    Categories:
    - Active loans
    - Overdue loans
    - Returned loans

    Conditional XPath expressions are used to classify loans.
-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://dsti.example/museum"
    exclude-result-prefixes="m">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Loan Dashboard</title>
                <meta charset="UTF-8"/>
            </head>

            <body>
                <h1>Loan Dashboard</h1>

                <h2>Summary</h2>

                <ul>
                    <li>
                        Active Loans:
                        <xsl:value-of select="count(m:museum/m:loans/m:loan[@status='active'])"/>
                    </li>

                    <li>
                        Overdue Loans:
                        <xsl:value-of select="count(m:museum/m:loans/m:loan[@status='overdue'])"/>
                    </li>

                    <li>
                        Returned Loans:
                        <xsl:value-of select="count(m:museum/m:loans/m:loan[@status='returned'])"/>
                    </li>
                </ul>

                <h2>Active Loans</h2>

                <table border="1">
                    <thead>
                        <tr>
                            <th>Artifact</th>
                            <th>Borrower</th>
                            <th>Start Date</th>
                            <th>Expected Return</th>
                            <th>Purpose</th>
                        </tr>
                    </thead>

                    <tbody>
                        <xsl:for-each select="m:museum/m:loans/m:loan[@status='active']">
                            <tr>
                                <td><xsl:value-of select="m:artifactRef"/></td>
                                <td><xsl:value-of select="m:borrower/m:institution"/></td>
                                <td><xsl:value-of select="m:startDate"/></td>
                                <td><xsl:value-of select="m:expectedReturnDate"/></td>
                                <td><xsl:value-of select="m:purpose"/></td>
                            </tr>
                        </xsl:for-each>
                    </tbody>
                </table>

                <h2>Overdue Loans</h2>

                <table border="1">
                    <thead>
                        <tr>
                            <th>Artifact</th>
                            <th>Borrower</th>
                            <th>Expected Return</th>
                            <th>Insurance Value</th>
                        </tr>
                    </thead>

                    <tbody>
                        <xsl:for-each select="m:museum/m:loans/m:loan[@status='overdue']">
                            <tr>
                                <td><xsl:value-of select="m:artifactRef"/></td>
                                <td><xsl:value-of select="m:borrower/m:institution"/></td>
                                <td><xsl:value-of select="m:expectedReturnDate"/></td>
                                <td><xsl:value-of select="m:insuranceValue"/></td>
                            </tr>
                        </xsl:for-each>
                    </tbody>
                </table>

                <h2>Returned Loans</h2>

                <table border="1">
                    <thead>
                        <tr>
                            <th>Artifact</th>
                            <th>Borrower</th>
                            <th>Actual Return</th>
                        </tr>
                    </thead>

                    <tbody>
                        <xsl:for-each select="m:museum/m:loans/m:loan[@status='returned']">
                            <tr>
                                <td><xsl:value-of select="m:artifactRef"/></td>
                                <td><xsl:value-of select="m:borrower/m:institution"/></td>
                                <td><xsl:value-of select="m:actualReturnDate"/></td>
                            </tr>
                        </xsl:for-each>
                    </tbody>
                </table>

            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
