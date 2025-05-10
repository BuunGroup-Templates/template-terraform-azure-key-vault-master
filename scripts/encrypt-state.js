#!/usr/bin/env node

// eslint-disable-next-line @typescript-eslint/no-require-imports
const crypto = require('crypto');
// eslint-disable-next-line @typescript-eslint/no-require-imports
const fs = require('fs');
// eslint-disable-next-line @typescript-eslint/no-require-imports
const path = require('path');

// --- Configuration ---
const SYMMETRIC_ALGORITHM = 'aes-256-gcm';
const SYMMETRIC_KEY_LENGTH = 32;
const IV_LENGTH = 12;
const AUTH_TAG_LENGTH = 16;
const RSA_PADDING = crypto.constants.RSA_PKCS1_OAEP_PADDING;
const RSA_OAEP_HASH = 'sha256';

// --- Helper Functions ---
function logError(message) {
  console.error(`\n::error::${message}\n`);
}

// --- Main Execution ---
async function main() {
  try {
    // Get arguments
    const inputFile = process.argv[2];
    const publicKeyPem = process.argv[3];
    const outputFile = process.argv[4];

    if (!inputFile || !publicKeyPem || !outputFile) {
      throw new Error('Usage: node encrypt-state.js <inputFile> <publicKeyPemString> <outputFile>');
    }
    if (!fs.existsSync(inputFile)) {
      throw new Error(`Input file not found: ${inputFile}`);
    }
    if (!publicKeyPem.startsWith('-----BEGIN PUBLIC KEY-----')) {
        throw new Error('Invalid Public Key PEM string provided.');
    }

    console.log(`Encrypting ${inputFile} to ${outputFile}...`);

    // 1. Generate random symmetric key and IV
    const symmetricKey = crypto.randomBytes(SYMMETRIC_KEY_LENGTH);
    const iv = crypto.randomBytes(IV_LENGTH);
    console.log(`Generated ${SYMMETRIC_ALGORITHM} key and IV.`);

    // 2. Encrypt the input file content (state file) using AES-GCM
    const plaintext = fs.readFileSync(inputFile);
    const cipher = crypto.createCipheriv(SYMMETRIC_ALGORITHM, symmetricKey, iv);

    // Perform encryption
    const encryptedContent = Buffer.concat([cipher.update(plaintext), cipher.final()]);
    const authTag = cipher.getAuthTag(); // Get the GCM authentication tag
    console.log(`File content encrypted using ${SYMMETRIC_ALGORITHM}. AuthTag length: ${authTag.length}`);

    // 3. Encrypt the symmetric key using the RSA Public Key
    const encryptedSymmetricKey = crypto.publicEncrypt(
      {
        key: publicKeyPem,
        padding: RSA_PADDING,
        oaepHash: RSA_OAEP_HASH,
      },
      symmetricKey
    );
    console.log(`Symmetric key encrypted using RSA Public Key. Encrypted key length: ${encryptedSymmetricKey.length}`);

    // 4. Construct the output buffer
    // Format: [EncryptedKeyLength (2 bytes BE)][EncryptedKey][IV (12 bytes)][AuthTag (16 bytes)][EncryptedData]
    const encryptedKeyLengthBuffer = Buffer.alloc(2);
    encryptedKeyLengthBuffer.writeUInt16BE(encryptedSymmetricKey.length, 0);

    const outputBuffer = Buffer.concat([
        encryptedKeyLengthBuffer, // 2 bytes
        encryptedSymmetricKey,    // variable length (e.g., 256 bytes for 2048-bit RSA)
        iv,                       // 12 bytes
        authTag,                  // 16 bytes
        encryptedContent          // rest of the data
    ]);

    // 5. Write the output buffer to the output file
    fs.writeFileSync(outputFile, outputBuffer);
    console.log(`Successfully created encrypted file: ${outputFile} (Total size: ${outputBuffer.length} bytes)`);

  } catch (error) {
    logError(`Encryption script failed: ${error.message}`);
    process.exit(1);
  }
}

main(); 