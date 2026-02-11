import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  bool _busy = false;
  String _result = 'Scan a code';

  Future<void> _handle(String raw) async {
    if (_busy) return;
    _busy = true;
    try {
      final clear = await CryptoHelper.open(raw);
      setState(() => _result = 'Decrypted: $clear');
    } catch (_) {
      setState(() => _result = 'Invalid / tampered / wrong key');
    } finally {
      await Future.delayed(const Duration(milliseconds: 600));
      _busy = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: MobileScanner(
              controller: _controller,
              onDetect: (capture) {
                final code = capture.barcodes.firstOrNull?.rawValue;
                if (code != null && code.isNotEmpty) _handle(code);
              },
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                _result,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QRGeneratorPage extends StatefulWidget {
  const QRGeneratorPage({super.key});

  @override
  State<QRGeneratorPage> createState() => _QRGeneratorPageState();
}

class _QRGeneratorPageState extends State<QRGeneratorPage> {
  String? _data;

  @override
  void initState() {
    super.initState();
    _make();
  }

  Future<void> _make() async {
    // Put whatever you want to encode here (user id, short-lived token, etc.)
    final payload = await CryptoHelper.seal('Hello from my app');
    setState(() => _data = payload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generate QR')),
      body: Center(
        child:
            _data == null
                ? const CircularProgressIndicator()
                : QrImageView(
                  data: _data!,
                  size: 280,
                  version: QrVersions.auto,
                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                  gapless: false,
                  // Use a pre-padded (white-bordered) logo asset
                  embeddedImage: const AssetImage(
                    'assets/images/logo with bg.png',
                  ),
                  embeddedImageStyle: const QrEmbeddedImageStyle(
                    size: Size(70, 45), // ~20% of 280
                  ),
                ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _make,
        label: const Text('Regenerate'),
        icon: const Icon(Icons.refresh),
      ),
    );
  }
}

/// Change this to your own 32-byte key (Base64URL). Keep it secret.
const String _kKeyB64 = 'u71C_DsAccMeqSr_D6OoWpJcrOKGBvSE0sGupdobNKc=';

/// Optional domain separation: binds the ciphertext to *your* app.
final List<int> _aad = utf8.encode('MYAPP-V1');

class CryptoHelper {
  static final AesGcm _algo = AesGcm.with256bits();
  static final SecretKey _key = SecretKey(
    base64Url.decode(_kKeyB64),
  ); // 32 bytes

  /// Encrypts plaintext and returns compact payload:
  /// v1.<nonceB64url>.<ctB64url>.<macB64url>
  static Future<String> seal(String plaintext) async {
    final nonce = _algo.newNonce(); // 12 bytes random
    final box = await _algo.encrypt(
      utf8.encode(plaintext),
      secretKey: _key,
      nonce: nonce,
      aad: _aad,
    );
    return [
      'v1',
      base64UrlEncode(nonce),
      base64UrlEncode(box.cipherText),
      base64UrlEncode(box.mac.bytes),
    ].join('.');
  }

  /// Reverses [seal]. Throws if tampered/wrong key.
  static Future<String> open(String payload) async {
    final parts = payload.split('.');
    if (parts.length != 4 || parts[0] != 'v1') {
      throw const FormatException('Bad QR payload');
    }
    final nonce = base64Url.decode(parts[1]);
    final ct = base64Url.decode(parts[2]);
    final mac = Mac(base64Url.decode(parts[3]));
    final box = SecretBox(ct, nonce: nonce, mac: mac);
    final clear = await _algo.decrypt(box, secretKey: _key, aad: _aad);
    return utf8.decode(clear);
  }
}

class QRpage extends StatefulWidget {
  const QRpage({super.key});

  @override
  State<QRpage> createState() => _QRpageState();
}

class _QRpageState extends State<QRpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Secure QR Demo')),
      body: Center(
        child: Wrap(
          spacing: 12,
          children: [
            FilledButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QRGeneratorPage()),
                  ),
              child: const Text('Generate'),
            ),
            FilledButton.tonal(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QRScannerPage()),
                  ),
              child: const Text('Scan'),
            ),
          ],
        ),
      ),
    );
  }
}
