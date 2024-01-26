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
  String environment = "UAT_SIM";
  String appId = "";
  String merchantId = "PGTESTPAYUAT";
  bool enableLogging = true;
  String checksum = "";
  String saltKey = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399";
  String saltIndex = "1";
  String callbackUrl =
      "https://webhook.site/eb14caa8-8165-4d30-9eed-c20c96933406";
  String body = "";
  String apiEndPoint = "/pg/v1/pay";
  Object? result;

  @override
  void initState() {
    super.initState();
    phonepeInit();
    body = getChecksum().toString();
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
            onPressed: ()  {

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
            child: Text("back"),

          ),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SuccessScreen(transactionId: widget.transactionId,
                cart: widget.cart,
                totalAmount: calculateTotalPrice(widget.cart),)));
            },
            child: Text("Redirect to succes page"),

          ),

        ],
      ),
    );
  }

  Future<void> phonepeInit() async {
    // if (appId.isEmpty) {
    //   handleError("Invalid appId!");
    //   return;
    // }

    try {
      final isInitialized = await PhonePePaymentSdk.init(
        environment,
        appId,
        merchantId,
        enableLogging,
      ).then((val) => {
        setState(() {
          result = 'PhonePe SDK Initialized - $val';
        })
      })
          .catchError((error) {
        handleError(error);
        return <dynamic>{};
      });

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
      "merchantUserId": FirebaseAuth.instance.currentUser?.uid ?? "",
      "amount": calculateTotalPrice(widget.cart).toString(),
      "mobileNumber": "9999999999",
      "callbackUrl": callbackUrl,
      "paymentInstrument": {"type": "PAY_PAGE"},
    };

    String base64Body = base64.encode(utf8.encode(json.encode(requestData)));

    checksum = '${sha256.convert(utf8.encode(base64Body+apiEndPoint+saltKey)).toString()}###$saltIndex';

    return base64Body;
  }

  // In the PhonePe gateway page
  void _onBackPressed() {
    // Create a map to represent your result data
    Map<String, dynamic> resultData = {
      "KEY": "VALUE",
    };

    // Pop the route with the result data
    Navigator.pop(context, resultData);
  }
}
