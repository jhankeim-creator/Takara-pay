import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_text_styles.dart";

class SCNumpad extends StatelessWidget {
  const SCNumpad({
    super.key,
    required this.onKey,
    this.showDecimal = true,
    this.onBackspace,
  });

  final ValueChanged<String> onKey;
  final bool showDecimal;
  final VoidCallback? onBackspace;

  @override
  Widget build(BuildContext context) {
    final rows = <List<_Key>>[
      const [_Key.digit('1'), _Key.digit('2'), _Key.digit('3')],
      const [_Key.digit('4'), _Key.digit('5'), _Key.digit('6')],
      const [_Key.digit('7'), _Key.digit('8'), _Key.digit('9')],
      [
        showDecimal ? const _Key.digit('.') : const _Key.empty(),
        const _Key.digit('0'),
        const _Key.backspace(),
      ],
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final row in rows)
          Row(
            children: [
              for (final key in row)
                Expanded(
                  child: _NumpadKey(
                    keyData: key,
                    onKey: onKey,
                    onBackspace: onBackspace,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _NumpadKey extends StatelessWidget {
  const _NumpadKey({
    required this.keyData,
    required this.onKey,
    required this.onBackspace,
  });

  final _Key keyData;
  final ValueChanged<String> onKey;
  final VoidCallback? onBackspace;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final text = dark ? AppColorsDark.text : AppColors.text;

    if (keyData.isEmpty) {
      return const SizedBox(height: 64);
    }

    final child = keyData.isBackspace
        ? Icon(Icons.backspace_outlined, color: text)
        : Text(
            keyData.value,
            style: AppTextStyles.h1.copyWith(color: text),
          );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          if (keyData.isBackspace) {
            if (onBackspace != null) {
              onBackspace!();
            } else {
              onKey('BACK');
            }
          } else {
            onKey(keyData.value);
          }
        },
        child: SizedBox(
          height: 64,
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _Key {
  const _Key.digit(this.value)
      : isBackspace = false,
        isEmpty = false;
  const _Key.backspace()
      : value = '',
        isBackspace = true,
        isEmpty = false;
  const _Key.empty()
      : value = '',
        isBackspace = false,
        isEmpty = true;

  final String value;
  final bool isBackspace;
  final bool isEmpty;
}
