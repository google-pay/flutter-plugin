import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pay/pay.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("correctly creates an instance of the client", (_) async {
    Pay client = Pay(paymentProfileAsset: 'default_payment_profile.json');
    expect(client, isNotNull);
  });
}