class Program {
  final String id;
  final String name;
  final String description;
  final String programType;
  final String? logo;
  final String? programHeaderPhoto;
  final int totalEvents;
  final String programStatus;
  final String publicationStatus;
  final String establishmentDate;
  final String? publicationDate;
  final String? directorName;
  
  Program({
    required this.id,
    required this.name,
    required this.description,
    required this.programType,
    this.logo,
    this.programHeaderPhoto,
    required this.totalEvents,
    required this.programStatus,
    required this.publicationStatus,
    required this.establishmentDate,
    this.publicationDate,
    this.directorName,
  });
  
  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      programType: json['program_type'],
      logo: json['logo'],
      programHeaderPhoto: json['program_header_photo'],
      totalEvents: json['total_events'],
      programStatus: json['program_status'],
      publicationStatus: json['publication_status'],
      establishmentDate: json['establishment_date'],
      publicationDate: json['publication_date'],
      directorName: json['director_name'],
    );
  }
}