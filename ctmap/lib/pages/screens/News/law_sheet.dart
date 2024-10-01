import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/data/law_data.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class LawSheet extends StatefulWidget {
  @override
  LawSheetState createState() => LawSheetState();
}

class LawSheetState extends State<LawSheet> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  bool isMenuOpened = false;

  @override
  void initState() {
    super.initState();
    itemPositionsListener.itemPositions.addListener(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Scrollbar(
            child: ScrollablePositionedList.builder(
              itemScrollController: itemScrollController,
              itemCount: getTotalArticleCount(),
              itemBuilder: (context, index) {
                return getArticleWidget(index);
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: () {
                  showTableOfContents();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: isMenuOpened
                    ? AppColors.red
                    : AppColors.white,
                child: Icon(
                  AppIcons.menu,
                  size: 30,
                  color: isMenuOpened
                      ? AppColors.white
                      : AppColors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int getTotalArticleCount() {
    int count = 0;
    for (var law in lawData) {
      count += law.articles.length + 1; // Add 1 for the chapter title
    }
    return count;
  }

  Widget getArticleWidget(int index) {
    int lawIndex = 0;
    int articleIndex = 0;
    int chapterCount = 0;
    for (var law in lawData) {
      if (index < law.articles.length + 1) {
        lawIndex = lawData.indexOf(law);
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              lawData[lawIndex].title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          articleIndex = index - 1;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lawData[lawIndex].articles[articleIndex].title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  lawData[lawIndex].articles[articleIndex].content,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        index -= law.articles.length + 1;
        chapterCount++;
      }
    }
    return Container();
  }

  void showTableOfContents() {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: AlertDialog(
            title: const Text(
              'Mục Lục',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.red,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // DANH SÁCH ĐIỀU
                  ...lawData.map((law) {
                    return ExpansionTile(
                      title: Text(
                        law.title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        ...law.articles.map((article) {
                          return ListTile(
                            title: Text(
                              article.title,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            onTap: () {
                              // LĂN ĐẾN ĐIỀU ĐƯỢC CHỌN
                              int index = 0;
                              for (var l in lawData) {
                                if (l.title == law.title) {
                                  index += law.articles.indexOf(article) + 1; // Add 1 for the chapter title
                                  break;
                                } else {
                                  index += l.articles.length + 1 ; // Add 1 for the chapter title
                                }
                              }
                              itemScrollController.scrollTo(
                                index: index,
                                duration: const Duration(milliseconds: 300),
                              );
                              Navigator.pop(context);
                            },
                          );
                        }),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    ).then((value) {
      setState(() {
        isMenuOpened = false;
      });
    });
    setState(() {
      isMenuOpened = true;
    });
  }
}