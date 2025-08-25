import 'package:finf_app/screen/contents/static_records_page.dart';
import 'package:finf_app/widget/common/app_background.dart';
import 'package:flutter/material.dart';

class SetPage extends StatelessWidget {
  const SetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('설정'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StaticRecordsPage(),
                ),
              );
            },
            child: const Text('정적 기록 페이지로 이동'),
          ),
        ),
      ),
    );
  }
}
