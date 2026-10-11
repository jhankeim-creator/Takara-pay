import "package:stripcard/base/utils/language/strings.dart";


class OnboardModel {
  final String image;
  final String title;
  final String subtitle;

  OnboardModel({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

List<OnboardModel> onboardData = [
  OnboardModel(
    image:"",
    title: Strings.onBoardTitle1,
    subtitle: Strings.onBoardSubTitle1,
  ),
  OnboardModel(
   image:"",
    title: Strings.onBoardTitle2,
    subtitle: Strings.onBoardSubTitle1,
  )
];
