import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

void main() async {
  Map<String, String> envVars = Platform.environment;
  final username = envVars['GITHUB_USER_NAME'];
  final token = envVars['GITHUB_TOKEN'];
  final apiUrl = 'https://api.github.com';
  final headers = {'Authorization': 'token $token'};

  final response = await http.get(
    Uri.parse('$apiUrl/search/issues?q=is:pr%20review-requested:$username'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    final items = jsonResponse['items'] as List<dynamic>;

    for (final item in items) {
      final repoUrl = item['repository_url'];
      final prNumber = item['number'];
      final prTitle = item['title'];
      final prUrl = item['url'];
      print('Repository: $repoUrl\n'
          'Pull Request #$prNumber: $prTitle\n'
          'URL: $prUrl\n\n');
    }
  } else {
    print('Error: ${response.statusCode}');
  }
}
