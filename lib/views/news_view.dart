import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class NewsView extends StatefulWidget {
  const NewsView({Key? key}) : super(key: key);

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  Query dbNewsRef = FirebaseDatabase.instance.ref('news');

  Widget listItem({required Map news}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 220.0,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32.0),
              bottomRight: Radius.circular(32.0),
            ),
            image: DecorationImage(
              opacity: 0.5,
              fit: BoxFit.cover,
              image: NetworkImage(news['imageLink']),
            ),
          ),
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                news['title'],
                style: Theme.of(context).textTheme.headline2,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                news['subtitle'],
                style: Theme.of(context).textTheme.headline3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latest news'),
      ),
      body: FirebaseAnimatedList(
        query: dbNewsRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map theNews = snapshot.value as Map;
          theNews['key'] = snapshot.key;
          return listItem(news: theNews);
        },
      ),
    );
  }
}
