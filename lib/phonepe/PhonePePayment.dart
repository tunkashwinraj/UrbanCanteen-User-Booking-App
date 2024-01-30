import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:testingproback/food_items/food_item.dart';
import 'package:testingproback/phonepe/success_screen.dart';

class PhonePePayment extends StatefulWidget {
  final String transactionId;
  final List<FoodItem> cart;
  final double totalAmount;

  const PhonePePayment({
    Key? key,
    required this.cart,
    required this.transactionId,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<PhonePePayment> createState() => _PhonePePaymentState();
}

class _PhonePePaymentState extends State<PhonePePayment> {
  String environment = "SANDBOX";
  String appId = ""; // Set your PhonePe app ID
  String merchantId = "PGTESTPAYUAT";
  bool enableLogging = true;
  String checksum = "";
  String saltKey = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399";
  String saltIndex = "1";
  String callbackUrl =
      "https://webhook.site/eb14caa8-8165-4d30-9eed-c20c96933406";
  String apiEndPoint = "/pg/v1/pay";
  Object? result;
  late String body; // Declare body at the class level

  @override
  void initState() {
    super.initState();
    getChecksum(); // Call getChecksum in initState to set up the checksum
    phonepeInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phonepe Payment Gateway"),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              startPgTransaction();
            },
            child: Text("Start Transaction"),
          ),
          SizedBox(height: 20),
          Text("Result \n $result"),
          TextButton(
            onPressed: () {
              _onBackPressed();
            },
            child: Text("Back"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SuccessScreen(
                    transactionId: widget.transactionId,
                    cart: widget.cart,
                    totalAmount: calculateTotalPrice(widget.cart),
                  ),
                ),
              );
            },
            child: Text("Redirect to Success Page"),
          ),
        ],
      ),
    );
  }

  Future<void> phonepeInit() async {
    try {
      final isInitialized = await PhonePePaymentSdk.init(
        environment,
        appId,
        merchantId,
        enableLogging,
      );

      setState(() {
        result = 'PhonePe SDK Initialized - $isInitialized';
      });
    } catch (error) {
      handleError(error);
    }
  }

  void startPgTransaction() async {
    try {
      var response = await PhonePePaymentSdk.startTransaction(
        body,
        callbackUrl,
        checksum,
        "",
      );

      setState(() {
        if (response != null) {
          String status = response['status'].toString();
          String error = response['error'].toString();

          if (status == 'SUCCESS') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SuccessScreen(
                  transactionId: widget.transactionId,
                  cart: widget.cart,
                  totalAmount: calculateTotalPrice(widget.cart),
                ),
              ),
            );
            result = "Flow complete - status SUCCESS";
          } else {
            result = "Flow complete - status : $status and error $error";
          }
        } else {
          result = "flow incomplete";
        }
      });
    } catch (error) {
      handleError(error);
    }
  }

  void handleError(error) {
    setState(() {
      result = {"error": error};
    });
  }

  double calculateTotalPrice(List<FoodItem> cart) {
    double total = 0;
    for (var item in cart) {
      total += item.price;
    }
    return total;
  }

  String getChecksum() {
    final requestData = {
      "merchantId": merchantId,
      "merchantTransactionId":
      "transaction_${DateTime.now().millisecondsSinceEpoch}",
      "merchantUserId": FirebaseAuth.instance.currentUser?.uid ?? "MUI100",
      "amount": calculateTotalPrice(widget.cart).toString(),
      "mobileNumber": "7673985665",
      "callbackUrl": callbackUrl,
      "paymentInstrument": {"type": "PAY_PAGE"},
    };

    String base64Body = base64.encode(utf8.encode(json.encode(requestData)));

    // Set the body variable with the calculated base64Body
    body = base64Body;

    checksum = '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltKey)).toString()}###$saltIndex';

    return base64Body;
  }

  void _onBackPressed() {
    Map<String, dynamic> resultData = {
      "KEY": "VALUE",
    };

    Navigator.pop(context, resultData);
  }
}
