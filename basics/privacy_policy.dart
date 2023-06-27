import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'This Privacy Policy describes how Finder ("we" or "us") collects, uses, and shares personal information when you use our Finder application (the "App") and our services (the "Services"). By using the App or Services, you agree to the collection and use of your personal information as described in this Privacy Policy.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Information We Collect',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              'We may collect personal information that you provide directly to us when using the App or Services. This may include:',
            ),
            SizedBox(height: 4.0),
            Text(
                '- Contact information such as your name, email address, and phone number.'),
            Text(
                '- Profile information such as your username and profile picture.'),
            Text(
                '- Lost or found item details, including descriptions, images, and location information.'),
            Text(
                '- Lost person details, including descriptions, images, and last-known location information.'),
            SizedBox(height: 16.0),
            Text(
              'How We Use Your Information',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We may use the information we collect for various purposes, including:',
            ),
            SizedBox(height: 4.0),
            Text('- Providing and maintaining the App and Services.'),
            Text(
                '- Facilitating lost and found item or person postings and searches.'),
            Text('- Improving and personalizing the user experience.'),
            Text('- Responding to inquiries, comments, or feedback.'),
            Text(
                '- Sending administrative messages, updates, and service-related notifications.'),
            Text(
                '- Conducting data analysis and research to improve our products and services.'),
            Text(
                '- Enforcing our Terms of Service and protecting against fraud or illegal activities.'),
            Text('- Complying with legal obligations.'),
            SizedBox(height: 16.0),
            Text(
              'Information Sharing and Disclosure',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We may share your personal information in the following circumstances:',
            ),
            SizedBox(height: 4.0),
            Text(
                '- With other users if you post a lost or found item or person listing.'),
            Text(
                '- With our authorized service providers and partners who assist us in operating the App and providing the Services.'),
            Text(
                '- In response to a valid legal request or to comply with applicable laws, regulations, or legal processes.'),
            Text(
                '- To enforce our rights, protect the security and integrity of our App and Services, or investigate and prevent any potential violation of our policies.'),
            SizedBox(height: 16.0),
            Text(
              'Data Security',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We take reasonable measures to protect the security of your personal information. However, please be aware that no method of transmission or storage is completely secure, and we cannot guarantee the absolute security of your information.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Your Choices',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'You may update or delete your personal information by accessing your account settings within the App. You may also opt out of receiving promotional communications from us by following the instructions in those communications. Please note that even if you opt out, we may still send you non-promotional messages regarding your use of the App or Services.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Changes to this Privacy Policy',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We may update this Privacy Policy from time to time. Any changes will be effective when posted on this page. We encourage you to review this Privacy Policy periodically for any updates.',
            ),
          ],
        ),
      ),
    );
  }
}
