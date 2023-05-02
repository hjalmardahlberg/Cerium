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
  return timeTime = timeTime.characters.skipLast(3).toString().split('T')[1];
}