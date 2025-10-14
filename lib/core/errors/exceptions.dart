class CacheException implements Exception {}

class ServerException implements Exception {}

class LoginException implements Exception {}

/// Thrown when a user's email domain is not on the allowlist
/// (e.g., only institutional accounts may sign in).
class DomainRestrictedException implements Exception {}
