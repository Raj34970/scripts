#!/usr/bin/env python3
from ldap3 import Server, Connection, ALL, SUBTREE
import getpass
import os

# LDAP configuration
LDAP_URI = "ldap://ldap-home.lxhome.local"
BASE_PEOPLE_DN = "ou=people,dc=lx,dc=local"
BASE_SERVERS_DN = "ou=servers,dc=lx,dc=local"
SSH_CONFIG_FILE = os.path.expanduser("~/.ssh/config_home")

def build_user_dn(username):
    return f"uid={username},{BASE_PEOPLE_DN}"

def fetch_attribute(conn, dn, attribute):
    conn.search(dn, "(objectClass=*)", attributes=[attribute])
    if not conn.entries:
        return []
    entry = conn.entries[0]
    values = entry[attribute].values
    return values if isinstance(values, list) else [values]

def find_allowed_servers(conn, user_dn):
    """Return servers where uniqueMember=user_dn"""
    search_filter = f"(uniqueMember={user_dn})"
    conn.search(search_base=BASE_SERVERS_DN,
                search_filter=search_filter,
                search_scope=SUBTREE,
                attributes=['cn'])
    servers = [entry.cn.value for entry in conn.entries]
    return servers

def write_ssh_config(servers, username, ssh_keys):
    """Generate ~/.ssh/config_home entries"""
    with open(SSH_CONFIG_FILE, "w") as f:
        for srv in servers:
            host_alias = f"{srv}-home"
            f.write(f"Host {host_alias}\n")
            f.write(f"    HostName {srv}\n")
            f.write(f"    User {username}\n")
            # Optional: include identity file if you save the key locally
            # f.write(f"    IdentityFile ~/.ssh/{username}_{srv}_id_rsa\n")
            f.write("\n")
    os.chmod(SSH_CONFIG_FILE, 0o600)
    print(f"[+] SSH config written to {SSH_CONFIG_FILE}")

def main():
    print("=== LDAP SSH Key Config Generator ===")

    username = input("Username: ").strip()
    password = getpass.getpass("Password: ")

    user_dn = build_user_dn(username)

    # Connect to LDAP
    try:
        server = Server(LDAP_URI, get_info=ALL)
        conn = Connection(server, user_dn, password, auto_bind=True)
        print(f"[+] Connected to LDAP as {username}")
    except Exception as e:
        print("[-] LDAP bind failed:", e)
        return

    # Fetch user's SSH keys
    ssh_keys = fetch_attribute(conn, user_dn, "sshPublicKey")
    if not ssh_keys:
        print("[-] No sshPublicKey found for user.")
        return

    # Find allowed servers
    allowed_servers = find_allowed_servers(conn, user_dn)
    if not allowed_servers:
        print("[-] No servers found where user is member of uniqueMember.")
        return

    print(f"[+] User {username} is allowed on servers:")
    for s in allowed_servers:
        print("   ", s)

    # Write SSH config
    write_ssh_config(allowed_servers, username, ssh_keys)

    conn.unbind()

if __name__ == "__main__":
    main()
