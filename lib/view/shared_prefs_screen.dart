import 'package:flutter/material.dart';
import 'package:ds_vpn/component/custom_appbar.dart';
import 'package:ds_vpn/main.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SharePrefScreen extends StatefulWidget {
  const SharePrefScreen({super.key});

  @override
  State<SharePrefScreen> createState() => _SharePrefScreenState();
}

class _SharePrefScreenState extends State<SharePrefScreen> {
  Future<Map<String, dynamic>> _getAllSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Set<String> keys = prefs.getKeys();
    final Map<String, dynamic> allPrefs = {};
    // deviceId = await helper.getDeviceInfo();
    // print("Keys => ${keys}");
    for (String key in keys) {
      allPrefs[key] = prefs.get(key);
    }

    return allPrefs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorManager.bgDark,
      appBar: CustomAppBar(canNavigate: true, title: "SharePreferences"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _getAllSharedPreferences(),
          builder:
              (
                BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No data found.',
                      style: TextStyle(color: colorManager.textColor),
                    ),
                  );
                } else {
                  final Map<String, dynamic> prefsData = snapshot.data!;
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: prefsData.length,
                          itemBuilder: (BuildContext context, int index) {
                            String key = prefsData.keys.elementAt(index);
                            dynamic value = prefsData[key];
                            return _reuseableRow(key, value);
                            // trailing: ,
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
        ),
      ),
    );
  }
}

Widget _reuseableRow(key, value) {
  return Container(
    padding: EdgeInsets.only(bottom: 4, top: 4),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: colorManager.borderColor)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$key:", style: TextStyle(color: colorManager.textColor)),
        Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Text(
            "$value",
            style: TextStyle(color: colorManager.textColor),
            textAlign: TextAlign.end,
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    ),
  );
}
