import 'dart:convert';
import 'dart:developer';

import 'package:ds_vpn/main.dart';
import 'package:ds_vpn/utility/constants.dart';
import 'package:ds_vpn/utility/toasts.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xml/xml.dart';
import 'package:path/path.dart' as p;

prettyPrint(mapData) {
  var data = const JsonEncoder.withIndent('  ').convert(mapData);
  print(data);
}

String capitalize(String input) {
  if (input.isEmpty) {
    return input;
  }
  return input[0].toUpperCase() + input.substring(1);
}

String hexToColor(String hexColor) {
  String onlyCode = hexColor.substring(1);
  String color = "0xff$onlyCode";
  return color;
}

String toParameterize(String key) {
  if (key.contains("_")) {
    var words = key
        .split('_')
        .map((word) {
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
    return words;
  } else {
    return key[0].toUpperCase() + key.substring(1).toLowerCase();
  }
}

String toSnakeCase(String label) {
  var words = label.split(' ').map((word) => word.toLowerCase()).join('_');
  return words;
}

copyToClipboard({String? text}) async {
  await Clipboard.setData(ClipboardData(text: text ?? ""));
}

bool isCNICValidate(String number) {
  // if (number.length < 13) {
  //   showToast(message: 'CNIC must be atleast 13 charactors.');
  //   return false;
  // }
  if (number.length == 13) {
    return true;
  } else {
    showToast(message: 'Please enter a valid CNIC number.');
    return false;
  }
}

bool isPasswordValidate(String pass) {
  if (pass.length >= 8) {
    return true;
  } else {
    showToast(message: 'Password must be at least 8 characters.');
    return false;
  }
}

bool isPasswordMatches(String pass, String confirmPass) {
  if (pass == confirmPass) {
    return true;
  } else {
    showToast(message: 'The passwords you entered don’t match.');
    return false;
  }
}

encodeAndSaveDataToPrefs({
  required String key,
  required Map<String, dynamic> data,
}) async {
  try {
    String encodedData = jsonEncode(data);
    await SharedPreferences.getInstance().then((v) {
      v.setString(key, encodedData);
    });
    print("Data saved successfully.");
  } catch (e) {
    print(e);
  }
}

getDecodedDataFromPrefs({required String key}) async {
  Map<String, dynamic>? decodedData;
  try {
    await SharedPreferences.getInstance().then((v) {
      var data = v.getString(key);
      if (data != null) {
        decodedData = jsonDecode(data);
      }
    });
    return decodedData;
  } catch (e) {
    print(e);
  }
}

removeKeyFromSharedPrefs(String key) async {
  var pref = await SharedPreferences.getInstance();
  pref.remove(key);
  print("key ${key} removed successfully!");
}

bool isEmail(String input) {
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(input);
}

String getFileNameFromPath(String filePath) {
  return p.basename(filePath);
}

bool isInteger(String value) {
  // Try to parse the value as an integer
  final intValue = int.tryParse(value);
  return intValue != null;
}

Map<String, dynamic> xmlToMap(String xmlString) {
  final Map<String, dynamic> resultMap = {};

  // Parse the XML string into an XmlDocument
  var document = XmlDocument.parse(xmlString);

  // Convert the XML document to Map
  var root = document.rootElement;
  resultMap[root.name.toString()] = _parseElement(root);

  return resultMap;
}

dynamic _parseElement(XmlElement element) {
  final Map<String, dynamic> elementMap = {};

  // Include attributes as part of the element map
  for (var attribute in element.attributes) {
    elementMap[attribute.name.toString()] = attribute.value;
  }

  if (element.children.isEmpty) {
    // Return the text content if no child elements exist
    return element.text.trim();
  }

  // If the element has children, recursively convert them to Map
  final Map<String, dynamic> subMap = {};
  for (var child in element.children) {
    if (child is XmlElement) {
      subMap[child.name.toString()] = _parseElement(child);
    }
  }

  // If the element has children, return them as a map
  if (subMap.isNotEmpty) {
    elementMap[element.name.toString()] = subMap;
  }

  return elementMap;
}

// List<Map<String, dynamic>> extractItemsFromXml(String xmlString) {
//   final document = XmlDocument.parse(xmlString);
//   final items = document.findAllElements('item');

//   return items.map((item) {
//     final Map<String, dynamic> itemMap = {};

//     for (var child in item.children.whereType<XmlElement>()) {
//       itemMap[child.name.toString()] = child.innerText.trim();
//     }

//     return itemMap;
//   }).toList();
// }import 'package:xml/xml.dart';

List<Map<String, dynamic>> extractItemsFromXml(String xmlString) {
  final document = XmlDocument.parse(xmlString);
  final items = document.findAllElements('item');

  final channelImage = _extractChannelImage(document);

  return items.map((item) {
    final Map<String, dynamic> itemMap = {};
    String? imageUrl;

    // Check for <enclosure> tag first
    final enclosure = item.getElement('enclosure');
    if (enclosure != null) {
      final urlAttr = enclosure.getAttribute('url');
      if (urlAttr != null && urlAttr.isNotEmpty) {
        imageUrl = urlAttr;
      }
    }

    for (var child in item.children.whereType<XmlElement>()) {
      final key = child.name.toString();
      String value = child.innerText.trim();

      if (_isHtmlContentField(key)) {
        final result = _extractImageAndCleanHtml(value);
        value = result['cleanHtml'] ?? value;

        // Only set imageUrl from description/content if enclosure didn't give one
        if (imageUrl == null) {
          imageUrl = result['imageUrl'];
        }
      }

      itemMap[key] = value;
    }

    if (imageUrl == null && channelImage != null) {
      imageUrl = channelImage;
    }

    if (imageUrl != null) {
      itemMap['image'] = imageUrl;
    }

    return itemMap;
  }).toList();
}

Map<String, String?> _extractImageAndCleanHtml(String html) {
  final imgRegex = RegExp(
    r'<img[^>]+src="([^">]+)"[^>]*>',
    caseSensitive: false,
  );
  final match = imgRegex.firstMatch(html);

  String? imageUrl;
  String cleanedHtml = html;

  if (match != null) {
    imageUrl = match.group(1);
    cleanedHtml = html.replaceFirst(match.group(0)!, '');
  }

  return {'imageUrl': imageUrl, 'cleanHtml': cleanedHtml.trim()};
}

bool _isHtmlContentField(String fieldName) {
  final lower = fieldName.toLowerCase();
  return lower == 'content:encoded' || lower == 'description';
}

String? _extractChannelImage(XmlDocument document) {
  final imageElement = document.findAllElements('image').firstOrNull;

  if (imageElement != null) {
    final urlElement = imageElement.findElements('url').firstOrNull;
    return urlElement?.innerText.trim();
  }

  return null;
}

openUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}

getDataFromPrefsDecoded({key}) async {
  String? jsonString = await getDataFromPrefs(key: key, type: 'string');

  var decodedData = jsonString != null ? json.decode(jsonString) : {};
  return decodedData;
}

setDataToPrefsEncoded({key, value}) async {
  String encodedValue = json.encode(value);
  await setDataToPrefs(key: key, value: encodedValue, type: 'string');
}

Future getDataFromPrefs({required String key, required String type}) async {
  var data;
  await SharedPreferences.getInstance().then((v) {
    if (type == "string") {
      data = v.getString(key);
    }
    if (type == "bool") {
      data = v.getBool(key);
    }
    if (type == "double") {
      data = v.getDouble(key);
    }
    if (type == "int") {
      data = v.getInt(key);
    }
  });
  return data;
}

setDataToPrefs({
  required String key,
  required var value,
  required String type,
}) async {
  await SharedPreferences.getInstance().then((v) {
    if (type == "string") {
      v.setString(key, value);
    }
    if (type == "bool") {
      v.setBool(key, value);
    }
    if (type == "double") {
      v.setDouble(key, value);
    }
    if (type == "int") {
      v.setInt(key, value);
    }
  });
}

dynamic dig(Map data, dynamic keys) {
  dynamic value = data;
  for (var k in keys) {
    if (value is Map && value.containsKey(k)) {
      value = value[k];
    } else {
      return null;
    }
  }
  return value;
}

isUserSessionActive() async {
  return await getDataFromPrefs(key: sessionToken, type: 'string') ?? "";
}

clearUserSession() async {
  await setDataToPrefs(key: sessionToken, value: '', type: 'string');
  await setDataToPrefsEncoded(key: membershipKey, value: []);
  await setDataToPrefs(key: userDetailsKey, value: '', type: 'string');
}

saveAuthToken(String token) async {
  await setDataToPrefs(key: sessionToken, value: token, type: 'string');
}

getDeviceToken() async {
  return await getDataFromPrefs(key: deviceToken, type: 'string') ?? '';
}

saveUserDetails(String role, String cnic, String name) async {
  Map<String, dynamic> userDetail = {'role': role, 'cnic': cnic, 'name': name};
  await setDataToPrefsEncoded(key: userDetailsKey, value: userDetail);
}

Future<String> loadUserCnic() async {
  var data = await getDataFromPrefsDecoded(key: userDetailsKey);
  prettyPrint(data);
  return data['cnic'] ?? '';
}

Future<String> loadUserName() async {
  var data = await getDataFromPrefsDecoded(key: userDetailsKey);
  prettyPrint(data);
  return data['name'] ?? '';
}

class RegexPatterns {
  // Email pattern
  static const String email = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  // Phone number: exactly 13 digits
  static const String phone13Digits = r'^[0-9]{13}$';

  // CNIC without dashes: 13 digits
  static const String cnic = r'^[0-9]{13}$';

  // CNIC with dashes: 5-7-1 digit format
  static const String cnicWithDashes = r'^[0-9]{5}-[0-9]{7}-[0-9]$';
}

getFormValidations(String fieldName) {
  getDecodedDataFromPrefs(key: 'form_validations').then((v) {
    return v[fieldName] ?? {};
  });
  return {};
}

launchCustomURL(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}
