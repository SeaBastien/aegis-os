# Create the Kali Linux container (run once; downloads several GB)
setup-kali:
    #!/usr/bin/env bash
    set -euo pipefail
    if distrobox list | grep -qw kali; then
        echo "Kali container already exists. Open it with: ujust kali"
        exit 0
    fi
    distrobox create --yes --name kali --image docker.io/kalilinux/kali-rolling:latest
    distrobox enter kali -- sudo apt-get update
    distrobox enter kali -- sudo apt-get install -y kali-linux-headless
    echo "Done. Open a Kali shell with: ujust kali"

# Open a shell inside the Kali Linux container
kali:
    distrobox enter kali
