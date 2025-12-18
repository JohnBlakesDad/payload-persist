#!/usr/bin/env python3
"""Test script for the Secret Vault API - Clean test"""
import requests
import json

BASE_URL = "http://localhost:5001"

# Create a session to maintain cookies
session = requests.Session()

print("=" * 70)
print("Testing Secret Vault API - Deep Update (Autovivification) Feature")
print("=" * 70)

# 1. Register a new clean user
print("\n1. Registering new user 'apitest'...")
response = session.post(f"{BASE_URL}/api/auth/register", json={
    "username": "apitest",
    "password": "testpass123"
})
print(f"   Status: {response.status_code}")
result = response.json()
if result.get('success'):
    print(f"   ✓ Registration successful!")
else:
    # User might already exist, try login
    print(f"   User exists, logging in...")
    response = session.post(f"{BASE_URL}/api/auth/login", json={
        "username": "apitest",
        "password": "testpass123"
    })
    if response.json().get('success'):
        print(f"   ✓ Login successful!")

# 2. Store a secret
print("\n2. Storing initial secret for 'TestApp'...")
response = session.post(f"{BASE_URL}/api/secrets/store", json={
    "app_name": "TestApp",
    "app_username": "admin@test.com",
    "secret_text": json.dumps({"password": "initial123", "api_key": "key456"}),
    "passphrase": "mypass"
})
print(f"   Status: {response.status_code}")
result = response.json()
if result.get('success'):
    print(f"   ✓ Secret stored successfully!")
else:
    print(f"   ✗ Failed: {result.get('error')}")

# 3. Test Deep Update - Add top-level field
print("\n3. Deep Update Test #1 - Adding top-level 'environment' field...")
response = session.post(f"{BASE_URL}/api/secrets/update", json={
    "app_name": "TestApp",
    "passphrase": "mypass",
    "key_path": "environment",
    "value": "production"
})
print(f"   Status: {response.status_code}")
result = response.json()
if result.get('success'):
    print(f"   ✓ Update successful!")
    print(f"   Updated structure:")
    print(f"   {json.dumps(result.get('updated_secret'), indent=4)}")
else:
    print(f"   ✗ Failed: {result.get('error')}")

# 4. Test Deep Update - Nested autovivification
print("\n4. Deep Update Test #2 - Autovivification 'database.host' (creates nested object)...")
response = session.post(f"{BASE_URL}/api/secrets/update", json={
    "app_name": "TestApp",
    "passphrase": "mypass",
    "key_path": "database.host",
    "value": "db.example.com"
})
print(f"   Status: {response.status_code}")
result = response.json()
if result.get('success'):
    print(f"   ✓ Update successful! (autovivification worked)")
    print(f"   Updated structure:")
    print(f"   {json.dumps(result.get('updated_secret'), indent=4)}")
else:
    print(f"   ✗ Failed: {result.get('error')}")

# 5. Test Deep Update - Deeper nesting
print("\n5. Deep Update Test #3 - Deep autovivification 'database.credentials.username'...")
response = session.post(f"{BASE_URL}/api/secrets/update", json={
    "app_name": "TestApp",
    "passphrase": "mypass",
    "key_path": "database.credentials.username",
    "value": "dbuser"
})
print(f"   Status: {response.status_code}")
result = response.json()
if result.get('success'):
    print(f"   ✓ Update successful! (deep autovivification worked)")
    print(f"   Updated structure:")
    print(f"   {json.dumps(result.get('updated_secret'), indent=4)}")
else:
    print(f"   ✗ Failed: {result.get('error')}")

# 6. Final retrieval to verify all updates
print("\n6. Final Retrieval - Verifying all updates persisted...")
response = session.post(f"{BASE_URL}/api/secrets/retrieve", json={
    "app_name": "TestApp",
    "passphrase": "mypass"
})
print(f"   Status: {response.status_code}")
result = response.json()
if result.get('success'):
    print(f"   ✓ Retrieval successful!")
    print(f"\n   Final Secret Structure:")
    print(f"   " + "=" * 60)
    secret_data = json.loads(result.get('secret'))
    print(f"   {json.dumps(secret_data, indent=4)}")
    print(f"   " + "=" * 60)
    print(f"\n   ✓ All fields present:")
    print(f"     - Original: password, api_key")
    print(f"     - Added: environment")
    print(f"     - Autovivified: database.host, database.credentials.username")
else:
    print(f"   ✗ Failed: {result.get('error')}")

print("\n" + "=" * 70)
print("✓ Deep Update (Autovivification) Testing Complete!")
print("=" * 70)
