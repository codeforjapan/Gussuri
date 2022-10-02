import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gussuri/component/DropBoxWidget.dart';
import 'package:gussuri/component/TimePicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gussuri/utils.dart';
import 'calendar.dart';
import 'home.dart';

class SleepyEdit extends StatefulWidget {
  final String value;

  const SleepyEdit(Map<List<Event>, List<Event>> map,
      {Key? key, required this.value})
      : super(key: key);

  @override
  State<SleepyEdit> createState() => _SleepyState();
}

class _SleepyState extends State<SleepyEdit> {
  String _editDate = "";
  List<String> _paths = [];
  Map<String, dynamic> _sleepyData = {
    "bed_time": "",
    "comments": "",
    "TASAFA": "",
    "get_up_time": "",
    "dysfunction": null,
    "WASO": null,
    "SOL": "",
    "NOA": null
  };

  Future<void> getSleepyData(List<String> paths) async {
    // NOTE: path[0] = collectionId; path[1],path[2],path[3] = year,month,day
    final orderSnap = await FirebaseFirestore.instance
        .collection(paths[0])
        .doc(paths[1])
        .collection(paths[2])
        .doc(paths[3])
        .get();

    if (mounted) {
      setState(() {
        _sleepyData = orderSnap.data() as Map<String, dynamic>;
      });
    }
  }

