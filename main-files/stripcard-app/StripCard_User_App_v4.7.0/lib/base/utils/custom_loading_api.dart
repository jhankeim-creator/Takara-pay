import "package:TAKARA PAY/base/utils/basic_screen_import.dart";

class CustomLoadingAPI extends StatelessWidget {
  const CustomLoadingAPI({
    Key? key,
    this.color = CustomColor.primaryLightColor,
  }) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color,
      ),
    );
  }
}
