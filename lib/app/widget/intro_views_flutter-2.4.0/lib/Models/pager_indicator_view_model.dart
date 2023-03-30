
//view model for page indicator

import 'package:event_app/app/widget/intro_views_flutter-2.4.0/lib/Models/page_view_model.dart';

import '../Constants/constants.dart';

class PagerIndicatorViewModel {
  final List<PageViewModel> pages;
  final int activeIndex;
  final SlideDirection? slideDirection;
  final double? slidePercent;

  PagerIndicatorViewModel(
    this.pages,
    this.activeIndex,
    this.slideDirection,
    this.slidePercent,
  );
}