  Future<void> updateSleepyData(dynamic timePickerKey,
      dynamic timePickerKeySecond, dynamic context) async {
    // NOTE: path[0] = collectionId; path[1],path[2],path[3] = year,month,day
    FirebaseFirestore.instance
        .collection(_paths[0])
        .doc(_paths[1])
        .collection(_paths[2])
        .doc(_paths[3])
        .set(_sleepyData);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Calendar()));
  }

  void setEditDate(List<String> paths) {
    _editDate = '${paths[1]}年${paths[2]}月${paths[3]}日';
  }

  void setSleepyData(String key, dynamic value) {
    setState(() {
      _sleepyData[key] = value;
    });
  }

  String getSleepyOtherTime(String value) {
    List<String> basicValues = ["00~15", "16~30", "31~45"];
    return basicValues.contains(value) ? "" : value;
  }

  DateTime convertDateTime(String datetime) {
    return datetime.isEmpty ? DateTime.now() : DateTime.parse(datetime);
  }

  @override
  void initState() {
    super.initState();
    _paths = widget.value.split('/');
    getSleepyData(_paths);
    setEditDate(_paths);
  }

  @override
  Widget build(BuildContext context) {
    const timePickerKey =
        GlobalObjectKey<TimePickerState>('__TIME_PICKER_KEY__');
    const timePickerKeySecond =
        GlobalObjectKey<TimePickerState>('__TIME_PICKER_KEY2__');
    const sleepyDropBoxKey =
        GlobalObjectKey<DropBoxWidgetState>('__DROP_BOX_KEY__');
    const sleepyDropBoxKeySecond =
        GlobalObjectKey<DropBoxWidgetState>('__DROP_BOX_KEY2__');
    const selectedBgColor = Colors.white60;

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
                )),
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
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                  child: Text(
                _editDate,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
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
                      child: TimePickerWidget(
                          key: timePickerKey,
                          value: convertDateTime(_sleepyData["bed_time"]),
                          onChanged: (value) => {
                                setState(() {
                                  _sleepyData["bed_time"] = value;
                                })
                              })),
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
                      child: TimePickerWidget(
                          key: timePickerKeySecond,
                          value: convertDateTime(_sleepyData["get_up_time"]),
                          onChanged: (value) => {
                                setState(() {
                                  _sleepyData["get_up_time"] = value;
                                })
                              })),
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
                                backgroundColor: _sleepyData["SOL"] == "00~15"
                                    ? selectedBgColor
                                    : Colors.white,
                                foregroundColor: Colors.black,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                )),
                            onPressed: () {
                              setSleepyData("SOL", "00~15");
                            },
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
                                backgroundColor: _sleepyData["SOL"] == "16~30"
                                    ? selectedBgColor
                                    : Colors.white,
                                foregroundColor: Colors.black,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                )),
                            onPressed: () {
                              setSleepyData("SOL", "16~30");
                            },
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
                                backgroundColor: _sleepyData["SOL"] == "31~45"
                                    ? selectedBgColor
                                    : Colors.white,
                                foregroundColor: Colors.black,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                )),
                            onPressed: () {
                              setSleepyData("SOL", "31~45");
                            },
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
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  width: 300,
                                  child: const Text(
                                    "46分以上",
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                SizedBox(
                                  width: 300,
                                  child: DropBoxWidget(
                                    key: sleepyDropBoxKey,
                                    value:
                                        getSleepyOtherTime(_sleepyData["SOL"]),
                                    onChanged: (value) => {
                                      setState(() {
                                        _sleepyData["SOL"] = value;
                                      })
                                    },
                                  ),
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
                                backgroundColor:
                                    _sleepyData["TASAFA"] == "00~15"
                                        ? selectedBgColor
                                        : Colors.white,
                                foregroundColor: Colors.black,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                )),
                            onPressed: () {
                              setSleepyData("TASAFA", "00~15");
                            },
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
                                backgroundColor:
                                    _sleepyData["TASAFA"] == "16~30"
                                        ? selectedBgColor
                                        : Colors.white,
                                foregroundColor: Colors.black,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                )),
                            onPressed: () {
                              setSleepyData("TASAFA", "16~30");
                            },
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
                                backgroundColor:
                                    _sleepyData["TASAFA"] == "31~45"
                                        ? selectedBgColor
                                        : Colors.white,
                                foregroundColor: Colors.black,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                )),
                            onPressed: () {
                              setSleepyData("TASAFA", "31~45");
                            },
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
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  width: 300,
                                  child: const Text(
                                    "46分以上",
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                SizedBox(
                                  width: 300,
                                  child: DropBoxWidget(
                                    key: sleepyDropBoxKeySecond,
                                    value: getSleepyOtherTime(
                                        _sleepyData["TASAFA"]),
                                    onChanged: (value) => {
                                      setState(() {
                                        _sleepyData["TASAFA"] = value;
                                      })
                                    },
                                  ),
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
                              backgroundColor: _sleepyData["NOA"] == null
                                  ? selectedBgColor
                                  : Colors.white,
                              foregroundColor: Colors.black,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                            ),
                            onPressed: () {
                              setSleepyData("NOA", null);
                            },
                          )),
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            child: const Text('1回'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(300, 80),
                              backgroundColor: _sleepyData["NOA"] == 1
                                  ? selectedBgColor
                                  : Colors.white,
                              foregroundColor: Colors.black,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                            ),
                            onPressed: () {
                              setSleepyData("NOA", 1);
                            },
                          )),
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            child: const Text('2回'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(300, 80),
                              backgroundColor: _sleepyData["NOA"] == 2
                                  ? selectedBgColor
                                  : Colors.white,
                              foregroundColor: Colors.black,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                            ),
                            onPressed: () {
                              setSleepyData("NOA", 2);
                            },
                          )),
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            child: const Text('3回以上'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(300, 80),
                              backgroundColor: _sleepyData["NOA"] == "3~"
                                  ? selectedBgColor
                                  : Colors.white,
                              foregroundColor: Colors.black,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                            ),
                            onPressed: () {
                              setSleepyData("NOA", "3~");
                            },
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
                              backgroundColor: _sleepyData["WASO"] == 0
                                  ? selectedBgColor
                                  : Colors.white,
                              foregroundColor: Colors.black,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                            ),
                            onPressed: () {
                              setSleepyData("WASO", 0);
                            },
                          )),
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            child: const Text('30分くらい'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(300, 80),
                              backgroundColor: _sleepyData["WASO"] == 30
                                  ? selectedBgColor
                                  : Colors.white,
                              foregroundColor: Colors.black,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                            ),
                            onPressed: () {
                              setSleepyData("WASO", 30);
                            },
                          )),
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            child: const Text('1時間くらい'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(300, 80),
                              backgroundColor: _sleepyData["WASO"] == 60
                                  ? selectedBgColor
                                  : Colors.white,
                              foregroundColor: Colors.black,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                            ),
                            onPressed: () {
                              setSleepyData("WASO", 60);
                            },
                          )),
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            child: const Text('２時間以上'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(300, 80),
                              backgroundColor: _sleepyData["WASO"] == 120
                                  ? selectedBgColor
                                  : Colors.white,
                              foregroundColor: Colors.black,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                            ),
                            onPressed: () {
                              setSleepyData("WASO", 120);
                            },
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
                    onChanged: (text) {
                      _sleepyData["comments"] = text;
                    },
                    controller:
                        TextEditingController(text: _sleepyData["comments"]),
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
                onPressed: () {
                  updateSleepyData(timePickerKey, timePickerKeySecond, context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
