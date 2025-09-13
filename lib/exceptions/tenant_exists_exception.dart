class TenantExistsException implements Exception {
  TenantExistsException();

  @override
  String toString() => "そのテナントは既に存在しています";
}
