import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/services/local-storage.service.dart';
import 'package:company_id_new/store/models/dynamic-link.model.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

mixin DynamicLinkService {
  static Future<DynamicLinkModel> retrieveDynamicLink() async {
    try {
      final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri? deepLink = data?.link;
      final String? forgotToken = deepLink?.queryParameters['forgotToken'];
      final String? registerToken = deepLink?.queryParameters['registerToken'];
      await localStorageService.saveTokenKey('');
      if (forgotToken != null) {
        return DynamicLinkModel(DynamicLinkEvents.Forgot, data: forgotToken);
      }
      if (registerToken != null) {
        return DynamicLinkModel(DynamicLinkEvents.Signup, data: registerToken);
      }
      return const DynamicLinkModel(DynamicLinkEvents.Null);
    } catch (e) {
      print(e.toString());
      return const DynamicLinkModel(DynamicLinkEvents.Null);
    }
  }
}
