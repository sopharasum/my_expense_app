import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator.adaptive(
              strokeWidth: 2.5,
            ),
          ),
        ),
      ),
    );
  }
}
