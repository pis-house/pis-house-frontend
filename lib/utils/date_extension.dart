extension DateTimeFormatting on DateTime {
  String toJapaneseFormat() {
    final local = toLocal();
    final y = local.year;
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    final h = local.hour.toString().padLeft(2, '0');
    final min = local.minute.toString().padLeft(2, '0');

    return "$y年$m月$d日 $h:$min";
  }
}
