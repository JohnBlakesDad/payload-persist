# Secret Server Architecture

## The 4-Block Security Model

To keep things transparent and secure, Secret Server is divided into four simple "blocks." Each block has one job, making the whole system easy to audit.

### 1. Vivify (The Input)
- **Job**: Collects your data and organizes it.
- **Why it’s cool**: It uses "autovivification." This means you can create deep folders (e.g., `Work > Projects > SecretKey`) just by typing the path. No complicated setup required.

### 2. Secrecy (The Lock)
- **Job**: Scrambles your data using GPG encryption.
- **Why it matters**: This happens **on your device** before the data is sent anywhere else. Even the server that stores the data cannot read it.

### 3. Payload (The Box)
- **Job**: Wraps the scrambled data into a JSON "package."
- **Why it matters**: It adds a timestamp and your username so the server knows where to put the data on the shelf.

### 4. Server (The Shelf)
- **Job**: Stores the "boxes" on your phone's disk.
- **Why it’s secure**: The server only ever sees the scrambled data. It functions like a locked storage unit—it holds the boxes but doesn't have the keys.

---

## The Data Flow (A-to-B)

When you save a secret, it follows this straight line:

`[Your Text]` -> **Vivify** (Organizes) -> **Secrecy** (Locks) -> **Payload** (Packs) -> **Server** (Stores)

When you retrieve a secret, it goes in reverse:

**Server** (Finds Box) -> **Payload** (Unpacks) -> **Secrecy** (Unlocks) -> **Vivify** (Displays)

---

## How this protects data

1.  **Encrypted at Rest**: Your secrets are stored as scrambled gibberish on the disk.
2.  **Encrypted in Transit**: Even if someone "sniffed" your Wi-Fi, they would only see the scrambled boxes being moved.
3.  **No Master Key**: There is no central server or company that holds a master key. Only your password can unlock your data.

---

## Technology Stack
- **CLI/Engine**: Python 3 (curses, json, gnupg)
- **Web Interface**: HTML5, Vanilla JS, CSS3
- **Transport**: Flask (HTTP/REST interface for storage)
- **Storage**: Plain JSON files (Human-readable filesystem structure)

---


