import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class HealthProvider {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/fitness.activity.read',
      'https://www.googleapis.com/auth/fitness.activity.write',
    ],
  );

  GoogleSignInAccount? _currentUser;
  String? _accessToken;

  Future<void> signIn() async {
    _currentUser = await _googleSignIn.signIn();
    if (_currentUser == null) throw Exception('Google Sign-In failed');
    final auth = await _currentUser!.authentication;
    _accessToken = auth.accessToken;
  }

  Future<int?> getStepsInRange(DateTime start, DateTime end) async {

    final url =
        'https://fitness.googleapis.com/fitness/v1/users/me/dataset:aggregate';

    final body = {
      "aggregateBy": [
        {"dataTypeName": "com.google.step_count.delta"}
      ],
      "bucketByTime": {"durationMillis": end.difference(start).inMilliseconds},
      "startTimeMillis": start.millisecondsSinceEpoch,
      "endTimeMillis": end.millisecondsSinceEpoch,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $_accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Error fetching steps: ${response.body}');
    }

    final data = jsonDecode(response.body);
    int totalSteps = 0;
    for (var bucket in data['bucket'] ?? []) {
      for (var dataset in bucket['dataset'] ?? []) {
        for (var point in dataset['point'] ?? []) {
          totalSteps += ((point['value'][0]['intVal'] ?? 0) as num).toInt();
        }
      }
    }
    return totalSteps;
  }

  Future<double> getActiveKcalsInRange(DateTime start, DateTime end) async {
    final url =
        'https://fitness.googleapis.com/fitness/v1/users/me/dataset:aggregate';

    final body = {
      "aggregateBy": [
        {"dataTypeName": "com.google.calories.expended"}
      ],
      "bucketByTime": {"durationMillis": end.difference(start).inMilliseconds},
      "startTimeMillis": start.millisecondsSinceEpoch,
      "endTimeMillis": end.millisecondsSinceEpoch,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $_accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Error fetching calories: ${response.body}');
    }

    final data = jsonDecode(response.body);
    double totalKcals = 0;
    for (var bucket in data['bucket'] ?? []) {
      for (var dataset in bucket['dataset'] ?? []) {
        for (var point in dataset['point'] ?? []) {
          totalKcals += (point['value'][0]['fpVal'] ?? 0.0);
        }
      }
    }

    return totalKcals;
  }

  Future<int> getTodaySteps() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    return (await getStepsInRange(start, now)) ?? 0;
  }

  Future<double> getTodayActiveKcals() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    return getActiveKcalsInRange(start, now);
  }
}
