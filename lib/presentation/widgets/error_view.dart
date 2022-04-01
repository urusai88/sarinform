import 'package:flutter/material.dart';

/// [isScrollable] true для использования в [RefreshIndicator]
class ErrorView extends StatelessWidget {
  const ErrorView({Key? key, this.isScrollable = true, this.action}) : super(key: key);

  final bool isScrollable;
  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    Widget child = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Не удалось загрузить данные'),
          if (action != null) ElevatedButton(onPressed: action!, child: const Text('Попробовать снова')),
        ],
      ),
    );
    if (isScrollable) {
      child = CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(child: child),
        ],
      );
    }
    return child;
  }
}
