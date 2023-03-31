import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class cardGridView extends StatelessWidget {
  const cardGridView({Key? key, this.imageURL, this.onTap, this.selected}) : super(key: key);

  final String? imageURL;
  final VoidCallback? onTap;
  final bool? selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          height: 300.h,
          width: 150.w,
          color: selected?? false? Colors.green:Colors.grey,
          child: Image.network(imageURL!),
        ),
      ),
    );
  }
}
