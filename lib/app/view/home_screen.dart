import 'package:flutter/material.dart';
import 'package:toonflix_fe/util/error_handler.dart';
import 'package:toonflix_fe/app/viewmodel/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel();
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadPosts();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted && _viewModel.hasError) {
      ErrorHandler.showErrorSnackBar(context, _viewModel.errorMessage!);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Toonflix"),
        actions: [IconButton(icon: Icon(Icons.add_rounded), onPressed: () {})],
        elevation: 5,
        centerTitle: false,
      ),
      body: _viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _viewModel.isEmpty
          ? const Center(child: Text('포스트가 없습니다'))
          : RefreshIndicator(
              onRefresh: _viewModel.refresh,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final post = _viewModel.posts[index];
                    return Card(
                      elevation: 0,
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            _viewModel.getUserAvatarText(post),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        title: Text(
                          _viewModel.getUserName(post),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          post.content,
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _viewModel.getPostClickMessage(post),
                              ),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  itemCount: _viewModel.posts.length,
                ),
              ),
            ),
    );
  }
}
