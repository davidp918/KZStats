String lenCheck(String str, int max) {
  return str.length > max ? str.substring(0, max) + '...' : str;
}
