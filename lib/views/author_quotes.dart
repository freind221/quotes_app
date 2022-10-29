import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quota_app/controller/db_handler.dart';
import 'package:quota_app/models/search_model.dart';
import 'package:quota_app/providers/app_provider.dart';
import 'package:quota_app/services/remote_services.dart';

import 'package:quota_app/utilis/message.dart';

class AuthorQuotes extends StatefulWidget {
  static String routName = '/search';
  const AuthorQuotes({super.key});

  @override
  State<AuthorQuotes> createState() => _AuthorQuotesState();
}

class _AuthorQuotesState extends State<AuthorQuotes> {
  final _textEditingController = TextEditingController();

  DBhelper? dBhelper;
  late Future<List<Searches>> noteslist;

  @override
  void initState() {
    super.initState();
    dBhelper = DBhelper();
    loadData();
  }

  loadData() async {
    noteslist = dBhelper!.getNotes();
  }

  bool check = false;
  @override
  Widget build(BuildContext context) {
    final remoteService = RemoteService();
    final provider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _textEditingController,
                decoration: InputDecoration(
                    hintText: 'Enter Author Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.8))),
                onFieldSubmitted: (value) {
                  provider.setText(_textEditingController.text, true);
                  value = provider.text;
                  check = provider.authorCheck;
                },
              ),
            ),
            check
                ? Expanded(
                    child: FutureBuilder(
                      future: remoteService.fetchSearches(
                          _textEditingController.text, 1),
                      builder:
                          ((context, AsyncSnapshot<List<dynamic>?> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                              child: Text('No Quote by this Author'));
                        }

                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            String name = snapshot.data![index]['author'];
                            if (name.toLowerCase().contains(
                                _textEditingController.text.toLowerCase())) {
                              return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  margin: const EdgeInsets.all(8),
                                  elevation: 0,
                                  color: Colors.grey.shade300,
                                  child: ListTile(
                                    title: Text(snapshot.data![index]['content']
                                        .toString()),
                                    subtitle: Text(snapshot.data![index]
                                            ['length']
                                        .toString()),
                                    trailing: IconButton(
                                        onPressed: () {
                                          dBhelper!
                                              .insert(Searches(
                                                  author: snapshot.data![index]
                                                      ['author'],
                                                  content: snapshot.data![index]
                                                      ['content'],
                                                  //tags: toDo['tags'],
                                                  authorId: snapshot
                                                      .data![index]['authorId'],
                                                  authorSlug:
                                                      snapshot.data![index]
                                                          ['authorSlug'],
                                                  length: snapshot.data![index]
                                                      ['length'],
                                                  dateAdded:
                                                      snapshot.data![index]
                                                          ['dateAdded'],
                                                  dateModified:
                                                      snapshot.data![index]
                                                          ['dateModified']))
                                              .then((value) {
                                            Message.toatsMessage(
                                                "Added to database");
                                          }).onError((error, stackTrace) {
                                            Message.toatsMessage(
                                                error.toString());
                                          });
                                          provider.getData();
                                          // setState(() {
                                          //   noteslist = dBhelper!.getNotes();
                                          // });
                                        },
                                        icon: const Icon(
                                            Icons.favorite_outlined)),
                                  ));
                            } else if (_textEditingController.text.isEmpty) {
                              return const Center(child: Icon(Icons.quora));
                            }
                            return Container();
                          },
                        );
                      }),
                    ),
                  )
                : const Center(child: Icon(Icons.quora)),
          ],
        ),
      ),
    );
  }
}
