import 'package:attendance_system_flutter_mobile/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: IntroductionScreen(
          pages: [
            PageViewModel(
              decoration: PageDecoration(
                  pageColor: Color.fromARGB(255, 56, 54, 54),
                  titleTextStyle:
                      TextStyle(color: Color.fromARGB(255, 223, 220, 220))),
              title: "Scan QRA",
              bodyWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Scan QRA to take attendance",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 223, 220, 220)),
                    ),
                  ),
                ],
              ),
              image: Center(child: Image.asset('assets/images/scan.jpg')),
            ),
            PageViewModel(
              decoration: PageDecoration(
                  pageColor: Color.fromARGB(255, 56, 54, 54),
                  titleTextStyle:
                      TextStyle(color: Color.fromARGB(255, 223, 220, 220))),
              title: "Get Books  ",
              bodyWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Search for Any Book you want it  ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 223, 220, 220)),
                    ),
                  ),
                ],
              ),
              image: Center(child: Image.asset('assets/images/book.jpg')),
            ),
            PageViewModel(
              decoration: PageDecoration(
                  pageColor: Color.fromARGB(255, 56, 54, 54),
                  titleTextStyle:
                      TextStyle(color: Color.fromARGB(255, 223, 220, 220))),
              title: "View Profile",
              bodyWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "View all Information About user profile  ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 223, 220, 220)),
                    ),
                  ),
                ],
              ),
              image: Center(child: Image.asset('assets/images/info.jpg')),
            ),
          ],
          onDone: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => SplashView()));
          },
          showNextButton: true,
          next: const Icon(
            Icons.arrow_forward,
            color: Color.fromARGB(255, 56, 54, 54),
          ),
          done: const Text("Done",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.orange,
                  fontSize: 18)),
          dotsDecorator: DotsDecorator(
              size: const Size.square(10.0),
              activeSize: const Size(20.0, 10.0),
              activeColor: Colors.orange.shade800,
              color: Color.fromARGB(255, 56, 54, 54),
              spacing: const EdgeInsets.symmetric(horizontal: 3.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0))),
        ),
      ),
    );
  }
}
