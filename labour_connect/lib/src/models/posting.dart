// Models a single posting — either a company needing labour
// or a labourer marking themselves as available.

enum PostingType { company, labour }

class Posting {
  String? id;          // Firestore document ID
  String? uid;         // Firebase Auth UID of the poster
  PostingType? type;   // 'company' or 'labour'
  String? posterName;  // Company name OR worker name
  String? workType;    // e.g. "Mason / Raj Mistri", "Plumber"
  String? location;    // City/area
  String? duration;    // "15 days", "Available from Monday"
  String? wage;        // "₹700/day", "Negotiable"
  String? phone;
  String? email;
  String? notes;       // Extra details
  bool urgent;
  DateTime? createdAt;

  Posting({
    this.id,
    this.uid,
    this.type,
    this.posterName,
    this.workType,
    this.location,
    this.duration,
    this.wage,
    this.phone,
    this.email,
    this.notes,
    this.urgent = false,
    this.createdAt,
  });

  // Converts Posting to a Map for saving to Firestore
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'type': type?.name,           // 'company' or 'labour'
        'posterName': posterName,
        'workType': workType,
        'location': location,
        'duration': duration,
        'wage': wage,
        'phone': phone,
        'email': email,
        'notes': notes,
        'urgent': urgent,
        'createdAt': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      };

  // Builds a Posting from a Firestore document snapshot
  factory Posting.fromSnapshot(dynamic snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Posting(
      id: snapshot.id,
      uid: data['uid'],
      type: data['type'] == 'company' ? PostingType.company : PostingType.labour,
      posterName: data['posterName'],
      workType: data['workType'],
      location: data['location'],
      duration: data['duration'],
      wage: data['wage'],
      phone: data['phone'],
      email: data['email'],
      notes: data['notes'],
      urgent: data['urgent'] ?? false,
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'])
          : null,
    );
  }
}
