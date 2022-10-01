import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DropBoxWidget extends StatefulWidget {
  final String value;

  const DropBoxWidget({Key? key, required this.value}) : super(key: key);

  @override
  DropBoxWidgetState createState() => DropBoxWidgetState();
}

class DropBoxWidgetState extends State<DropBoxWidget> {
  final List<DropdownMenuItem<String>> _items = [];
  String? selectItem;

  @override
  void initState() {
    super.initState();
    setItems();
    selectItem = _items[0].value!;
  }

  @override
  void didUpdateWidget(DropBoxWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    selectItem = widget.value;
  }

  void setItems() {
    _items.add(const DropdownMenuItem(
        child: Text(
          "--分",
          style: TextStyle(fontSize: 16.0),
        ),
        value: ""));
    for (var i = 60; i < 300; i += 15) {
      _items.add(DropdownMenuItem(
          child: Text(
            "~$i分",
            style: const TextStyle(fontSize: 16.0),
          ),
          value: "${i - 15}~$i"));
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
              value: selectItem,
              onChanged: (value) => {
                setState(() {
                  selectItem = value as String;
                }),
              },
            )));
  }
}
