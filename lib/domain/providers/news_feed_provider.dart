import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:when/when.dart';

import '../../data/data.dart';
import '../utils.dart';

part 'news_feed_provider.g.dart';
part 'news_feed_provider.state.dart';

enum LoadResult {
  empty,
  success,
  error,
  errorWithSuccessCache,
}

class NewsFeedProvider extends ValueNotifier<NewsFeedState> {
  NewsFeedProvider({required this.newsRepository}) : super(const _State.initial());

  final NewsRepository newsRepository;

  Box<NewsEntity> get box => Hive.box<NewsEntity>('news');

  /// Если [useCache] true, то при успешной загрузке сущностей из кэша и неуспешном обновлении сущностей с сервера,
  /// состояние [NewsFeedStateError] не выставляется
  Future<LoadResult> load({bool useCache = true}) async {
    return await value.maybeMap(
      initial: (s) async {
        final usingCache = box.isNotEmpty && useCache;
        if (usingCache) {
          value = NewsFeedState.load(items: box.values.toList(), hasMore: true);
        } else {
          value = const NewsFeedState.loading();
        }

        try {
          value = NewsFeedState.load(items: await newsRepository.getList(), hasMore: true);
          await _store();
          return LoadResult.success;
        } catch (e) {
          if (!usingCache) {
            value = const NewsFeedState.error();
            return LoadResult.error;
          }
          return LoadResult.errorWithSuccessCache;
        }
      },
      orElse: (_) async => LoadResult.empty,
    );
  }

  Future<void> loadMore() async {
    var s = value.maybeMap(
      withItems: (s) => s,
      orElse: (_) => null,
    );
    if (s == null) return;

    final next = value = NewsFeedState.loadingMore(items: s.items, hasMore: s.hasMore) as WithItems;
    try {
      final resp = await newsRepository.getList(from: AppUtils.rawDateTime(next.items.last.date));
      if (resp.isEmpty) {
        value = NewsFeedState.load(items: next.items, hasMore: false);
      } else {
        value = NewsFeedState.load(items: List.of(next.items)..addAll(resp), hasMore: true);
      }
    } catch (_) {
      value = s;
    }
  }

  Future<bool> refresh() async {
    if (!value.isError && !value.isLoad) return true;
    final s = value;
    s.maybeWhen(
      load: (s) {
        value = NewsFeedState.refreshing(items: s.items, hasMore: s.hasMore);
      },
    );

    try {
      value = NewsFeedState.load(items: await newsRepository.getList(), hasMore: true);
      await _store();
      return true;
    } catch (e) {
      value = s;
      return false;
    }
  }

  Future<void> _store() async {
    await value.maybeWhenFuture(
      load: (s) async {
        if (s.items.isNotEmpty) {
          await box.clear();
          await box.addAll(s.items);
        }
      },
    );
  }
}
