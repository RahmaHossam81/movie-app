import 'package:flutter/material.dart';
import 'package:movie/screens/login_screen.dart';
import 'package:movie/utils/app_assets.dart';
import 'package:movie/utils/app_colors.dart';
import 'package:movie/utils/app_styles.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = 'onboarding_screen';

  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _controller = PageController();
  int index = 0;

  Widget buildOnboardingPage({
    required String image,
    required int color,
    required String title,
    required String description,
    required String nextButton,
    required String backButton,
  }) {
    return Container(
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              image,
              fit: BoxFit.fill,
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(color),
                    Color(color).withOpacity(0),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppStyles.bold24white,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      description,
                      style: AppStyles.regular20white,
                      textAlign: TextAlign.center,
                    ),
                    if (index == 1)

                      ElevatedButton(
                        onPressed: () {
                          _controller.animateToPage(
                            index + 1,
                            duration: Duration(milliseconds: 250),
                            curve: Curves.linear,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.yallow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 110, vertical: 12),
                          child: Text(nextButton,
                              style: AppStyles.semiBold20black),
                        ),
                      )
                    else if (index == 5)
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, LoginScreen.routeName);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.yallow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 110, vertical: 12),
                              child: Text(nextButton,
                                  style: AppStyles.semiBold20black),
                            ),
                          ),
                          SizedBox(height: 16),

                          ElevatedButton(
                            onPressed: () {
                              _controller.animateToPage(
                                index - 1,
                                duration: Duration(milliseconds: 250),
                                curve: Curves.linear,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.black,
                              side:
                              BorderSide(color: AppColors.yallow, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 110, vertical: 12),
                              child: Text(backButton,
                                  style: AppStyles.semiBold20yallow),
                            ),
                          ),
                        ],
                      )
                    else

                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _controller.animateToPage(
                                index + 1,
                                duration: Duration(milliseconds: 250),
                                curve: Curves.linear,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.yallow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 110, vertical: 12),
                              child: Text(nextButton,
                                  style: AppStyles.semiBold20black),
                            ),
                          ),
                          SizedBox(height: 16),

                          ElevatedButton(
                            onPressed: () {
                              _controller.animateToPage(
                                index - 1,
                                duration: Duration(milliseconds: 250),
                                curve: Curves.linear,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.black,
                              side:
                              BorderSide(color: AppColors.yallow, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 110, vertical: 12),
                              child: Text(backButton,
                                  style: AppStyles.semiBold20yallow),
                            ),
                          ),
                        ],
                      ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: PageView(
        onPageChanged: (value) {
          setState(() {
            index = value;
          });
        },
        controller: _controller,
        children: [
          Container(
            decoration: BoxDecoration(color: AppColors.black),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  AppAssets.onboarding1,
                  width: width,
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Find Your Next \nFavorite Movie Here",
                        textAlign: TextAlign.center,
                        style: AppStyles.mediem36white,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Get access to a huge library of movies to suit all tastes. You will surely like it.",
                        style: AppStyles.regular20gray,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          _controller.animateToPage(
                            index + 1,
                            duration: Duration(milliseconds: 250),
                            curve: Curves.linear,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.yallow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 70, vertical: 12),
                          child: Text("Explore Now",
                              style: AppStyles.semiBold20black),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          buildOnboardingPage(
            image: AppAssets.onboarding2,
            color: 0xff084250,
            title: "Discover Movies",
            description:
            "Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.",
            nextButton: "Next",
            backButton: "",
          ),
          buildOnboardingPage(
            image: AppAssets.onboarding3,
            color: 0xff85210E,
            title: "Explore All Genres",
            description:
            "Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.",
            nextButton: "Next",
            backButton: "Back",
          ),
          buildOnboardingPage(
            image: AppAssets.onboarding4,
            color: 0xff4C2471,
            title: "Create Watchlists",
            description:
            "Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.",
            nextButton: "Next",
            backButton: "Back",
          ),
          buildOnboardingPage(
            image: AppAssets.onboarding5,
            color: 0xff601321,
            title: "Rate, Review, and Learn",
            description:
            "Share your thoughts on the movies you've watched. Dive deep into film details and help others discover great movies with your reviews.",
            nextButton: "Next",
            backButton: "Back",
          ),
          buildOnboardingPage(
            image: AppAssets.onboarding6,
            color: 0xff2A2C30,
            title: "Start Watching Now",
            description: "",
            nextButton: "Finish",
            backButton: "Back",
          )
        ],
      ),
    );
  }
}