import "package:stripcard/base/utils/basic_screen_import.dart";

class DarkModeWidget extends StatefulWidget {
   DarkModeWidget({super.key, required this.keys});
     Key keys = UniqueKey();

  @override
  State<DarkModeWidget> createState() => _DarkModeWidgetState();
}

class _DarkModeWidgetState extends State<DarkModeWidget> {



  void reloadScreen() {
    setState(() {
      widget.keys = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Get.isDarkMode;
    return Container(
      margin:
          EdgeInsets.symmetric(vertical: Dimensions.marginSizeVertical * 0.5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: isDarkMode
            ? CustomColor.primaryDarkScaffoldBackgroundColor
            : CustomColor.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.radius * 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(2, 3),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.white38 : Colors.black26,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                color: isDarkMode ? Colors.yellow : Colors.orangeAccent,
                size: 24,
              ),
              const SizedBox(width: 10),
              TitleHeading4Widget(
                text: isDarkMode ? "Dark Mode" : "Light Mode",
                fontWeight: FontWeight.w500,
                color: isDarkMode
                    ? CustomColor.primaryLightTextColor
                    : CustomColor.primaryDarkTextColor,
              ),
            ],
          ),
          Switch.adaptive(
            value: Get.isDarkMode,
            activeColor: CustomColor.primaryDarkColor,
            inactiveTrackColor: Colors.grey.shade300,
            onChanged: (value) {
              Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
              reloadScreen();

            },
          )
        ],
      ),
    );
  }
}
