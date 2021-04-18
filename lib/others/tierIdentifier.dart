String identifyTier(int tierNum) {
  switch (tierNum) {
    case 1:
      return 'Very Easy';
      break;
    case 2:
      return 'Easy';
      break;
    case 3:
      return 'Medium';
      break;
    case 4:
      return 'Hard';
      break;
    case 5:
      return 'Very Hard';
      break;
    case 6:
      return 'Extreme';
      break;
    case 7:
      return 'Death';
      break;
    default:
      return 'unknown';
  }
}
