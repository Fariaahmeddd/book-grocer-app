import 'package:flutter/material.dart';
import '../../common/color_extenstion.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtFeedback = TextEditingController();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        backgroundColor: TColor.primary,
      ),
      body: Padding(
        padding: EdgeInsets.all(media.width * 0.05),
        child: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(vertical: media.width * 0.05),
            padding: EdgeInsets.symmetric(
              vertical: media.height * 0.03,
              horizontal: media.width * 0.05,
            ),
            decoration: BoxDecoration(
              color: TColor.dColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "We value your feedback! Please provide your name, email, and thoughts below.",
                  style: TextStyle(
                    color: TColor.subTitle,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(txtName, "Your Name", false),
                const SizedBox(height: 15),
                _buildTextField(txtEmail, "Your Email Address", false),
                const SizedBox(height: 15),
                _buildTextArea(txtFeedback, "Your Feedback"),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _isSubmitting
                        ? CircularProgressIndicator(color: TColor.primary)
                        : MiniRoundButton(
                      title: "Submit Feedback",
                      onPressed: () {
                        _submitFeedback(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // TextField with black outline and white background
  Widget _buildTextField(TextEditingController controller, String hintText, bool isMultiline) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black, width: 2), // Black border outline
      ),
      child: TextField(
        controller: controller,
        maxLines: isMultiline ? 5 : 1,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black), // Black hint text
          border: InputBorder.none, // No internal border
          contentPadding: const EdgeInsets.all(12),
        ),
        style: TextStyle(color: Colors.black), // Black text color
      ),
    );
  }

  // Larger TextArea for Feedback with black outline and white background
  Widget _buildTextArea(TextEditingController controller, String hintText) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2), // Black border outline
      ),
      child: TextField(
        controller: controller,
        maxLines: 5,  // Make it large enough for feedback
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black), // Black hint text
          border: InputBorder.none, // No internal border
          contentPadding: const EdgeInsets.all(12),
        ),
        style: TextStyle(color: Colors.black), // Black text color
      ),
    );
  }

  // Feedback submission function with validation
  void _submitFeedback(BuildContext context) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

    if (txtName.text.isEmpty || txtEmail.text.isEmpty || txtFeedback.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
    } else if (!emailRegex.hasMatch(txtEmail.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email address.")),
      );
    } else {
      setState(() {
        _isSubmitting = true; // Set loading state
      });

      // Simulate feedback submission
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isSubmitting = false; // Reset after submission
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Thank you for your feedback!")),
        );

        // Clear fields after submission
        txtName.clear();
        txtEmail.clear();
        txtFeedback.clear();
      });
    }
  }
}

// Custom Button Widget for MiniRoundButton
class MiniRoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const MiniRoundButton({required this.title, required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: TColor.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
