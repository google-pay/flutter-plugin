class PaymentConfiguration {
  PaymentConfiguration.fromMap(Map<String, dynamic> configuration)
      : this.provider = configuration['provider'],
        this.configurationData = configuration['data'];

  final String provider;
  final Map<String, dynamic> configurationData;

  Map<String, dynamic> toMap() => {
        'provider': this.provider,
        'data': configurationData,
      };
}
