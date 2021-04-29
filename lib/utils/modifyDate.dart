String modifyDate(String originalDate) {
  final year = originalDate.substring(0, 4);
  final month = originalDate.substring(5, 7);
  final day = originalDate.substring(8, 10);
  return ('$year.$month.$day');
}
