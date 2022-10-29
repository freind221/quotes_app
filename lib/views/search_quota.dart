import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quota_app/controller/db_handler.dart';
import 'package:quota_app/models/search_model.dart';
import 'package:quota_app/providers/app_provider.dart';
import 'package:quota_app/services/remote_services.dart';

import 'package:quota_app/utilis/message.dart';

class SearchQouta extends StatefulWidget {
  static String routName = '/searchQ';
  const SearchQouta({super.key});

  @override
  State<SearchQouta> createState() => _SearchQoutaState();
}

class _SearchQoutaState extends State<SearchQouta> {
  final _textEditingController = TextEditingController();

  DBhelper? dBhelper;
  late Future<List<Searches>> noteslist;

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    dBhelper = DBhelper();
    loadData();
    RemoteService().fetchSearches(
        Provider.of<AppProvider>(context, listen: false).someValue, 10);
    print(Provider.of<AppProvider>(context, listen: false).someValue);
    _textEditingController.text =
        Provider.of<AppProvider>(context, listen: false).someValue;
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
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                      hintText: 'Enter Topic Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Colors.grey, width: 1.8))),
                  onFieldSubmitted: (value) {
                    provider.updateSomeValue(_textEditingController.text, true);
                    value = provider.someValue;

                    //value = provider.controller.text;
                    check = provider.check;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          provider.decrement();
                        },
                        icon: const Icon(Icons.minimize_rounded)),
                    Text(provider.limit.toString()),
                    IconButton(
                        onPressed: () {
                          provider.increment();
                        },
                        icon: const Icon(Icons.add)),
                  ],
                ),
              ),
              check
                  ? Expanded(
                      child: FutureBuilder(
                        future: remoteService.fetchSearches(
                            _textEditingController.text, provider.limit),
                        builder:
                            ((context, AsyncSnapshot<List<dynamic>?> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: Text('No Such Quote'));
                          }

                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
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
                                            Icons.add_reaction_rounded)),
                                  ));
                            },
                          );
                        }),
                      ),
                    )
                  : const Center(child: Icon(Icons.quora)),
            ],
          ),
        ),
      ),
    );
  }
}
