import 'package:intl/intl.dart';

class ConstanceManger {
  static String formatDateTime(DateTime dateTime) {
    String month = DateFormat('MMM').format(dateTime).toUpperCase();

    // Format the date
    return "$month ${dateTime.day}, ${dateTime.year}";
  }

  static List<String> jobsInTurkish = [
    "Marangoz",
    "Demirci",
    "Tesisatçı",
    "Boyacı",
    "Sıradan İşçi"
  ];
}
