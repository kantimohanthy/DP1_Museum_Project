"""
===================================================================
S26 Data Pipeline Project - DOM API Implementation (Optional Bonus)
===================================================================
Description:
This program provides a second, standalone implementation of Scenario 09 (Artifact API) 
and Scenario 10 (Collection Summary) using Python's standard W3C DOM API (xml.dom.minidom).

Instead of applying XSLT stylesheets, this script directly traverses the XML 
Document Object Model (DOM) tree, navigates element nodes, extracts text nodes, 
performs in-memory relational join lookups across entity tables, and outputs 
a formatted JSON/XML DOM export.

Requirements Fulfilled:
- "Optionally, provide a second implementation of one of your scenarios in Python or Java (using XML APIs, e.g. DOM)."
===================================================================
"""

import json
from pathlib import Path
from xml.dom import minidom


ROOT = Path(__file__).resolve().parents[1]
XML_FILE = ROOT / "data" / "museum.xml"
OUTPUT_FILE = ROOT / "outputs" / "json" / "dom_artifact_summary.json"


def get_text(node_list):
    """Utility function to extract concatenated text from a list of DOM text nodes."""
    rc = []
    for node in node_list:
        if node.nodeType == node.TEXT_NODE:
            rc.append(node.data)
    return "".join(rc).strip()


def parse_museum_dom():
    """Parses museum.xml using xml.dom.minidom and builds relational entity dictionaries."""
    print("[DOM API] Parsing museum.xml using xml.dom.minidom...")
    dom = minidom.parse(str(XML_FILE))
    root = dom.documentElement

    # Extract Metadata
    metadata_elem = root.getElementsByTagName("m:metadata")[0]
    name = get_text(metadata_elem.getElementsByTagName("m:name")[0].childNodes)
    city = get_text(metadata_elem.getElementsByTagName("m:city")[0].childNodes)
    country = get_text(metadata_elem.getElementsByTagName("m:country")[0].childNodes)
    established = get_text(metadata_elem.getElementsByTagName("m:established")[0].childNodes)

    # Build Artist Lookup Table (DOM Node Traversal)
    artists = {}
    artist_nodes = root.getElementsByTagName("m:artist")
    for a in artist_nodes:
        aid = a.getAttribute("id")
        aname = get_text(a.getElementsByTagName("m:name")[0].childNodes)
        artists[aid] = aname

    # Build Collection Lookup Table
    collections = {}
    coll_nodes = root.getElementsByTagName("m:collection")
    for c in coll_nodes:
        cid = c.getAttribute("id")
        cname = get_text(c.getElementsByTagName("m:name")[0].childNodes)
        collections[cid] = cname

    # Build Period Lookup Table
    periods = {}
    period_nodes = root.getElementsByTagName("m:period")
    for p in period_nodes:
        pid = p.getAttribute("id")
        pname = get_text(p.getElementsByTagName("m:name")[0].childNodes)
        periods[pid] = pname

    # Traverse Artifact DOM Nodes and perform relational join lookups
    artifacts = []
    artifact_nodes = root.getElementsByTagName("m:artifact")

    for art in artifact_nodes:
        art_id = art.getAttribute("id")
        title = get_text(art.getElementsByTagName("m:title")[0].childNodes)
        inv_no = get_text(art.getElementsByTagName("m:inventoryNumber")[0].childNodes)
        creation_date = get_text(art.getElementsByTagName("m:creationDate")[0].childNodes)
        medium = get_text(art.getElementsByTagName("m:medium")[0].childNodes)
        status = get_text(art.getElementsByTagName("m:currentStatus")[0].childNodes)

        artist_ref = get_text(art.getElementsByTagName("m:artistRef")[0].childNodes)
        coll_ref = get_text(art.getElementsByTagName("m:collectionRef")[0].childNodes)
        period_ref = get_text(art.getElementsByTagName("m:historicalPeriodRef")[0].childNodes)

        location_elem = art.getElementsByTagName("m:location")[0]
        building = get_text(location_elem.getElementsByTagName("m:building")[0].childNodes)
        gallery = get_text(location_elem.getElementsByTagName("m:gallery")[0].childNodes)

        # Extract Provenance Events using DOM child element iteration
        provenance_events = []
        prov_elems = art.getElementsByTagName("m:provenance")
        if prov_elems:
            events = prov_elems[0].getElementsByTagName("m:event")
            for ev in events:
                e_date = get_text(ev.getElementsByTagName("m:date")[0].childNodes)
                e_type = get_text(ev.getElementsByTagName("m:type")[0].childNodes)
                e_desc = get_text(ev.getElementsByTagName("m:description")[0].childNodes)
                provenance_events.append({"date": e_date, "type": e_type, "description": e_desc})

        artifacts.append({
            "id": art_id,
            "inventoryNumber": inv_no,
            "title": title,
            "creationDate": creation_date,
            "medium": medium,
            "artist": {"id": artist_ref, "name": artists.get(artist_ref, "Unknown Artist")},
            "collection": {"id": coll_ref, "name": collections.get(coll_ref, "Unknown Collection")},
            "period": periods.get(period_ref, "Unknown Period"),
            "status": status,
            "location": f"{building} — {gallery}",
            "provenanceEventsCount": len(provenance_events),
            "provenanceHistory": provenance_events
        })

    result_payload = {
        "museum": {
            "name": name,
            "location": f"{city}, {country}",
            "established": int(established)
        },
        "domTraversalEngine": "Python xml.dom.minidom (W3C DOM Level 2)",
        "totalArtifactsProcessed": len(artifacts),
        "artifacts": artifacts
    }

    OUTPUT_FILE.parent.mkdir(parents=True, exist_ok=True)
    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        json.dump(result_payload, f, indent=2)

    print(f"[DOM API] Success! Export written to: {OUTPUT_FILE.relative_to(ROOT)}")
    return result_payload


if __name__ == "__main__":
    parse_museum_dom()
