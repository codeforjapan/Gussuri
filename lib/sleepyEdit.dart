import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gussuri/component/DropBoxWidget.dart';
import 'package:gussuri/component/TimePicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gussuri/utils.dart';
import 'home.dart';

class SleepyEdit extends StatefulWidget {
  final String value;

  const SleepyEdit(Map<List<Event>, List<Event>> map, {Key? key, required this.value}) : super(key: key);

  @override
  State<SleepyEdit> createState() => _SleepyState();
}

class _SleepyState extends State<SleepyEdit> {
  Object _sleepyData = {};

  Future<void> getSleepyData(pathName) async {
    var paths = pathName.split('/');
    // NOTE: path[0] = collectionId; path[1],path[2],path[3] = year,month,day
    final orderSnap = await FirebaseFirestore.instance
        .collection(paths[0])
        .doc(paths[1])
        .collection(paths[2])
        .doc(paths[3])
        .get();
    _sleepyData = orderSnap.data() as Object;
  }

  @override
  void initState() {
    super.initState();
    getSleepyData(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final valueController = TextEditingController();
    const timePickerKey =
        GlobalObjectKey<TimePickerState>('__TIME_PICKER_KEY__');
    const timePickerKeySecond =
        GlobalObjectKey<TimePickerState>('__TIME_PICKER_KEY2__');
    const sleepyDropBoxKey =
        GlobalObjectKey<DropBoxWidgetState>('__DROP_BOX_KEY__');
    const sleepyDropBoxKeySecond =
        GlobalObjectKey<DropBoxWidgetState>('__DROP_BOX_KEY2__');

    return Scaffold(
      backgroundColor: const Color(0xFFBDBDBD),
      appBar: AppBar(
        centerTitle: false,
        title: const Padding(
            padding: EdgeInsets.only(left: 28.0),
            child: Text(
              "睡眠記録の編集",
              style: TextStyle(color: Colors.black),
            )),
        actions: [
          ElevatedButton(
            child: const Text('ホーム'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(0),
                  ),
                )
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Home()));
            },
          )
        ],
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 60,
            decoration: const BoxDecoration(color: Colors.black),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                  child: Text(
                "20XX年XX月XX日",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              )),
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
            children: [
              Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 15),
                      padding: const EdgeInsets.all(15),
                      child: const Text("布団に入った時間")),
                  Container(
                      alignment: Alignment.center,
                      child: const TimePickerWidget(key: timePickerKey)),
                ],
              ),
              Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 15),
                      padding: const EdgeInsets.all(15),
                      child: const Text("布団から出た時間")),
                  Container(
                      alignment: Alignment.center,
                      child: const TimePickerWidget(key: timePickerKeySecond)),
                ],
              ),
              Column(
                children: [
                  const Padding(
                      padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                      child: Text("布団から出るまでにかかった時間")),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("00〜"),
                          ElevatedButton(
                            child: const Text('15分'),
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(200, 60),
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                )),
                            onPressed: () {},
                          )
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("16〜"),
                          ElevatedButton(
                            child: const Text('30分'),
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(200, 60),
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                )),
                            onPressed: () {},
                          )
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("31〜"),
                          ElevatedButton(
                            child: const Text('45分'),
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(200, 60),
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                )),
                            onPressed: () {},
                          )
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: const [
                                Text("46分以上", textAlign: TextAlign.left),
                                SizedBox(
                                  width: 300,
                                  child: DropBoxWidget(key: sleepyDropBoxKey),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  const Padding(
                      padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                      child: Text("寝付くまでにかかった時間")),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("00〜"),
                          ElevatedButton(
                            child: const Text('15分'),
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(200, 60),
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                )),
                            onPressed: () {},
                          )
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("16〜"),
                          ElevatedButton(
                            child: const Text('30分'),
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(200, 60),
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                )),
                            onPressed: () {},
                          )
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("31〜"),
                          ElevatedButton(
                            child: const Text('45分'),
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(200, 60),
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                )),
                            onPressed: () {},
                          )
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: const [
                                Text("46分以上", textAlign: TextAlign.left),
                                SizedBox(
                                  width: 300,
                                  child: DropBoxWidget(
                                      key: sleepyDropBoxKeySecond),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Column(children: [
                const Padding(
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
                    child: Text("途中で目が覚めた回数")),
                Column(
                    // alignment: Alignment.center,
                    children: [
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            child: const Text('0回'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(300, 80),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                            ),
                            onPressed: () {},
                          )),
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            child: const Text('1回'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(300, 80),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                            ),
                            onPressed: () {},
                          )),
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            child: const Text('2回'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(300, 80),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                            ),
                            onPressed: () {},
                          )),
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            child: const Text('3回以上'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(300, 80),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                            ),
                            onPressed: () {},
                          )),
                    ]),
              ]),
              Column(children: [
                const Padding(
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
                    child: Text("再び眠りに入るまでにかかった時間")),
                Column(
                    // alignment: Alignment.center,
                    children: [
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            child: const Text('比較的すぐ'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(300, 80),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                            ),
                            onPressed: () {},
                          )),
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            child: const Text('30分くらい'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(300, 80),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                            ),
                            onPressed: () {},
                          )),
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            child: const Text('1時間くらい'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(300, 80),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                            ),
                            onPressed: () {},
                          )),
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            child: const Text('２時間以上'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(300, 80),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                            ),
                            onPressed: () {},
                          )),
                    ]),
              ]),
              Column(children: [
                const Padding(
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
                    child: Text("一言メモ：この睡眠に関連しそうなこと")),
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
                      hintText: 'メモ',
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
              ]),
              const Padding(padding: EdgeInsets.only(bottom: 20)),
            ],
          ))),
          Container(
            width: double.infinity,
            height: 100,
            decoration: const BoxDecoration(color: Color(0xFF424242)),
            child: Center(
              child: ElevatedButton(
                child: const Text('保存'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 60),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
