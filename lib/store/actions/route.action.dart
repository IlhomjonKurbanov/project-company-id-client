import 'package:flutter/material.dart';

class PushAction {
  PushAction(this.destination, this.title);
  String title;
  final Widget destination;
}

class PushReplacementAction {
  PushReplacementAction(this.destination, {this.isExternal = false});
  final Widget destination;
  final bool isExternal;
}

class PopAction {
  PopAction({this.params, this.changeTitle = true, this.isExternal = false});
  bool changeTitle;
  dynamic params;
  final bool isExternal;
}

class PopUntilFirst {}
