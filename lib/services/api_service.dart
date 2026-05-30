class ApiService {
  Future<Map<String, dynamic>> sendSOSRequest({
    required String location,
    required String phone,
    required String service,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    return {
      "success": true,
      "message": "$service request sent successfully",
      "eta": "7 minutes",
    };
  }

  Future<Map<String, dynamic>> submitAccidentReport({
    required String description,
    required String location,
  }) async {
    await Future.delayed(const Duration(seconds: 3));

    return {
      "success": true,
      "severity": "High",
      "victims": 2,
      "services": [
        "Ambulance",
        "Police",
      ],
    };
  }

  Future<Map<String, dynamic>> getCitizenProfile() async {
    await Future.delayed(const Duration(seconds: 1));

    return {
      "name": "Citizen Reporter",
      "points": 150,
      "level": "Community Reporter",
      "reports": 3,
      "verifiedReports": 2,
    };
  }
}