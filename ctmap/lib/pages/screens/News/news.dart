import 'package:ctmap/pages/screens/News/law_sheet.dart';
import 'package:ctmap/pages/screens/News/news_sheet.dart';
import 'package:ctmap/widgets/components/button/button.dart';
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
    return const NewsSheet();
  }

  showLawSheet() {
    return const LawSheet();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "An Toàn Giao Thông",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 28,
            fontWeight: FontWeight.normal
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.red,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                  height: MediaQuery.of(context).size.height - 86 - 20*4 - MediaQuery.of(context).size.height * 0.06,
                  child: showNewsSheet(),
                ),
              if (!showNews)
                SizedBox(
                  height: MediaQuery.of(context).size.height - 86 - 20*4 - MediaQuery.of(context).size.height * 0.06,
                  child: showLawSheet(),
                ),       
            ],
          ),
        )
      )
    );
  }
}

