import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  bool _scanned = false;
  late final MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      formats: [BarcodeFormat.qrCode],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          const double scanSize = 280;
          // centered within the body, not the full screen
          final scanWindow = Rect.fromCenter(
            center: Offset(
              constraints.maxWidth / 2,
              constraints.maxHeight / 2 - 64,
            ),
            width: scanSize,
            height: scanSize,
          );

          return Stack(
            children: [
              MobileScanner(
                controller: _controller,
                scanWindow: scanWindow,
                onDetect: (capture) {
                  if (_scanned) return;
                  final raw = capture.barcodes.firstOrNull?.rawValue;
                  if (raw == null) return;
                  final uri = Uri.tryParse(raw);
                  if (uri == null) return;
                  final host = uri.host;
                  final port = uri.port;
                  if (host.isEmpty || port == 0) return;
                  _scanned = true;
                  Navigator.of(context).pop((host, port));
                },
              ),
              // dimmed overlay with hole cut out
              ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Colors.transparent,
                  BlendMode.dstOut,
                ),
                child: ColoredBox(
                  color: Colors.black54,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: scanSize,
                      height: scanSize,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              // corner brackets drawn on top
              CustomPaint(
                painter: _CornerBracketPainter(scanWindow),
                size: Size(constraints.maxWidth, constraints.maxHeight),
              ),
              // hint + torch
              Positioned(
                top: scanWindow.bottom + 48,
                left: 0,
                right: 0,
                child: const Text(
                  'Point at the QR code on your desktop app',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CornerBracketPainter extends CustomPainter {
  const _CornerBracketPainter(this.window);
  final Rect window;

  @override
  void paint(Canvas canvas, Size size) {
    // draw dim overlay with transparent hole
    final dimPaint = Paint()..color = Colors.black54;
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(window, const Radius.circular(12)));
    canvas.drawPath(path..fillType = PathFillType.evenOdd, dimPaint);

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const double len = 24;
    const double r = 12;
    final l = window.left;
    final t = window.top;
    final ri = window.right;
    final b = window.bottom;

    // top-left
    canvas.drawPath(
      Path()
        ..moveTo(l, t + len)
        ..lineTo(l, t + r)
        ..arcToPoint(Offset(l + r, t), radius: const Radius.circular(r))
        ..lineTo(l + len, t),
      paint,
    );
    // top-right
    canvas.drawPath(
      Path()
        ..moveTo(ri - len, t)
        ..lineTo(ri - r, t)
        ..arcToPoint(Offset(ri, t + r), radius: const Radius.circular(r))
        ..lineTo(ri, t + len),
      paint,
    );
    // bottom-left
    canvas.drawPath(
      Path()
        ..moveTo(l, b - len)
        ..lineTo(l, b - r)
        ..arcToPoint(
          Offset(l + r, b),
          radius: const Radius.circular(r),
          clockwise: false,
        )
        ..lineTo(l + len, b),
      paint,
    );
    // bottom-right
    canvas.drawPath(
      Path()
        ..moveTo(ri - len, b)
        ..lineTo(ri - r, b)
        ..arcToPoint(
          Offset(ri, b - r),
          radius: const Radius.circular(r),
          clockwise: false,
        )
        ..lineTo(ri, b - len),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CornerBracketPainter old) =>
      old.window != window;
}
