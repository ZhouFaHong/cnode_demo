

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

  if (day >= 1 && day < 30) {
    text = '$day天前';
  } else if (day >= 30 && day < 60) {
    text = '1个月前';
  } else if (day >= 60 && day < 90) {
    text = '2个月前';
  } else if (day >= 90 && day < 120) {
    text = '3个月前';
  } else if (day >= 120 && day < 150) {
    text = '4个月前';
  } else if (day >= 150 && day < 180) {
    text = '5个月前';
  } else if (day >= 180 && day < 210) {
    text = '6个月前';
  } else if (day >= 210 && day < 240) {
    text = '7个月前';
  } else if (day >= 240 && day < 270) {
    text = '8个月前';
  } else if (day >= 270 && day < 300) {
    text = '9个月前';
  } else if (day >= 300 && day < 330) {
    text = '10个月前';
  } else if (day >= 330 && day < 365) {
    text = '11个月前';
  } else if (day >= 365) {
    text = '1年前';
  } else if (day >= 365*2) {
    text = '2年前';
  }else if (day >= 365*3) {
    text = '3年前';
  }else if (day >= 365*4) {
    text = '4年前';
  }else if (day >= 365*5) {
    text = '5年前以上';
  }else {
    if (hour >= 1) {
      text = '$hour小时前';
    } else if (minute >= 1) {
      text = '$minute分钟前';
    } else {
      text = '$second分钟前';
    }
  }

  return text;
}