import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key, this.padding = EdgeInsets.zero}) : super(key: key);

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
