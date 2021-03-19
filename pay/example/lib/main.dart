import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

void main() {
  runApp(PayMaterialApp());
}

class PayMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pay for Flutter Demo',
      home: PaySampleApp(),
    );
  }
}

class PaySampleApp extends StatefulWidget {
  PaySampleApp({Key? key}) : super(key: key);

  @override
  _PaySampleAppState createState() => _PaySampleAppState();
}

class _PaySampleAppState extends State<PaySampleApp> {
  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('T-shirt Shop'),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: Image(
              image: AssetImage('assets/images/ts_10_11019a.jpg'),
              height: 350,
            ),
          ),
          Text(
            'Amanda\'s Polo Shirt',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xff333333),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '\$50.20',
            style: TextStyle(
              color: Color(0xff777777),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Description',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xff333333),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'A versatile full-zip that you can wear all day long and even...',
            style: TextStyle(
              color: Color(0xff777777),
              fontSize: 15,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: GooglePayButton(
              paymentConfigurationAsset: 'default_payment_profile_ios.json',
              paymentItems: [
                PaymentItem(
                  amount: '99.99',
                  status: PaymentItemStatus.final_price,
                )
              ],
              color: GooglePayButtonColor.flat,
              type: GooglePayButtonType.pay,
              margin: EdgeInsets.only(top: 15.0),
              onPaymentResult: onGooglePayResult,
              loadingIndicator: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
