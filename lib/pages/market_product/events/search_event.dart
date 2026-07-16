import 'package:cloud/models/sample/media.dart';

enum SearchEventFrom {
  /// 来源于 app
  appbar,

  /// 来源与切换
  tab,
}

class SearchEvent {
  final String? search;
  final TemporaryMedia? media;
  final SearchEventFrom? from;

  SearchEvent({this.search, this.media, this.from});
}
