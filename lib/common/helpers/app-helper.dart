// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/popups/choose-mod-image/choose-mod-image.popup.dart';
import 'package:company_id_new/store/actions/notifier.action.dart';
import 'package:company_id_new/store/models/notify.model.dart';
import 'package:company_id_new/store/store.dart';

mixin AppHelper {
  static bool isMac(BuildContext context) {
    return Platform.isMacOS && MediaQuery.of(context).size.aspectRatio > 0.8;
  }

  static SpeedDialChild speedDialChild(Function func, Widget icon) =>
      SpeedDialChild(
          child: icon, backgroundColor: AppColors.main, onTap: () => func());
  static Future<dynamic> openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      store.dispatch(
          Notify(NotifyModel(NotificationType.Error, 'Could not launch $url')));
    }
  }

  static Future<DateTime?> chooseDate(BuildContext context,
      {DateTime? lastDate}) async {
    final DateTime today = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: today,
        firstDate: DateTime(1950, 8),
        lastDate: lastDate ?? today,
        builder: (BuildContext context, Widget? child) => Theme(
            data: Theme.of(context).copyWith(
              primaryColor: AppColors.semiGrey,
              colorScheme: const ColorScheme.light(
                  primary: AppColors.main, onSurface: Colors.white),
            ),
            child: child!));
    if (picked != null) {
      return picked;
    }
  }

  static Future<File?> getCroppedImage(BuildContext context) async {
    File? _image;
    final ImagePickerType? imagePickerType =
        await showCupertinoModalPopup<ImagePickerType>(
            context: context,
            builder: (BuildContext context) => ChooseImagePickerPopup());
    if (imagePickerType != null) {
      final ImageSource source = imagePickerType == ImagePickerType.camera
          ? ImageSource.camera
          : ImageSource.gallery;
      final XFile? pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        _image = await ImageCropper.cropImage(
            sourcePath: pickedFile.path,
            aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
            cropStyle: CropStyle.circle,
            androidUiSettings: const AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: Colors.deepOrange,
                toolbarWidgetColor: AppColors.main2,
                initAspectRatio: CropAspectRatioPreset.square,
                lockAspectRatio: false),
            iosUiSettings: const IOSUiSettings(
              title: 'Cropper',
            ));
        if (_image != null) {
          _image = await compressFile(_image);
        }
      }
    }
    return _image;
  }

  static Future<File?> compressFile(File file,
      {int minHeight = 150, int minWidth = 150}) async {
    final Directory dir = await getTemporaryDirectory();
    final String targetPath =
        dir.absolute.path + '/temp${DateTime.now().microsecondsSinceEpoch}.jpg';
    final File? compressed = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      minHeight: minHeight,
      minWidth: minWidth,
    );
    return compressed;
  }
}
