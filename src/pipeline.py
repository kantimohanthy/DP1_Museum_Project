"""
===================================================================
S26 Data Pipeline Project - XML Processing Pipeline (lxml API)
===================================================================
Description:
This Python program executes the primary XML processing pipeline:
1. Loads the museum XML database (data/museum.xml).
2. Validates the XML document against the XML Schema Definition (schema/museum.xsd).
3. Discovers all 10 XSLT stylesheets under xslt/.
4. Applies each stylesheet to generate transformed HTML, XML, JSON, and YAML files.
5. Saves transformation results in the outputs/ directory.

Author: Group S26
===================================================================
"""

from pathlib import Path
from lxml import etree


ROOT = Path(__file__).resolve().parents[1]

XML_FILE = ROOT / "data" / "museum.xml"
XSD_FILE = ROOT / "schema" / "museum.xsd"
XSLT_ROOT = ROOT / "xslt"
OUTPUT_ROOT = ROOT / "outputs"


def validate_xml():
    """Loads and validates museum.xml against museum.xsd using lxml XML Schema APIs."""
    print("[1/3] Loading XML and XSD...")

    if not XML_FILE.exists():
        raise FileNotFoundError(f"XML file not found: {XML_FILE}")
    if not XSD_FILE.exists():
        raise FileNotFoundError(f"XSD schema file not found: {XSD_FILE}")

    xml_tree = etree.parse(str(XML_FILE))
    xsd_tree = etree.parse(str(XSD_FILE))

    schema = etree.XMLSchema(xsd_tree)

    if not schema.validate(xml_tree):
        print("XML SCHEMA VALIDATION FAILED")
        for error in schema.error_log:
            print(f"  - Line {error.line}: {error.message}")
        raise SystemExit(1)

    print("[OK] XML SCHEMA VALIDATION PASSED")
    return xml_tree


def transform(xml_tree):
    """Discovers and applies every XSLT stylesheet under xslt/."""
    print("[2/3] Applying XSLT Transformations...")

    stylesheets = sorted(XSLT_ROOT.rglob("*.xsl"))
    if not stylesheets:
        raise RuntimeError("No XSLT stylesheets found in xslt/ directory.")

    generated_files = []

    for xslt_file in stylesheets:
        relative = xslt_file.relative_to(XSLT_ROOT)
        output_type = relative.parts[0]  # html, xml, json, yaml

        output_dir = OUTPUT_ROOT / output_type
        output_dir.mkdir(parents=True, exist_ok=True)

        stylesheet_doc = etree.parse(str(xslt_file))
        transform_fn = etree.XSLT(stylesheet_doc)
        result = transform_fn(xml_tree)

        output_name = xslt_file.stem
        ext_map = {"html": ".html", "xml": ".xml", "json": ".json", "yaml": ".yaml"}
        extension = ext_map.get(output_type, ".txt")

        output_file = output_dir / f"{output_name}{extension}"

        with open(output_file, "wb") as f:
            if output_type in ("json", "yaml"):
                f.write(str(result).encode("UTF-8"))
            else:
                f.write(etree.tostring(result, encoding="UTF-8", pretty_print=True))

        print(f"  [OK] Generated ({output_type.upper()}): {output_file.relative_to(ROOT)}")
        generated_files.append(output_file)

    print(f"[3/3] Successfully generated {len(generated_files)} transformation outputs.")


def main():
    print("=" * 65)
    print("S26 MUSEUM DATA PIPELINE — LXML XML PROCESSING")
    print("=" * 65)

    xml_tree = validate_xml()
    transform(xml_tree)

    print("=" * 65)
    print("PIPELINE EXECUTION COMPLETED SUCCESSFULLY")
    print("=" * 65)


if __name__ == "__main__":
    main()
