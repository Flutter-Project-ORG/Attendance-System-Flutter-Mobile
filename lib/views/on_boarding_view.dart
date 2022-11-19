import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../view_model/on_boarding_view_model.dart';
import 'auth_view.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final OnBoardingViewModel _viewModel = OnBoardingViewModel();

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
                titleTextStyle: Theme.of(context).textTheme.bodyText1!,
              ),
              title: "Latest News",
              bodyWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Stay informed of the latest news",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText2!,
                    ),
                  ),
                ],
              ),
              image: Center(child: Image.asset('assets/images/news.png')),
            ),
            PageViewModel(
              decoration: PageDecoration(
                pageColor: Color.fromARGB(255, 56, 54, 54),
                titleTextStyle: Theme.of(context).textTheme.bodyText1!,
              ),
              title: "Scan QR",
              bodyWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Scan QR to take attendance",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText2!,
                    ),
                  ),
                ],
              ),
              image: Center(child: Image.asset('assets/images/qr_scan.gif')),
            ),
            PageViewModel(
              decoration: PageDecoration(
                pageColor: Color.fromARGB(255, 56, 54, 54),
                titleTextStyle: Theme.of(context).textTheme.bodyText1!,
              ),
              title: "To Do Reminder",
              bodyWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Reminders are useful because they keep us organized and on task in our daily lives and offer valuable support to students.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText2!,
                    ),
                  ),
                ],
              ),
              image: Center(child: Image.asset('assets/images/todo.png')),
            ),
            PageViewModel(
              decoration: PageDecoration(
                pageColor: Color.fromARGB(255, 56, 54, 54),
                titleTextStyle: Theme.of(context).textTheme.bodyText1!,
              ),
              title: "View Profile",
              bodyWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "View all Information About user profile  ",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText2!,
                    ),
                  ),
                ],
              ),
              image:
                  Center(child: Image.asset('assets/images/infoprofile.png')),
            ),
          ],
          onDone: () async {
            await _viewModel.onBoardingFinished();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => AuthView()));
          },
          showNextButton: true,
          next: const Icon(
            Icons.arrow_forward,
            color: Color.fromARGB(255, 56, 54, 54),
          ),
          done: const Text(
            "Done",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.orange,
                fontSize: 18),
          ),
          dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: Colors.orange.shade800,
            color: Color.fromARGB(255, 56, 54, 54),
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
      ),
    );
  }
}
