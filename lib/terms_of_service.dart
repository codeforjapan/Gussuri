import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gussuri/component/title_box.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsOfService extends StatefulWidget {
  const TermsOfService({Key? key}) : super(key: key);

  @override
  State<TermsOfService> createState() => _TermsOfServiceState();
}

class _TermsOfServiceState extends State<TermsOfService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const TitleBox(text: '利用規約'),
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
                    child: const Text(
                      'gussuriサービス利用規約（以下「本規約」といいます）は、一般社団法人コード・フォー・ジャパン（以下「CfJ」といいます）が提供する睡眠のセルフモニタリングツールであるアプリケーション・ソフトウェア「gussuri」及び「gussuri」上で提供するサービス（以下総称して「本サービス」といいます）の提供条件及びCfJとユーザーとの権利義務関係を定めています。本サービスを利用する際には、ご利用前に本規約をよく読み、本規約に同意の上でご利用ください。',
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
                      '第1条（本サービスの利用）\n '
                      '本規約に同意いただくことで本サービスを無料で利用することができます。本サービスの利用にあたっては利用登録の手続は不要ですが、本サービス上の表示に従って本規約に同意いただく必要があります。必ず本規約を事前にご確認いただき、本サービス上の表示に従って同意した上でご利用ください。',
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
                      '第2条（定義）\n本規約における用語の定義は以下の各号のとおりとします。\n'
                      '(1)「コンテンツ」とは、文章、音声、音楽、画像、動画、ソフトウェア、プログラム、コードその他一切の情報をいいます。\n'
                      '(2)「本コンテンツ」とは、本サービスにおいて提供される又は本サービスを構成するコンテンツをいいます。\n'
                      '(3)「知的財産権」とは、著作権（著作権法第27条及び第28条に定める権利を含む。）、著作隣接権、商標権、意匠権、特許権、実用新案権、不正競争防止法に定める権利、ノウハウその他一切の知的財産権（意匠登録、特許又は実用新案登録を受ける権利、商標出願により生じる権利及び将来の法令改正等により追加される権利を含みます）の総称をいいます。\n'
                      '(4)「ユーザー」とは、本サービスを利用する者（利用しようとする者を含みます）をいいます。\n'
                      '(5)「睡眠記録」とは、本コンテンツのうち、ユーザーが通常の方法によって本サービスを利用することにより本サービス上で視認することができる、ユーザーの睡眠の記録を表示した画面、当該画面の表示内容及び当該画面を本サービス上で指定された方法で出力した当該出力物（電磁的記録での出力が可能な場合は当該電磁的記録に記録されたデータ内容を含みます）をいいます。なお、睡眠記録及びその提供は疾病の治療、予防、診断又は査定その他これらに類する事項を目的とするものではなく、睡眠記録によって何らかの検証結果を提供するものでもありません。\n',
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
                      '第3条（権利帰属）\n '
                      '本サービス又は本コンテンツに関する知的財産権、所有権、肖像権その他一切の権利は全て、CfJ又はCfJに対してその利用、使用、実施等を許諾している正当な権利を有する第三者に帰属します。本規約に明示的な定めがある場合を除き、ユーザーの本規約への同意又は本サービスの利用は、ユーザーに対する、これらの権利の譲渡又は許諾を意味するものではありません。',
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
                      child: RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                              text: '第4条（オープンソースソフトウェア）\n '
                                  '本サービスには、CfJが開発したオープンソースソフトウェアを使用しています。CfJは、別途指定する方法及び条件により当該オープンソースソフトウェアを配布します。オープンソースソフトウェアの配布及び利用条件については、'),
                          TextSpan(
                            text: '＜こちら＞',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launchUrl(Uri.parse(
                                    'https://github.com/codeforjapan/Gussuri'));
                              },
                          ),
                          const TextSpan(
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                              text:
                                  'をご参照ください。本規約は本サービスの利用に関して定めるものであってオープンソフトウェアの配布及び利用条件を定める趣旨の規約ではありませんが、万一当該オープンソースソフトウェアの配布及び利用条件と本規約の内容が矛盾する場合は、当該オープンソフトウェアに関しては、当該オープンソースソフトウェアの配布及び利用条件が優先します。')
                        ]),
                      ))),
              Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 5.h,
                    horizontal: 20.w,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      '第5条（利用許諾）\n '
                      '1. CfJは、ユーザーが以下の全ての事項を遵守することを条件に、ユーザーに対し、睡眠記録について、譲渡不可能で、非独占的な利用権 を付与します。\n'
                      '(1)睡眠記録の内容を改変しないこと\n'
                      '(2)睡眠記録を、自己の睡眠の記録を確認・保管する目的で使用又は利用すること\n'
                      '(3)睡眠記録の使用又は利用にあたって本規約又は法令に違反しないこと\n'
                      '2. CfJは、ユーザーが本サービス上で入力した内容及びそれに基づく睡眠記録を保存することがありますが、法令に定めのある場合を除いて、これらの情報の保存義務を負いません。これらの情報はユーザーが本サービス利用にあたって使用するユーザー自身の端末に記録されます。ユーザーは、睡眠記録を保存したい場合は、自己の責任において睡眠記録を保存する必要があります。\n'
                      '3. CfJは、本サービスを継続して提供する義務を負わず、またその保証もしておらず、任意に本サービスの提供を停止又は終了することがあります。このため、本規約に基づく本サービスの使用権限はCfJが本サービスを提供している間に限り有効です。ユーザーは、本サービス提供終了後は、本サービス提供期間中にユーザーが自ら出力し保管している睡眠記録のみ、第1項に定める範囲で継続して利用することができます。',
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
                      '第６条（使用環境）\n '
                      'ユーザーは、本サービスを利用するために必要な、スマートフォン、コンピューター、ソフトウェアその他の機器、通信回線その他の通信環境等の準備及び維持を、自己の費用と責任において行うものとします。これには、通信料金の負担、ユーザーの使用環境に応じた、コンピューター・ウィルスの感染の防止、不正アクセス及び情報漏洩の防止等のセキュリティ対策の実施も含みます。',
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
                      '第7条（注意事項及び禁止事項）\n '
                      '1. ユーザーは、本サービスを利用する場合は、本サービスの利用にあたり又は本サービスの利用に関連して（睡眠記録の利用を含みます）以下の各号に定める事項に注意して利用する義務を負います。\n'
                      '(1)本サービスの目的は、ユーザー自らが睡眠を記録しその記録を確認・保管する目的であり、疾病の診断、治療、予防等は本サービスの目的ではないこと\n'
                      '(2)ユーザーが入力する睡眠の記録はユーザーの主観によるものであって、睡眠記録は客観性が担保されたものではないこと\n'
                      '(3)ユーザーが入力した情報について、法令の定めがある場合を除いて、CfJは保存義務を負わず、本サービス上のエラーその他障害等が発生した場合に消去される可能性があること\n'
                      '2. ユーザーは、本サービスの利用にあたり又は本サービスの利用に関連して（睡眠記録の利用を含みます）、以下の各号のいずれかに該当する行為をしてはなりません。\n'
                      '(1)本規約において明示的に許諾又は指定された内容又は方法以外の内容又は方法で、本サービス又は本コンテンツを使用又は利用する行為\n'
                      '(2)本サービスのバグ、不具合その他の事情を利用し、又は本規約の規定を逸脱した方法で本サービスを利用する方法により、本サービスのセキュリティを解除する行為又はCfJ、ユーザー若しくは第三者の権利を侵害し若しくは損害を与える行為\n'
                      '(3)本サービスにおいて提供される情報を改ざんする等、本サービス又は本コンテンツの全部又は一部を改変する行為\n'
                      '(4)本規約に明示的に定めがある場合又はCfJの事前の承諾を得た場合を除いて、本サービス又は本コンテンツの全部又は一部を複製、出版、上映、貸与、販売、配布、展示、公衆送信、公に伝達又は送信可能化する行為\n'
                      '(5)法令に違反する行為、犯罪行為、犯罪行為に関連する行為又は公序良俗に反する行為\n'
                      '(6)CfJ、ユーザーその他第三者の知的財産権、肖像権、プライバシー権、名誉その他の権利又は利益を侵害する行為\n'
                      '(7)虚偽の情報、コンピューター・ウィルスその他の有害なコンピューター・プログラムを含む情報、暴力的な、残虐な若しくはわいせつな表現を含む情報、差別を助長する表現を含む情報、反社会的な表現を含む情報、チェーンメール等の第三者への情報の拡散を求める情報、他人に不快感を与える表現を含む情報を、CfJ、ユーザーその他第三者に対し送信する行為\n'
                      '(8)本サービスに関するネットワーク又はシステムに過度の負担をかける行為\n'
                      '(9)CfJが提供するソフトウェアその他のシステムに対する改変、翻案、リバースエンジニアリング、逆コンパイル、逆アセンブルその他の解析行為。但し、本サービスに用いられているオープンソースソフトウェアについては各オープンソフトウェアに付されたライセンス条件がある場合には当該ライセンス条件が適用されます。\n'
                      '(10)本サービスの運営を妨げる行為等、本サービスに支障をきたすおそれのある行為\n'
                      '(11)CfJのネットワーク又はシステム等への不正アクセス行為\n'
                      '(12)第三者になりすます行為\n'
                      '(13)他のユーザーの情報を収集する行為\n'
                      '(14)CfJ、ユーザーその他第三者に対して不利益、損害、不快感を与える行為\n'
                      '(15)前各号の行為に準ずる行為又は前各号の行為を援助若しくは助長する行為\n',
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
                      '第8条（サービスの変更及び終了）\n '
                      '1. CfJは、CfJが必要と判断した場合には、本サービスの一部又は全部を変更又は終了することができるものとします。\n'
                      '2. CfJは、本サービスの変更又は終了によりユーザーに生じた損害に関し、第11条第4項に定める場合を除いて、責任を負いません。\n',
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
                      '第9条（サービスの停止 ）\n '
                      '1. CfJは、次の各号のいずれかに該当する場合には、本サービスの一部又は全部を停止することができます。\n'
                      '(1)本サービスの提供のための装置、システム、通信回線等の点検又は保守作業を行う場合\n'
                      '(2)本サービスの提供のための装置、システム、通信回線等が事故や障害により停止した場合\n'
                      '(3) 火災、停電、通信回線の事故、地震、天災地変、感染症の発生又は感染症に対する対策の実施（政府又は地方自治体等による強制力を伴わない営業自粛要請等への対応実施も含みます）、などの不可抗力により本サービスの運営ができなくなった場合\n'
                      '(4)その他、当社が停止を必要と判断した場合\n'
                      '2. CfJは、当該停止によりユーザーに生じた損害に関し、第11条第4項に定める場合を除いて、責任を負いません。\n',
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
                      '第10条（ユーザーの責任）\n '
                      '1. ユーザーは、自己の責任と負担において、本サービスを利用するものとし、本サービスを利用する行為及びその結果について責任を負うものとします。ユーザーは、本サービスが、疾病の治療、予防、診断又は査定その他これらに類する事項を目的とするものではなく、またユーザーが入力したデータに基づいて何らかの検証結果を提供するものではないことを了承した上で本サービスを利用するものとします。\n'
                      '2. 睡眠記録その他のコンテンツは、あくまでユーザーの睡眠の記録に活用いただくための参考情報であり、ユーザーは、当該情報を前提とした判断又は行動についてユーザー自身の責任と負担において行うものとします。\n'
                      '3. ユーザーが、本規約に違反する行為をした場合、CfJは、当該行為を差し止めることができます。当該本規約違反行為によりCfJ又は第三者に損害が発生した場合、当該ユーザーは、当該損害を賠償する義務を負います。\n'
                      '4. 本サービスの利用に関連して、ユーザーと他のユーザーその他第三者の間で紛争等が生じた場合でも、第11条第4項に定める場合を除いて、ユーザーは自らの費用と責任でその紛争等を処理するものとします。\n',
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
                      '第11条（非保証及び免責）\n'
                      '1. CfJは、本サービス又は本コンテンツについて、セキュリティなどに関する欠陥、エラーやバグ、権利侵害等がないことその他の事実上若しくは法律上の瑕疵がないこと、安全性、信頼性、妥当性、正確性、完全性、有効性又は特定の目的若しくは特定の機器等への適合性を、明示的にも黙示的にも保証しておりません。\n'
                      '2. CfJは、ユーザーが本サービスを利用する際に、コンピュータウイルスなど有害なプログラム等による損害を受けないことを保証せず、また、ユーザーが本サービスを利用する際に使用するいかなる機器、ソフトウェアについても、その動作保証をしておりません。\n'
                      '3. CfJは、本規約の各条項においてCfJが責任を負わない若しくは保証しないとしている事項又はユーザーの責任としている事項について、第11条第4項に定める場合を除いて、責任を負いません。\n'
                      '4. 本規約の他の定めにかかわらず、本サービスに関するユーザーとCfJとの間の契約が消費者契約法に定める消費者契約に該当する場合は、CfJの債務不履行または不法行為によって消費者であるユーザーに生じた損害を賠償する義務を負います。ただし、CfJの故意または重大な過失による債務不履行又は不法行為による損害である場合を除いて、CfJが賠償すべき範囲は、当該損害を予見しまたは予見し得たか否かにかかわらず、ユーザーが現実に被った直接かつ通常の損害に限られるものとし、間接損害、特別損害、逸失利益についてCfJは一切の責任を負わないものとし、その賠償額は当該ユーザーに最初に発生した損害の発生日から起算して１年間に同一ユーザーに発生した累計の損害については合計1,000円を上限とし、当該１年間経過後も同様とします。',
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
                      '第12条（本規約上の地位の譲渡等）\n'
                      '1. ユーザーは、CfJの書面（電磁的記録を含みます）による事前の承諾なく、本規約上の地位又は本規約に基づく権利若しくは義務を、第三者に譲渡し又は担保に供することはできません。\n'
                      '2. CfJは、本サービスにかかる事業の第三者への事業譲渡その他事業が移転する行為（以下「事業譲渡等」といいます）があった場合、ユーザーとCfJとの間の契約（本規約に基づく契約を含む）上の地位及びユーザーが本サービスを利用するにあたってCfJに提供した情報を当該第三者に譲渡することができます。ユーザーは当該譲渡について予め同意します。なお、 事業譲渡等には、CfJから会社に対して事業譲渡等がなされたのちに当該会社についてなされる会社分割、合併等の組織再編に伴って第三者に本サービスにかかる事業が譲渡される場合を含みます。',
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
                      '第13条（分離可能性）\n'
                      '本規約のいずれかの条項又はその一部が、消費者契約法その他の法令等により無効又は執行不能と判断された場合であっても、本規約の残りの規定及び一部が無効又は執行不能と判断された規定の残りの部分は、継続して完全に効力を有するものとします。',
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
                      '第14条（規約の変更）\n'
                      '1. CfJは、必要と判断した場合は、本規約を変更することができます。\n'
                      '2. 本規約を変更する場合、CfJは、本規約を変更する旨及び変更後の本規約の内容並びにその効力発生時期を、本サービス上での公表その他CfJ所定の方法により、周知します。変更後の本規約は、当該効力発生時期から有効となります。',
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
                      '第15条（準拠法及び管轄裁判所）\n'
                      '1. 本規約の解釈に当たっては、日本法を準拠法とします。\n'
                      '2. 本サービスに起因し、又は関連する一切の紛争については、東京地方裁判所を第一審の専属的合意管轄裁判所とします。',
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
                      child: RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                              text: '第16条（お問い合わせ先・連絡通知方法）\n '
                                  '1. 本サービスに関するお問い合わせは'),
                          TextSpan(
                            text: '＜こちら＞',
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
                          const TextSpan(
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                              text: 'までご連絡ください。\n '
                                  '2. CfJからユーザーに対する連絡又は通知は、当社が定める方法により行います。')
                        ]),
                      ))),
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
