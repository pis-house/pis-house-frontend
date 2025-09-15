class TenantNotJoinException implements Exception {
  TenantNotJoinException();

  @override
  String toString() => 'テナントに参加していません';
}
