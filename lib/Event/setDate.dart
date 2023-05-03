import 'package:characters/characters.dart';
import 'package:intl/intl.dart';

class SetDate
{
   final String startTimeDate;

   final String endTimeDate;

   final int value;

    const SetDate({
        required this.value, required this.startTimeDate,required this.endTimeDate,
    });
}

String dateToString(timeDate){
  return timeDate = timeDate.split('T')[0];
}

String timeToString(timeTime){
  DateTime dateObject = DateTime.parse(timeTime);
  String hours = dateObject.hour.toString().padLeft(2, '0');
  String minutes = dateObject.minute.toString().padLeft(2, '0');
  return "$hours:$minutes";
}