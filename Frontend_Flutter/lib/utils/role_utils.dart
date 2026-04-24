String? normalizeRole(String? role) {
  final normalized = role?.trim().toUpperCase();
  if (normalized == null || normalized.isEmpty) {
    return null;
  }

  if (normalized.startsWith('ROLE_')) {
    return normalized.substring(5);
  }

  return normalized;
}
