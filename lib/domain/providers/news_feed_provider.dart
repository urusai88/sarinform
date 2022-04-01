import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../../data/data.dart';
import '../domain.dart';

class NewsFeedProvider extends ChangeNotifier {
  NewsFeedProvider({required this.newsRepository});

  final NewsRepository newsRepository;

  var isError = false;
  var isLoading = false;
  var isRefreshing = false;
  var isLoad = false;
  var isLoadingMore = false;
  var hasMore = true;
  var items = <NewsEntity>[];

  Box<NewsEntity> get box => Hive.box<NewsEntity>('news');

  Future<void> load({bool useCache = true}) async {
    if (isLoading || isRefreshing || isLoadingMore || isLoad) return;

    if (box.isNotEmpty && useCache) {
      items = box.values.toList();
      isLoad = true;
    } else {
      isLoading = true;
      isError = false;
    }
    notifyListeners();

    try {
      items = await newsRepository.getList();
      isLoad = true;
    } catch (e) {
      isError = true;
    } finally {
      isLoading = false;
      notifyListeners();
      await box.clear();
      await box.addAll(items);
    }
  }

  Future<void> loadMore() async {
    if (isLoading || isRefreshing || isLoadingMore || !hasMore) return;

    isLoadingMore = true;
    notifyListeners();

    try {
      final resp = await newsRepository.getList(from: AppUtils.rawDateTime(items.last.date));
      if (resp.isEmpty) {
        hasMore = false;
        return;
      }
      items.addAll(resp);
    } catch (_) {
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    if (isLoading || isRefreshing || isLoadingMore) return;

    isRefreshing = true;
    notifyListeners();

    try {
      items = await newsRepository.getList();
      hasMore = true;
    } catch (e) {
      isError = true;
    } finally {
      isRefreshing = false;
      notifyListeners();
    }
  }
}
