import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../physics/projectile_physics.dart';

/// ドラッグ中に表示する着弾予測の点線ガイド。
/// 実際の飛翔計算(ProjectilePhysics)をそのまま流用して予測するため、
/// 見た目と実際の挙動がズレない。
class AimTrajectoryComponent extends PositionComponent {
  AimTrajectoryComponent({required this.origin}) : super(priority: 5);

  final Vector2 origin;
  Vector2? _dragVector;
  bool visible = false;

  static const int _steps = 24;
  static const double _stepDt = 0.075;

  void updateAim(Vector2 dragVector) {
    _dragVector = dragVector;
    visible = true;
  }

  void hide() {
    visible = false;
  }

  @override
  void render(Canvas canvas) {
    if (!visible || _dragVector == null) return;
    final velocity = ProjectilePhysics.velocityFromDrag(_dragVector!);

    var pos = origin.clone();
    var vel = velocity.clone();
    final paint = Paint()
      ..color = AppColors.red.withOpacity(0.95)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < _steps; i++) {
      pos = ProjectilePhysics.integratePosition(
          position: pos, velocity: vel, dt: _stepDt);
      vel = ProjectilePhysics.integrateVelocity(velocity: vel, dt: _stepDt);
      final radius = (5 - i * 0.12).clamp(1.5, 5).toDouble();
      canvas.drawCircle(Offset(pos.x, pos.y), radius, paint);
    }

    // 引っ張りを示すゴム紐風の線。
    final bandPaint = Paint()
      ..color = AppColors.red.withOpacity(1.0)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(origin.x, origin.y),
      Offset(origin.x - _dragVector!.x, origin.y - _dragVector!.y),
      bandPaint,
    );
  }
}
