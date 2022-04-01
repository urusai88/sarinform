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

abstract class NewsFeedState {
  const NewsFeedState();
}

class NewsFeedStateInitial extends NewsFeedState {
  const NewsFeedStateInitial();
}

class NewsFeedStateLoading extends NewsFeedState {
  const NewsFeedStateLoading();
}

class NewsFeedStateError extends NewsFeedState {
  const NewsFeedStateError();
}

abstract class NewsFeedStateWithItems extends NewsFeedState {
  const NewsFeedStateWithItems({required this.items, required this.hasMore});

  final List<NewsEntity> items;
  final bool hasMore;
}

class NewsFeedStateLoad extends NewsFeedStateWithItems {
  const NewsFeedStateLoad({required List<NewsEntity> items, required bool hasMore})
      : super(items: items, hasMore: hasMore);
}

class NewsFeedStateRefreshing extends NewsFeedStateWithItems {
  const NewsFeedStateRefreshing({required List<NewsEntity> items, required bool hasMore})
      : super(items: items, hasMore: hasMore);
}

class NewsFeedStateLoadingMore extends NewsFeedStateWithItems {
  const NewsFeedStateLoadingMore({required List<NewsEntity> items, required bool hasMore})
      : super(items: items, hasMore: hasMore);
}

class NewsFeedProvider extends ValueNotifier<NewsFeedState> {
  NewsFeedProvider({required this.newsRepository}) : super(const NewsFeedStateInitial());

  final NewsRepository newsRepository;

  Box<NewsEntity> get box => Hive.box<NewsEntity>('news');

  /// Если [useCache] true, то при успешной загрузке сущностей из кэша и неуспешном обновлении сущностей с сервера,
  /// флаг [isError] не выставляется
  Future<LoadResult> load({bool useCache = true}) async {
    if (value is! NewsFeedStateInitial) return LoadResult.empty;

    final usingCache = box.isNotEmpty && useCache;
    if (usingCache) {
      value = NewsFeedStateLoad(items: box.values.toList(), hasMore: true);
    } else {
      value = const NewsFeedStateLoading();
    }

    try {
      value = NewsFeedStateLoad(items: await newsRepository.getList(), hasMore: true);
      await _store();
      return LoadResult.success;
    } catch (e) {
      if (!usingCache) {
        value = const NewsFeedStateError();
        return LoadResult.error;
      }
      return LoadResult.errorWithSuccessCache;
    }
  }

  Future<void> loadMore() async {
    final loadState = value;
    if (loadState is! NewsFeedStateLoad) return;
    final loadingMoreState = value = NewsFeedStateLoadingMore(items: loadState.items, hasMore: loadState.hasMore);

    try {
      final resp = await newsRepository.getList(from: AppUtils.rawDateTime(loadingMoreState.items.last.date));
      if (resp.isEmpty) {
        value = NewsFeedStateLoad(items: loadingMoreState.items, hasMore: false);
      } else {
        value = NewsFeedStateLoad(items: List<NewsEntity>.of(loadingMoreState.items)..addAll(resp), hasMore: true);
      }
    } catch (_) {
      value = loadState;
    }
  }

  Future<bool> refresh() async {
    final loadState = value;
    if (loadState is! NewsFeedStateLoad && loadState is! NewsFeedStateError) return true;
    if (loadState is NewsFeedStateLoad) {
      value = NewsFeedStateRefreshing(items: loadState.items, hasMore: loadState.hasMore);
    }

    try {
      value = NewsFeedStateLoad(items: await newsRepository.getList(), hasMore: true);
      await _store();
      return true;
    } catch (e) {
      value = loadState;
      return false;
    }
  }

  Future<void> _store() async {
    final loadState = value;
    if (loadState is! NewsFeedStateLoad) return;
    if (loadState.items.isNotEmpty) {
      await box.clear();
      await box.addAll(loadState.items);
    }
  }
}
