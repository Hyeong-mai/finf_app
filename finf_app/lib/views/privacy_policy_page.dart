import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_text_style.dart';
import '../theme/theme.dart';
import '../widgets/common_layout.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('개인정보 처리방침', style: AppTextStyles.h4m('white')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: CommonLayout(
        overlayColor: AppTheme.primaryColor,
        overlayOpacity: 0,
        child: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '개인정보 처리방침',
                    style: AppTextStyles.h3m('white'),
                  ),
                  const SizedBox(height: 20),
                  
                  // 서문
                  _buildSection(
                    title: '',
                    content: '핀프렌즈팀 은(는) 「개인정보 보호법」 등 관련 법령상의 개인정보보호 규정을 준수하며 사용자의 권익 보호에 최선을 다할 것을 약속드립니다. < 핀프렌즈팀 >은(는) 개인정보처리방침을 통해 사용자의 개인정보보호를 위해 어떠한 조치가 취해지고 있는지 투명하게 공개합니다. 개인정보처리방침을 개정하는 경우 웹사이트 또는 앱 공지항을 통하여 공지할 것입니다.\n\n'
                    '- 이 개인정보처리방침은 2021년 8월 17부터 적용됩니다.',
                  ),
                  
                  // 제1조 개인정보의 수집 및 처리 목적
                  _buildSection(
                    title: '제1조 (개인정보의 수집 및 처리 목적)',
                    content: '< 핀프렌즈팀 >은(는) 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며 이용 목적이 변경되는 경우에는 「개인정보 보호법」 제18조에 따라 별도의 동의를 받는 등의 추가적인 조치가 이루어질 예정입니다.\n\n'
                    '1. 홈페이지 회원가입 및 관리\n\n'
                    '회원 가입의사 확인, 회원자격 유지·관리, 서비스 부정이용 방지 목적으로 개인정보를 처리합니다.',
                  ),
                  
                  // 제2조 개인정보의 항목 및 수집 방법
                  _buildSection(
                    title: '제2조 (개인정보의 항목 및 수집 방법)',
                    content: '1. 홈페이지 회원가입 및 관리\n'
                    '    - 필수항목 : 이메일, 이름\n'
                    '    - 수집 방식: 카카오 로그인',
                  ),
                  
                  // 제3조 개인정보의 보유 및 이용기간
                  _buildSection(
                    title: '제3조 (개인정보의 보유 및 이용기간)',
                    content: '< 핀프렌즈팀 >은(는) 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.\n\n'
                    '- 탈퇴 회원의 재가입 지원을 위한 회원 정보: 1개월',
                  ),
                  
                  // 제4조 정보주체와 법정대리인의 권리·의무 및 그 행사방법
                  _buildSection(
                    title: '제4조(정보주체와 법정대리인의 권리·의무 및 그 행사방법)',
                    content: '① 정보주체는 < 핀프렌즈팀 >에 대해 언제든지 개인정보 열람·정정·삭제·처리정지 요구 등의 권리를 행사할 수 있습니다.\n\n'
                    '② 제1항에 따른 권리 행사는 서면 혹은 이메일 등을 통하여 하실 수 있으며 < 핀프렌즈팀 > 은(는) 이에 대해 지체 없이 조치합니다.\n\n'
                    '③ 제1항에 따른 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통할 수 있습니다. 이 경우 "개인정보 처리 방법에 관한 고시(제2023-12호)" 별지 제11호 서식에 따른 위임장 제출이 요구됩니다.\n\n'
                    '④ 개인정보 열람 및 처리정지 요구는 「개인정보 보호법」 제35조 제4항, 제37조 제2항에 의하여 정보주체의 권리가 제한될 수 있습니다.\n\n'
                    '⑤ 개인정보의 정정 및 삭제 요구는 다른 법령에서 그 개인정보가 수집 대상으로 명시되어 있는 경우에는 그 삭제를 요구할 수 없습니다.',
                  ),
                  
                  // 제5조 개인정보의 파기
                  _buildSection(
                    title: '제5조(개인정보의 파기)',
                    content: '① < 핀프렌즈팀 > 은(는) 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다.\n\n'
                    '② 정보주체로부터 동의받은 개인정보 보유기간이 경과하거나 처리 목적이 달성되었음에도 불구하고 다른 법령에 따라 개인정보를 계속 보존하여야 하는 경우에는, 해당 기간이 경과된 후 불가역적인 방식으로 파기합니다.\n\n'
                    '③ 개인정보 파기의 절차 및 방법은 다음과 같습니다.\n\n'
                    '1. 파기절차\n\n'
                    '< 핀프렌즈팀 > 은(는) 파기 사유가 발생한 개인정보를 선정하고, 내부 규정 및 기타 관련 법령에 따라 일정 기간 저장되거나 즉기 파기 됩니다.\n\n'
                    '2. 파기방법\n\n'
                    '전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용합니다. 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기합니다.',
                  ),
                  
                  // 제6조 개인정보의 안전성 확보 조치
                  _buildSection(
                    title: '제6조(개인정보의 안전성 확보 조치)',
                    content: '< 핀프렌즈팀 >은(는) 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다.\n\n'
                    '- 관리적 조치: 개인정보 관리 책임자를 지정하여 이를 처리할 수 있는 인원을 최소한으로 제한합니다.\n'
                    '- 기술적 조치: 개인정보를 처리하는 데이터베이스시스템에 대한 접근권한의 부여, 변경,말소를 통하여 개인정보에 대한 접근통제를 위하여 필요한 조치를 하고 있습니다.',
                  ),
                  
                  // 제7조 개인정보 자동 수집 장치의 설치•운영 및 거부에 관한 사항
                  _buildSection(
                    title: '제7조(개인정보 자동 수집 장치의 설치•운영 및 거부에 관한 사항)',
                    content: '- < 핀프렌즈팀 >은(는) 맞춤형 정보 제공을 위해 수시로 회원의 정보를 저장하고 사용하는 쿠키(cookie) 를 운용하지 않습니다.',
                  ),
                  
                  // 제8조 수집한 개인정보의 국외 이전
                  _buildSection(
                    title: '제8조 (수집한 개인정보의 국외 이전)',
                    content: '< 핀프렌즈팀 >은(는)  서비스 제공을 위해 반드시 필요한 업무 중 일부를 외부 업체에 위탁하고 있습니다. 서비스 제공 계약 이행과 회원의 편의증진 등을 위해 개인정보의 처리 위탁이 필요한 경우, 정보통신망법 제 25조 제 2항에 따라 본 개인정보처리방침의 공개로 위탁동의를 갈음합니다.\n\n'
                    '< 핀프렌즈팀 >은(는) 서비스 제공을 위해 아래와 같은 업무를 외부 업체에 위탁하고 있습니다.\n\n'
                    '- Supabase Inc.\n'
                    '    - 이전 국가: 미국\n'
                    '    - 목적: 서비스 이용을 위한 Cloud DB 서비스',
                  ),
                  
                  // 제9조 개인정보 보호책임자
                  _buildSection(
                    title: '제9조 (개인정보 보호책임자)',
                    content: '① < 핀프렌즈팀 >은(는) 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.\n\n'
                    '- 개인정보 보호책임자\n'
                    '    - 성명: 홍길동\n'
                    '    - 직책: 대표\n'
                    '    - 연락처 : 휴대폰번호 이메일\n\n'
                    '② 정보주체는 핀프렌즈팀의 서비스를 이용하면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 문의할 수 있습니다.',
                  ),
                  
                  // 제10조 권익침해 구제방법
                  _buildSection(
                    title: '제10조(권익침해 구제방법)',
                    content: '정보주체는 개인정보침해로 인한 구제를 받기 위하여 개인정보분쟁조정위원회, 한국인터넷진흥원 개인정보침해신고센터 등에 분쟁해결이나 상담 등을 신청할 수 있습니다. 이 밖에 기타 개인정보침해의 신고, 상담에 대하여는 아래의 기관에 문의하시기 바랍니다.\n\n'
                    '1. 개인정보분쟁조정위원회 : (국번없이) 1833-6972 (www.kopico.go.kr)\n\n'
                    '2. 개인정보침해신고센터 : (국번없이) 118 (privacy.kisa.or.kr)\n\n'
                    '3. 대검찰청 : (국번없이) 1301 (www.spo.go.kr)\n\n'
                    '4. 경찰청 : (국번없이) 182 (cyberbureau.police.go.kr)',
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h4m('white'),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: AppTextStyles.b2r('white'),
          ),
        ],
      ),
    );
  }
}
