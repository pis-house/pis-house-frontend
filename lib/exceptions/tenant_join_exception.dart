class TenantJoinException implements Exception {
  TenantJoinException();

  @override
  String toString() => '既にテナントに参加しています';
}
