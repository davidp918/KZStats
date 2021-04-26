String convertMode(String mode) {
  switch (mode) {
    case 'Kztimer':
      return 'kz_timer';
    case 'SimpleKZ':
      return 'kz_simple';
    case 'Vanila':
      return 'kz_vanilla';
    default:
      throw (UnimplementedError);
      return 'error';
  }
}
