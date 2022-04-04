// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_feed_provider.dart';

// **************************************************************************
// WhenGenerator
// **************************************************************************

extension NewsFeedStateWhenExtension on NewsFeedState {
  _T map<_T>({
    required _T Function(Initial) initial,
    required _T Function(Loading) loading,
    required _T Function(Error) error,
    required _T Function(WithItems) withItems,
  }) {
    if (this is Initial) {
      return initial(this as Initial);
    } else if (this is Loading) {
      return loading(this as Loading);
    } else if (this is Error) {
      return error(this as Error);
    } else if (this is WithItems) {
      return withItems(this as WithItems);
    }
    throw 'Invalid self type $this';
  }

  _T maybeMap<_T>({
    _T Function(Initial)? initial,
    _T Function(Loading)? loading,
    _T Function(Error)? error,
    _T Function(WithItems)? withItems,
    required _T orElse(NewsFeedState),
  }) {
    if (this is Initial && initial != null) {
      return initial(this as Initial);
    } else if (this is Loading && loading != null) {
      return loading(this as Loading);
    } else if (this is Error && error != null) {
      return error(this as Error);
    } else if (this is WithItems && withItems != null) {
      return withItems(this as WithItems);
    } else {
      return orElse(this);
    }
  }

  void when({
    required void Function(Initial) initial,
    required void Function(Loading) loading,
    required void Function(Error) error,
    required void Function(WithItems) withItems,
  }) {
    if (this is Initial) {
      return initial(this as Initial);
    } else if (this is Loading) {
      return loading(this as Loading);
    } else if (this is Error) {
      return error(this as Error);
    } else if (this is WithItems) {
      return withItems(this as WithItems);
    }
    throw 'Invalid self type $this';
  }

  void maybeWhen({
    void Function(Initial)? initial,
    void Function(Loading)? loading,
    void Function(Error)? error,
    void Function(WithItems)? withItems,
    void Function(NewsFeedState)? orElse,
  }) {
    if (this is Initial && initial != null) {
      return initial(this as Initial);
    } else if (this is Loading && loading != null) {
      return loading(this as Loading);
    } else if (this is Error && error != null) {
      return error(this as Error);
    } else if (this is WithItems && withItems != null) {
      return withItems(this as WithItems);
    } else if (orElse != null) {
      return orElse(this);
    }
  }

  Future<void> whenFuture({
    required Future<void> Function(Initial) initial,
    required Future<void> Function(Loading) loading,
    required Future<void> Function(Error) error,
    required Future<void> Function(WithItems) withItems,
  }) {
    if (this is Initial) {
      return initial(this as Initial);
    } else if (this is Loading) {
      return loading(this as Loading);
    } else if (this is Error) {
      return error(this as Error);
    } else if (this is WithItems) {
      return withItems(this as WithItems);
    }
    throw 'Invalid self type $this';
  }

  Future<void> maybeWhenFuture({
    Future<void> Function(Initial)? initial,
    Future<void> Function(Loading)? loading,
    Future<void> Function(Error)? error,
    Future<void> Function(WithItems)? withItems,
    Future<void> Function(NewsFeedState)? orElse,
  }) {
    if (this is Initial && initial != null) {
      return initial(this as Initial);
    } else if (this is Loading && loading != null) {
      return loading(this as Loading);
    } else if (this is Error && error != null) {
      return error(this as Error);
    } else if (this is WithItems && withItems != null) {
      return withItems(this as WithItems);
    } else if (orElse != null) {
      return orElse(this);
    }
    return Future.value();
  }

  bool get isInitial => this is Initial;

  bool get isLoading => this is Loading;

  bool get isError => this is Error;

  bool get isWithItems => this is WithItems;

  Initial? get asInitial => this as Initial?;

  Loading? get asLoading => this as Loading?;

  Error? get asError => this as Error?;

  WithItems? get asWithItems => this as WithItems?;
}

extension WithItemsWhenExtension on WithItems {
  _T map<_T>({
    required _T Function(Load) load,
    required _T Function(Refreshing) refreshing,
    required _T Function(LoadingMore) loadingMore,
  }) {
    if (this is Load) {
      return load(this as Load);
    } else if (this is Refreshing) {
      return refreshing(this as Refreshing);
    } else if (this is LoadingMore) {
      return loadingMore(this as LoadingMore);
    }
    throw 'Invalid self type $this';
  }

  _T maybeMap<_T>({
    _T Function(Load)? load,
    _T Function(Refreshing)? refreshing,
    _T Function(LoadingMore)? loadingMore,
    required _T orElse(WithItems),
  }) {
    if (this is Load && load != null) {
      return load(this as Load);
    } else if (this is Refreshing && refreshing != null) {
      return refreshing(this as Refreshing);
    } else if (this is LoadingMore && loadingMore != null) {
      return loadingMore(this as LoadingMore);
    } else {
      return orElse(this);
    }
  }

  void when({
    required void Function(Load) load,
    required void Function(Refreshing) refreshing,
    required void Function(LoadingMore) loadingMore,
  }) {
    if (this is Load) {
      return load(this as Load);
    } else if (this is Refreshing) {
      return refreshing(this as Refreshing);
    } else if (this is LoadingMore) {
      return loadingMore(this as LoadingMore);
    }
    throw 'Invalid self type $this';
  }

  void maybeWhen({
    void Function(Load)? load,
    void Function(Refreshing)? refreshing,
    void Function(LoadingMore)? loadingMore,
    void Function(WithItems)? orElse,
  }) {
    if (this is Load && load != null) {
      return load(this as Load);
    } else if (this is Refreshing && refreshing != null) {
      return refreshing(this as Refreshing);
    } else if (this is LoadingMore && loadingMore != null) {
      return loadingMore(this as LoadingMore);
    } else if (orElse != null) {
      return orElse(this);
    }
  }

  Future<void> whenFuture({
    required Future<void> Function(Load) load,
    required Future<void> Function(Refreshing) refreshing,
    required Future<void> Function(LoadingMore) loadingMore,
  }) {
    if (this is Load) {
      return load(this as Load);
    } else if (this is Refreshing) {
      return refreshing(this as Refreshing);
    } else if (this is LoadingMore) {
      return loadingMore(this as LoadingMore);
    }
    throw 'Invalid self type $this';
  }

  Future<void> maybeWhenFuture({
    Future<void> Function(Load)? load,
    Future<void> Function(Refreshing)? refreshing,
    Future<void> Function(LoadingMore)? loadingMore,
    Future<void> Function(WithItems)? orElse,
  }) {
    if (this is Load && load != null) {
      return load(this as Load);
    } else if (this is Refreshing && refreshing != null) {
      return refreshing(this as Refreshing);
    } else if (this is LoadingMore && loadingMore != null) {
      return loadingMore(this as LoadingMore);
    } else if (orElse != null) {
      return orElse(this);
    }
    return Future.value();
  }

  bool get isLoad => this is Load;

  bool get isRefreshing => this is Refreshing;

  bool get isLoadingMore => this is LoadingMore;

  Load? get asLoad => this as Load?;

  Refreshing? get asRefreshing => this as Refreshing?;

  LoadingMore? get asLoadingMore => this as LoadingMore?;
}
