class AppConfig {
  static const String appName = 'Wahnkap';
  static const String appVersion = '1.0.0';
  
  // Environment specific configs
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');
  static bool get isDevelopment => !isProduction;
  
  // API Configuration
  static const Duration defaultTimeout = Duration(seconds: 30);
  
  // Cache Configuration
  static const Duration cacheTimeout = Duration(hours: 1);
}