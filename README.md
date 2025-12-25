# Secret Server

### Simple. Transparent. Secure.

**Secret Server** is a phone-friendly web app that allows you to safely store data such as passwords or more. The web side is a client that encrypts and sends data to a server that leverages file system hierarchy to store encrypted json files, 

It turns your phone into a local-first vault, where your data stays on your hardware and moves only over your own Wi-Fi.

---

## 🛡️ How it works (The Simple Flow)

It consists of these components:

1.  **Vivify**: This is the interface. It organizes your data.
2.  **Secrecy**: This is the lock. It scrambles (encrypts) your data on your device.
3.  **Payload**: This is the box. It packs the scrambled data for storage.
4.  **Server**: This is the shelf. It stores the boxes safely.

**Because the "lock" (Secrecy) happens before the data (as payload) is sent and stored, the Server and (potentially) others only see encrypted data**

---

## 🔍 Please Audit

- **Encryption Logic**: Check [`lib/secrecy.py`](lib/secrecy.py).
- **Storage Logic**: Check [`lib/storage.py`](lib/storage.py).
- **The Engine**: Check [`web_server.py`](web_server.py) or [`vivify.py`](vivify.py).

---

## 🚀 One-Step Installation (Termux)

Copy and paste this into Termux to get started:

```bash
curl -sSL https://raw.githubusercontent.com/JohnBlakesDad/payload-persist/main/install.sh | bash
```

Usage:
- Type `secret-server` to start the engine manually.

---

## Using the web interface

Open `http://localhost:5001` in a browser (Chrome).

## 📱 Running Automatically (Start on Boot)

If you want Secret Server to start every time you turn on your phone:

1.  **Install the "Termux:Boot" app** (available on F-Droid).
2.  **Open the app once** to register it.
3.  **That's it!** The installation script already placed the boot script in the right place.

---

## 🏗 Architecture

For a more detailed technical look, read the [ARCHITECTURE.md](ARCHITECTURE.md).

## 🧹 Uninstallation

To remove everything cleanly:
```bash
cd ~/payload-persist && ./uninstall.sh
```

---


