import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

import 'package:yaml/yaml.dart';

enum PayProvider { apple_pay, google_pay }

class PaymentConfiguration {
  final PayProvider provider;
  final Future<Map<String, dynamic>> parameters;

  PaymentConfiguration.fromMap(Map<String, dynamic> configuration)
      : assert(configuration.containsKey('provider')),
        assert(configuration.containsKey('data')),
        assert(PayProviders.isValidProvider(configuration['provider'])),
        provider = PayProviders.fromString(configuration['provider'])!,
        parameters = _populateConfiguration(
            PayProviders.fromString(configuration['provider'])!,
            configuration['data']);

  static Future<Map<String, dynamic>> _populateConfiguration(
      PayProvider provider, Map<String, dynamic> parameters) async {
    switch (provider) {
      case PayProvider.apple_pay:
        return Future.value(parameters);

      case PayProvider.google_pay:
        final updatedMerchantInfo = {
          ...(parameters['merchantInfo'] ?? {}) as Map,
          'softwareInfo': {
            'id': 'flutter/pay-plugin',
            'version': (await _getPackageConfiguration())['version']
          }
        };

        final updatedPaymentConfiguration = Map<String, Object>.unmodifiable(
            {...parameters, 'merchantInfo': updatedMerchantInfo});

        return updatedPaymentConfiguration;
    }
  }

  static Future<Map> _getPackageConfiguration() async {
    final configurationFile = await rootBundle.loadString('../../pubspec.yaml');
    return Future.value(loadYaml(configurationFile));
  }
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
