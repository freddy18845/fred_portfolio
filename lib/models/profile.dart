class Profile {
  final String name, role, location, phone, workEmail, personalEmail, linkedIn;
  final String headline, aboutLead, quote, achievement;
  final List<String> skills;
  final String whatsapp;
// and in the constructor:


  const Profile({
    required this.name,
    required this.role,
    required this.location,
    required this.phone,
    required this.workEmail,
    required this.personalEmail,
    required this.linkedIn,
    required this.headline,
    required this.aboutLead,
    required this.quote,
    required this.achievement,
    required this.skills,
    required this.whatsapp,
  });
}
