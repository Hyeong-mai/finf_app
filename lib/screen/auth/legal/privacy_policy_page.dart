import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('개인정보 처리방침'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '여기에 개인정보 처리방침 내용을 작성하세요.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
