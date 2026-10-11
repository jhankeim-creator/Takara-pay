/// StripCard 4-base spacing scale — exact values from v0 prototype tokens.jsx.
/// Index naming matches the JS tokens.space[N] indices for direct portability.
class AppSpacing {
  AppSpacing._();

  // Numerical scale (matches tokens.space in the prototype)
  static const double s0  = 0;
  static const double s1  = 4;
  static const double s2  = 8;
  static const double s3  = 12;
  static const double s4  = 16;
  static const double s5  = 20;
  static const double s6  = 24;
  static const double s7  = 32;
  static const double s8  = 40;
  static const double s9  = 56;
  static const double s10 = 72;

  // Friendly aliases (use these in screen code for readability)
  static const double xs   = s1;   // 4
  static const double sm   = s2;   // 8
  static const double md   = s3;   // 12
  static const double lg   = s4;   // 16
  static const double xl   = s5;   // 20
  static const double xxl  = s6;   // 24
  static const double xxxl = s7;   // 32
}
