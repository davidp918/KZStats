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

String stateConvert(String mode) {
  switch (mode) {
    case 'Kztimer':
      return 'kz_timer';
    case 'SimpleKZ':
      return 'kz_simple';
    case 'Vanilla':
      return 'kz_vanilla';
    case 'Pro':
      return 'false';
    case 'Nub':
      return 'true';
    default:
      return 'error';
  }
}
