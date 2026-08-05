import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';

/// 文化祭風の背景。アセット未配置でもフォールバックのグラデーションを描画する。
class BackgroundComponent extends PositionComponent {
  BackgroundComponent({required Vector2 size}) : super(size: size, priority: -10);

  Sprite? _sprite;
  bool _loadFailed = false;

  @override
  Future<void> onLoad() async {
    try {
      _sprite = await Sprite.load('backimage.png');
    } catch (_) {
      // アセット未配置の場合はグラデーションにフォールバック。
      _loadFailed = true;
    }
  }

  @override
  void render(Canvas canvas) {
    if (_sprite != null) {
      _sprite!.render(canvas, size: size);
      return;
    }
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.yellow, AppColors.yellowDeep],
      ).createShader(rect);
    canvas.drawRect(rect, paint);

    if (_loadFailed) {
      // 文化祭らしい提灯風の丸をいくつか置いて簡易装飾。
      final lanternPaint = Paint()..color = AppColors.red.withOpacity(0.25);
      for (int i = 0; i < 5; i++) {
        final cx = size.x * (0.1 + i * 0.2);
        canvas.drawCircle(Offset(cx, size.y * 0.12), 18, lanternPaint);
      }
    }
  }
}
