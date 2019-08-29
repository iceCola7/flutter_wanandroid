import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/widgets/progress_view.dart';

/// 自定义带有缓存的Image
class CustomCachedImage extends StatelessWidget {
  /// 图片链接
  final String imageUrl;
  final BoxFit fit;

  CustomCachedImage({Key key, @required this.imageUrl, this.fit = BoxFit.cover})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imageUrl.isNotEmpty
        ? CachedNetworkImage(
            fit: fit,
            imageUrl: imageUrl,
            placeholder: (context, url) => new ProgressView(),
            errorWidget: (context, url, error) => new Icon(Icons.error),
          )
        : Container();
  }
}
