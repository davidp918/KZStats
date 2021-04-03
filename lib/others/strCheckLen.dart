String mapNameLenCheck(String str) {
  return str.length > 20 ? str.substring(0, 20) + '...' : str;
}
