String buildStorageKeyString(dynamic identifier, dynamic name) {
  // ignore: prefer_interpolation_to_compose_strings
  return identifier.toString() + "@" + name.toString();
}