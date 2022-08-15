import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DropBoxWidget extends StatefulWidget {
  const DropBoxWidget({Key? key}) : super(key: key);

  @override
  _DropBoxWidgetState createState() => _DropBoxWidgetState();
}

class _DropBoxWidgetState extends State<DropBoxWidget> {
  final List<DropdownMenuItem<int>> _items = [];
  int _selectItem = 0;

  @override
  void initState() {
    super.initState();
    setItems();
    _selectItem = _items[0].value!;
  }

  void setItems() {
    _items.add(const DropdownMenuItem(
        child: Text(
          "--分",
          style: TextStyle(fontSize: 16.0),
        ),
        value: 0));
    for (var i = 60; i < 300; i += 15) {
      _items.add(DropdownMenuItem(
          child: Text(
            "~$i分",
            style: const TextStyle(fontSize: 16.0),
          ),
          value: i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 60.h,
        child: Container(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            color: Colors.white,
            alignment: Alignment.center,
            child: DropdownButton(
              underline: const SizedBox(),
              itemHeight: 50.0.h,
              isExpanded: true,
              items: _items,
              value: _selectItem,
              onChanged: (value) => {
                setState(() {
                  _selectItem = value as int;
                }),
              },
            )));
  }
}
