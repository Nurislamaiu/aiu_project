import 'package:aiu_project/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../constants/text_string.dart';

class TValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }

    final emailRegExp = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character.';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegExp = RegExp(r'^\d{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number format (10 digits required)';
    }

    return null;
  }
}



dynamic emptyWarning(BuildContext context) {
  return FToast.toast(context,
      msg: TTexts.oopsMsg,
      subMsg: 'You Must fill all fields',
      corner: 20,
      duration: 2000,
      padding: EdgeInsets.all(20));
}

dynamic updateTaskWarning(BuildContext context) {
  return FToast.toast(context,
      msg: TTexts.oopsMsg,
      subMsg: 'You Must edit the tasks then try to update it!',
      corner: 20,
      duration: 3000,
      padding: EdgeInsets.all(20));
}

dynamic noTaskWarning(BuildContext context) {
  return PanaraInfoDialog.showAnimatedGrow(context,
      title: TTexts.oopsMsg,
      message: "There is no Task for Delete!\n"
          "Try adding some and then try to delete it!",
      buttonText: "Okay", onTapDismiss: () {
    Navigator.pop(context);
  }, panaraDialogType: PanaraDialogType.warning);
}

dynamic noLessonWarning(BuildContext context) {
  return PanaraInfoDialog.showAnimatedGrow(context,
      title: TTexts.oopsMsg,
      message: "All fields are required!",
      buttonText: "Okay", onTapDismiss: () {
    Navigator.pop(context);
  }, panaraDialogType: PanaraDialogType.error);
}

dynamic lessonDone(BuildContext context) {
  return PanaraInfoDialog.showAnimatedGrow(context,
      title: "Успешно",
      message: "Урок добавлен",
      buttonText: "Okay", onTapDismiss: () {
    Navigator.pop(context);
  }, panaraDialogType: PanaraDialogType.custom,color: Color(0xFF3A6FF2));
}

dynamic deleteAllTask(BuildContext context) {
  return PanaraConfirmDialog.show(
    context,
    title: TTexts.areYouSure,
    message: 'Do You really want to delete all tasks?',
    panaraDialogType: PanaraDialogType.error,

    confirmButtonText: 'Yes',
    cancelButtonText: 'No',
    onTapConfirm: () {
      BaseWidget.of(context).dataStore.box.clear();
      Navigator.pop(context);
    },
    onTapCancel: () {
      Navigator.pop(context);
    },
  );
}
