part of 'news_feed_provider.dart';

typedef _State = NewsFeedState;

@When(children: [Initial, Loading, Error, Load, Refreshing, LoadingMore, WithItems])
abstract class NewsFeedState {
  const NewsFeedState();

  const factory NewsFeedState.initial() = Initial;

  const factory NewsFeedState.loading() = Loading;

  const factory NewsFeedState.error() = Error;

  const factory NewsFeedState.load({required List<NewsEntity> items, required bool hasMore}) = Load;

  const factory NewsFeedState.refreshing({required List<NewsEntity> items, required bool hasMore}) = Refreshing;

  const factory NewsFeedState.loadingMore({required List<NewsEntity> items, required bool hasMore}) = LoadingMore;
}

class Initial extends NewsFeedState {
  const Initial();
}

class Loading extends NewsFeedState {
  const Loading();
}

class Error extends NewsFeedState {
  const Error();
}

@When(children: [Load, Refreshing, LoadingMore])
abstract class WithItems extends NewsFeedState {
  const WithItems({required this.items, required this.hasMore});

  final List<NewsEntity> items;
  final bool hasMore;
}

class Load extends WithItems {
  const Load({required List<NewsEntity> items, required bool hasMore}) : super(items: items, hasMore: hasMore);
}

class Refreshing extends WithItems {
  const Refreshing({required List<NewsEntity> items, required bool hasMore}) : super(items: items, hasMore: hasMore);
}

class LoadingMore extends WithItems {
  const LoadingMore({required List<NewsEntity> items, required bool hasMore}) : super(items: items, hasMore: hasMore);
}
