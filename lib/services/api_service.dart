import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://172.25.63.22:8000";

  Future<Map<String, dynamic>> sendSOSRequest({
    required String location,
    required String phone,
    required String service,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/sos"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "location": location,
          "phone": phone,
          "service": service,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return {
        "success": false,
        "message": "SOS failed with status ${response.statusCode}",
        "eta": "Not available",
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Backend connection failed",
        "eta": "Not available",
      };
    }
  }

  Future<Map<String, dynamic>> submitAccidentReport({
    required String reporterName,
    required String description,
    required String videoPath,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse("$baseUrl/processIncident"),
      );

      request.fields["reporter_name"] = reporterName;
      request.fields["description"] = description;
      request.fields["latitude"] = latitude.toString();
      request.fields["longitude"] = longitude.toString();

      request.files.add(
        await http.MultipartFile.fromPath(
          "video",
          videoPath,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return {
        "success": false,
        "message": "Report failed with status ${response.statusCode}",
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Backend connection failed: $e",
      };
    }
  }

  Future<List<dynamic>> getIncidentHistory() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/incidentHistory"),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> getLatestIncident() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/latestIncident"),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return {
        "success": false,
        "message": "Failed to fetch latest incident",
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Backend connection failed: $e",
      };
    }
  }

  Future<Map<String, dynamic>> getCitizenProfile() async {
    return {
      "name": "Citizen Reporter",
      "points": 0,
      "level": "Beginner Helper",
      "reports": 0,
      "verifiedReports": 0,
    };
  }
}