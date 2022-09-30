import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gussuri/finish.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'helper/DateKey.dart';
import 'helper/DeviceData.dart';
import 'home.dart';

class Memo extends StatelessWidget {
  const Memo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final valueController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFBDBDBD),
      appBar: AppBar(
        centerTitle: false,
        title: Padding(
            padding: EdgeInsets.only(left: 18.0.w),
            child: const Text(
              '一言メモ',
              style: TextStyle(color: Colors.black),
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
                      onPressed: () => Navigator.of(context).pop())),
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
                        .collection(await DeviceData
                        .getDeviceUniqueId()) // コレクションID
                        .doc(DateKey.year())
                        .collection(DateKey.month())
                        .doc(DateKey.day())
                        .set({
                      'comments': valueController.text,
                    }, SetOptions(merge: true));

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Finish()));
                  },
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15.w, 100.h, 15.w, 10.h),
                  width: 350.w,
                  height: 150.h,
                  child: Column(
                    children: const [Text('今日の睡眠に関連しそうなこと')],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 35.w, right: 35.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 350.w,
                  child: TextField(
                    controller: valueController,
                    decoration: InputDecoration(
                      hintText: 'プレースホルダー',
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    maxLines: 15,
                    minLines: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
