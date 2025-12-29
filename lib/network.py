import socket
from . import config

def create_connection():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((config.HOST, config.PORT))
    return s

def send_message(sock, message_bytes):
    sock.sendall(message_bytes)

def receive_message(sock, buffer_size=8192):
    return sock.recv(buffer_size)

def start_server_socket():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind((config.HOST, config.PORT))
    s.listen()
    return s

def get_connected_peers():
    """
    Reads the system ARP table to find IP addresses of devices 
    that are currently connected/reachable on the network.
    """
    peers = set()
    try:
        with open('/proc/net/arp', 'r') as f:
            lines = f.readlines()
            # Skip header line
            for line in lines[1:]:
                parts = line.split()
                if len(parts) >= 1:
                    ip = parts[0]
                    # Filter out header garbage if any, basic validity check
                    if ip.count('.') == 3:
                        peers.add(ip)
    except FileNotFoundError:
        # Fallback for systems without /proc/net/arp (e.g., non-Linux dev)
        pass
    except Exception as e:
        print(f"Warning: Could not read ARP table: {e}")
        
    return peers
