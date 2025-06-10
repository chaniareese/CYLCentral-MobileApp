class Event {
  final int id;
  final String title;
  final String programId;
  final String programName;
  final String? programLogo;
  final String? eventType;
  final String? poster;
  final String description;
  final String eventDate;
  final String formattedDate;
  final String? eventTime;
  final String? formattedTime;
  final String? eventFormat;
  final String? eventLocation;
  final String? eventPlatform;
  final String? eventLink;
  final double? registrationFee;
  final bool isFree;
  final String? inclusions;
  final bool memberonlyRegis;
  final String? eventHeadName;
  
  Event({
    required this.id,
    required this.title,
    required this.programId,
    required this.programName,
    this.programLogo,
    this.eventType,
    this.poster,
    required this.description,
    required this.eventDate,
    required this.formattedDate,
    this.eventTime,
    this.formattedTime,
    this.eventFormat,
    this.eventLocation,
    this.eventPlatform,
    this.eventLink,
    this.registrationFee,
    required this.isFree,
    this.inclusions,
    required this.memberonlyRegis,
    this.eventHeadName,
  });
  
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      programId: json['program_id'],
      programName: json['program_name'],
      programLogo: json['program_logo'],
      eventType: json['event_type'],
      poster: json['poster'],
      description: json['description'],
      eventDate: json['event_date'],
      formattedDate: json['formatted_date'] ?? formatDate(json['event_date']),
      eventTime: json['event_time'],
      formattedTime: json['formatted_time'],
      eventFormat: json['event_format'],
      eventLocation: json['event_location'],
      eventPlatform: json['event_platform'],
      eventLink: json['event_link'],
      registrationFee: json['registration_fee']?.toDouble(),
      isFree: json['is_free'] ?? false,
      inclusions: json['inclusions'],
      memberonlyRegis: json['memberonly_regis'] ?? false,
      eventHeadName: json['event_head_name'],
    );
  }
  
  static String formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}