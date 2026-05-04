import 'package:flutter/material.dart';
import 'package:fitwego/models/training_model.dart';
import 'package:fitwego/theme/app_theme.dart';

const kMapBg     = Color(0xFF12121F);
const kAvailClr  = Color(0xFF00E676);
const kBusyClr   = Color(0xFFFF5252);
const kSessClr   = Color(0xFFFFD740);

Color trainerStatusColor(TrainerStatus s) {
  switch (s) {
    case TrainerStatus.available:  return kAvailClr;
    case TrainerStatus.busy:       return kBusyClr;
    case TrainerStatus.inSession:  return kSessClr;
  }
}

String trainerStatusLabel(TrainerStatus s) {
  switch (s) {
    case TrainerStatus.available:  return 'Available';
    case TrainerStatus.busy:       return 'Busy';
    case TrainerStatus.inSession:  return 'In Session';
  }
}

// ── Fake Map Painter ─────────────────────────────────────────────────────────

class FakeMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Background
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF0F0F1E));

    // City blocks
    final blockP = Paint()..color = const Color(0xFF191928)..style = PaintingStyle.fill;
    final rects = [
      Rect.fromLTWH(0,       0,       w*.18, h*.28),
      Rect.fromLTWH(w*.22,   0,       w*.16, h*.20),
      Rect.fromLTWH(w*.42,   0,       w*.16, h*.16),
      Rect.fromLTWH(w*.62,   0,       w*.16, h*.26),
      Rect.fromLTWH(w*.82,   0,       w*.18, h*.20),
      Rect.fromLTWH(0,       h*.32,   w*.16, h*.18),
      Rect.fromLTWH(w*.22,   h*.24,   w*.14, h*.20),
      Rect.fromLTWH(w*.62,   h*.30,   w*.14, h*.18),
      Rect.fromLTWH(w*.80,   h*.24,   w*.20, h*.22),
      Rect.fromLTWH(0,       h*.58,   w*.18, h*.18),
      Rect.fromLTWH(w*.22,   h*.66,   w*.16, h*.16),
      Rect.fromLTWH(w*.46,   h*.54,   w*.18, h*.20),
      Rect.fromLTWH(w*.70,   h*.60,   w*.14, h*.18),
      Rect.fromLTWH(0,       h*.82,   w*.20, h*.18),
      Rect.fromLTWH(w*.60,   h*.80,   w*.40, h*.20),
    ];
    for (final r in rects) {
      canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(3)), blockP);
    }

    // Park (green tint)
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w*.40, h*.46, w*.18, h*.14), const Radius.circular(4)),
      Paint()..color = const Color(0xFF162618),
    );

    // Main roads (wide)
    final roadW = Paint()..color = const Color(0xFF1D1D38)..strokeWidth = 10..style = PaintingStyle.stroke;
    for (final y in [0.28, 0.50, 0.70, 0.86]) {
      canvas.drawLine(Offset(0, h * y), Offset(w, h * y), roadW);
    }
    for (final x in [0.20, 0.42, 0.62, 0.80]) {
      canvas.drawLine(Offset(w * x, 0), Offset(w * x, h), roadW);
    }

    // Side roads (thin)
    final roadT = Paint()..color = const Color(0xFF17172C)..strokeWidth = 4..style = PaintingStyle.stroke;
    for (final y in [0.12, 0.20, 0.38, 0.60, 0.78]) {
      canvas.drawLine(Offset(0, h * y), Offset(w, h * y), roadT);
    }
    for (final x in [0.10, 0.30, 0.52, 0.72, 0.90]) {
      canvas.drawLine(Offset(w * x, 0), Offset(w * x, h), roadT);
    }

    // Diagonal roads
    canvas.drawLine(Offset(0,       h * .14), Offset(w * .40, h * .48), roadT);
    canvas.drawLine(Offset(w * .62, h * .50), Offset(w,       h * .70), roadT);

    // User position pulse
    final cx = w * .50; final cy = h * .55;
    canvas.drawCircle(Offset(cx, cy), 55, Paint()..color = AppTheme.primaryBlue.withOpacity(0.07));
    canvas.drawCircle(Offset(cx, cy), 28, Paint()..color = AppTheme.primaryBlue.withOpacity(0.05));
    canvas.drawCircle(Offset(cx, cy), 9,  Paint()..color = AppTheme.primaryBlue);
    canvas.drawCircle(Offset(cx, cy), 9,  Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2.5);
  }

  @override
  bool shouldRepaint(FakeMapPainter o) => false;
}

// ── Trainer Avatar Pin ────────────────────────────────────────────────────────

class TrainerAvatarPin extends StatelessWidget {
  final DiscoveryTrainer trainer;
  final bool selected;
  const TrainerAvatarPin({super.key, required this.trainer, required this.selected});

  @override
  Widget build(BuildContext context) {
    final sc = trainerStatusColor(trainer.status);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? AppTheme.primaryBlue : Colors.white.withOpacity(0.7),
              width: selected ? 3.0 : 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: selected
                    ? AppTheme.primaryBlue.withOpacity(0.55)
                    : Colors.black.withOpacity(0.45),
                blurRadius: selected ? 18 : 8,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(trainer.imageUrl),
                backgroundColor: AppTheme.bgColor,
              ),
              Positioned(
                right: 0, bottom: 0,
                child: Container(
                  width: 11, height: 11,
                  decoration: BoxDecoration(
                    color: sc,
                    shape: BoxShape.circle,
                    border: Border.all(color: kMapBg, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: selected ? AppTheme.primaryBlue : Colors.black.withOpacity(0.75),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? AppTheme.primaryBlue : Colors.white.withOpacity(0.18),
            ),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 4)],
          ),
          child: Text(
            trainer.name.split(' ').first,
            style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
