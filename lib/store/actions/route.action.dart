// Flutter imports:
import 'package:flutter/material.dart';

class PushAction {
  const PushAction(this.destination, this.title, {this.isExternal = false});
  final String title;
  final Widget destination;
  final bool isExternal;
}

class PushReplacementAction {
  const PushReplacementAction(this.destination, {this.isExternal = false});
  final Widget destination;
  final bool isExternal;
}

class PopAction {
  const PopAction(
      {this.params, this.changeTitle = true, this.isExternal = false});
  final bool changeTitle;
  final dynamic params;
  final bool isExternal;
}

class PopUntilFirst {}
