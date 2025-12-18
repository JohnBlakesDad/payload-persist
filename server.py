import socket
from lib import network, storage, protocol

def handle_store(username, app_name, user_password, payload, conn):
    try:
        filename = storage.store_payload(username, app_name, user_password, payload)
        print(f"Stored payload in {filename}")
        conn.sendall(b"ACK: Payload stored")
    except PermissionError:
        print(f"Auth failed for user {username}")
        conn.sendall(b"ERR: Authentication failed")

def handle_retrieve(username, app_name, user_password, conn):
    try:
        result = storage.retrieve_latest_payload(username, app_name, user_password)
        if not result:
            conn.sendall(b"")
            return

        data, latest = result
        print(f"Sent payload from {latest}")
        conn.sendall(data.encode("utf-8"))
    except PermissionError:
        print(f"Auth failed for user {username}")
        conn.sendall(b"ERR: Authentication failed")

def main():
    with network.start_server_socket() as s:
        print(f"Server listening...")
        while True:
            conn, addr = s.accept()
            with conn:
                print(f"Connected by {addr}")
                data = network.receive_message(conn)
                if not data:
                    continue

                try:
                    message = protocol.parse_message(data)
                    if not message:
                        continue

                    if message.get("command") == "REQUEST_SECRET":
                        username = message["username"]
                        user_password = message["user_password"]
                        app_name = message["app"]
                        handle_retrieve(username, app_name, user_password, conn)
                    else:
                        username = message["username"]
                        user_password = message["user_password"]
                        app_name = message["app"]
                        payload = message["payload"]
                        handle_store(username, app_name, user_password, payload, conn)

                except Exception as e:
                    print("Error:", e)
                    conn.sendall(b"ERR: Failed to process request")

if __name__ == "__main__":
    main()

