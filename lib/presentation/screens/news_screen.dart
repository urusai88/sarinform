import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../../data/data.dart';
import '../../domain/domain.dart';
import '../widgets/widgets.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  NewsEntity? item;
  var isError = true;

  @override
  void initState() {
    super.initState();
    _asyncInitState();
  }

  Future<void> _load() async {
    setState(() => isError = false);
    try {
      item = await context.read<NewsRepository>().getDetails(widget.id);
    } catch (e) {
      isError = true;
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _asyncInitState() async {
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (isError) {
      body = ErrorView(isScrollable: false, action: _load);
    } else if (item != null) {
      body = SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 320 / 180,
              child: Image(image: ExtendedNetworkImageProvider(item!.img, cache: true), fit: BoxFit.fitWidth),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(AppUtils.formatDateTime(item!.date)),
                  const SizedBox(height: 16),
                  Text(item!.title),
                  const SizedBox(height: 16),
                  Html(data: item!.text),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      body = const LoadingView();
    }

    return Scaffold(
      appBar: AppBar(),
      body: body,
    );
  }
}
