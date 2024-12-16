// review.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/myreviews.dart';
import 'screens/allreviews.dart';
import 'screens/addreview.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'My Reviews'),
    const Tab(text: 'All Reviews'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews | Dinepasar'),
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
          indicatorColor: Colors.yellow,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AllReviewsPage(),
          AllReviewsPage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to AddReviewPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddReviewPage()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.yellow,
      ),
    );
  }
}
