// // upi_payment_page.dart
//
// import 'package:flutter/material.dart';
// import 'package:upi_india/upi_india.dart';
// import 'package:testingproback/phonepe/success_screen.dart';
// import 'package:testingproback/food_items/food_item.dart';
//
// class UpiPaymentPage extends StatefulWidget {
//   final List<FoodItem> cart;
//   final String transactionId;
//
//   UpiPaymentPage({required this.cart, required this.transactionId});
//
//   @override
//   _UpiPaymentPageState createState() => _UpiPaymentPageState();
// }
//
// class _UpiPaymentPageState extends State<UpiPaymentPage> {
//   UpiIndia _upiIndia = UpiIndia();
//   List<UpiApp>? apps;
//   Future<UpiResponse>? _transaction;
//
//   @override
//   void initState() {
//     _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
//       setState(() {
//         apps = value;
//       });
//     }).catchError((e) {
//       apps = [];
//     });
//     super.initState();
//   }
//
//   Future<UpiResponse> initiateTransaction(UpiApp app) async {
//     return _upiIndia.startTransaction(
//       app: app,
//       receiverUpiId: "tunkashwinraj@ybl", // Replace with the recipient's UPI ID
//       receiverName: 'Recipient Name',
//       transactionRefId: widget.transactionId,
//       transactionNote: 'Payment for goods/services',
//       amount: calculateTotalPrice(widget.cart),
//     );
//   }
//
//   double calculateTotalPrice(List<FoodItem> cart) {
//     return cart.fold(0, (sum, item) => sum + item.price);
//   }
//
//   String _upiErrorHandler(dynamic error) {
//     switch (error.runtimeType) {
//       case UpiIndiaAppNotInstalledException:
//         return 'Requested app not installed on device';
//       case UpiIndiaUserCancelledException:
//         return 'You cancelled the transaction';
//       case UpiIndiaNullResponseException:
//         return 'Requested app didn\'t return any response';
//       case UpiIndiaInvalidParametersException:
//         return 'Requested app cannot handle the transaction';
//       default:
//         return 'An Unknown error has occurred';
//     }
//   }
//
//   void _checkTxnStatus(String status) {
//     switch (status) {
//       case UpiPaymentStatus.SUCCESS:
//         print('Transaction Successful');
//         break;
//       case UpiPaymentStatus.SUBMITTED:
//         print('Transaction Submitted');
//         break;
//       case UpiPaymentStatus.FAILURE:
//         print('Transaction Failed');
//         break;
//       default:
//         print('Received an Unknown transaction status');
//     }
//   }
//
//   Widget displayTransactionData(String title, String body) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text("$title: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           Flexible(
//             child: Text(
//               body,
//               style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget displayUpiApps() {
//     if (apps == null) {
//       return Center(child: CircularProgressIndicator());
//     } else if (apps!.isEmpty) {
//       return Center(
//         child: Text(
//           "No apps found to handle transaction.",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//       );
//     } else {
//       return Align(
//         alignment: Alignment.topCenter,
//         child: SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           child: Wrap(
//             children: apps!.map<Widget>((UpiApp app) {
//               return GestureDetector(
//                 onTap: () {
//                   _transaction = initiateTransaction(app);
//                   setState(() {});
//                 },
//                 child: Container(
//                   height: 100,
//                   width: 100,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Image.memory(
//                         app.icon,
//                         height: 60,
//                         width: 60,
//                       ),
//                       Text(app.name),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('UPI Payment'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: displayUpiApps(),
//           ),
//           Expanded(
//             child: FutureBuilder(
//               future: _transaction,
//               builder: (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   if (snapshot.hasError) {
//                     return Center(
//                       child: Text(
//                         _upiErrorHandler(snapshot.error),
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     );
//                   }
//
//                   UpiResponse _upiResponse = snapshot.data!;
//                   String txnId = _upiResponse.transactionId ?? 'N/A';
//                   String resCode = _upiResponse.responseCode ?? 'N/A';
//                   String txnRef = _upiResponse.transactionRefId ?? 'N/A';
//                   String status = _upiResponse.status ?? 'N/A';
//                   String approvalRef = _upiResponse.approvalRefNo ?? 'N/A';
//                   _checkTxnStatus(status);
//
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         displayTransactionData('Transaction Id', txnId),
//                         displayTransactionData('Response Code', resCode),
//                         displayTransactionData('Reference Id', txnRef),
//                         displayTransactionData('Status', status.toUpperCase()),
//                         displayTransactionData('Approval No', approvalRef),
//                       ],
//                     ),
//                   );
//                 } else {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
