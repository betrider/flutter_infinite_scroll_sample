import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final _numberOfPostsPerRequest = 10;

  final PagingController<int, Post> _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final response = await get(
          Uri.parse("https://jsonplaceholder.typicode.com/posts?_page=$pageKey&_limit=$_numberOfPostsPerRequest"));
      List responseList = json.decode(response.body);
      List<Post> postList = responseList.map((data) => Post(data['title'], data['body'])).toList();
      final isLastPage = postList.length < _numberOfPostsPerRequest;
      if (isLastPage) {
        _pagingController.appendLastPage(postList);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(postList, nextPageKey);
      }
    } catch (e) {
      print("error --> $e");
      _pagingController.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blog App"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() => _pagingController.refresh()),
        child: PagedListView<int, Post>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Post>(
            itemBuilder: (context, item, index) => Text("title: ${item.title}"),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

class Post {
  final String title;
  final String body;
  Post(this.title, this.body);
}
