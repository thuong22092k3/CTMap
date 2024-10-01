import 'package:ctmap/pages/screens/News/law_sheet.dart';
import 'package:ctmap/pages/screens/News/news_sheet.dart';
import 'package:ctmap/widgets/components/Button/Button.dart';
import 'package:flutter/material.dart';
import '../../../assets/colors/colors.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  NewsState createState() => NewsState();
}

class NewsState extends State<News> {
  bool showNews = true;
  bool isNewsButtonSelected = true;
  bool isLawButtonSelected = false;

  showNewsSheet() {
    return NewsSheet();
  }

  showLawSheet() {
    return LawSheet();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverHeaderDelegate(
              minHeight: 86,
              maxHeight: 86,
              child: Container(
                color: AppColors.red,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: const Center(
                  child: Text(
                    'An toàn giao thông',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        onTap: () {
                          setState(() {
                            showNews = true;
                            isNewsButtonSelected = true;
                            isLawButtonSelected = false;
                          });
                        },
                        btnText: "Tin tức",
                        btnHeight: 30,
                        borderRadius: 5,
                        btnWidth: 140,
                        fontSize: 14,
                        btnColor: isNewsButtonSelected
                            ? AppColors.red
                            : AppColors.primaryGray,
                      ),
                      const SizedBox(width: 20),
                      CustomButton(
                        onTap: () {
                          setState(() {
                            showNews = false;
                            isNewsButtonSelected = false;
                            isLawButtonSelected = true;
                          });
                        },
                        btnText: "Luật TT-ATGTĐB",
                        btnHeight: 30,
                        borderRadius: 5,
                        btnWidth: 140,
                        fontSize: 14,
                        btnColor: isLawButtonSelected
                            ? AppColors.red
                            : AppColors.primaryGray,
                      ),
                    ],
                  ),
                  //SizedBox(height: 20),                   
                  if (showNews)
                    SizedBox(
                      height: 500,
                      child: showNewsSheet(),
                    ),
                  if (!showNews)
                    SizedBox(
                      height: 500,
                      child: showLawSheet(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
