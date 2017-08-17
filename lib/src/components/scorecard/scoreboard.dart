// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';

import '../../model/selection/selection_model.dart';
import '../../utils/browser/dom_service/angular_2.dart';
import '../../utils/color/palette.dart';
import '../../utils/disposer/disposer.dart';
import '../material_button/material_button.dart';
import '../material_icon/material_icon.dart';
import 'scorecard.dart';
import 'src/scorecard_bar.dart';

/// ACUX Scoreboard component
///
/// This component manages a row of scorecards.
///
/// __Example usage:__
///
///      <acx-scoreboard scrollable [type]="toggle">
///        <acx-scorecard
///            label="Estimated earnings"
///            value="$158.22"
///            description="+$24.20 (15%)"
///            changeType="positive">
///        </acx-scorecard>
///        <acx-scorecard
///            label="Ad RPM"
///            value="$0.58"
///            description="-$0.02 (3%)"
///            changeType="negative">
///        </acx-scorecard>
///      </acx-scoreboard>
///
/// __Inputs:__
///
/// - `type: ScoreboardType` -- Type of scoreboard, e.g., standard, selectable,
///   radio, toggle.
/// - `enableUniformWidths: bool` -- Whether scorecards in the scoreboard
///   should have uniform widths.
/// - `scrollable: bool` -- Whether the scoreboard is scrollable.
/// - `resetOnCardChanges` -- Whether to reset the card selection when there are
///   card changes.
/// - `isVertical: bool` -- Whether the scorecard is displayed vertically.
///   Defaults to false.
@Component(
    selector: 'acx-scoreboard',
    directives: const [
      MaterialButtonComponent,
      MaterialIconComponent,
      NgIf,
      ScorecardBarDirective,
    ],
    templateUrl: 'scoreboard.html',
    styleUrls: const ['scoreboard.scss.css'],
    changeDetection: ChangeDetectionStrategy.OnPush)
class ScoreboardComponent implements OnInit, OnDestroy {
  static const chevronLeft = 'chevron_left';
  static const chevronRight = 'chevron_right';
  final _disposer = new Disposer.oneShot();
  final _cardSelectionDisposer = new Disposer.multi();
  final ChangeDetectorRef _changeDetector;
  final DomService _domService;
  SelectionModel _selectionModel;
  QueryList<ScorecardComponent> _scorecards;
  ScorecardBarDirective _scorecardBar;
  String chevronBack = chevronLeft;
  String chevronForward = chevronRight;

  /// Whether to allow for uniform widths on scorecards.
  bool _enableUniformWidths;

  bool get isScrollable => scrollable && (_scorecardBar?.isScrollable ?? false);
  bool _atScorecardBarStart = false;
  bool get atScorecardBarStart => _atScorecardBarStart;
  bool _atScorecardBarEnd = false;
  bool get atScorecardBarEnd => _atScorecardBarEnd;
  String get backIconType => isVertical ? 'expand_less' : chevronBack;
  String get forwardIconType => isVertical ? 'expand_more' : chevronForward;

  ScoreboardComponent(
      @Attribute('enableUniformWidths') String enableUniformWidths,
      this._domService,
      this._changeDetector) {
    _enableUniformWidths = enableUniformWidths != 'false'; // Defaults to true
  }

  @ContentChildren(ScorecardComponent)
  set scoreCards(QueryList<ScorecardComponent> value) {
    _scorecards = value;
    _disposer.addStreamSubscription(
        _scorecards.changes.listen((_) => _onScorecardsChange));
    scheduleMicrotask(_onScorecardsChange);
  }

  @override
  void ngOnInit() {
    switch (type) {
      case ScoreboardType.toggle:
      case ScoreboardType.radio:
        _selectionModel = new SelectionModel.withList();
        break;
      case ScoreboardType.selectable:
        _selectionModel = new SelectionModel.withList(allowMulti: true);
        break;
      default:
        _selectionModel = new SelectionModel();
        break;
    }
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
    _cardSelectionDisposer.dispose();
  }

  @ViewChild(ScorecardBarDirective)
  set scorecardBar(ScorecardBarDirective value) {
    _scorecardBar = value;
    _disposer.addDisposable(
        _scorecardBar.refreshStream.listen((_) => _refreshArrows()));
  }

  @Input()
  ScoreboardType type = ScoreboardType.standard;

  /// Whether allow scrolling the scoreboard via scroll buttons.
  ///
  /// Scrollable property can be set dynamically during app runtime -- will add
  /// or remove window resize listener depending on state of `scrollable`.
  @Input()
  bool scrollable = false;

  /// Whether to reset the card selection when there are card changes.
  ///
  /// If a card is added or removed, and this is set to true, then all
  /// cards will be deselected. For [ScoreboardType.radio], the first card will
  /// be selected.
  @Input()
  bool resetOnCardChanges = false;

  /// Whether the scorecard is displayed vertically. Defaults to false.
  @Input()
  bool isVertical = false;

  void scrollBack() {
    _scorecardBar.scrollBack();
    _resetTabIndex();
  }

  void scrollForward() {
    _scorecardBar.scrollForward();
    _resetTabIndex();
  }

  void selectionChange(ScorecardComponent selectedScorecard) {
    if (_selectionModel.isSelected(selectedScorecard)) {
      if (type != ScoreboardType.radio) {
        _selectionModel.deselect(selectedScorecard);
      }
    } else {
      _selectionModel.select(selectedScorecard);
    }
    _updatedSelected();
  }

