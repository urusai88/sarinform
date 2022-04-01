import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/data.dart';
import '../../domain/domain.dart';
import '../widgets/widgets.dart';
import 'news_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_asyncInitState);
  }

  Future<void> _showErrorPopup() async {
    await showDialog(context: context, builder: (_) => const AlertDialog(title: Text('Не удалось загрузить данные')));
  }

  Future<void> _asyncInitState() async {
    final result = await context.read<NewsFeedProvider>().load();
    if (result == LoadResult.errorWithSuccessCache) {
      await _showErrorPopup();
    }
  }

  Future<void> _onRefresh() async {
    final prov = context.read<NewsFeedProvider>();
    final isLoad = prov.isLoad;
    final result = await prov.refresh();
    if (!result && isLoad) {
      await _showErrorPopup();
    }
  }

  @override
  Widget build(BuildContext context) {
    final newsFeedProvider = context.watch<NewsFeedProvider>();

    Widget child;
    if (newsFeedProvider.isError) {
      child = const ErrorView();
    } else if (newsFeedProvider.isLoad) {
      child = FeedScreenListView(items: newsFeedProvider.items);
    } else {
      child = const LoadingView();
    }

    return Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: child,
      ),
    );
  }
}

class FeedScreenListView extends StatelessWidget {
  const FeedScreenListView({Key? key, required this.items}) : super(key: key);

  final List<NewsEntity> items;

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<NewsFeedProvider>();
    var itemCount = items.length;
    var banner = false;
    if (prov.hasMore) {
      itemCount++;
    }
    if (items.length >= 5) {
      itemCount++;
      banner = true;
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        if (prov.hasMore && index == itemCount - 1) {
          if (!prov.isLoadingMore) {
            Future.microtask(() => context.read<NewsFeedProvider>().loadMore());
          }
          return const LoadingView(padding: EdgeInsets.symmetric(vertical: 32));
        }
        if (banner) {
          if (index == 5) {
            return const Image(image: AssetImage('assets/images/banner.jpg'), fit: BoxFit.fitWidth);
          } else if (index > 5) {
            index--;
          }
        }

        final item = items[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NewsScreen(id: item.id))),
            child: FeedScreenListItem(item: item),
          ),
        );
      },
    );
  }
}

class FeedScreenListItem extends StatelessWidget {
  const FeedScreenListItem({Key? key, required this.item}) : super(key: key);

  final NewsEntity item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(AppUtils.formatDateTime(item.date), textAlign: TextAlign.start),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(flex: 2, child: Text(item.title)),
            const SizedBox(width: 8),
            Expanded(
              child: AspectRatio(
                aspectRatio: 320 / 180,
                child: Image(
                  image: ExtendedNetworkImageProvider(item.img, cache: true),
                  frameBuilder: _imageFrameBuilder,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Widget _imageFrameBuilder(BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
  return AnimatedOpacity(
    child: child,
    opacity: frame == null ? 0 : 1,
    duration: const Duration(milliseconds: 500),
  );
}
