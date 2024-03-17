import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gussuri/component/title_box.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const TitleBox(text: 'プライバシーポリシー'),
        Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5.h,
                        horizontal: 20.w,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(children: [
                            const TextSpan(
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                                text: 'gussuriプライバシーポリシー（以下「本ポリシー」といいます）は、一般社団法人コード・フォー・ジャパン（以下「CfJ」といいます）が提供する睡眠のセルフモニタリングツールであるアプリケーション・ソフトウェア「gussuri」及び「gussuri」上で提供するサービス（以下総称して「本サービス」といいます）のユーザーの情報（以下「ユーザー情報」といいます）の取扱いについて、次のとおり定めます。利用者は、本サービスの初回起動時に本ポリシーに同意して、本サービスを利用するものとします。利用者は、本サービスの設定画面からいつでも本ポリシーを確認することができます。本サービスの用語の定義は、特段の定めのない限り「gussuriサービス利用規約」及び個人情報の保護に関する法律（平成15年法律第57号。以下「個人情報保護法」といいます）によるものとします。\n'
                                    'なお、本ポリシーに定めのない事項については'),
                            TextSpan(
                              text: 'Code for Japanプライバシーポリシー',
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchUrl(Uri.parse(
                                      'https://www.code4japan.org/privacy-policy'));
                                },
                            ),
                            const TextSpan(
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                                text:
                                'が適用され、Code for Japanプライバシーポリシーと本ポリシーに相違がある場合は、本ポリシーが優先して適用されます。')
                          ]),
                        )
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 1.h,
                        horizontal: 20.w,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          '第1条（取得情報及び利用目的）\n '
                              'CfJは、本サービスにおいて、以下に定めるユーザー情報を取得する場合があります。取得したユーザー情報は以下に定める利用目的のために利用いたします。なお、情報をご提供いただけない場合、本サービス及び本サービスの全部あるいは一部をご利用いただけないことがあります。\n'
                              '(1)ユーザーから直接取得する情報 \n'
                              '【取得情報】\n'
                              '・年齢及び性別 \n'
                              '【利用目的】\n'
                              '・ユーザーの閲覧履歴等の情報を分析して本サービスの利用傾向等についての調査・分析を実施するため',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 1.h,
                        horizontal: 20.w,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          '【取得情報】\n'
                              '・起床時間（目覚めた時間、布団から出た時間等）、就寝時間（布団に入った時間、眠りに入った時間等）及びその日付 \n'
                              '【利用目的】\n'
                              '・ユーザーに本サービスを提供するため\n'
                              '・睡眠に関する調査・研究を実施するため及び当該目的のために個人を特定できない形で第三者に提供するため',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 1.h,
                        horizontal: 20.w,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          '【取得情報】\n'
                              '・お問い合わせ内容、お問い合わせの際のメールアドレス、ユーザーの氏名 \n'
                              '【利用目的】\n'
                              '・ユーザーからのお問い合わせに対応するため',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 1.h,
                        horizontal: 20.w,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          '(2)自動的に取得する情報\n'
                              '【取得情報】\n'
                              '・端末識別子\n'
                              '・端末及び接続環境に関する情報（端末機種名、OS名・バージョン、通信キャリア、端末の設定、IPアドレス等）\n'
                              '・位置情報\n'
                              '・本サービス上での行動に関する情報（アクセス、入力の履歴等）\n'
                              '【利用目的】\n'
                              '・ユーザーの閲覧履歴等の情報を分析して本サービスの利用傾向等についての調査・分析を実施し、ユーザーの利便性を向上させ、本サービスを改善するため',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 1.h,
                        horizontal: 20.w,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          '第2条（第三者提供）\n '
                              'CfJは、ユーザー情報のうち個人データに該当しない情報を、調査・研究目的で、学術研究機関等の第三者に提供することがあります。',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 1.h,
                        horizontal: 20.w,
                      ),
                      child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: TextSpan(children: [
                              const TextSpan(
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                  text: '第3条（お問い合わせ窓口）\n '
                                      'ユーザー情報の取扱いに関するお問い合わせは、下記の窓口までお願いいたします。'),
                              TextSpan(
                                text: '＜フォーム＞',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrl(Uri.parse(
                                        'https://forms.gle/mtgsLfDcLjwnXeQM9'));
                                  },
                              ),
                            ]),
                          ))),
                  Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 1.h,
                        horizontal: 20.w,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          '第4条（本ポリシーの変更）\n '
                              'CfJは、本ポリシーを、随時変更する場合があり、変更した場合には、本サービス上に掲載します。お客様は、本サービス上に掲載される最新の本ポリシーの内容を十分にご確認ください。',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5.h,
                        horizontal: 20.w,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          '一般社団法人コード・フォー・ジャパン\n'
                              '制定　2023年9月18日',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      )),
                ],
              ),
            ))
      ],
    ));
  }
}
