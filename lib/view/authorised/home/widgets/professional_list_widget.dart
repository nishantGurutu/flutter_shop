import 'package:flutter/material.dart';
import 'package:shop/model/home/home_model.dart';
import 'package:shop/model/professional/professional_model.dart';

class ProfessionalListWidget extends StatelessWidget {
  final List<UserModel> users;
  final bool isLoading;

  const ProfessionalListWidget({
    super.key,
    required this.users,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (users.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text("No professionals found.")),
      );
    }

    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: users.length,
        clipBehavior: Clip.none,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final user = users[index];
          final String rating = "4.${9 - (index % 5)}";

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                'professional_profile_screen',
                arguments: ProfessionalModel(
                  id: index.toString(),
                  name: user.name.isNotEmpty ? user.name : "Professional",
                  title: user.profession.isNotEmpty
                      ? user.profession
                      : "Service",
                  imageUrl: user.imageUrl.isNotEmpty
                      ? user.imageUrl
                      : 'https://images.unsplash.com/photo-1540569014015-19a7be504e3a?q=80&w=150&auto=format&fit=crop',
                  rating: double.tryParse(rating) ?? 4.0,
                  reviewsCount: 15,
                  distance: 1.5,
                  timeEstimate: '1 hr',
                  servicesOffered: ['Service 1', 'Service 2', 'Service 3'],
                  portfolioImages: [
                    'https://images.pexels.com/photos/3483098/pexels-photo-3483098.jpeg?auto=compress&cs=tinysrgb&w=300',
                    'https://images.pexels.com/photos/1080616/pexels-photo-1080616.jpeg?auto=compress&cs=tinysrgb&w=300',
                  ],
                ),
              );
            },
            child: Container(
              width: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.network(
                      user.imageUrl.isNotEmpty
                          ? user.imageUrl
                          : 'https://images.unsplash.com/photo-1540569014015-19a7be504e3a?q=80&w=150&auto=format&fit=crop',
                      height: 110,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 110,
                          width: double.infinity,
                          color: Colors.grey.shade300,
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.profession.isNotEmpty
                              ? user.profession
                              : "Service",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF1E2843),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "$rating - 15",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
