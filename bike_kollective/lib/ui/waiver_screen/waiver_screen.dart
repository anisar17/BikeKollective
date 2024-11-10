import 'package:bike_kollective/ui/waiver_screen/logo.dart';
import 'package:flutter/material.dart';

class WaiverScreen extends StatefulWidget {
  @override
  _WaiverScreenState createState() => _WaiverScreenState();
}

class _WaiverScreenState extends State<WaiverScreen> {
  bool isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Logo(),
            const SizedBox(height: 24),
            const Text(
              'Waiver of Liability Agreement',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "1. Acceptance of Risk",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "I understand that riding a bicycle involves inherent risks, including but not limited to the risk of personal injury, property damage, or death. I acknowledge that I am voluntarily using the bikes provided through the Bike Kollective bike-sharing service at my own risk.",
                      style: TextStyle(height: 1.5),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "2. Responsibility for Bike Use",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "I agree to use the bicycles responsibly and adhere to all local traffic laws and safety regulations. I will wear appropriate safety gear, including a helmet, while riding, and I understand that the Bike Kollective does not provide helmets or other protective equipment.",
                      style: TextStyle(height: 1.5),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "3. Release of Liability",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "In consideration for being allowed to use the Bike Kollective bike-sharing service, I hereby release, waive, and discharge the Bike Kollective, its owners, employees, agents, and affiliates from any and all claims, actions, or damages arising out of or related to my use of the bicycles, including but not limited to any claims for personal injury, property damage, or wrongful death.",
                      style: TextStyle(height: 1.5),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "4. Assumption of Responsibility for Damage",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "I agree to be financially responsible for any damage, theft, or loss of the bicycle while it is checked out to me. I understand that failure to return the bike within 24 hours will result in penalties, including but not limited to the permanent suspension of my account.",
                      style: TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: isAgreed,
                      onChanged: (bool? value) {
                        setState(() {
                          isAgreed = value ?? false;
                        });
                      },
                    ),
                    const Text(
                      "I Agree",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: isAgreed
                  ? () {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Continue",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
