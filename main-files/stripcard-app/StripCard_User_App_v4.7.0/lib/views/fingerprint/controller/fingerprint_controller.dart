// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import "package:TAKARA PAY/base/utils/local_storage.dart";

class FingerprintController extends GetxController {
  final LocalAuthentication auth = LocalAuthentication();
  SupportState supportState = SupportState.unknown;

  @override
  void onInit() async {
    // Only detect support here. The actual biometric prompt is triggered
    // explicitly by the "Sign in with fingerprint" button so the user stays
    // in control — no silent auto-prompt on screen build.
    try {
      final isSupported = await auth.isDeviceSupported();
      supportState =
          isSupported ? SupportState.supported : SupportState.unsupported;
    } catch (_) {
      supportState = SupportState.unsupported;
    }
    super.onInit();
  }
}

enum SupportState {
  unknown,
  supported,
  unsupported,
}

/// Result of a biometric attempt: [success] plus a user-facing [error] reason
/// when it didn't succeed (so the caller can show a snackbar instead of a
/// silent no-op).
class BiometricAuthResult {
  final bool success;
  final String? error;

  const BiometricAuthResult(this.success, [this.error]);
}

class Authentication {
  static final LocalAuthentication _auth = LocalAuthentication();

  /// True when the device can perform biometric (or device-credential) auth.
  static Future<bool> isAvailable() async {
    try {
      final supported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      return supported && canCheck;
    } catch (_) {
      return false;
    }
  }

  /// Runs the OS biometric prompt and maps the common failure codes to clear,
  /// user-facing messages. Never throws.
  static Future<BiometricAuthResult> authenticate({
    String reason = 'Verify your identity to sign in.',
  }) async {
    try {
      final supported = await _auth.isDeviceSupported();
      if (!supported) {
        return const BiometricAuthResult(
          false,
          'This device does not support biometric sign-in.',
        );
      }

      final didAuth = await _auth.authenticate(
        localizedReason: reason,
        // Allow the device PIN/pattern as a fallback so users without an
        // enrolled fingerprint can still confirm. stickyAuth keeps the prompt
        // alive if the app is briefly backgrounded.
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      return BiometricAuthResult(
        didAuth,
        didAuth ? null : 'Authentication cancelled.',
      );
    } on PlatformException catch (e) {
      return BiometricAuthResult(false, _messageForCode(e.code));
    } catch (_) {
      return const BiometricAuthResult(
        false,
        'Biometric sign-in is unavailable right now.',
      );
    }
  }

  static String _messageForCode(String code) {
    switch (code) {
      case auth_error.notAvailable:
      case auth_error.notEnrolled:
        return 'No biometrics or screen lock set up on this device. Add one in '
            'Settings, or sign in with your password.';
      case auth_error.lockedOut:
      case auth_error.permanentlyLockedOut:
        return 'Biometric sign-in is temporarily locked. Use your password.';
      case auth_error.passcodeNotSet:
        return 'Set a device screen lock to use biometric sign-in.';
      default:
        return 'Biometric sign-in is unavailable right now.';
    }
  }

  /// Backward-compatible boolean wrapper kept for existing callers.
  static Future<bool> authenticateWithBiometrics() async {
    final result = await authenticate();
    return result.success;
  }
}

/// Convenience re-export so callers can read the remembered biometric email
/// (e.g. to prefill the field) without importing LocalStorage directly.
String? rememberedBiometricEmail() => LocalStorage.getBiometricEmail();
