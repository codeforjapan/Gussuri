import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gussuri/awake.dart';
import 'package:gussuri/awakening.dart';
import 'package:gussuri/component/DropBoxWidget.dart';

import 'helper/DateKey.dart';
import 'helper/DeviceData.dart';
import 'home.dart';

class Sleepy extends StatelessWidget {
  const Sleepy({required this.title, required this.text, Key? key}) : super(key: key);

  final String title, text;

  @override
  Widget build(BuildContext context) {
    final dropBoxWidgetKey = GlobalObjectKey<DropBoxWidgetState>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFBDBDBD),
      appBar: AppBar(
        centerTitle: false,
        title: Padding(
            padding: EdgeInsets.only(left: 18.0.w),
            child: Text(
              title,
              style: const TextStyle(color: Colors.black),
            )),
        actions: [
          ElevatedButton(
            child: const Text('ホーム'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Home()));
            },
          )
        ],
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF424242),
        child: SizedBox(
          width: double.infinity,
          height: 65.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 28.0.w),
                  child: ElevatedButton(
                    child: const Text('前へ'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(70.w, 45.h),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Awake(
                                  title: '目が覚めた時間',
                                  text: '布団から出るまでにかかった時間')));
                    },
                  )),
              Padding(
                padding: EdgeInsets.only(right: 28.0.w),
                child: ElevatedButton(
                    child: const Text('次へ'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(70.w, 45.h),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () async {
                      FirebaseFirestore.instance
                          .collection(
                          await DeviceData.getDeviceUniqueId()) // コレクションID
                          .doc(DateKey.year())
                          .collection(DateKey.month())
                          .doc(DateKey.day())
                          .set({
                        'SOL':
                        dropBoxWidgetKey.currentState?.selectItem == ''
                            ? null
                            : dropBoxWidgetKey.currentState?.selectItem,
                      }, SetOptions(merge: true));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Awaking(
                                  title: '中途覚醒', text: '途中で目が覚めた回数')));
                    }),
              )
            ],
          ),
        )
      ),
      body: Column(
        children: [
          Expanded(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50.h),
                child: Text(text),
              ),
              Container(
                  padding: EdgeInsets.only(top: 30.h),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: const Text('00~'),
                      ),
                      ElevatedButton(
                        child: const Text('15分'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(260.w, 60.h),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () async {
                          FirebaseFirestore.instance
                              .collection(await DeviceData
                              .getDeviceUniqueId()) // コレクションID
                              .doc(DateKey.year())
                              .collection(DateKey.month())
                              .doc(DateKey.day())
                              .set({
                          'SOL': '0~15',
                          }, SetOptions(merge: true));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Awaking(
                                      title: '中途覚醒', text: '途中で目が覚めた回数')));
                        },
                      )
                    ],
                  )),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 50.h),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: const Text('16~'),
                        ),
                        ElevatedButton(
                          child: const Text('30分'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(260.w, 60.h),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () async {
                            FirebaseFirestore.instance
                                .collection(await DeviceData
                                .getDeviceUniqueId()) // コレクションID
                                .doc(DateKey.year())
                                .collection(DateKey.month())
                                .doc(DateKey.day())
                                .set({
                            'SOL': '16~30',
                            }, SetOptions(merge: true));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Awaking(
                                        title: '中途覚醒', text: '途中で目が覚めた回数')));
                          },
                        )
                      ])),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 50.h),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: const Text('31~'),
                        ),
                        ElevatedButton(
                          child: const Text('45分'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(260.w, 60.h),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () async {
                            FirebaseFirestore.instance
                                .collection(await DeviceData
                                .getDeviceUniqueId()) // コレクションID
                                .doc(DateKey.year())
                                .collection(DateKey.month())
                                .doc(DateKey.day())
                                .set({
                            'SOL': '31~45',
                            }, SetOptions(merge: true));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Awaking(
                                        title: '中途覚醒', text: '途中で目が覚めた回数')));
                          },
                        )
                      ])),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 30.h),
                  child: SizedBox(
                      width: 290.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: const Text('46分以上')),
                          DropBoxWidget(key: dropBoxWidgetKey, value: '', onChanged: (value) => {},)
                        ],
                      ))),
            ],
          )),
        ],
      ),
    );
  }
}
