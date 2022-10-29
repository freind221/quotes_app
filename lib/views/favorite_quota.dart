import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quota_app/controller/db_handler.dart';
import 'package:quota_app/models/search_model.dart';
import 'package:quota_app/providers/app_provider.dart';

class FavQuota extends StatefulWidget {
  static String routeName = '/fav';
  const FavQuota({Key? key}) : super(key: key);

  @override
  State<FavQuota> createState() => _FavQuotaState();
}

class _FavQuotaState extends State<FavQuota> {
  final searchController = TextEditingController();
  final edit = TextEditingController();
  final editAuthor = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: 'Search Your Quote',
                  suffixIcon: searchController.text.isEmpty
                      ? const Icon(Icons.search)
                      : GestureDetector(
                          onTap: () {
                            //searchController.text = "";
                            provider.updateSomeValue("", true);
                            searchController.text = provider.someValue;
                            //setState(() {});
                          },
                          child: const Icon(Icons.clear)),
                ),
                onChanged: (value) {
                  provider.updateSomeValue(searchController.text, true);
                  value = provider.someValue;
                  //setState(() {});
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: noteslist,
                  builder: ((context, AsyncSnapshot<List<Searches>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: ((context, index) {
                          String name = snapshot.data![index].content!;
                          String authorName = snapshot.data![index].author!;
                          if (searchController.text.isEmpty) {
                            return Dismissible(
                              background: Container(
                                decoration:
                                    const BoxDecoration(color: Colors.red),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: const Icon(Icons.delete_forever),
                              ),
                              onDismissed: (direction) {
                                dBhelper!.delete(snapshot.data![index].sId!);
                                provider.getData();
                                noteslist = provider.getData();
                                snapshot.data!.remove(snapshot.data![index]);
                              },
                              key: ValueKey<int>(snapshot.data![index].sId!),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.all(8),
                                elevation: 0,
                                color: Colors.grey.shade300,
                                child: ListTile(
                                  title: Text(
                                    snapshot.data![index].content.toString(),
                                  ),
                                  subtitle: Text(snapshot.data![index].author!),
                                  trailing: PopupMenuButton(
                                      icon: const Icon(Icons.more_vert),
                                      itemBuilder: ((context) => [
                                            PopupMenuItem(
                                                child: ListTile(
                                              onTap: (() {
                                                Navigator.pop(context);
                                                // Here we have tp pass title and id of that title to out dunction
                                                // We got the ID by firebaseAnimated list
                                                showDialog(
                                                    context: context,
                                                    builder: ((context) {
                                                      edit.text = name;
                                                      editAuthor.text =
                                                          authorName;
                                                      return AlertDialog(
                                                        alignment:
                                                            Alignment.center,
                                                        title: const Text(
                                                            'Update'),
                                                        content: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            TextFormField(
                                                              controller: edit,
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            TextFormField(
                                                              controller:
                                                                  editAuthor,
                                                            ),
                                                          ],
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'Cancel')),
                                                          TextButton(
                                                              onPressed: () {
                                                                dBhelper!.update(Searches(
                                                                    sId: snapshot
                                                                        .data![
                                                                            index]
                                                                        .sId,
                                                                    content: edit
                                                                        .text,
                                                                    author: editAuthor
                                                                        .text));

                                                                noteslist =
                                                                    provider
                                                                        .getData();
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'Update')),
                                                        ],
                                                      );
                                                    }));
                                              }),
                                              title: const Text('Edit'),
                                              leading: const Icon(Icons.edit),
                                            )),
                                            PopupMenuItem(
                                                child: ListTile(
                                              onTap: (() {
                                                dBhelper!.deleteTable();

                                                noteslist = provider.getData();
                                                Navigator.pop(context);

                                                // Here we used the ID to delete message from databse
                                              }),
                                              title: const Text('Delete All'),
                                              leading: const Icon(Icons.delete),
                                            ))
                                          ])),
                                ),
                              ),
                            );
                          } else if (name
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase())) {
                            return Dismissible(
                              background: Container(
                                decoration:
                                    const BoxDecoration(color: Colors.red),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: const Icon(Icons.delete_forever),
                              ),
                              onDismissed: (direction) {
                                dBhelper!.delete(snapshot.data![index].sId!);
                                provider.getData();
                                noteslist = provider.getData();
                                snapshot.data!.remove(snapshot.data![index]);
                                // setState(() {
                                //   dBhelper!.delete(snapshot.data![index].sId!);
                                //   noteslist = dBhelper!.getNotes();
                                //   snapshot.data!.remove(snapshot.data![index]);
                                // });
                              },
                              key: ValueKey<int>(snapshot.data![index].sId!),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.all(8),
                                elevation: 0,
                                color: Colors.grey.shade300,
                                child: ListTile(
                                  title: Text(
                                    snapshot.data![index].content.toString(),
                                  ),
                                  subtitle: Text(
                                    snapshot.data![index].author.toString(),
                                  ),
                                  trailing: PopupMenuButton(
                                      icon: const Icon(Icons.more_vert),
                                      itemBuilder: ((context) => [
                                            PopupMenuItem(
                                                child: ListTile(
                                              onTap: (() {
                                                Navigator.pop(context);

                                                showDialog(
                                                    context: context,
                                                    builder: ((context) {
                                                      edit.text = name;
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Update'),
                                                        content: Column(
                                                          children: [
                                                            TextFormField(
                                                              controller: edit,
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            TextFormField(
                                                              controller:
                                                                  editAuthor,
                                                            ),
                                                          ],
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'Cancel')),
                                                          TextButton(
                                                              onPressed: () {
                                                                dBhelper!
                                                                    .update(
                                                                  Searches(
                                                                      sId: snapshot
                                                                          .data![
                                                                              index]
                                                                          .sId,
                                                                      content: edit
                                                                          .text,
                                                                      author: editAuthor
                                                                          .text),
                                                                );

                                                                noteslist =
                                                                    provider
                                                                        .getData();
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'Update')),
                                                        ],
                                                      );
                                                    }));
                                              }),
                                              title: const Text('Edit'),
                                              leading: const Icon(Icons.edit),
                                            )),
                                            PopupMenuItem(
                                                child: ListTile(
                                              onTap: (() {
                                                dBhelper!.deleteTable();

                                                noteslist = provider.getData();
                                                Navigator.pop(context);

                                                // Here we used the ID to delete message from databse
                                              }),
                                              title: const Text('Delete All'),
                                              leading: const Icon(Icons.delete),
                                            ))
                                          ])),
                                ),
                              ),
                            );
                          }
                          return Container();
                        }));
                  })),
            ),
          ],
        ),
      ),
    );
  }
}
