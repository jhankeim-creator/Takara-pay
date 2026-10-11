import "package:TAKARA PAY/base/utils/basic_screen_import.dart";

class RecentRecipientsWidget extends StatefulWidget {
  @override
  _RecentRecipientsWidgetState createState() => _RecentRecipientsWidgetState();
}

class _RecentRecipientsWidgetState extends State<RecentRecipientsWidget> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> recipients = [
    {
      "image": "assets/clipart/Ellipse 1234.png",
      "bgColor": Colors.purpleAccent
    },
    {"image": "assets/clipart/man.png", "bgColor": Colors.blue},
    {"image": "assets/clipart/pp.png", "bgColor": Colors.green},
    {"image": "assets/clipart/Ellip.png", "bgColor": Colors.pink},
    {"image": "assets/clipart/men.png", "bgColor": Colors.lightBlue},
    {"image": "assets/clipart/mann.png", "bgColor": Colors.green},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpace(Dimensions.marginSizeVertical * 0.5),
        Divider(
          color: CustomColor.grayColor.withAlpha(77),
        ),
        TitleHeading3Widget(
          padding: EdgeInsets.only(
              top: Dimensions.marginSizeVertical * 0.5,
              bottom: Dimensions.marginSizeVertical * 0.2),
          text: Strings.recentRecipients,
          color: Get.isDarkMode
              ? CustomColor.primaryLightTextColor
              : CustomColor.primaryDarkTextColor,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.07,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recipients.length,
            itemBuilder: (context, index) {
              bool isSelected = selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    padding: EdgeInsets.all(isSelected ? 3.0 : 0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(
                              color: CustomColor.primaryLightColor, width: 2.0)
                          : null,
                    ),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: recipients[index]['bgColor'],
                      child: CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage(recipients[index]['image']),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
