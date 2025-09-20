class ApiEndpoints {
  static const String baseUrl = 'https://api.wahnkap.com';
  static const String derivApiUrl = 'https://api.deriv.com';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String profile = '/auth/profile';

  // Payments endpoints
  static const String wallet = '/payments/wallet';
  static const String transactions = '/payments/transactions';
  static const String depositToDeriv = '/payments/deposit-to-deriv';
  static const String withdrawFromDeriv = '/payments/withdraw-from-deriv';

  // Trading bots endpoints
  static const String bots = '/trading-bots';
  static const String marketplace = '/trading-bots/marketplace';

  // Investments endpoints
  static const String investments = '/investments';
  static const String programs = '/investments/programs';
}
