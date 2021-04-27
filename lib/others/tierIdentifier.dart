String identifyTier(int? tierNum) {
  switch (tierNum) {
    case 1:
      return 'Very Easy';
    case 2:
      return 'Easy';
    case 3:
      return 'Medium';

    case 4:
      return 'Hard';

    case 5:
      return 'Very Hard';

    case 6:
      return 'Extreme';

    case 7:
      return 'Death';

    default:
      return 'unknown';
  }
}
