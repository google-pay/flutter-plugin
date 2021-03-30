enum Provider { apple_pay, google_pay }

extension Providers on Provider {
  static Provider? fromString(String providerString) => {
        'apple_pay': Provider.apple_pay,
        'google_pay': Provider.google_pay,
      }[providerString];

  static bool isValidProvider(String providerString) =>
      Providers.fromString(providerString) != null;

  String? toSimpleString() => {
        Provider.apple_pay: 'apple_pay',
        Provider.google_pay: 'google_pay',
      }[this];
}

class PaymentConfiguration {
  PaymentConfiguration.fromMap(Map<String, dynamic> configuration)
      : assert(configuration.containsKey('provider')),
        assert(configuration.containsKey('data')),
        assert(Providers.isValidProvider(configuration['provider'])),
        provider = Providers.fromString(configuration['provider'])!,
        parameters = _populateConfiguration(
            Providers.fromString(configuration['provider'])!,
            configuration['data']);

  final Provider provider;
  final Map<String, dynamic> parameters;

  Map<String, dynamic> toMap() => {
        'provider': provider,
        'data': parameters,
      };

  static Map<String, dynamic> _populateConfiguration(
      Provider provider, Map<String, dynamic> parameters) {
    switch (provider) {
      case Provider.apple_pay:
        return parameters;

      case Provider.google_pay:
        final updatedMerchantInfo = {
          ...parameters['merchantInfo'] ?? {},
          'softwareInfo': {'id': 'pay-flutter-plug-in', 'version': '0.9.9'}
        };

        final updatedPaymentConfiguration = Map<String, dynamic>.unmodifiable(
            {...parameters, 'merchantInfo': updatedMerchantInfo});

        return updatedPaymentConfiguration;
    }
  }
}
