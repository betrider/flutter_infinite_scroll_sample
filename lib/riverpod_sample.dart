
// import 'package:flutter/material.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   MyHomePageState createState() => MyHomePageState();
// }

// class MyHomePageState extends State<MyHomePage> {
//   final numberOfPostsPerRequest = 10;

//   final PagingController<int, PostModel> pagingController = PagingController(firstPageKey: 0);

//   @override
//   void initState() {
//     pagingController.addPageRequestListener((pageKey) {
//       _fetchPage(pageKey);
//     });
//     super.initState();
//   }

//   Future<void> _fetchPage(int pageKey) async {
//     try {
//       final result = await globalProviderContainer.read(usersDataFutureProvider(pageKey).future);
//       if (result.isSuccess) {
//         final postList = result.data!;
//         final isLastPage = postList.length < numberOfPostsPerRequest;
//         if (isLastPage) {
//           pagingController.appendLastPage(postList);
//         } else {
//           final nextPageKey = pageKey + 1;
//           pagingController.appendPage(postList, nextPageKey);
//         }
//       } else {
//         print("error --> ${result.reasonPhrase}");
//         pagingController.error = result.reasonPhrase;
//       }
//     } catch (e) {
//       print("error --> $e");
//       pagingController.error = e;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: RefreshIndicator(
//         onRefresh: () => Future.sync(() {
//           globalProviderContainer.invalidate(usersDataFutureProvider);
//           pagingController.refresh();
//         }),
//         child: PagedListView<int, PostModel>(
//           pagingController: pagingController,
//           builderDelegate: PagedChildBuilderDelegate<PostModel>(
//             itemBuilder: (context, item, index) => Text("title: ${item.title}"),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     pagingController.dispose();
//     super.dispose();
//   }
// }

// class PostModel {
//   final int id;
//   final int userId;
//   final String title;
//   final String body;

//   PostModel({
//     required this.id,
//     required this.userId,
//     required this.title,
//     required this.body,
//   });

//   static List<PostModel> fromList(List resultMap) {
//     return List<PostModel>.from(
//       resultMap.map((x) => PostModel.fromMap(x))
//     );
//   }

//   factory PostModel.fromMap(Map<String, dynamic> map) {
//     return PostModel(
//       id: map['id']?.toInt(),
//       userId: map['userId']?.toInt(),
//       title: map['title'],
//       body: map['body'],
//     );
//   }
// }

// final usersDataFutureProvider = FutureProvider.family<DataOrFailure<List<PostModel>>, int>(
//   (ref, pageNumber) {
//     return ref.read(apiProvider).getUsers(pageNumber);
//   },
//   name: 'usersDataFutureProvider',
// );

// final apiProvider = Provider<ApiService>((ref) => ApiService());

// class ApiService {

//   final Map<String,String> headers = {'Content-Type': 'application/json; charset=UTF-8'};

//   Future<DataOrFailure<PostModel>> getUser() async {
//     try {
//       Response response = await get(Uri.parse('$endPoint/1'), headers: headers);
//       return DataOrFailure.withData(response: response, fromMap: PostModel.fromMap);
//     } catch (e) {
//       return DataOrFailure.withFailure(e);
//     }
//   }

//   Future<DataOrFailure<List<PostModel>>> getUsers(int pageNumber) async {
//     try {
//       Response response = await get(Uri.parse('$endPoint?_page=$pageNumber'), headers: headers);
//       return DataOrFailure.withDataList(response: response, fromList: PostModel.fromList);
//     } catch (e) {
//       return DataOrFailure.withFailure(e);
//     }
//   }
// }