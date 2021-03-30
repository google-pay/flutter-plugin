enum PayProvider { apple_pay, google_pay }

class PaymentConfiguration {
  final PayProvider provider;
  final Map<String, dynamic> parameters;

  PaymentConfiguration.fromMap(Map<String, dynamic> configuration)
      : assert(configuration.containsKey('provider')),
        assert(configuration.containsKey('data')),
        assert(PayProviders.isValidProvider(configuration['provider'])),
        provider = PayProviders.fromString(configuration['provider'])!,
        parameters = _populateConfiguration(
            PayProviders.fromString(configuration['provider'])!,
            configuration['data']);

  static Map<String, dynamic> _populateConfiguration(
      PayProvider provider, Map<String, dynamic> parameters) {
    switch (provider) {
      case PayProvider.apple_pay:
        return parameters;

      case PayProvider.google_pay:
        final updatedMerchantInfo = {
          ...parameters['merchantInfo'] ?? {},
          'softwareInfo': {'id': 'pay-flutter-plug-in', 'version': '0.9.9'}
        };

        final updatedPaymentConfiguration = Map<String, dynamic>.unmodifiable(
            {...parameters, 'merchantInfo': updatedMerchantInfo});

        return updatedPaymentConfiguration;
    }
  }

  Map<String, dynamic> toMap() => {
        'provider': provider,
        'data': parameters,
      };
}

extension PayProviders on PayProvider {
  static PayProvider? fromString(String providerString) => {
        'apple_pay': PayProvider.apple_pay,
        'google_pay': PayProvider.google_pay,
      }[providerString];

  static bool isValidProvider(String providerString) =>
      fromString(providerString) != null;

  String? toSimpleString() => {
        PayProvider.apple_pay: 'apple_pay',
        PayProvider.google_pay: 'google_pay',
      }[this];
}
