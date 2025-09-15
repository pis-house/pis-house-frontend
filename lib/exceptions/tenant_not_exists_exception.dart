class TenantNotExistsException implements Exception {
  TenantNotExistsException();

  @override
  String toString() => "そのテナントは存在しません";
}
