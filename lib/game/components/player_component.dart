import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';

enum PlayerState { idle, aiming, throwing, happy, sad }

/// マスコット「ヤガあげクン」。状態に応じてアニメーションを切り替えるだけの、
/// 見た目専任コンポーネント(ロジックは持たない = View的責務のみ)。
class PlayerComponent extends PositionComponent with HasGameReference {
  PlayerComponent({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.center);

  PlayerState _state = PlayerState.idle;
  final Map<PlayerState, SpriteAnimation> _animations = {};
  SpriteAnimationComponent? _animComponent;
  bool _assetsLoaded = false;

  static const Map<PlayerState, String> _assetPrefix = {
    PlayerState.idle: 'yaga_kun_idle',
    PlayerState.aiming: 'yaga_kun_aim',
    PlayerState.throwing: 'yaga_kun_throw',
    PlayerState.happy: 'yaga_kun_happy',
    PlayerState.sad: 'yaga_kun_sad',
  };

  @override
  Future<void> onLoad() async {
    try {
      for (final entry in _assetPrefix.entries) {
        // 各状態につき 1〜4枚の連番PNG (例: yaga_kun_idle_0.png ...) を想定。
        // 実アセット投入前は失敗して例外→フォールバック描画に切り替わる。
        final sprite = await Sprite.load('${entry.value}_0.png');
        _animations[entry.key] = SpriteAnimation.spriteList(
          [sprite],
          stepTime: 0.15,
        );
      }
      _assetsLoaded = true;
      _animComponent = SpriteAnimationComponent(
        animation: _animations[PlayerState.idle],
        size: size,
        anchor: Anchor.center,
      );
      _animComponent!.paint.colorFilter = ColorFilter.matrix(_saturationMatrix(1.25));
      add(_animComponent!);
    } catch (_) {
      _assetsLoaded = false;
    }
  }

  void setState(PlayerState newState) {
    _state = newState;
    if (_assetsLoaded && _animations.containsKey(newState)) {
      _animComponent?.animation = _animations[newState];
      _animComponent?.paint.colorFilter = ColorFilter.matrix(_saturationMatrix(1.25));
    }
  }

  static List<double> _saturationMatrix(double saturation) {
    final m = <double>[
      0.213 + 0.787 * saturation,
      0.715 - 0.715 * saturation,
      0.072 - 0.072 * saturation,
      0,
      0,
      0.213 - 0.213 * saturation,
      0.715 + 0.285 * saturation,
      0.072 - 0.072 * saturation,
      0,
      0,
      0.213 - 0.213 * saturation,
      0.715 - 0.715 * saturation,
      0.072 + 0.928 * saturation,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
    return m;
  }

  PlayerState get state => _state;

  @override
  void render(Canvas canvas) {
    if (_assetsLoaded) return; // アセットがあれば SpriteAnimationComponent が描画する
    _renderFallback(canvas);
  }

  /// アセット未配置時のプレースホルダー(丸ボディ+状態別の簡易表情)。
  void _renderFallback(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    final radius = size.x / 2;

    final bodyColor = switch (_state) {
      PlayerState.sad => AppColors.cream.withOpacity(0.7),
      _ => AppColors.cream,
    };
    canvas.drawCircle(center, radius, Paint()..color = bodyColor);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.charcoal
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // とさか(赤いギザギザ)
    final combPaint = Paint()..color = AppColors.red;
    final combPath = Path()
      ..moveTo(center.dx - radius * 0.3, center.dy - radius * 0.9)
      ..lineTo(center.dx - radius * 0.1, center.dy - radius * 1.4)
      ..lineTo(center.dx + radius * 0.1, center.dy - radius * 0.9)
      ..lineTo(center.dx + radius * 0.25, center.dy - radius * 1.3)
      ..lineTo(center.dx + radius * 0.4, center.dy - radius * 0.85)
      ..close();
    canvas.drawPath(combPath, combPaint);

    // 目(状態で変化)
    final eyePaint = Paint()..color = AppColors.charcoal;
    switch (_state) {
      case PlayerState.aiming:
        canvas.drawLine(
          Offset(center.dx - radius * 0.25, center.dy - radius * 0.1),
          Offset(center.dx - radius * 0.05, center.dy - radius * 0.1),
          eyePaint..strokeWidth = 3,
        );
        break;
      case PlayerState.sad:
        canvas.drawArc(
          Rect.fromCircle(
              center: Offset(center.dx - radius * 0.15, center.dy),
              radius: radius * 0.12),
          3.4,
          2.8,
          false,
          eyePaint
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
        break;
      default:
        canvas.drawCircle(
          Offset(center.dx - radius * 0.15, center.dy - radius * 0.05),
          radius * 0.08,
          eyePaint,
        );
    }
  }
}
