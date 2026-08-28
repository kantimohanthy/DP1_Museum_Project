# DP1 Museum Project

## Overview

This project demonstrates the transformation and validation of structured museum data using XML, XSD, and XSLT.

The original museum dataset is represented in XML and validated against an XML Schema Definition (XSD). XSLT transformations are then used to generate multiple output formats for the museum artifact catalogue.

## Project Structure

```text
DP1_Museum_Project/
├── data/
│   └── museum.xml
│
├── outputs/
│   ├── html/
│   │   └── artifact_catalogue.html
│   ├── json/
│   │   └── artifact_catalogue.json
│   ├── xml/
│   │   └── artifact_catalogue.xml
│   └── yaml/
│       └── artifact_catalogue.yaml
│
├── schema/
│   └── museum.xsd
│
├── xslt/
│   ├── html/
│   │   └── 01_artifact_catalogue.xsl
│   ├── json/
│   │   └── 01_artifact_catalogue.xsl
│   ├── xml/
│   │   └── 01_artifact_catalogue.xsl
│   └── yaml/
│       └── 01_artifact_catalogue.xsl
│
└── .gitignore
