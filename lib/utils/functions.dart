import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void openWhatsAppChat(String phoneNumber) async {
  String formattedPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

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
    // Handle exceptions, if any
  }
}

void openPDF(String link) async {
  final Uri _url = Uri.parse(link);

  try {
    if (await canLaunchUrl(_url)) {
      await launchUrl(
        _url,
        mode: LaunchMode.platformDefault,
      );
    } else {}
  } catch (e) {
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

void printError(String text) {}

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
