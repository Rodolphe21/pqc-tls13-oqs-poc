# pqc-tls13-oqs-poc
Containerized PoC for Post-Quantum TLS 1.3 protocol analysis using Open Quantum Safe (OQS), NIST standards (ML-KEM/ML-DSA), Wireshark packet captures, and master key decryption

Set-Content -Path "README.md" -Value @"
# PQC TLS 1.3 Wire-Level Analysis Proof of Concept (PoC)

[![TLS 1.3](https://img.shields.io/badge/TLS-1.3-blue.svg)](https://tools.ietf.org/html/rfc8446)
[![NIST FIPS 203/204](https://img.shields.io/badge/NIST-FIPS%20203%20%2F%20204-green.svg)](https://csrc.nist.gov/projects/post-quantum-cryptography)
[![Open Quantum Safe](https://img.shields.io/badge/OQS-oqsprovider-orange.svg)](https://openquantumsafe.org/)

An automated, containerized Proof of Concept (PoC) environment designed to evaluate, capture, and inspect Post-Quantum Cryptography (PQC) and hybrid key exchanges on the wire.

Built using Docker and the Open Quantum Safe (openquantumsafe/curl) stack, this project provides step-by-step scripts to test NIST standardized algorithms (ML-KEM-768 / ML-DSA-65), BSI-recommended hybrid key exchange (X25519MLKEM768), and conservative unstructured LWE schemes (FrodoKEM).

## ⚡ Quick Start & Execution

### Prerequisites
* Docker Desktop installed and running.
* Wireshark (with Npcap driver enabled for loopback traffic inspection).
* PowerShell (Windows) or terminal execution environment.

### Step 1: Generate Cryptographic Assets
Generate the Root CA, Server CSR, and signed server certificate using ML-DSA-65 (FIPS 204):
\`\`\`powershell
.\scripts\01_generate_certs_mldsa65.ps1
\`\`\`

### Step 2: Launch the PQC TLS Server
Run one of the server profiles on port 4433:

* Pure Standardized PQC (ML-KEM-768):
  \`\`\`powershell
  .\scripts\02_run_server_pure_pqc.ps1
  \`\`\`
* BSI Hybrid Mode (X25519 + ML-KEM-768):
  \`\`\`powershell
  .\scripts\02_run_server_hybrid.ps1
  \`\`\`
* FrodoKEM Mode (frodo640shake):
  \`\`\`powershell
  .\scripts\02_run_server_frodo.ps1
  \`\`\`

### Step 3: Trigger Client Handshakes & Capture Keys
In a second terminal, execute client tests. This automatically exports session secrets to tls_keylog.log:
\`\`\`powershell
.\scripts\03_run_client_tests.ps1
\`\`\`

---

## 🔍 Wireshark Decryption Setup

1. Open Wireshark and select the Adapter for loopback traffic capture.
2. Apply display filter: tcp.port == 4433.
3. Go to Edit → Preferences → Protocols → TLS.
4. Set (Pre)-Master-Secret log filename to point to tls_keylog.log in your project folder.
5. Observe raw encrypted Application Data decrypting into readable TLS structures (Certificate, CertificateVerify, Finished).

---

## 📊 Summary of Observed Wire Behavior

| Algorithm Profile | Key Exchange / Signature | Client Hello Key Share Size | Certificate Chain Overhead | Wire Impact / Findings |
| :--- | :--- | :--- | :--- | :--- |
| **Pure Standardized PQC** | \`mlkem768\` + \`mldsa65\` | ~1,184 Bytes | ~10–15 KB | Expanded Key Share; Server Certificate fragmented across multiple TCP segments. |
| **BSI Hybrid** | \`X25519MLKEM768\` | ~1,216 Bytes | ~10–15 KB | Dual key share payloads inside Client Hello; classical + PQC protection. |
| **Unstructured LWE** | \`frodo640shake\` | ~9,616 Bytes | ~10–15 KB | Client Hello exceeds MTU, forcing client-side TCP fragmentation across 8 segments. |

---

## 📖 References & Standards

* **NIST FIPS 203:** Module-Lattice-Based Key-Encapsulation Mechanism Standard (ML-KEM)
* **NIST FIPS 204:** Module-Lattice-Based Digital Signature Standard (ML-DSA)
* **BSI TR-02102-1:** Cryptographic Mechanisms: Recommendations and Key Lengths
* **RFC 8446:** The Transport Layer Security (TLS) Protocol Version 1.3
* **Open Quantum Safe Project:** https://openquantumsafe.org/

---
*Author: Rodolphe Masson | Scope: TLS v1.3 / Open Quantum Safe (OQS) Proof of Concept*
"@
