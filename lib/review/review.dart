// review.dart

import 'package:flutter/material.dart';
import 'screens/myreviews.dart';
import 'screens/allreviews.dart';
import 'widgets/addreview.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});
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
        title: const Text(
          'Let\'s Taste the World Through Reviews!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Color.fromRGBO(202, 138, 4, 1),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(255, 242, 229, 1),
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
          MyReviewsPage(),
          AllReviewsPage(),
        ],
      ),
    );
  }
}
