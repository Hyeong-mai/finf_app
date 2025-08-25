import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('서비스 이용 약관'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '여기에 서비스 이용 약관 내용을 작성하세요.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
