import 'package:carousel_slider/carousel_slider.dart';
// import 'package:pusher_beams/pusher_beams.dart';
import "package:stripcard/views/app_settings/controller/app_settings_controller.dart";
import "package:stripcard/base/utils/local_storage.dart";
import "package:stripcard/base/api/model/dashboard/dashboard_model.dart";
import "package:stripcard/base/api/model/pusher_model/pusher_model.dart";
import "package:stripcard/base/api/endpoint/api_endpoint.dart";
import "package:stripcard/base/api/services/api_services.dart";
import "package:stripcard/service/pusher_api_service.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";

class DashBoardController extends GetxController {
  final CarouselSliderController carouselController =
      CarouselSliderController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final controller = Get.put(AppSettingsController());
  RxInt precision = 0.obs;

  RxInt current = 0.obs;
  RxString activeVirtualSystem = ''.obs;
  RxDouble percentCharge = 0.0.obs;
  RxDouble fixedCharge = 0.0.obs;
  RxDouble rate = 0.0.obs;
  RxDouble limitMin = 0.0.obs;
  RxDouble limitMax = 0.0.obs;
  RxString totalAddMoney = ''.obs;
  RxString totalTransactions = ''.obs;

  RxBool isFirst = true.obs;

  var hasLoadedOnce = false.obs;
  // Stream<DashBoardModel> getDashboardDataStream() async* {
  //   while (LocalStorage.isLoggedIn()) {
  //     await Future.delayed(Duration(seconds: isFirst.value ? 0 : 2));
  //     if (LocalStorage.isLoggedIn()) {
  //       DashBoardModel data = await getDashboardData();
  //       hasLoadedOnce.value = true; //
  //       // walletController.getWalletsInfoProcess();
  //       isFirst.value = false;
  //       yield data;
  //     }
  //   }
  // }

  @override
  void onInit() {
    getDashboardData();
    super.onInit();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  // True only once the dashboard model has loaded successfully. The screen
  // gates its body on this so it never reads the uninitialised `late`
  // _dashBoardModel (which would throw a LateInitializationError red screen
  // whenever the dashboard API fails — e.g. no network / server / language
  // issue). On failure we show a proper error + retry state instead.
  final _hasData = false.obs;

  bool get hasData => _hasData.value;

  late DashBoardModel _dashBoardModel;

  DashBoardModel get dashBoardModel => _dashBoardModel;

  Future<DashBoardModel?> getDashboardData() async {
    _isLoading.value = true;
    update();

    await ApiServices.dashboardApi()
        .then((value) {
          _dashBoardModel = value!;
          _hasData.value = true;
          hasLoadedOnce.value = true;
          _isLoading.value = false;
          final data = _dashBoardModel.data.user;
          firstNameController.text = data.firstname;
          lastNameController.text = data.lastname;
          emailController.text = data.email;

          limitMin.value = _dashBoardModel.data.cardReloadCharge.minLimit
              .toDouble();
          limitMax.value = _dashBoardModel.data.cardReloadCharge.maxLimit
              .toDouble();
          percentCharge.value = _dashBoardModel
              .data
              .cardReloadCharge
              .percentCharge
              .toDouble();
          fixedCharge.value = _dashBoardModel.data.cardReloadCharge.fixedCharge
              .toDouble();
          totalAddMoney.value = _dashBoardModel.data.totalAddMoney;
          totalTransactions.value = _dashBoardModel.data.totalTransactions;

          precision.value =
              _dashBoardModel.data.userWallet.first.currency.type == 'FIAT'
              ? controller.fiatPrecisionValue.value
              : controller.cryptoPrecisionValue.value;

          rate.value = 1.0;
          activeVirtualSystem.value = _dashBoardModel.data.activeVirtualSystem;
          debugPrint("""🌟🌟🌟 
      
                     ${activeVirtualSystem.value} 
                                
                                """);
          debugPrint("""🌟🌟🌟 transfer module
      
                     ${_dashBoardModel.data.moduleAccess.transferMoney} 
                                
                                 🌟🌟🌟""");
          LocalStorage.saveBaseCurrency(
            currency: _dashBoardModel.data.baseCurr,
          );
          LocalStorage.saveKycStatus(
            status: _dashBoardModel.data.user.kycVerified,
          );
          update();

          _isLoading.value = false;
          update();
        })
        .catchError((onError) {
          log.e(onError);
          _isLoading.value = false;
        });

    _isLoading.value = false;
    update();
    // Never read the uninitialised `late` field on the failure path — that
    // throws a LateInitializationError. Only return the model once it has
    // actually loaded; otherwise hand back null and let the screen show its
    // error/retry state (gated on `hasData`).
    return _hasData.value ? _dashBoardModel : null;
  }

  // Register Pusher Beams
  final _isPusherBeamsLoading = false.obs;

  bool get isPusherBeamsLoading => _isPusherBeamsLoading.value;
  late PusherBeamsModel _pusherBeamsModel;

  PusherBeamsModel get pusherBeamsModel => _pusherBeamsModel;

  Future<PusherBeamsModel> getPusherAuth() async {
    _isPusherBeamsLoading.value = true;

    update();
    await PusherApiServices.getPusherBeamsAuth(LocalStorage.getId()!)
        .then((value) {
          _pusherBeamsModel = value!;
          getSecure();
          LocalStorage.savePusherAuthenticationKey(
            pusherAuthenticationKey: true,
          );
          _isPusherBeamsLoading.value = false;
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });
    update();
    return _pusherBeamsModel;
  }

  getSecure() async {
    // final BeamsAuthProvider provider = BeamsAuthProvider()
    //   ..authUrl = ApiEndpoint.pusherBeamsAuthMain
    //   ..headers = {'Content-Type': 'application/json'}
    //   ..queryParams = {'user_id': '1'}
    //   ..credentials = 'omit';

    // await PusherBeams.instance.setUserId(
    //   '1',
    //   provider,
    //   (error) => {
    //     if (error != null) {debugPrint("----------$error---------")}
    //   },
    // );
  }
}
