import 'package:ctmap/assets/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';  // Import the intl package

class NewsSheet extends StatefulWidget {
  const NewsSheet({super.key});

  //const NewsSheet({super.key});

  @override
  NewsSheetState createState() => NewsSheetState();
}

class NewsSheetState extends State<NewsSheet> {
  static const String feedURL =
      'https://www.baogiaothong.vn/rss/an-toan-giao-thong/giao-thong-24h.rss';
  late RssFeed _feed = RssFeed(items: []);
  static const String loadingFeedMsg = 'Đang tải tin tức...';
  static const String feedLoadErrorMsg = 'Lỗi tải.';
  static const String feedOpenErrorMsg = 'Không mở được tin tức.';
  static const String placeholderImg = 'images/no_image.png';
  late GlobalKey<RefreshIndicatorState> _refreshKey;

  // Pagination variables
  final int _itemsPerPage = 20;
  int _itemsToShow = 20;

  // Loading state
  bool _isLoading = true;

  updateTitle(title) {
    setState(() {
    });
  }

  updateFeed(feed) {
    setState(() {
      _feed = feed;
      _isLoading = false;
    });
  }

  Future<void> openFeed(Uri url) async {
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.inAppWebView,
        );
        return;
      }
    } catch (e) {
      //print('Không mở được tin tức. : $e');
    }
    updateTitle(feedOpenErrorMsg);
  }

  // load() async {
  //   updateTitle(loadingFeedMsg);
  //   loadFeed().then((result) {
  //     if (null == result || result.toString().isEmpty) {
  //       updateTitle(feedLoadErrorMsg);
  //       return;
  //     }
  //     updateFeed(result);
  //     //updateTitle(_feed.title ?? widget.title);
  //   });
  // }

  Future<void> load() async {
    setState(() {
      _isLoading = true; // Start loading
    });
    loadFeed().then((result) {
      if (result == null || result.toString().isEmpty) {
        setState(() {
          _isLoading = false; 
        });
        return;
      }
      updateFeed(result);
    });
  }

  Future<RssFeed?> loadFeed() async {
    try {
      final client = http.Client();
      final response = await client.get(Uri.parse(feedURL));
      return RssFeed.parse(response.body);
    } catch (e) {
      //print('Lỗi tải: $e');
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    //_title = widget.title;
    load();
  }

  title(title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  subtitle(DateTime pubDate) {
    final formattedDate = DateFormat('dd-MM-yyyy HH:mm').format(pubDate);
    return Text(
      formattedDate,
      style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w100),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  // thumbnail(imageUrl) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 15.0),
  //     child: CachedNetworkImage(
  //       placeholder: (context, url) => Image.asset(placeholderImg),
  //       imageUrl: imageUrl,
  //       height: 50,
  //       width: 70,
  //       alignment: Alignment.center,
  //       fit: BoxFit.fill,
  //     ),
  //   );
  // }

  rightIcon() {
    return const Icon(
      Icons.keyboard_arrow_right,
      color: Colors.grey,
      size: 30.0,
    );
  }

  List<Widget> _buildListItems() {
    final items = _feed.items!;
    final endIndex = _itemsToShow.clamp(0, items.length);

    return items.sublist(0, endIndex).map((item) {
      return ListTile(
        title: title(item.title ?? ''),
        subtitle: subtitle(item.pubDate ?? DateTime.now()),
        //leading: thumbnail(item.enclosure?.url ?? ''),
        trailing: rightIcon(),
        contentPadding: const EdgeInsets.all(5.0),
        onTap: () => openFeed(Uri.parse(item.link ?? '')),
      );
    }).toList();
  }

  bool _hasMoreItems() {
    return _itemsToShow < _feed.items!.length;
  }

  void _loadMoreItems() {
    setState(() {
      _itemsToShow += _itemsPerPage;
    });
  }

  list() {
    return ListView(
      padding: EdgeInsets.zero, 
      shrinkWrap: true, // Tránh tình trạng scroll mặc định chiếm không gian
      physics: const ClampingScrollPhysics(), 
      children: [
        ..._buildListItems(),
        if (_hasMoreItems())
          Center(
            child: TextButton(
              onPressed: _loadMoreItems,
              child: const Text('Xem thêm tin tức'),
            ),
          ),
      ],
    );
  }

  isFeedEmpty() {
    return _feed.items == null;
  }

  // bodyNews() {
  //   return isFeedEmpty()
  //       ? const Center(
  //           child: CircularProgressIndicator(),
  //         )
  //       : RefreshIndicator(
  //           key: _refreshKey,
  //           child: list(),
  //           onRefresh: () async {
  //             _itemsToShow = _itemsPerPage;
  //             await load();
  //           },
  //         );
  // }
    bodyNews() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.red)
        )
      );
    }

    if (_feed.items == null || _feed.items!.isEmpty) {
      return const Center(child: Text('Không có tin tức nào.'));
    }

    return RefreshIndicator(
      key: _refreshKey,
      child: list(),
      onRefresh: () async {
        _itemsToShow = _itemsPerPage;
        await load();
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyNews(),
    );
  }
}