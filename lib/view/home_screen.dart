import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Toonflix"),
        actions: [IconButton(icon: Icon(Icons.add_rounded), onPressed: () {})],
        elevation: 5,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 20),
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return Card(
              elevation: 0,
              child: ListTile(
                leading: CircleAvatar(child: Text('G')),
                title: Text('Item $index'),
                subtitle: Text('Subtitle for item $index'),
              ),
            );
          },
          itemCount: 20,
        ),
      ),
    );
  }
}
