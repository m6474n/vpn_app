import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ds_vpn/main.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading, trailing, bottom;
  final bool canNavigate;
  final VoidCallback? onNavigateBack;
  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.trailing,
    this.onNavigateBack,
    this.canNavigate = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: (leading != null)
            ? leading
            : canNavigate
            ? IconButton(
                onPressed: () {
                  Get.back();
                  onNavigateBack?.call();
                },
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowLeft01,
                  color: colorManager.primaryColor,
                ),
              )
            : SizedBox(),
        backgroundColor: colorManager.bgDark,
        title: title != null
            ? Text(title!, style: TextStyle(color: colorManager.textColor))
            : null,
        bottom: PreferredSize(
          preferredSize: preferredSize,
          child: bottom ?? SizedBox(),
        ),

        actions: [trailing ?? SizedBox()],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70);
}
