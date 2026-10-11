import 'dart:async';
import 'dart:io';
import "package:stripcard/base/api/endpoint/api_endpoint.dart";
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import "package:stripcard/base/utils/custom_snackbar.dart";
import "package:stripcard/views/app_settings/controller/app_settings_controller.dart";
import "package:stripcard/views/profile/controller/update_profile_controller.dart";
import "package:stripcard/custom_assets/assets.gen.dart";
import "package:stripcard/base/utils/custom_color.dart";
import "package:stripcard/base/utils/dimensions.dart";
import "package:stripcard/base/widgets/others/custom_image_widget.dart";
import "package:stripcard/base/widgets/design_system/sc_network_image.dart";
import "package:stripcard/base/widgets/others/image_picker/image_picker.dart";

File? imageFile;

class ImagePickerWidget extends StatelessWidget {
  ImagePickerWidget({Key? key}) : super(key: key);
  final controller = Get.put(UpdateProfileController());
  final imgController = Get.put(InputImageController());

  // image picker function
  Future pickImage(imageSource) async {
    try {
      final image = await ImagePicker().pickImage(
        source: imageSource,
        imageQuality: 40, // define image quality
        maxHeight: 600, // image height
        maxWidth: 600, // image width
      );
      if (image == null) return;

      imageFile = File(image.path);
      imgController.setImagePath(imageFile!.path);
    } on PlatformException catch (e) {
      CustomSnackBar.error('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Center(
        child: imgController.isImagePathSet.value == true
            ? GestureDetector(
                onTap: () {
                  showGeneralDialog(
                    context: context,
                    pageBuilder: (ctx, a1, a2) {
                      return const Icon(
                        Icons.close,
                        color: Colors.red,
                      );
                    },
                    transitionBuilder: (ctx, a1, a2, child) {
                      var curve = Curves.easeInOut.transform(a1.value);
                      return Transform.scale(
                        scale: curve,
                        child: AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius * 2),
                          ),
                          content: _imagePickerBottomSheetWidget(context),
                        ),
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 400),
                  );
                },
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: Dimensions.paddingSize,
                      bottom: Dimensions.paddingSize,
                    ),
                    height: Dimensions.heightSize * 8.3,
                    width: Dimensions.widthSize * 11.5,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius * 1.5),
                        color: CustomColor.primaryLightColor,
                        border: Border.all(
                            color: CustomColor.primaryBGLightColor, width: 5),
                        image: DecorationImage(
                            image: FileImage(
                              File(
                                imageController.imagePath.value,
                              ),
                            ),
                            fit: BoxFit.cover)),
                  ),
                ),
              )
            : _userImageWidget(context),
      );
    });
  }

  _imagePickerBottomSheetWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: MediaQuery.of(context).size.height * 0.12,
      margin: EdgeInsets.all(Dimensions.marginSizeVertical * 0.5),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(Dimensions.paddingSize),
                child: IconButton(
                    onPressed: () {
                      Get.back();
                      pickImage(ImageSource.gallery);
                    },
                    icon: Icon(
                      Icons.image,
                      color: Theme.of(context).primaryColor,
                      size: 50,
                    )),
              ),
              Padding(
                padding: EdgeInsets.all(Dimensions.paddingSize),
                child: IconButton(
                    onPressed: () {
                      Get.back();
                      pickImage(ImageSource.camera);
                    },
                    icon: Icon(
                      Icons.camera,
                      color: Theme.of(context).primaryColor,
                      size: 50,
                    )),
              ),
            ],
          ),
       Positioned(
            top: -12,
            right: -15,
            child: IconButton(
              onPressed: () {
                Get.close(1);
              },
              icon: const Icon(
                Icons.close,
                color: Colors.red,
              ),
            ),
          ), ],
      ),
    );
  }

  _userImageWidget(BuildContext context) {
    var data = controller.userProfileModel.data;
    final image = data.user.userImage;
    final defaultImage = "${Get.find<AppSettingsController>().assetBaseUrl.value}/${data.defaultImage}";
    return Stack(
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.only(
              top: Dimensions.paddingSize,
              bottom: Dimensions.paddingSize,
            ),
            height: Dimensions.heightSize * 8.3,
            width: Dimensions.widthSize * 11.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius * 1.5),
              color: CustomColor.primaryLightColor,
              border:
                  Border.all(color: CustomColor.primaryBGLightColor, width: 5),
            ),
            child: SCNetworkImage(
              url: data.imagePath.isNotEmpty ? image : defaultImage,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
              radius: Dimensions.radius,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            showGeneralDialog(
        
              context: context,
              pageBuilder: (ctx, a1, a2) {
                return const Icon(
                  Icons.close,
                  color: Colors.red,
                );
              },
              transitionBuilder: (ctx, a1, a2, child) {
                var curve = Curves.easeInOut.transform(a1.value);
                return Transform.scale(
                  scale: curve,
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Dimensions.radius * 2),
                    ),
                    content: _imagePickerBottomSheetWidget(context),
                  ),
                );
              },
              transitionDuration: const Duration(milliseconds: 400),
            );
          },
          child: Center(
            child: Container(
              margin: EdgeInsets.only(top: Dimensions.marginSizeVertical * 2.6),
              child: CustomImageWidget(
                path: Assets.icon.camera,
                color: CustomColor.whiteColor,
                height: Dimensions.heightSize * 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
