// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../package/models.dart' show PackageView;
import '../../search/search_form.dart';
import '../../service/youtube/backend.dart' show PkgOfWeekVideo;
import '../../shared/tags.dart';
import '../../shared/urls.dart' as urls;

import '_cache.dart';
import 'layout.dart';
import 'views/landing/mini_list.dart';
import 'views/landing/pow_video_list.dart';

/// Renders the `views/page/landing.mustache` template.
String renderLandingPage({
  List<PackageView>? ffPackages,
  List<PackageView>? mostPopularPackages,
  List<PackageView>? topFlutterPackages,
  List<PackageView>? topDartPackages,
  List<PkgOfWeekVideo>? topPoWVideos,
}) {
  bool isNotEmptyList(List? l) => l != null && l.isNotEmpty;
  String? renderMiniListIf(
          bool cond, String sectionTag, List<PackageView>? packages) =>
      cond ? miniListNode(sectionTag, packages!).toString() : null;

  final hasFF = isNotEmptyList(ffPackages);
  final hasMostPopular = isNotEmptyList(mostPopularPackages);
  final hasTopFlutter = isNotEmptyList(topFlutterPackages);
  final hasTopDart = isNotEmptyList(topDartPackages);
  final hasPoW = isNotEmptyList(topPoWVideos);
  final values = {
    'has_ff': hasFF,
    'ff_mini_list_html':
        renderMiniListIf(hasFF, 'flutter-favorites', ffPackages),
    'ff_view_all_url': '/flutter/favorites',
    'has_mp': hasMostPopular,
    'mp_mini_list_html':
        renderMiniListIf(hasMostPopular, 'most-popular', mostPopularPackages),
    'mp_view_all_url':
        SearchForm.parse(order: SearchOrder.popularity).toSearchLink(),
    'has_tf': hasTopFlutter,
    'tf_mini_list_html':
        renderMiniListIf(hasTopFlutter, 'top-flutter', topFlutterPackages),
    'tf_view_all_url': urls.searchUrl(sdk: SdkTagValue.flutter),
    'has_td': hasTopDart,
    'td_mini_list_html':
        renderMiniListIf(hasTopDart, 'top-dart', topDartPackages),
    'td_view_all_url': urls.searchUrl(sdk: SdkTagValue.dart),
    'has_pow': hasPoW,
    'pow_mini_list_html':
        hasPoW ? videoListNode(topPoWVideos!).toString() : null,
  };
  final content = templateCache.renderTemplate('landing/page', values);
  return renderLayoutPage(
    PageType.landing,
    content,
    title: 'Dart packages',
    canonicalUrl: '/',
    mainClasses: ['landing-main'],
  );
}
