import 'package:flutter/material.dart';

/// アプリ全体で使う定数群。
/// マジックナンバーをここに集約し、調整はこのファイルだけで完結させる。
class AppColors {
  AppColors._();

  static const Color yellow = Color(0xFFEFC65B);
  static const Color yellowDeep = Color(0xFFE0AE2E);
  static const Color red = Color(0xFFD14B34);
  static const Color cream = Color(0xFFFFF6E4);
  static const Color charcoal = Color(0xFF3A2A1E);
  static const Color wood = Color(0xFF8B5A2B);
}

class GameConfig {
  GameConfig._();

  /// デザイン基準解像度(横画面)。実機ではこの比率にフィットさせる。
  static const double designWidth = 960;
  static const double designHeight = 540;

  /// 1プレイあたりの投球回数。
  static const int totalThrows = 5;

  /// 物理: 重力加速度(px/s^2)。地球の9.8m/s^2をゲーム画面スケールに変換した値。
  static const double gravity = 980;

  /// ドラッグ距離→初速度への変換係数。値を上げると同じドラッグでも遠くへ飛ぶ。
  static const double powerScale = 4.2;

  /// 初速度の上限(px/s)。強く引きすぎても暴投にならないようクランプする。
  static const double maxLaunchSpeed = 900;

  /// 初速度の下限。これ未満のドラッグは投球とみなさない(誤操作防止)。
  static const double minDragDistance = 12;

  /// スコア配点。
  static const int scoreSuccess = 200;
  static const int scoreBonusNoBounce = 50;
  static const int scoreBonusCenter = 100;
  static const int scoreBonusPerfect = 1000;

  /// カップの中央判定の許容半径比(カップ幅に対する割合)。
  static const double cupCenterToleranceRatio = 0.28;
}
