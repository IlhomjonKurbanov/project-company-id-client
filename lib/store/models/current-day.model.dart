class CurrentDateModel {
  CurrentDateModel({required this.currentMohth, required this.focusedDay});
  DateTime currentMohth;
  DateTime focusedDay;

  CurrentDateModel copyWith({DateTime? currentMohth, DateTime? focusedDay}) =>
      CurrentDateModel(
          focusedDay: focusedDay ?? this.focusedDay,
          currentMohth: currentMohth ?? this.currentMohth);
}