  void _refreshArrows() {
    if (scrollable) {
      _atScorecardBarStart = _scorecardBar?.atStart ?? false;
      _atScorecardBarEnd = _scorecardBar?.atEnd ?? false;
      _changeDetector.markForCheck();
      if (scrollable) {
        _resetTabIndex();
      }
    }
  }

  /// Updates each scorecards' [HtmlElement.tabIndex] based on whether the
  /// element is viewable.
  ///
  /// An element is viewable if it's relative offset is within the range of:
  /// (current scrollbar transform, current scrollbar transform + current scroll
  /// bar width). A tabIndex value of any non-negative number means it is
  /// hoverable through tabs.
  void _resetTabIndex() {
    for (ScorecardComponent component in _scorecards) {
      var offset = _scorecardOffset(component.element);
      var scoreCardBarEndPosition = _scorecardBar.currentTransformSize +
          _scorecardBar.currentClientSize -
          _scorecardBar.currentButtonSize;
      if (offset < scoreCardBarEndPosition &&
          offset > _scorecardBar.currentTransformSize) {
        component.element.tabIndex = 0;
      } else {
        component.element.tabIndex = -1;
      }
    }
  }

  /// Returns the relative bottom or left of a scorecard, depending on the
  /// orientation of the scorecard.
  ///
  /// We need this to determine where in the list of scorecards the current
  /// scorecard is located. When the scorecards are loaded left to right, if
  /// the end of the scorecard overlaps with the scroll arrow, it'll hover over
  /// the scorecard without affecting the transform. This is not the case for
  /// vertical score cards, therefore we need to look for the bottom.
  int _scorecardOffset(HtmlElement element) {
    return isVertical
        ? element.offsetTop + element.offsetHeight
        : element.offsetLeft;
  }

  void _onScorecardsChange() {
    _cardSelectionDisposer.dispose();
    if (_enableUniformWidths) _makeScorecardsUniformWidth();
    for (ScorecardComponent scorecard in _scorecards) {
      scorecard.selectable = type == ScoreboardType.custom
          ? scorecard.selectable
          : type != ScoreboardType.standard;
      // Select for initial scorecards selection on page load.
      if (!resetOnCardChanges && scorecard.selected) {
        _selectionModel.select(scorecard);
      }
      _cardSelectionDisposer.addDisposable(
          scorecard.selectedChange.listen((_) => selectionChange(scorecard)));
    }

    if (resetOnCardChanges) _selectionModel.clear();
    if (type == ScoreboardType.radio && _selectionModel.isEmpty) {
      _selectionModel.select(_scorecards.first);
    }
    _updatedSelected();

    // Refresh scoreboard scrolling on card changes.
    if (scrollable) _scorecardBar?.reset();

    if (type == ScoreboardType.selectable) {
      int i = 0;
      for (ScorecardComponent scorecard in _scorecards) {
        scorecard.selectedColor = chartingPalette[i % chartingPalette.length];
        i++;
      }
    }
    _refreshArrows();
  }

  void _makeScorecardsUniformWidth() {
    List<HtmlElement> scorecardsElem = _scorecards
        .map((ScorecardComponent scorecard) => scorecard.element)
        .toList();

    var width = 0.0;
    // Reset CSS widths so scorecards shrink to their individual widths.
    _disposer.addDisposable(_domService.scheduleWrite(() {
      for (var element in scorecardsElem) {
        element.style.minWidth = '';
      }
      _disposer.addDisposable(_domService.scheduleRead(() {
        for (var element in scorecardsElem) {
          var elemWidth = element
              .getComputedStyle()
              .width
              .replaceAll(new RegExp('[^0-9.]'), '');
          var elemWidthValue =
              elemWidth.isEmpty ? 0.0 : double.parse(elemWidth);
          if (elemWidthValue > width) width = elemWidthValue;
        }
        // Add 1 pixel to handle approximation errors when resetting widths.
        width += 1;
        _disposer.addDisposable(_domService.scheduleWrite(() {
          for (var element in scorecardsElem) {
            element.style.minWidth = '${width}px';
          }
          _refreshArrows();
        }));
      }));
    }));
  }

  void _updatedSelected() {
    for (ScorecardComponent scorecard in _scorecards) {
      scorecard.selected = _selectionModel.isSelected(scorecard);
    }
  }

  String get scrollScorecardBarForward => Intl.message(
      'Scroll scorecard bar forward',
      name: 'scrollScorecardBarForward',
      desc: 'Aria label of a button that scrolls the scorecard bar horizontally'
          ' forward. Forward is, to the right in left-to-right layouts'
          ' and to the left in right-to-left layouts.');
  String get scrollScorecardBarBack => Intl.message(
      'Scroll scorecard bar backward',
      name: 'scrollScorecardBarBack',
      desc: 'Aria label of a button that scrolls the scorecard bar horizontally'
          ' backward. Backward is, to the left in left-to-right layouts'
          ' and to the right in right-to-left layouts.');
}

/// The interaction type of the scoreboard.
///
/// Possible values are:
///
/// * standard - scorecards are not selectable (default)
/// * selectable - multiple scorecards can be selected simultaneously
/// * toggle - zero or one scorecard can be selected at a time
/// * radio - similar to toggle, but one card always selected,
///           cannot unselect selected card
enum ScoreboardType { standard, selectable, toggle, radio, custom }
