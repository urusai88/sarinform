import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../../data/data.dart';
import '../domain.dart';

enum LoadResult {
  empty,
  success,
  error,
  errorWithSuccessCache,
}

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

  /// Если [useCache] true, то при успешной загрузке сущностей из кэша и неуспешном обновлении сущностей с сервера,
  /// флаг [isError] не выставляется
  Future<LoadResult> load({bool useCache = true}) async {
    if (isLoading || isRefreshing || isLoadingMore || isLoad) return LoadResult.empty;

    final usingCache = box.isNotEmpty && useCache;
    if (usingCache) {
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
      return LoadResult.success;
    } catch (e) {
      if (!usingCache) {
        isError = true;
        return LoadResult.error;
      }
      return LoadResult.errorWithSuccessCache;
    } finally {
      isLoading = false;
      notifyListeners();
      await _store();
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

  Future<bool> refresh() async {
    if (isLoading || isRefreshing || isLoadingMore) return true;

    isRefreshing = true;
    notifyListeners();

    try {
      items = await newsRepository.getList();
      hasMore = true;
      isLoad = true;
      isError = false;
      return true;
    } catch (e) {
      return false;
    } finally {
      isRefreshing = false;
      notifyListeners();
      await _store();
    }
  }

  Future<void> _store() async {
    if (items.isNotEmpty) {
      await box.clear();
      await box.addAll(items);
    }
  }
}
