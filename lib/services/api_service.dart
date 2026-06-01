import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl =
      "http://192.168.1.20:8000";

  Future<Map<String, dynamic>> submitAccidentReport({
    required String reporterName,
    required String description,
    required String videoPath,
    required double latitude,
    required double longitude,
  }) async {

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/processIncident"),
    );

    request.fields["reporter_name"] = reporterName;

    request.fields["latitude"] =
        latitude.toString();

    request.fields["longitude"] =
        longitude.toString();

    request.fields["description"] =
        description;

    request.files.add(
      await http.MultipartFile.fromPath(
        "video",
        videoPath,
      ),
    );

    final streamedResponse =
        await request.send();

    final response =
        await http.Response.fromStream(
          streamedResponse,
        );

    if (response.statusCode == 200) {

      return jsonDecode(response.body);

    } else {

      return {
        "success": false
      };
    }
  }
}