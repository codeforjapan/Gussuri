import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gussuri/about_me.dart';
import 'package:gussuri/component/title_box.dart';
import 'package:gussuri/helper/DeviceData.dart';
import 'package:gussuri/privacy_policy.dart';
import 'package:gussuri/terms_of_service.dart';
import 'gen_l10n/app_localizations.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  late final Future<String> _deviceIdFuture;

  @override
  void initState() {
    super.initState();
    _deviceIdFuture = DeviceData.getDeviceUniqueId();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final List<Map<String, dynamic>> listItems = [
      {"title": localizations.helpHowToUse, "link": const AboutMe()},
      {"title": localizations.helpPrivacyPolicy, "link": const PrivacyPolicy()},
      {"title": localizations.helpTermsOfService, "link": const TermsOfService()},
    ];

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TitleBox(text: localizations.help),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: listItems.length,
                      itemBuilder: (context, index) {
                        return Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Color(0xFFC4C4C4)),
                              ),
                            ),
                            child: ListTile(
                              trailing: const Icon(Icons.arrow_forward_ios),
                              title: Text(listItems[index]['title']),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => listItems[index]['link']));
                              },
                            ));
                      }),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(localizations.googleFond),
                  ),
                  const Spacer(),
                  FutureBuilder<String>(
                    future: _deviceIdFuture,
                    builder: (context, snap) {
                      return SafeArea(
                        top: false,
                        child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 8, 8),
                        child: Row(
                          children: [
                            Text(
                              '${localizations.helpUserId}: ${snap.data ?? '...'}',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                            if (snap.hasData)
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: snap.data!));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(localizations.helpCopied)),
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Icon(Icons.copy, size: 14, color: Colors.grey),
                                ),
                              ),
                          ],
                        ),
                      ));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
        ),
    );
  }
}
