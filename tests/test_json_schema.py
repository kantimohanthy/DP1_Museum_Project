"""
DP1 Museum Project - JSON Schema Validation Test

Validates the generated Scenario 09 JSON REST API output (09_artifact_api.json)
against the JSON Schema draft-2020-12 specification (artifact-api.schema.json).
"""

import json
import unittest
from pathlib import Path
from jsonschema import Draft202012Validator

ROOT = Path(__file__).resolve().parents[1]

schema_file = ROOT / "json-schema" / "artifact-api.schema.json"
json_file = ROOT / "outputs" / "json" / "09_artifact_api.json"


class TestJsonSchema(unittest.TestCase):

    def test_validate_json_schema(self):
        self.assertTrue(schema_file.exists(), f"Schema file missing: {schema_file}")
        self.assertTrue(json_file.exists(), f"JSON output missing: {json_file}")

        with schema_file.open(encoding="utf-8") as f:
            schema = json.load(f)

        with json_file.open(encoding="utf-8") as f:
            data = json.load(f)

        validator = Draft202012Validator(schema)
        errors = sorted(validator.iter_errors(data), key=lambda e: list(e.path))

        if errors:
            print("JSON SCHEMA VALIDATION FAILED:")
            for error in errors:
                path = ".".join(str(x) for x in error.path)
                print(f" - [{path}]: {error.message}")

        self.assertEqual(len(errors), 0, "JSON Schema validation produced errors.")
        print(f"\n[OK] JSON SCHEMA VALIDATION PASSED: {data['museum']['name']} ({data['museum']['location']})")
        print(f"Validated Artifact Count: {len(data['artifacts'])}\n")


if __name__ == "__main__":
    unittest.main()
