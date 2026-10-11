import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:logger/logger.dart';

logger(Type type) => Logger(printer: CustomPrinter(type.toString()));

class CustomPrinter extends LogPrinter {
  final String className;
  CustomPrinter(this.className);
  @override
  List<String> log(LogEvent event) {
    // Every ApiMethod/ApiServices/etc. call logs full request bodies and
    // responses (see ApiMethod) — that includes plaintext passwords, 2FA
    // codes, KYC PII and card data. Never write any of that in a release
    // build; only stdout in debug builds is acceptable exposure.
    if (kReleaseMode) return const [];
    final color = PrettyPrinter.defaultLevelColors[event.level];
    final emoji = PrettyPrinter.defaultLevelEmojis[event.level];
    final message = event.message;

    return [color!('$emoji $className : $message')];
  }
}
