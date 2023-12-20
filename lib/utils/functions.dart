import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void openWhatsAppChat(String phoneNumber) async {
  String formattedPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
  print(formattedPhoneNumber);
  String whatsappUrl = "https://wa.me/$formattedPhoneNumber";
  final Uri _url = Uri.parse(whatsappUrl);

  try {
    if (await canLaunchUrl(_url)) {
      await launchUrl(
        _url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch WhatsApp';
    }
  } catch (e) {
    print(e);
    // Handle exceptions, if any
  }
}

Address? getUserLocationFromHive() {
  var dataBox = Hive.box<ProfileData>('profileDataBox3');

  var savedData = dataBox.get('profile');

  if (savedData != null) {
    if (savedData.address.length == 0) {
      return null;
    }
    if (savedData.address[0].district == "" ||
        savedData.address[0].village == "" ||
        savedData.address[0].gramPanchayat == "" ||
        savedData.address[0].taluk == "") {
      return null;
    }
    return savedData.address[0];
  } else {
    return null;
  }
}

void printError(String text) {
  print('\x1B[31m$text\x1B[0m');
}

String formatDate(String inputDate) {
  // Parse inputDate into a DateTime object
  DateTime parsedDate = DateTime.parse(inputDate);

  List<String> months = [
    '', // Empty string to make months list 1-indexed
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct',
    'Nov', 'Dec'
  ];

  // Extract day, month, and year components
  int day = parsedDate.day;
  int month = parsedDate.month;

  // Format the output string as '2 Oct'
  String formattedDate = '$day ${months[month]}';

  return formattedDate;
}

String formatDateWithYear(String inputDate) {
  // Parse inputDate into a DateTime object
  DateTime parsedDate = DateTime.parse(inputDate);

  List<String> months = [
    '', // Empty string to make months list 1-indexed
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct',
    'Nov', 'Dec'
  ];

  // Extract day, month, and year components
  int day = parsedDate.day;
  int month = parsedDate.month;

  // Format the output string as '2 Oct'
  String formattedDate = '$day ${months[month]}, ${parsedDate.year}';

  return formattedDate;
}
