# Compad Share: Peer-to-Peer Offline File Transfer Protocol

## 1. Overview
Compad Share is an end-to-end encrypted, zero-cloud peer-to-peer file transfer system engineered specifically for campus environments where internet access is spotty, dead zones exist in lecture halls, or students share a local Wi-Fi router / phone hotspot.

---

## 2. Modes of Operation

### 2.1 Wi-Fi QR Mode (High-Speed Direct P2P)
- **Sender Architecture**:
  - Launches an embedded Dart `shelf` HTTP server bound to the device's local area network (LAN) IP on an ephemeral port (e.g. `192.168.1.108:8088`).
  - Encodes session connection metadata into a QR Code:
    ```json
    {
      "ip": "192.168.1.108",
      "port": 8088,
      "token": "cpd_tok_1740000000",
      "deviceName": "Pixel 9 Pro",
      "publicKey": "x25519_pk_...",
      "expiresAt": 1740000300
    }
    ```
  - **Visual QR Security**:
    - Embedded `CompadLogo` positioned exactly at the center of the QR matrix.
    - Uses High Error Correction (`QrErrorCorrectLevel.H`), guaranteeing 100% scannability while keeping logo surface area under 18% (well below the 20% limit).
    - 5-Minute dynamic token expiry with one-tap regeneration.
    - 6-digit numeric PIN fallback for manual entry.
- **Receiver Architecture**:
  - Scans QR security key and issues a mutual handshaking request to `/handshake`.
  - Sender receives an incoming device approval prompt.
  - Streaming file payload is transferred in chunks over HTTP with AES-GCM 256-bit encryption.
  - Integrity verified using SHA-256 hash digests on receiver side before saving to disk.

### 2.2 Bluetooth Mode (Zero-Infrastructure Fallback)
- **When to Use**: Used when devices are not connected to the same Wi-Fi network and no phone hotspot is available.
- **UI Experience**: Radar-style proximity scan displaying discovered nearby devices, estimated distance, and one-tap pairing prompts.
- **Platform Limitations & Architectural Mitigations**:
  - **Android**: Supports `NearbyConnections` API for robust high-speed Bluetooth / Wi-Fi Direct bridging.
  - **iOS Limitations**: iOS limits raw Bluetooth Classic file streaming in user space and restricts CoreBluetooth throughput for large binary files.
  - **iOS Mitigation**: On iOS, the system utilizes Apple Multipeer Connectivity (`MCSession` / `MCPeerID`) via platform channels or prompts the user to activate a Personal Hotspot to enable high-speed Wi-Fi QR mode.
  - Small payloads (notes, flashcard decks, syllabus highlights) transfer quickly over BLE; large PDFs and media automatically trigger recommendation to switch to Wi-Fi QR hotspot.

---

## 3. Cryptography & Security Verification
- **Symmetric Cipher**: AES-GCM (256-bit key, 12-byte nonce, 16-byte MAC tag).
- **Key Derivation**: X25519 Elliptic Curve Diffie-Hellman session key exchange.
- **Integrity**: Full-file SHA-256 digest validation after download completion.
- **Zero Cloud Guarantee**: All traffic travels strictly through local radio interfaces. No packet is routed through an external server or cloud relay.
