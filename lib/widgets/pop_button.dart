import 'package:flutter/material.dart';

import '../core/constants.dart';

/// 要件の「丸みのあるポップなデザイン」を満たす共通ボタン。
/// 影をずらして配置することで、押した時に沈み込むような操作感を出す。
class PopButton extends StatefulWidget {
  const PopButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.cream,
    this.textColor = AppColors.charcoal,
  });

  final String label;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;

  @override
  State<PopButton> createState() => _PopButtonState();
}

class _PopButtonState extends State<PopButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        transform: Matrix4.translationValues(
          _pressed ? 3 : 0,
          _pressed ? 3 : 0,
          0,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.charcoal, width: 3),
          boxShadow: _pressed
              ? []
              : const [
                  BoxShadow(
                    color: AppColors.charcoal,
                    offset: Offset(4, 4),
                  ),
                ],
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color: widget.textColor,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
