enum Provider { apple_pay, google_pay }

extension Providers on Provider {
  static Provider? fromString(String providerString) => {
        'apple_pay': Provider.apple_pay,
        'google_pay': Provider.google_pay,
      }[providerString];

  static bool isValidProvider(String providerString) =>
      Providers.fromString(providerString) != null;
}

class PaymentConfiguration {
  PaymentConfiguration.fromMap(Map<String, dynamic> configuration)
      : assert(configuration.containsKey('provider')),
        assert(configuration.containsKey('data')),
        assert(Providers.isValidProvider(configuration['provider'])),
        provider = Providers.fromString(configuration['provider'])!,
        configurationData = _populateConfigurationData(
            Providers.fromString(configuration['provider'])!,
            configuration['data']);

  final Provider provider;
  final Map<String, dynamic> configurationData;

  Map<String, dynamic> toMap() => {
        'provider': this.provider,
        'data': configurationData,
      };

  static Map<String, dynamic> _populateConfigurationData(
      Provider provider, Map<String, dynamic> configurationData) {
    switch (provider) {
      case Provider.apple_pay:
        return configurationData;

      case Provider.google_pay:
        final updatedMerchantInfo = {
          ...configurationData['merchantInfo'] ?? {},
          'softwareInfo': {'id': 'pay-flutter-plug-in', 'version': '0.9.9'}
        };

        final updatedPaymentConfiguration = Map<String, dynamic>.unmodifiable(
            {...configurationData, 'merchantInfo': updatedMerchantInfo});

        return updatedPaymentConfiguration;
    }
  }
}
