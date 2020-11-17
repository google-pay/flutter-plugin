import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_pay/google_pay.dart';

GooglePay _googlePayClient = GooglePay('default_payment_profile.json');

void main() {
  runApp(GooglePayMaterialApp());
}

class GooglePayMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Pay for Flutter Demo',
      home: GooglePaySampleApp(),
    );
  }
}

class GooglePaySampleApp extends StatefulWidget {
  GooglePaySampleApp({Key key}) : super(key: key);

  @override
  _GooglePaySampleAppState createState() => _GooglePaySampleAppState();
}

class _GooglePaySampleAppState extends State<GooglePaySampleApp> {

  void googlePayButtonPressed() async {
      var result = await _googlePayClient.showPaymentSelector();
      debugPrint(result.toString());
  }

  Widget _getPaymentButtons() {
    return FutureBuilder<bool>(
      future: _googlePayClient.userCanPay(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return SizedBox(
                width: double.infinity,
                child: GooglePayButton(onPressed: googlePayButtonPressed)
            );

          } else if (snapshot.hasError) {
            PlatformException exc = snapshot.error;
            return Text(exc.message);
          }
        }

        return CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Pay T-shirt Shop'),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: Image(
                image: AssetImage('assets/images/ts_10_11019a.jpg'),
                height: 350
            )
          ),
          Text('Amanda\'s Polo Shirt',
            style: TextStyle(
              fontSize: 20,
                color: Color(0xff333333),
                fontWeight:FontWeight.bold
            ),
          ),
          SizedBox(height: 5),
          Text('\$50.20',
            style: TextStyle(color: Color(0xff777777), fontSize: 15),
          ),
          SizedBox(height: 15),
          Text('Description',
            style: TextStyle(
                fontSize: 15,
                color: Color(0xff333333),
                fontWeight:FontWeight.bold
            ),
          ),
          SizedBox(height: 5),
          Text(
            'A versatile full-zip that you can wear all day long and even...',
            style: TextStyle(color: Color(0xff777777), fontSize: 15)
          ),
          SizedBox(height: 15),
          Center(child: _getPaymentButtons())
        ]
      )
    );
  }
}
