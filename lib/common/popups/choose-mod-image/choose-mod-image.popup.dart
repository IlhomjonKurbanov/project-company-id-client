// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';

class ChooseImagePickerPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: <Widget>[
        Container(
          color: AppColors.main2,
          child: CupertinoActionSheetAction(
            child: const Text('Camera', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(context, ImagePickerType.camera);
            },
          ),
        ),
        Container(
          color: AppColors.main2,
          child: CupertinoActionSheetAction(
              child:
                  const Text('Gallery', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.pop(context, ImagePickerType.gallery);
              }),
        ),
      ],
      cancelButton: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13), color: AppColors.main2),
        child: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
