import 'package:url_launcher/url_launcher.dart';

Future<bool> sendEmail({
  required String email,
  required String subject,
  required String body,
}) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
    query: encodeQueryParameters(<String, String>{
      'subject': subject,
      'body': body,
    }),
  );

  // if (await canLaunchUrl(emailLaunchUri)) {
  return await launchUrl(emailLaunchUri);
  // } else {
  // throw 'Could not launch $emailLaunchUri';
  // return false;
  // }
}

Future<bool> testMail() async {
  return await launchUrl(
      Uri.parse('mailto:sadeq.s502@gmail.com?subject=hello&body=Test'));
  // mailto:sadeq.s502@gmail.com?subject=hello&body=Test
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
