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
