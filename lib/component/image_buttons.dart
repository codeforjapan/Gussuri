import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class ImageButton extends StatefulWidget {
  final ValueChanged<String?>? onChanged;
  final String? value;
  final bool disabled;

  const ImageButton(
      {super.key, this.onChanged, this.disabled = false, this.value});

  @override
  ImageButtonState createState() => ImageButtonState();
}

class ImageButtonState extends State<ImageButton>
    with TickerProviderStateMixin {
  List<bool> isSelected = List.generate(5, (i) => false);
  late final Function(String?) submitOnChanged;
  bool disabled = false;

  final Map<String, String> _values = {
    'すぐ\n0-15': '0-15',
    'すこし\n16-30': '16-30',
    'まぁまぁ\n31-45': '31-45',
    'しばらく\n46-60': '46-60',
    'めっちゃ\n61-': '61-'
  };

  @override
  void initState() {
    super.initState();
    if (widget.onChanged != null) {
      submitOnChanged = widget.onChanged!;
    }
    if (widget.value != null && widget.value != '0') {
      isSelected[_values.values.toList().indexOf(widget.value as String)] =
          true;
    }
  }

  @override
  Widget build(BuildContext context) {
    disabled = widget.disabled;

    return SizedBox(
      height: 70.h,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: isSelected.length,
          itemBuilder: (context, index) {
            var key = _values.keys.elementAt(index);
            return Column(
              children: [
                ElevatedButton(
                  onPressed: disabled == false
                      ? () {
                          setState(() {
                            isSelected = List.generate(5, (index) => false);
                            isSelected[index] = true;
                            submitOnChanged(_values[key]);
                          });
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.white),
                  child: ClipOval(
                      child: Opacity(
                          opacity: isSelected[index] ? 1 : 0.5,
                          child: Image.asset('images/time$index.png'))),
                ),
                Text(
                  key,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: isSelected[index]
                          ? Colors.black.withOpacity(1)
                          : Colors.black.withOpacity(0.4)),
                )
              ],
            );
          }),
    );
  }
}
