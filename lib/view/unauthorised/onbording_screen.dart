import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/bloc/onbording_bloc/onbording_bloc.dart';
import 'package:shop/config/routes/routes_name.dart';
import 'package:shop/services/onboarding_storage_service.dart';

class OnbordingScreen extends StatefulWidget {
  const OnbordingScreen({super.key});

  @override
  State<OnbordingScreen> createState() => _OnbordingScreenState();
}

class _OnbordingScreenState extends State<OnbordingScreen> {
  final PageController _pageController = PageController();

  final List<Map<String, String>> pages = [
    {
      "image": "assets/onbording_1.png",
      "title": "उन्नत किसान\nखुशहाल किसान",
      "subtitle":
          "बेहतरीन उत्पाद, सही जानकारी और समय पर सलाह – सब कुछ एक ही ऐप में।"
    },
    {
      "image": "assets/onbording_2.png",
      "title": "सभी कृषि उत्पाद\nएक ही जगह",
      "subtitle":
          "उर्वरक, बीज, कीटनाशक और अन्य सभी कृषि उत्पाद आसानी और एक साथ।"
    },
    {
      "image": "assets/onbording_3.png",
      "title": "सही जानकारी,\nबेहतर फसल",
      "subtitle":
          "मौसम, बीमारी पहचान, विशेषज्ञ सलाह और फसल सुझाव पाएं – बिल्कुल मुफ्त।"
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboardingAndNavigate(BuildContext context) async {
    await OnboardingStorageService.setOnboardingCompleted();
    if (context.mounted) {
      context.read<OnbordingBloc>().add(const CompleteOnbordingEvent());
      Navigator.pushReplacementNamed(context, RoutesName.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<OnbordingBloc, OnbordingState>(
        builder: (context, state) {
          return SafeArea(child:  Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pages.length, 
                onPageChanged: (index) {
                    context.read<OnbordingBloc>().add(PageChangedEvent(index));
                    },
                  itemBuilder: (context, index) {
                    final page = pages[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            page["image"]!,
                            height: 260,
                          ),
                          const SizedBox(height: 30),
                          Text(
                            page["title"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            page["subtitle"]!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        _pageController.jumpToPage(2);
                      },
                      child: const Text(
                        "Skip",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Row(
                      children: List.generate(
                        3,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: state.currentStep == index ? 10 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: state.currentStep == index
                                ? Colors.green
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        if (state.currentStep < 2) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                          context
                              .read<OnbordingBloc>()
                              .add(ProceedToNextStepEvent());
                        } else {
                          _completeOnboardingAndNavigate(context);
                        }
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_forward,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
              )
            ],
          )
          );
        },
      ),
    );
  }
}