import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  // Replace with your backend IP
  static const String baseUrl =
"http://172.25.63.22:8000";

  // ==========================
  // SUBMIT ACCIDENT REPORT
  // ==========================

  Future<Map<String, dynamic>> submitAccidentReport({
    required String reporterName,
    required String description,
    required String videoPath,
    required double latitude,
    required double longitude,
  }) async {

    try {

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
          "success": false,
          "message":
              "Failed with status ${response.statusCode}"
        };
      }

    } catch (e) {

      return {
        "success": false,
        "message": e.toString()
      };
    }
  }

  // ==========================
  // INCIDENT HISTORY
  // ==========================

  Future<List<dynamic>> getIncidentHistory() async {

    try {

      final response = await http.get(
        Uri.parse(
          "$baseUrl/incidentHistory",
        ),
      );

      if (response.statusCode == 200) {

        return jsonDecode(response.body);

      } else {

        return [];
      }

    } catch (e) {

      return [];
    }
  }

  // ==========================
  // LATEST INCIDENT
  // ==========================

  Future<Map<String, dynamic>> getLatestIncident() async {

    try {

      final response = await http.get(
        Uri.parse(
          "$baseUrl/latestIncident",
        ),
      );

      if (response.statusCode == 200) {

        return jsonDecode(response.body);

      } else {

        return {
          "message":
              "Failed to fetch latest incident"
        };
      }

    } catch (e) {

      return {
        "message": e.toString()
      };
    }
  }

  // ==========================
  // SOS API (Future)
  // ==========================

  Future<Map<String, dynamic>> sendSOS({
    required double latitude,
    required double longitude,
  }) async {

    try {

      final response = await http.post(
        Uri.parse("$baseUrl/sos"),
        headers: {
          "Content-Type":
              "application/json"
        },
        body: jsonEncode({
          "latitude": latitude,
          "longitude": longitude,
        }),
      );

      return jsonDecode(response.body);

    } catch (e) {

      return {
        "success": false,
        "message": e.toString()
      };
    }
  }
}