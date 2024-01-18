import 'dart:convert';


import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:testingproback/food_items/food_item.dart';
import 'package:testingproback/phonepe/success_screen.dart';

class PhonePePayment extends StatefulWidget {
  final List<FoodItem> cart;

  const PhonePePayment({super.key, required this.cart});

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

      String callbackurl = "https://webhook.site/0095e8a0-2fbb-47d5-b69e-b5b66336a12b";

      String body = "";
      String apiEndPoint = "/pg/v1/pay";

      Object? result;


      getChecksum(){
        final requestData = {
          "merchantId": merchantId,
          "merchantTransactionId": "transaction_${DateTime.now().millisecondsSinceEpoch}",
          "merchantUserId": FirebaseAuth.instance.currentUser?.uid ?? "", // Add user ID here
          "amount": calculateTotalPrice(widget.cart).toString(), // Add the actual amount
          "mobileNumber": "9999999999",
          "callbackUrl": callbackurl,
          "paymentInstrument": {"type": "PAY_PAGE" },
        };



        String base64Body = base64.encode(utf8.encode(json.encode(requestData)));


        checksum = '${sha256.convert(utf8.encode(base64Body+apiEndPoint+saltKey)).toString()}###$saltIndex';

        return base64Body;

      }

  @override
  void initState() {
    // TODO: implement initState
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
              onPressed: (){
                startPgTransaction();
          },
              child: Text("Start Transaction")),
          
          SizedBox(height: 20,),
        
        Text("Result \n $result"),
        ],
      ),
    );
  }

  void phonepeInit() {

    PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
        .then((val) => {
      setState(() {
        result = 'PhonePe SDK Initialized - $val';
      })
    })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });


  }

  void startPgTransaction() async {

    try {
      var response = PhonePePaymentSdk.startPGTransaction(
          body, callbackurl, checksum, {}, apiEndPoint, "");
      response
          .then((val) => {
        setState(() {

          if(val != null){

            String status = val['status'].toString();
            String error = val['error'].toString();

            if(status == 'SUCCESS'){
              /// Handing after success transaction
              ///
              //Navigator.push(context, MaterialPageRoute(builder: (context)=> SuccessScreen(transactionId: '',) ));
              result = "Flow complete - status SUCCESS";


            }else{
              result = "Flow complete - status : $status and error $error";
            }

          }else{
            result = "flow incomplete";
          }


        })
      })
          .catchError((error) {
        handleError(error);
        return <dynamic>{};
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
}

double calculateTotalPrice(List<FoodItem> cart) {
  double total = 0;
  for (var item in cart) {
    total += item.price;
  }
  return total;
}

