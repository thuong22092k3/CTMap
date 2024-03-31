import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../assets/colors/colors.dart';

class News extends StatefulWidget {
  const News({super.key});

  final String title = 'RSS Feed Demo';

  @override
  RSSDemoState createState() => RSSDemoState();
}

class RSSDemoState extends State<News> {
  static const String FEED_URL =
      'https://www.baogiaothong.vn/rss/an-toan-giao-thong/giao-thong-24h.rss';
  late RssFeed _feed = RssFeed(items: []);
  late String _title;
  static const String loadingFeedMsg = 'Đang tải tin tức...';
  static const String feedLoadErrorMsg = 'Lỗi tải.';
  static const String feedOpenErrorMsg = 'Không mở được tin tức.';
  static const String placeholderImg = 'images/no_image.png';
  late GlobalKey<RefreshIndicatorState> _refreshKey;

  updateTitle(title) {
    setState(() {
      _title = title;
    });
  }

  updateFeed(feed) {
    setState(() {
      _feed = feed;
    });
  }

  Future<void> openFeed(Uri url) async {
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
        );
        return;
      }
    } catch (e) {
      //print('Không mở được tin tức. : $e');
    }
    updateTitle(feedOpenErrorMsg);
  }

  load() async {
    updateTitle(loadingFeedMsg);
    loadFeed().then((result) {
      if (null == result || result.toString().isEmpty) {
        updateTitle(feedLoadErrorMsg);
        return;
      }
      updateFeed(result);
      updateTitle(_feed.title ?? widget.title);
    });
  }

  Future<RssFeed?> loadFeed() async {
    try {
      final client = http.Client();
      final response = await client.get(Uri.parse(FEED_URL));
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
    _title = widget.title;
    load();
  }

  title(title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  subtitle(subTitle) {
    return Text(
      subTitle,
      style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w100),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  thumbnail(imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: CachedNetworkImage(
        placeholder: (context, url) => Image.asset(placeholderImg),
        imageUrl: imageUrl,
        height: 50,
        width: 70,
        alignment: Alignment.center,
        fit: BoxFit.fill,
      ),
    );
  }

  rightIcon() {
    return const Icon(
      Icons.keyboard_arrow_right,
      color: Colors.grey,
      size: 30.0,
    );
  }

  list() {
    return ListView.builder(
      itemCount: _feed.items!.length,
      itemBuilder: (BuildContext context, int index) {
        final item = _feed.items![index];
        return ListTile(
          title: title(item.title ?? ''),
          subtitle: subtitle(item.pubDate.toString()),
          leading: thumbnail(item.enclosure?.url ?? ''),
          trailing: rightIcon(),
          contentPadding: const EdgeInsets.all(5.0),
          onTap: () => openFeed(Uri.parse(item.link ?? '')),
        );
      },
    );
  }

  isFeedEmpty() {
    return _feed.items == null;
  }

  body() {
    return 
      isFeedEmpty()
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            key: _refreshKey,
            child: list(),
            onRefresh: () => load(),
          );
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tin Tức',
          style: TextStyle(
            fontSize: 28, 
            color: AppColors.primaryWhite
          )
        ),
        toolbarHeight: 86,
        centerTitle: true,
        backgroundColor: AppColors.red,
      ),
      //  appBar: AppBar(
      //   title: Text(_title),
      // ),
      body: body(),
    );
  }
}
