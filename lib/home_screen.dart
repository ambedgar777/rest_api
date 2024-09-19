import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api/models/GetPostModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ///because we are returning the list in the future model
  ///we created a list variable and initialized it.
  List<GetPostModel> postList = [];

  ///future method
  ///we are creating the Future method just because API will send data in the future and it takes some milli seconds
  ///We are giving it list because the response of the API is a list itself
  ///and in the list we are giving the class name it means it will fetch all the data in the list.
  Future<List<GetPostModel>> getPostApi() async {
    ///we are creating a variable named response which will take URL of our API, response is final,
    ///it will be awaited, means it wait for the response.
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    ///whatever the value we are getting we are decoding it first using the jsonDecode constructor.
    var data = jsonDecode(response.body.toString());

    ///we are using the if condition to check the status code
    ///if the status code is 200 we will use for loop to get the data
    ///otherwise we will return else condition
    if (response.statusCode == 200) {
      for (Map i in data) {
        //using the postList variable we have added Json data in it using the for loop.
        postList.add(GetPostModel.fromJson(i));
      }
      //returning the post list now.
      return postList;
    } else {
      //in the else we are again returning the postList variable.
      return postList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: const Text('REST API'),
        backgroundColor: Colors.purple.shade200,
      ),
      body: Column(
        children: [
          ///finally our integration is completed, now will use the api data into our app
          ///future builder is used to use to API data in the app, it take future and builder
          ///FutureBuilder waits for the response and then builds the widget in the app.
          ///future takes the method of api integration and builder takes context and snapshot

          Expanded(
            child: FutureBuilder(
              future: getPostApi(),
              builder: (context, snapshot) {
                ///we are using the if statement again, in the condition we will check if the snapshot has data or not
                ///if it has then return the data otherwise return the text "loading".
                if (!snapshot.hasData) {
                  return const Text('Loading');
                } else {
                  return ListView.builder(
                    itemCount: postList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(12),
                        height: 240,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Title: ${postList[index].title}",
                                style: const TextStyle(
                                  color: Colors.purple,
                                ),
                              ),
                              Text(
                                "ID: ${postList[index].id}",
                                style: TextStyle(
                                  color: Colors.purple.shade400,
                                ),
                              ),
                              Text(
                                "UserID: ${postList[index].userId}",
                                style: TextStyle(
                                  color: Colors.purple.shade300,
                                ),
                              ),
                              Text(
                                "Body: ${postList[index].body}",
                                style: TextStyle(
                                  color: Colors.purple.shade200,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
