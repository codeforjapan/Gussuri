import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gussuri/component/gradient_box.dart';
import 'package:gussuri/enums/TabItem.dart';
import 'package:gussuri/helper/DateKey.dart';
import 'package:gussuri/helper/DeviceData.dart';
import 'package:gussuri/input.dart';
import 'dart:math' as math;
import 'package:gussuri/utils.dart';
import 'package:provider/provider.dart';
import 'gen_l10n/app_localizations.dart';


class Home extends StatefulWidget {
  final Function? updateIndex;

  const Home({super.key, this.updateIndex});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool? _checkLastNightSleep;
  String _tips = '';

  Future<void> checkLastNightSleep() async {
    try {
      final orderSnap = await FirebaseFirestore.instance
          .collection(await DeviceData.getDeviceUniqueId())
          .doc(DateKey.year())
          .collection(DateKey.month())
          .doc(DateKey.day())
          .get();
      if (!mounted) return;
      setState(() {
        try {
          orderSnap.get('dysfunction');
          _checkLastNightSleep = true;
        } on StateError {
          _checkLastNightSleep = false;
        }
      });
    } catch (_) {
      if (mounted) setState(() => _checkLastNightSleep = false);
    }
  }

  Future<void> getTips() async {
    try {
      var rand = math.Random();
      final tips = await FirebaseFirestore.instance
          .collection('tips')
          .doc(rand.nextInt(2).toString())
          .get();
      _tips = tips.get('content') as String;
    } catch (_) {
      // _tips は challengeFirst ロケール文字列で上書きされるためフォールバック不要
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<CalenderState>(context, listen: false).loadEvents();
    checkLastNightSleep();
    getTips();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (isTablet(context)) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: GradientBox(
          child: Row(
            children: [
              // 左カラム：バク君 + チャレンジTips
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  localizations.challenge,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  AppLocalizations.of(context)?.challengeFirst ?? _tips,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Image.asset('images/baku-kun-1.png'),
                  ],
                ),
              ),
              // 右カラム：ボタン
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _checkLastNightSleep == true
                            ? Text(
                                localizations.recordComplete,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              )
                            : SizedBox(
                                width: double.infinity,
                                height: 72,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffFFD069),
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: _checkLastNightSleep == false
                                      ? () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Input(
                                                DateTime.now(),
                                                nextPage: Home(
                                                  updateIndex: widget.updateIndex,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      : null,
                                  child: Text(localizations.record),
                                ),
                              ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              widget.updateIndex?.call(1, TabItem.calender);
                            },
                            icon: const Icon(Icons.calendar_month),
                            label: Text(localizations.calendar),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: GradientBox(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(30.h),
                    child: _checkLastNightSleep == true ? Text(localizations.recordComplete, style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),) : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(280.w, 80.h),
                          backgroundColor: const Color(0xffFFD069),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          textStyle: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      onPressed: _checkLastNightSleep == false
                          ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Input(DateTime.now(), nextPage: Home(updateIndex: widget.updateIndex))));
                            }
                          : null,
                      child: Text(localizations.record),
                    )
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 0.h),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(280.w, 50.h),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          textStyle: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        widget.updateIndex?.call(1, TabItem.calender);
                      },
                      icon: const Icon(Icons.calendar_month),
                      label: Text(localizations.calendar),
                    )),
              ],
            )),
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 10.h),
              margin: EdgeInsets.only(bottom: 0.h, left: 20.w, right: 20.w),
              width: double.infinity,
              height: 130.h,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Text(localizations.challenge,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ))),
                  Text(AppLocalizations.of(context)?.challengeFirst ??_tips)
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 20.w),
              child: Image.asset('images/baku-kun-1.png'),
            )
          ],
        ),
          ),
        ),
      ),
    );
  }
}
