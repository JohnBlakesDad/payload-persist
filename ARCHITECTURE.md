# Payload-Persist Architecture

## Overview

The payload-persist system is designed to function as a standalone secrets keeper with a JSON-based structure for easy recognition and manipulation. This document outlines the initial structure before the Perl Depth.pm app is fully demystified.

**Primary Goal**: Make the payload a JSON structure so the data hierarchy is easily recognizable.

---

## System Operations

### UPDATE or CREATION Flow

```mermaid
graph TD
    A[User Input] --> B{Input Method}
    B -->|Graphical| C[UI Input - vivify client]
    B -->|Terminal| D[CLI Curses Input - vivify client]
    C --> E[Autovivification Process]
    D --> E
    E --> F[Un-schema'd JSON<br/>Hash of Hashes Structure]
    F --> G[Payload Initialization]
    G --> H[Secrecy Encryption<br/>Secrets Encrypted]
    H --> I[Payload Preparation<br/>Serialized/Frozen]
    I --> J[IP Transmission to Server<br/>with DB-User Password]
    J --> K[Server Processing]
    K --> L[Strip First Two Layers<br/>name, app-name/topic]
    L --> M[Extract Large Binary Chunks]
    M --> N{Storage Decision}
    N -->|Text Data| O[Store as JSON File]
    N -->|Binary Data| P[Store as Binary Object]
    
    style H fill:#ff9999
    style O fill:#99ff99
    style P fill:#99ff99
```

#### Key Points

1. **Client-Side Input**: 
   - Graphical (UI) or curses (CLI) input within the vivify client
   - Input is autovivified into un-schema'd JSON (hash of hashes) complex structure

2. **Encryption & Transmission**:
   - Payload is initialized and "secrecy" encrypts secrets
   - Payload is prepared (serialized, frozen) for IP transmission
   - Sent to server with db-user password

3. **Server-Side Processing**:
   - Server strips off first two layers: `name`, `app-name` (or other topic)
   - Large binary chunks are extracted
   - Remainder stored as JSON file or binary object
   - **Not encrypted on server** for admin ease
   - Secrets remain encrypted (client-side encryption in high-security context)
   - Same password can be used for more casual access

---

### RETRIEVAL Flow

```mermaid
graph TD
    A[User Request] --> B{Input Method}
    B -->|Graphical| C[UI Input - vivify client]
    B -->|Terminal| D[CLI Curses Input - vivify client]
    C --> E[Payload Creation]
    D --> E
    E --> F[Input Components:<br/>- name db top layer<br/>- app-name/other next layer<br/>- desired value path<br/>- db-user secret]
    F --> G[Server Request<br/>with Credentials]
    G --> H[Server Locates JSON File<br/>using app-name]
    H --> I{Access Type}
    I -->|Single Value| J[Perl-like Hash Navigation<br/>Traverse to Desired Depth]
    I -->|Structure/Subset| K[Extract Whole Structure<br/>or Named Subset]
    J --> L[Return Value as Payload<br/>Usually Encrypted]
    K --> M[Form Structure into Payload]
    M --> L
    L --> N[Client Receives Payload]
    N --> O[Reverse Creation Process]
    O --> P[Print/Display Data]
    
    style L fill:#ff9999
    style P fill:#99ccff
```

#### Key Points

1. **Client-Side Request**:
   - Same UI or CLI curses interface
   - Payload created with:
     - `name` (database top layer)
     - `app-name` or other name (next layer)
     - Desired value path (from hash of hashes JSON)
     - DB-user secret

2. **Server-Side Retrieval**:
   - Access JSON file using `app-name`
   - Navigate using Perl-like hash of hashes syntax
   - Reach desired value at specified depth

3. **Return Options**:
   - **Single Value**: Return specific value (usually encrypted)
   - **Structure/Subset**: Return whole structure or named subset as payload

4. **Client-Side Processing**:
   - Client receives payload
   - Reverses creation process
   - Prints/displays the data

---

## Data Structure Hierarchy

```mermaid
graph TD
    A[Root] --> B[name - DB Top Layer]
    B --> C[app-name/topic - Second Layer]
    C --> D[Hash of Hashes Structure]
    D --> E[Key 1]
    D --> F[Key 2]
    D --> G[Key N]
    E --> H[Value or Nested Hash]
    F --> I[Value or Nested Hash]
    G --> J[Value or Nested Hash]
    H --> K[Deeper Nesting...]
    
    style B fill:#ffcc99
    style C fill:#ffcc99
    style D fill:#99ccff
```

### Layer Breakdown

1. **Layer 1**: `name` - Database top layer (stripped by server)
2. **Layer 2**: `app-name` or topic - Application identifier (stripped by server)
3. **Layer 3+**: Hash of hashes JSON structure (stored on server)
   - Navigable using Perl-like syntax
   - Arbitrary depth supported
   - Values can be encrypted secrets or plain data

---

## Security Model

```mermaid
graph LR
    A[Client High-Security Context] -->|Encrypts| B[Secrets]
    B --> C[Encrypted Payload]
    C -->|Transmitted| D[Server]
    D -->|Stores| E[JSON with Encrypted Secrets]
    E -->|No Server-Side Decryption| F[Admin Can View Structure<br/>But Not Decrypt Secrets]
    
    style A fill:#ff9999
    style B fill:#ff9999
    style C fill:#ff9999
    style E fill:#ffff99
    style F fill:#99ff99
```

### Security Characteristics

- **Client-side encryption**: Secrets encrypted in high-security context before transmission
- **Server storage**: JSON stored unencrypted for admin ease
- **Secret protection**: Secrets cannot be decrypted on server (no keys available)
- **Password usage**: Same db-user password for both secure and casual access
- **Separation of concerns**: Structure visible to admins, secrets remain protected

---

## Technology Stack

- **Client**: vivify (UI/CLI with curses)
- **Data Format**: JSON (hash of hashes)
- **Serialization**: Frozen/serialized payloads
- **Navigation**: Perl-like hash of hashes syntax (Depth.pm)
- **Encryption**: Client-side "secrecy" encryption
- **Transport**: IP-based transmission
- **Storage**: JSON files and binary objects

---

## Future Considerations

- Full demystification of Perl Depth.pm app
- Enhanced autovivification capabilities
- Improved structure navigation
- Extended security features
