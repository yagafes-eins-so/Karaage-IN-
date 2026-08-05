import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';

/// 成功時に呼び出す紙吹雪パーティクル。呼び出し側は
/// `ConfettiComponent.spawn(game, at: position)` を使うだけでよい。
class ConfettiComponent {
  ConfettiComponent._();

  static const _colors = [
    AppColors.red,
    AppColors.yellow,
    AppColors.cream,
  ];

  static void spawn(Component parent, {required Vector2 at}) {
    final rnd = Random();
    final particle = Particle.generate(
      count: 24,
      lifespan: 0.9,
      generator: (i) {
        final angle = rnd.nextDouble() * pi * 2;
        final speed = 80 + rnd.nextDouble() * 140;
        final color = _colors[rnd.nextInt(_colors.length)];
        return AcceleratedParticle(
          position: at.clone(),
          speed: Vector2(cos(angle), sin(angle)) * speed,
          acceleration: Vector2(0, 260),
          child: RotatingParticle(
            to: rnd.nextDouble() * pi * 2,
            child: RectangleParticle(
              size: Vector2(6, 6),
              paint: Paint()..color = color,
            ),
          ),
        );
      },
    );
    parent.add(ParticleSystemComponent(particle: particle));
  }
}

/// 回転しながら消えていく矩形の紙吹雪片。
class RectangleParticle extends Particle {
  RectangleParticle({required this.size, required this.paint});
  final Vector2 size;
  final Paint paint;

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: size.x, height: size.y),
      paint,
    );
  }
}
