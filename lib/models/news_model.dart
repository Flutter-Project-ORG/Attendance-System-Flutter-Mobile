import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsModel {
  void getNews() async {
    Uri myUrl = Uri.parse(
        "https://attendance-system-98e2b-default-rtdb.europe-west1.firebasedatabase.app/news.json%22");

    http.Response response = await http.get(myUrl);

    List data = jsonDecode(response.body);
    print(data.toString());
  }
}
