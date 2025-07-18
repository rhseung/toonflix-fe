import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rhseung"),
        actions: [
          IconButton(icon: Icon(Icons.settings_rounded), onPressed: () {}),
        ],
        elevation: 5,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        child: Text('R', style: TextStyle(fontSize: 44)),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Rhseung',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Flexible(
              flex: 3,
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 20),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text('Item $index'),
                      subtitle: Text('Subtitle for item $index'),
                    ),
                  );
                },
                itemCount: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
