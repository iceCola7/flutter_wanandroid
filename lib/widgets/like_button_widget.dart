import 'package:flutter/material.dart';

class LikeButtonWidget extends StatelessWidget {
  bool isLike = false;
  double size = 24.0;

  LikeButtonWidget({Key key, this.isLike, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      isLike ? Icons.favorite : Icons.favorite_border,
      size: size,
      color: isLike ? Colors.red : Colors.grey[600],
    );
  }
}
