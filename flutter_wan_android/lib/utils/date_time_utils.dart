class DateTimeUtils{

  static parseMilliseconds(num publishTime){
    return "${DateTime.fromMillisecondsSinceEpoch(publishTime).year}-${DateTime.fromMillisecondsSinceEpoch(publishTime).month}-${DateTime.fromMillisecondsSinceEpoch(publishTime).day} ${DateTime.fromMillisecondsSinceEpoch(publishTime).hour}:${DateTime.fromMillisecondsSinceEpoch(publishTime).minute}:${DateTime.fromMillisecondsSinceEpoch(publishTime).second}";
  }
}