"""
===================================================================
S26 Data Pipeline Project - Final Submission Build & Packaging Script
===================================================================
Description:
This script automates the complete build, validation, and packaging workflow:
1. Executes `src/pipeline.py` (XML validation & 10 XSLT transformations).
2. Executes `src/dom_export.py` (DOM API second implementation).
3. Executes `tests/test_json_schema.py` (JSON Schema Draft 2020-12 validation).
4. Executes `src/generate_report.py` (PDF Report compilation).
5. Bundles all required deliverables into `submission_museum_platform.zip`.
===================================================================
"""

import sys
import zipfile
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
ZIP_FILE = ROOT / "submission_museum_platform.zip"


def run_step(description, command):
    print(f"\n[BUILD STEP] {description}...")
    result = subprocess.run([sys.executable] + command, cwd=str(ROOT), capture_output=True, text=True)
    if result.returncode != 0:
        print(f"[FAILED]: {description}")
        print(result.stdout)
        print(result.stderr)
        sys.exit(1)
    print(f"[OK] PASSED: {description}")


def create_zip():
    print(f"\n[ZIP PACKAGING] Creating submission package: {ZIP_FILE.name}...")
    
    files_to_zip = []

    # 1. Report PDF
    pdf_report = ROOT / "report" / "Report_Museum_Platform.pdf"
    if pdf_report.exists():
        files_to_zip.append((pdf_report, "Report_Museum_Platform.pdf"))

    # 2. Source XML file
    xml_file = ROOT / "data" / "museum.xml"
    if xml_file.exists():
        files_to_zip.append((xml_file, "data/museum.xml"))

    # 3. XML Schema file
    xsd_file = ROOT / "schema" / "museum.xsd"
    if xsd_file.exists():
        files_to_zip.append((xsd_file, "schema/museum.xsd"))

    # 4. XSLT files
    for xslt_file in sorted((ROOT / "xslt").rglob("*.xsl")):
        arcname = f"xslt/{xslt_file.relative_to(ROOT / 'xslt')}"
        files_to_zip.append((xslt_file, arcname))

    # 5. Outputs of XSLT transformations
    for out_file in sorted((ROOT / "outputs").rglob("*.*")):
        arcname = f"outputs/{out_file.relative_to(ROOT / 'outputs')}"
        files_to_zip.append((out_file, arcname))

    # 6. JSON Schema file
    json_schema = ROOT / "json-schema" / "artifact-api.schema.json"
    if json_schema.exists():
        files_to_zip.append((json_schema, "json-schema/artifact-api.schema.json"))

    # 7. Python source files
    for py_file in sorted((ROOT / "src").rglob("*.py")):
        arcname = f"src/{py_file.name}"
        files_to_zip.append((py_file, arcname))

    # Also include test script
    test_script = ROOT / "tests" / "test_json_schema.py"
    if test_script.exists():
        files_to_zip.append((test_script, "tests/test_json_schema.py"))

    # Include README.md
    readme = ROOT / "README.md"
    if readme.exists():
        files_to_zip.append((readme, "README.md"))

    with zipfile.ZipFile(ZIP_FILE, "w", zipfile.ZIP_DEFLATED) as zipf:
        for filepath, arcname in files_to_zip:
            zipf.write(filepath, arcname)

    print(f"[OK] SUBMISSION ZIP CREATED SUCCESSFULLY: {ZIP_FILE.relative_to(ROOT)}")
    print(f"Total bundled items: {len(files_to_zip)}")


def main():
    print("=" * 65)
    print("S26 MUSEUM PLATFORM — AUTOMATED BUILD & SUBMISSION PACKAGING")
    print("=" * 65)

    run_step("1/4 Running XML & XSLT Pipeline", ["src/pipeline.py"])
    run_step("2/4 Running Python DOM API Implementation", ["src/dom_export.py"])
    run_step("3/4 Running JSON Schema Validation Tests", ["tests/test_json_schema.py"])
    run_step("4/4 Generating Project PDF Report", ["src/generate_report.py"])

    create_zip()

    print("\n" + "=" * 65)
    print("ALL BUILD STEPS AND SUBMISSION PACKAGING COMPLETED SUCCESSFULLY")
    print("=" * 65)


if __name__ == "__main__":
    main()
