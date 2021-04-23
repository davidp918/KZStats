String convertMode(String mode) {
  switch (mode) {
    case 'Kztimer':
      return 'kz_timer';
    case 'SimpleKZ':
      return 'kz_simple';
    default:
      return 'vanilla';
  }
}
