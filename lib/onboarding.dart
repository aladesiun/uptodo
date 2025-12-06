import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      image: 'assets/images/onboarding/one.png',
      title: 'Manage your tasks',
      description:
          'You can easily manage all of your daily tasks in DoMe for free',
    ),
    OnboardingData(
      image: 'assets/images/onboarding/two.png',
      title: 'Create daily routine',
      description:
          'In Uptodo  you can create your personalized routine to stay productive',
    ),
    OnboardingData(
      image: 'assets/images/onboarding/three.png',
      title: 'Orgonaize your tasks',
      description:
          'You can organize your daily tasks by adding your tasks into separate categories',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn,
      );
    } else {
      _navigateToHome();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // top bar skip button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "SKIP",
                  style: TextStyle(
                    color: Color(0xFFAFAFAF),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Lato',
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    data: _pages[index],
                    pageController: _pageController,
                    length: _pages.length,
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  // Navigation buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button
                      Opacity(
                        opacity: _currentPage > 0 ? 1 : 0,
                        child: TextButton(
                          onPressed: _currentPage > 0 ? _previousPage : null,
                          child: Text(
                            'BACK',
                            style: TextStyle(
                              color: Color(0xFFAFAFAF),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Lato',
                            ),
                          ),
                        ),
                      ),

                      // NEXT BUTTON
                      ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff8875FF),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          _currentPage == _pages.length - 1
                              ? "GET STARTED"
                              : 'NEXT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Lato',
                          ),
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
  }
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  final PageController pageController;
  final int length;

  const OnboardingPage({
    super.key,
    required this.data,
    required this.pageController,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Image.asset(data.image, fit: BoxFit.contain, height: 300, width: 200),
          const SizedBox(height: 40),
          SmoothPageIndicator(
            controller: pageController,
            count: length,
            effect: ExpandingDotsEffect(
              dotColor: Color(0XFFAFAFAF),
              activeDotColor: const Color(0xFFFFFFFFDE),
              dotHeight: 6,
              dotWidth: 30,
              spacing: 8,
              expansionFactor: 1.2,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            data.title,
            style: TextStyle(
              color: Color(0XFFFFFFFFDE),
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lato',
            ),
          ),
          const SizedBox(height: 20),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0XFFFFFFFFDE),
              fontSize: 16,
              fontWeight: FontWeight.w300,
              fontFamily: 'Lato',
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String image;
  final String title;
  final String description;

  OnboardingData({
    required this.image,
    required this.title,
    required this.description,
  });
}
