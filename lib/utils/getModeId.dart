int getModeId(String mode) {
  switch (mode) {
    case 'kz_timer':
      return 200;
    case 'kz_simple':
      return 201;
    case 'kz_vanilla':
      return 202;
    default:
      throw ('mode id error');
  }
}
