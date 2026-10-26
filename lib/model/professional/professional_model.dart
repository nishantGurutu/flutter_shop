class ProfessionalModel {
  final String id;
  final String name;
  final String title;
  final String imageUrl;
  final double rating;
  final int reviewsCount;
  final double distance;
  final String timeEstimate;
  final List<String> servicesOffered;
  final List<String> portfolioImages;

  ProfessionalModel({
    required this.id,
    required this.name,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.reviewsCount,
    required this.distance,
    required this.timeEstimate,
    this.servicesOffered = const [],
    this.portfolioImages = const [],
  });
}
