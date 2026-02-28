import 'package:http/http.dart' as http;

/// 获取安全令牌
/// 返回: Token 字符串
/// 异常: 如果请求失败或数据格式错误，抛出 Exception
Future<String> Login(String card, String imei) async {
  final url = Uri.parse('http://api.1wxyun.com/?type=17');
  final response = await http.post(
    url,
    body: {
      'Softid': '7T1O8Q0S3O7R3R9A',
      'Card': card,
      'Version': '1.0',
      'Mac': imei,
    },
  );
  return response.body;
}
