#/bin/bash
echo "Setting up Supercog to run from Docker..."
if [ -f ".env" ]; then
    echo ".env file already exists. Skipping setup."
    exit 0
fi
if [ ! -f "env.base" ]; then
    echo "Please copy env.example to env.base and edit your config." >&2
    exit 1
fi
mkdir -p ./local_data/tools
cp ./dummy_tool.py ./local_data/tools
cp env.base .env
echo "Generating local keys..."
mkdir -p ./keys
openssl ecparam -name prime256v1 -genkey -noout -out ./keys/dash_ecdsa_private_key.pem 2>/dev/null
openssl ec -in ./keys/dash_ecdsa_private_key.pem -pubout -out ./keys/dash_ecdsa_public_key.pem 2>/dev/null
export DASH_PRIVATE_KEY=$(base64 < "./keys/dash_ecdsa_private_key.pem" | tr -d '\n')
export DASH_PUBLIC_KEY=$(base64 < "./keys/dash_ecdsa_public_key.pem" | tr -d '\n')
echo "DASH_PRIVATE_KEY=$DASH_PRIVATE_KEY" >> .env
echo "DASH_PUBLIC_KEY=$DASH_PUBLIC_KEY" >> .env

generate_fernet_key() {
    openssl rand -base64 32 | tr '/+' '_-' | cut -c1-44
}

FERNET_KEY=$(generate_fernet_key)
echo "CREDENTIALS_MASTER_KEY=$FERNET_KEY" >> .env

echo "Setup done. Configuration stored in .env file."
