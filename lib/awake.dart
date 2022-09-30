import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gussuri/component/DropBoxWidget.dart';
import './sleepy.dart';
import 'helper/DateKey.dart';
import 'helper/DeviceData.dart';
import 'home.dart';

class Awake extends StatelessWidget {
  const Awake({required this.title, required this.text, Key? key})
      : super(key: key);

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
            style: ElevatedButton.styleFrom(primary: Colors.black),
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
                      primary: Colors.white,
                      onPrimary: Colors.black,
                    ),
                    onPressed: null,
                  )),
              Padding(
                padding: EdgeInsets.only(right: 28.0.w),
                child: ElevatedButton(
                  child: const Text('次へ'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(70.w, 45.h),
                    primary: Colors.white,
                    onPrimary: Colors.black,
                  ),
                  onPressed: () async {
                    FirebaseFirestore.instance
                        .collection(
                            await DeviceData.getDeviceUniqueId()) // コレクションID
                        .doc(DateKey.dateFormat())
                        .set({
                      'TASAFA': dropBoxWidgetKey.currentState?.selectItem == ''
                          ? null
                          : dropBoxWidgetKey.currentState?.selectItem,
                    }, SetOptions(merge: true));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Sleepy(
                                title: '寝付くまでにかかった時間', text: '寝付くまでにかかった時間')));
                  },
                ),
              )
            ],
          ),
        ),
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
                          primary: Colors.white,
                          onPrimary: Colors.black,
                        ),
                        onPressed: () async {
                          FirebaseFirestore.instance
                              .collection(await DeviceData
                                  .getDeviceUniqueId()) // コレクションID
                              .doc(DateKey.dateFormat())
                              .set({
                            'TASAFA': '0~15',
                          }, SetOptions(merge: true));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Sleepy(
                                      title: '寝付くまでにかかった時間',
                                      text: '寝付くまでにかかった時間')));
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
                            primary: Colors.white,
                            onPrimary: Colors.black,
                          ),
                          onPressed: () async {
                            FirebaseFirestore.instance
                                .collection(await DeviceData
                                    .getDeviceUniqueId()) // コレクションID
                                .doc(DateKey.dateFormat())
                                .set({
                              'TASAFA': '16~30',
                            }, SetOptions(merge: true));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Sleepy(
                                        title: '寝付くまでにかかった時間',
                                        text: '寝付くまでにかかった時間')));
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
                            primary: Colors.white,
                            onPrimary: Colors.black,
                          ),
                          onPressed: () async {
                            FirebaseFirestore.instance
                                .collection(await DeviceData
                                    .getDeviceUniqueId()) // コレクションID
                                .doc(DateKey.dateFormat())
                                .set({
                              'TASAFA': '31~45',
                            }, SetOptions(merge: true));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Sleepy(
                                        title: '寝付くまでにかかった時間',
                                        text: '寝付くまでにかかった時間')));
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
                          DropBoxWidget(key: dropBoxWidgetKey)
                        ],
                      ))),
            ],
          )),
        ],
      ),
    );
  }
}
