

String switchToDateTime(String date) {

  if (date == null) {
    return '';
  }
  String text = '';
  // 现在的时间
  var nowDate = new DateTime.now();
  // 字符串转date
  DateTime date3 = DateTime.parse(date);

  Duration cha = nowDate.difference(date3);
  // 天
  int day = cha.inDays;
  // 小时
  int hour = cha.inHours;
  // 分
  var minute = cha.inMinutes;
  // 秒
  var second = cha.inSeconds;

  if (day >= 1 && day <= 30) {
    text = '$day天前';
  } else if (day > 30 && day <= 30*12) {
    int m = day ~/30;
    if (m<12) {
      text = '$m个月前';
    }else{
      int y = m ~/12;
      text = '$y年前';
    }
    
  } else {
    if (hour >= 1) {
      text = '$hour小时前';
    } else if (minute >= 1) {
      text = '$minute分钟前';
    } else {
      text = '$second秒前';
    }
  }

  return text;
}