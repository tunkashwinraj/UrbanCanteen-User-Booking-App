import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testingproback/bottom_navigation/BottomNavigation.dart';

class FeedbackForm extends StatefulWidget {
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  // TextEditingController for feedback
  final TextEditingController _feedbackController = TextEditingController();

  // List of rating options
  final List<String> _ratings = ['1', '2', '3', '4', '5'];
  String _selectedRating = '1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Form'),
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Feedback TextFormField
            TextFormField(
              controller: _feedbackController,
              decoration: InputDecoration(
                labelText: 'Feedback',
                hintText: 'Enter your feedback here...',
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),

            // Rating DropdownButton
            DropdownButtonFormField(
              value: _selectedRating,
              onChanged: (String? value) {
                setState(() {
                  _selectedRating = value!;
                });
              },
              items: _ratings.map((String rating) {
                return DropdownMenuItem(
                  value: rating,
                  child: Text('Rating: $rating'),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Rating',
              ),
            ),
            SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: () async {
                // Implement your logic to handle the feedback
                String feedbackText = _feedbackController.text;
                String rating = _selectedRating;

                // You can send the feedback to your backend or process it as needed
                print('Feedback: $feedbackText, Rating: $rating');
                 await FirebaseFirestore.instance.collection("feedback").doc(FirebaseAuth.instance.currentUser!.uid)
                 .set({
                  "uid": FirebaseAuth.instance.currentUser!.uid,
                  "feedbackText": feedbackText,
                  "rating":rating
                 });
                 _feedbackController.clear();
                 setState(() {
                   
                 });
                // Optionally, you can navigate back or show a thank you message
                // Navigator.pop(context); // Uncomment if you want to navigate back
              },
              child: Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
