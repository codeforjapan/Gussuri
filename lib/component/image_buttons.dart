import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class ImageButton extends StatefulWidget {
  final ValueChanged<String?>? onChanged;

  const ImageButton({super.key, this.onChanged});

  @override
  ImageButtonState createState() => ImageButtonState();
}

class ImageButtonState extends State<ImageButton>
    with TickerProviderStateMixin {
  List<bool> isSelected = List.generate(5, (i) => false);
  late final Function(String?) submitOnChanged;
  final List<String> values = [
    'すぐ\n0-15',
    'すこし\n16-30',
    'まぁまぁ\n31-45',
    'しばらく\n46-60',
    'めっちゃ\n61-'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.onChanged != null) {
      submitOnChanged = widget.onChanged!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.h,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: isSelected.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isSelected = List.generate(5, (index) => false);
                      isSelected[index] = true;
                      submitOnChanged(values[index]);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.white
                  ),
                  child: ClipOval(
                      child: Opacity(
                          opacity: isSelected[index] ? 1 : 0.5,
                          child: Image.asset('images/time$index.png'))),
                ),
                Text(
                  values[index],
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
