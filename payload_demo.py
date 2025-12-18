import json
from lib import fs_mapper

# --- Demo payload ---
payload = {
    "App1": {
        "metadata": {
            "url": "https://mybank.com",
            "author": "Alice"
        },
        "password": "Use 12+ chars",
        "comments": "Primary banking app"
    },
    "ProposedApp1": {
        "proposal": {
            "idea": "AI budgeting assistant",
            "features": ["expense tracking", "forecasting", "alerts"],
            "status": "draft"
        },
        "discussion": "Large semantic text goes here..."
    }
}

if __name__ == "__main__":
    # Write payload to filesystem
    fs_mapper.write_dict_to_fs("apps", payload)

    # Read back into dict
    apps_dict = fs_mapper.read_fs_to_dict("apps")

    # Convert to JSON string
    apps_json = json.dumps(apps_dict, indent=2)
    print(apps_json)
