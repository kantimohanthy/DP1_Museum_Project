"""
DP1 Museum Project - XML Processing Pipeline

This program:
1. Loads the museum XML database.
2. Validates the XML document against the XML Schema.
3. Discovers and applies XSLT stylesheets.
4. Writes the generated transformation outputs.

The implementation uses lxml XML APIs as required by the project.
"""

from pathlib import Path
from lxml import etree


ROOT = Path(__file__).resolve().parents[1]

XML_FILE = ROOT / "data" / "museum.xml"
XSD_FILE = ROOT / "schema" / "museum.xsd"
XSLT_ROOT = ROOT / "xslt"
OUTPUT_ROOT = ROOT / "outputs"


def validate_xml():
    """Load and validate museum.xml against museum.xsd."""

    print("[1/3] Loading XML and XSD...")

    xml_tree = etree.parse(str(XML_FILE))
    xsd_tree = etree.parse(str(XSD_FILE))

    schema = etree.XMLSchema(xsd_tree)

    if not schema.validate(xml_tree):
        print("XML VALIDATION FAILED")
        for error in schema.error_log:
            print(error)
        raise SystemExit(1)

    print("XML VALIDATION PASSED")

    return xml_tree


def transform(xml_tree):
    """Apply every XSLT stylesheet found under xslt/."""

    print("[2/3] Applying XSLT transformations...")

    transformations = []

    for xslt_file in sorted(XSLT_ROOT.rglob("*.xsl")):
        transformations.append(xslt_file)

    if not transformations:
        raise RuntimeError("No XSLT stylesheets were found.")

    for xslt_file in transformations:

        relative = xslt_file.relative_to(XSLT_ROOT)

        output_type = relative.parts[0]

        output_dir = OUTPUT_ROOT / output_type
        output_dir.mkdir(parents=True, exist_ok=True)

        stylesheet = etree.XSLT(etree.parse(str(xslt_file)))
        result = stylesheet(xml_tree)

        output_name = xslt_file.stem

        if output_type == "html":
            extension = ".html"
        elif output_type == "xml":
            extension = ".xml"
        elif output_type == "json":
            extension = ".json"
        elif output_type == "yaml":
            extension = ".yaml"
        else:
            extension = ".txt"

        output_file = output_dir / f"{output_name}{extension}"

        with open(output_file, "wb") as file:
            if output_type in ("json", "yaml"):
                file.write(str(result).encode("UTF-8"))
            else:
                file.write(
                    etree.tostring(
                        result,
                        encoding="UTF-8",
                        pretty_print=True
                    )
                )

        print(f"  Generated: {output_file.relative_to(ROOT)}")

    print("XSLT TRANSFORMATIONS PASSED")


def main():
    """Execute the complete XML processing pipeline."""

    print("=" * 60)
    print("DP1 MUSEUM DATA PIPELINE")
    print("=" * 60)

    xml_tree = validate_xml()
    transform(xml_tree)

    print("=" * 60)
    print("PIPELINE COMPLETED SUCCESSFULLY")
    print("=" * 60)


if __name__ == "__main__":
    main()
