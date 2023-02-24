import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _surname = TextEditingController();

  List<Map<String, dynamic>> items = [];

  final databox = Hive.box("Data_box");

  @override
  void initState() {
    // TODO: implement initState
    _refresh();
  }

  void _refresh() {
    final data = databox.keys.map((key) {
      final item = databox.get(key);

      return {"key": key, "name": item["name"], "surname": item["surname"]};
    }).toList();

    setState(() {
      items = data.reversed.toList();
      print(items.length);
    });
  }

  Future<void> creatItem(Map<String, dynamic> newitem) async {
    await databox.add(newitem);
    _refresh();
  }

  Future<void> updateItem(int itemkey, Map<String, dynamic> item) async {
    await databox.put(itemkey, item);
    _refresh();
  }

  Future<void> deleteitem(int itemkey) async {
    await databox.delete(itemkey);
    _refresh();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("An item has been deleted"),
      ),
    );
  }

  _showform(BuildContext context, int? itemkeys) {
    if (itemkeys != null) {
      final existingItem =
          items.firstWhere((element) => element["key"] == itemkeys);
      _name.text = existingItem["name"];
      _surname.text = existingItem["surname"];
    }else {
      scaffoldKey.currentState?.showBottomSheet(
            (context) => Container(
          color: Colors.grey,
          padding: EdgeInsets.only(
            bottom: 15,
            top: 15,
            right: 15,
            left: 15,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _name,
                decoration: const InputDecoration(hintText: "Name"),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                decoration: const InputDecoration(hintText: "Surname"),
                controller: _surname,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  creatItem({
                    "name": _name.text,
                    "surname": _surname.text,
                  });

                  if (itemkeys != null) {
                    updateItem(itemkeys, {
                      "name": _name.text.trim(),
                      "surname": _surname.text.trim(),
                    });
                  }

                  _name.text = "";
                  _surname.text = "";

                  Navigator.of(context).pop();
                },
                child: itemkeys == null ? Text("Create New") : Text("Update"),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      );

    }

    scaffoldKey.currentState?.showBottomSheet(
      (context) => Container(
        color: Colors.grey,
        padding: EdgeInsets.only(
          bottom: 15,
          top: 15,
          right: 15,
          left: 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(hintText: "Name"),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              decoration: const InputDecoration(hintText: "Surname"),
              controller: _surname,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                creatItem({
                  "name": _name.text,
                  "surname": _surname.text,
                });

                if (itemkeys != null) {
                  updateItem(itemkeys, {
                    "name": _name.text.trim(),
                    "surname": _surname.text.trim(),
                  });
                }

                _name.text = "";
                _surname.text = "";

                Navigator.of(context).pop();
              },
              child: itemkeys == null ? Text("Create New") : Text("Update"),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text("Hive Example"),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, index) {
          final currentItem = items[index];

          return Card(
            color: Colors.orange,
            child: ListTile(
              title: Text("Name is ${currentItem["name"]}"),
              subtitle: Text("Surname is ${currentItem["surname"]}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      _showform(context, currentItem['key']);
                    },
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      deleteitem(currentItem["key"]);
                    },
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showform(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
