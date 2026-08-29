import json
from pathlib import Path
from jsonschema import Draft202012Validator

ROOT = Path(__file__).resolve().parents[1]

schema_file = ROOT / "schema" / "artifact_catalogue.schema.json"
json_file = ROOT / "outputs" / "json" / "01_artifact_catalogue.json"

with schema_file.open(encoding="utf-8") as f:
    schema = json.load(f)

with json_file.open(encoding="utf-8") as f:
    data = json.load(f)

validator = Draft202012Validator(schema)
errors = sorted(validator.iter_errors(data), key=lambda e: list(e.path))

if errors:
    print("JSON SCHEMA VALIDATION FAILED")
    for error in errors:
        path = ".".join(str(x) for x in error.path)
        print(f"- {path}: {error.message}")
    raise SystemExit(1)

print("JSON SCHEMA VALIDATION PASSED")
print(f"Museum: {data['museum']['name']}")
print(f"Artifact count: {len(data['artifacts'])}")
