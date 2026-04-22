#!/bin/bash
# entrypoint.sh
set -e

# --- INITIALIZATION PHASE ---
echo "Initializing Python venv..."
python3 -m venv /opt/ansible-venv
source /opt/ansible-venv/bin/activate

echo "Installing dependencies..."
pip install --upgrade pip
pip install -r /project/requirements.txt

# --- EXECUTION PHASE ---
echo "Executing playbook: ${PLAYBOOK_FILE}"
# We assume the playbook and inventory are mounted to /project
ansible-playbook -i /project/inventory.ini /project/$PLAYBOOK_FILE