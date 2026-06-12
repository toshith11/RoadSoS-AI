import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
<<<<<<< HEAD

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

=======
  static const String baseUrl = "http://10.152.15.1:8000";

  Future<Map<String, dynamic>> sendSOSRequest({
  required double latitude,
  required double longitude,
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
  "latitude": latitude,
  "longitude": longitude,
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
  required int injuredCount,
}) async {
>>>>>>> 7764ec2 (Final Base Model from frontend)
    try {

      var request = http.MultipartRequest(
        "POST",
        Uri.parse("$baseUrl/processIncident"),
      );

      request.fields["reporter_name"] = reporterName;
<<<<<<< HEAD

      request.fields["latitude"] =
          latitude.toString();

      request.fields["longitude"] =
          longitude.toString();

      request.fields["description"] =
          description;
=======
      request.fields["description"] = description;
      request.fields["latitude"] = latitude.toString();
      request.fields["longitude"] = longitude.toString();
      request.fields["injured_count"] =
    injuredCount.toString();
>>>>>>> 7764ec2 (Final Base Model from frontend)

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

<<<<<<< HEAD
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
=======
  Future<Map<String, dynamic>> getCitizenProfile() async {
  try {
    final response = await http.get(
      Uri.parse("$baseUrl/citizenProfile?reporter_name=Citizen Reporter"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return {
      "success": false,
      "message": "Failed to fetch profile",
    };
  } catch (e) {
    return {
      "success": false,
      "message": e.toString(),
    };
>>>>>>> 7764ec2 (Final Base Model from frontend)
  }
}
}