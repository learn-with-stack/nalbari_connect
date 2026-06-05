enum AppointmentStatus { pending, approved, rejected }

enum ComplaintStatus { newRequest, inReview, resolved }

enum ComplaintPriority { low, medium, high }

enum AreaType { ward, panchayat }

class NewsItem {
  const NewsItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.body,
    required this.publishedAt,
  });

  final String id;
  final String title;
  final String summary;
  final String body;
  final DateTime publishedAt;
}

class AppointmentRequest {
  const AppointmentRequest({
    required this.id,
    required this.fullName,
    required this.withPerson,
    required this.date,
    required this.time,
    required this.reason,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String fullName;
  final String withPerson;
  final DateTime date;
  final String time;
  final String reason;
  final AppointmentStatus status;
  final DateTime createdAt;

  AppointmentRequest copyWith({AppointmentStatus? status}) {
    return AppointmentRequest(
      id: id,
      fullName: fullName,
      withPerson: withPerson,
      date: date,
      time: time,
      reason: reason,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}

class ComplaintRequest {
  const ComplaintRequest({
    required this.id,
    required this.reporterName,
    required this.areaType,
    required this.areaNumber,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.mediaName,
  });

  final String id;
  final String reporterName;
  final AreaType areaType;
  final String areaNumber;
  final String description;
  final ComplaintStatus status;
  final ComplaintPriority priority;
  final DateTime createdAt;
  final String? mediaName;

  ComplaintRequest copyWith({
    ComplaintStatus? status,
    ComplaintPriority? priority,
  }) {
    return ComplaintRequest(
      id: id,
      reporterName: reporterName,
      areaType: areaType,
      areaNumber: areaNumber,
      description: description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt,
      mediaName: mediaName,
    );
  }
}
