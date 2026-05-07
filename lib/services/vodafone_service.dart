import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class VodafoneService {
  static const String _authUrl = 
      "http://mobile.vodafone.com.eg/checkSeamless/realms/vf-realm/protocol/openid-connect/auth";
  static const String _tokenUrl = 
      "https://mobile.vodafone.com.eg/auth/realms/vf-realm/protocol/openid-connect/token";
  
  static const Map<String, String> _baseHeaders = {
    'User-Agent': "okhttp/4.12.0",
    'Connection': "Keep-Alive",
    'Accept-Encoding': "gzip",
    'x-agent-operatingsystem': "13",
    'clientId': "AnaVodafoneAndroid",
    'Accept-Language': "ar",
    'x-agent-device': "Xiaomi 21061119AG",
    'x-agent-version': "2025.10.3",
    'x-agent-build': "1050",
    'digitalId': "28RI9U7ISU8SW",
    'device-id': "1df4efae59648ac3"
  };

  static Future<Map<String, dynamic>> extractData() async {
    try {
      final params = {'client_id': "cash-app"};
      final response1 = await http.get(
        Uri.parse(_authUrl).replace(queryParameters: params),
        headers: _baseHeaders,
      );

      if (response1.statusCode != 200) {
        throw Exception("فشل في الاتصال بخدمة فودافون");
      }

      final data1 = json.decode(response1.body);
      final nuber = data1['msisdn'];
      final phoneNumber = "0$nuber";
      final seamlessToken = data1['seamlessToken'];

      final tokenPayload = {
        'grant_type': "password",
        'client_secret': "b86e30a8-ae29-467a-a71f-65c73f2ff5e3",
        'client_id': "cash-app"
      };

      final tokenHeaders = {
        ..._baseHeaders,
        'Accept': "application/json, text/plain, */*",
        'silentLogin': "true",
        'CRP': "false",
        'seamlessToken': seamlessToken,
        'firstTimeLogin': "true",
        'digitalId': "",
      };

      final response2 = await http.post(
        Uri.parse(_tokenUrl),
        body: tokenPayload,
        headers: tokenHeaders,
      );

      if (response2.statusCode != 200) {
        throw Exception("فشل في جلب التوكن");
      }

      final data2 = json.decode(response2.body);
      final accessToken = data2['access_token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('phoneNumber', phoneNumber);
      await prefs.setString('accessToken', accessToken);
      await prefs.setInt('tokenTimestamp', DateTime.now().millisecondsSinceEpoch);

      return {
        'phoneNumber': phoneNumber,
        'accessToken': accessToken,
        'success': true,
      };
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  static Future<String> getValidToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    final timestamp = prefs.getInt('tokenTimestamp');
    
    if (token == null || timestamp == null) {
      return await refreshToken();
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final diff = now - timestamp;
    
    if (diff > 300000) {
      return await refreshToken();
    }

    return token;
  }

  static Future<String> refreshToken() async {
    final data = await extractData();
    return data['accessToken'];
  }

  static String buildFinalUrl(String token, String phoneNumber) {
    return "https://internet.kesug.com/index.php?token=$token&msisdn=$phoneNumber";
  }
}
