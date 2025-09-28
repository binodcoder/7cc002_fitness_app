enum BackendFlavor { fake, rest, firebase }

class BackendConfig {
  // Default to Firebase; override with --dart-define=BACKEND_FLAVOR=fake|rest
  static const String _env =
      String.fromEnvironment('BACKEND_FLAVOR', defaultValue: 'firebase');

  static final BackendFlavor flavor = _parse(_env);

  static bool get isFake => flavor == BackendFlavor.fake;
  static bool get isRest => flavor == BackendFlavor.rest;
  static bool get isFirebase => flavor == BackendFlavor.firebase;

  static BackendFlavor _parse(String value) {
    switch (value.toLowerCase()) {
      case 'rest':
        return BackendFlavor.rest;
      case 'firebase':
        return BackendFlavor.firebase;
      case 'fake':
        return BackendFlavor.fake;
      default:
        // Fallback to Firebase if the env value is unrecognized
        return BackendFlavor.firebase;
    }
  }
}
