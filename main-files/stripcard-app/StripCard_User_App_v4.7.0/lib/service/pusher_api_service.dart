

import "package:TAKARA PAY/base/api/model/pusher_model/pusher_model.dart";
import "package:TAKARA PAY/base/api/method/api_method.dart";
import "package:TAKARA PAY/base/utils/custom_snackbar.dart";
import "package:TAKARA PAY/base/api/endpoint/api_endpoint.dart";

class PusherApiServices {
  // Get Pusher Beams Auth
  static Future<PusherBeamsModel?> getPusherBeamsAuth(String userId) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.pusherBeamsAuthURL}$userId",
        code: 200,
      );
      if (mapResponse != null) {
        PusherBeamsModel result = PusherBeamsModel.fromJson(mapResponse);

        return result;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from Pusher Beams Auth Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
    return null;
  }
}
