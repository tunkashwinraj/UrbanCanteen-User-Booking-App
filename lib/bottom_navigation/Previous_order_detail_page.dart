// import 'package:flutter/material.dart';
// import 'package:testingproback/QR/QRCodeGenerator.dart';
// import 'package:testingproback/bottom_navigation/previous_Orders_Page.dart';
//
// class OrderDetailsPage extends StatelessWidget {
//   final OrderModel order;
//
//   OrderDetailsPage({required this.order});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildDetailRow('Order ID:', order.transactionId),
//             _buildDetailRow('Total Amount:', '₹${order.totalAmount.toStringAsFixed(2)}'),
//             _buildDetailRow('Address:', order.address),
//             _buildDetailRow('Payment Method:', order.paymentMethod),
//             _buildDetailRow('Status:', order.status),
//             _buildDetailRow('Timestamp:', order.timestamp.toDate().toString()),
//             Divider(),
//             Text(
//               'Items:',
//               style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: order.items.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(order.items[index]['name']),
//                     subtitle: Text('₹${order.items[index]['price'].toStringAsFixed(2)}'),
//                   );
//                 },
//               ),
//             ),
//             // Display the QR code based on the transaction ID
//             _buildDetailRow('QR Code:', QRCodeGenerator.generateQRCode(order.transactionId)),
//
//             _buildDetailRow('Total Amount:', '₹${order.totalAmount.toStringAsFixed(2)}'), // New row for total amount
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, dynamic value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//           ),
//           // Check if the value is a String or Widget
//           if (value is String)
//             Text(
//               value,
//               style: TextStyle(fontSize: 16.0),
//             )
//           else if (value is Widget)
//             value,
//         ],
//       ),
//     );
//   }
// }
