// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:angular_components/src/laminate/enums/base.dart';

export 'package:angular_components/src/laminate/enums/base.dart';

/// Enum for browser display alignment options.
class Alignment implements ElementStyleEnum {
  /// Align content before a container.
  ///
  /// This is *not* equivalent to any CSS positioning model.
  static const Before = BeforeCustomAlignment();

  /// Align content to the start of a container.
  ///
  /// This is equivalent to 'flex-start'.
  static const Start = Alignment('Start', 'flex-start');

  /// Align content to the center of a container.
  ///
  /// This is equivalent to 'center'.
  static const Center = Alignment('Center', 'center');

  /// Align content to the end of a container.
  ///
  /// This is equivalent to 'flex-end'.
  static const End = Alignment('End', 'flex-end');

  /// Align content after a container.
  ///
  /// This is *not* equivalent to any CSS positioning model.
  static const After = AfterCustomAlignment();

  final String _displayName;
  final String _cssPropertyValue;

  /// Parses one of the following values into an [Alignment]:
  /// - 'start'
  /// - 'center'
  /// - 'end'
  /// - 'before'
  /// - 'after'
  ///
  /// A null value is treated as 'start'. Else throws [ArgumentError].
  factory Alignment.parse(String displayName) {
    if (displayName == null || displayName == 'start') {
      return Alignment.Start;
    } else if (displayName == 'center') {
      return Alignment.Center;
    } else if (displayName == 'end') {
      return Alignment.End;
    } else if (displayName == 'before') {
      return Alignment.Before;
    } else if (displayName == 'after') {
      return Alignment.After;
    } else {
      throw ArgumentError.value(displayName, 'displayName');
    }
  }

  const Alignment(this._displayName, this._cssPropertyValue);

  @override
  void apply(SetPropertyFn setProperty) {
    setProperty('align-items', _cssPropertyValue);
  }

  /// Whether [calcLeft] and [calcTop] can be used without measuring the size
  /// of the content being aligned.
  ///
  /// This is provided to optimize positioning logic.
  bool get requiresContentSizeToPosition => this != Start;

  /// Returns the calculated x position from [sourceRect].
  ///
  /// If [contentRect] is provided, it is considered to be the size of the
  /// content being aligned *if* it were visible.
  num calcLeft(Rectangle sourceRect, [Rectangle contentRect]) {
    if (requiresContentSizeToPosition && contentRect == null) {
      throw ArgumentError.notNull('contentRect');
    }
    var left = sourceRect.left;
    if (this == Center) {
      left += sourceRect.width / 2 - contentRect.width / 2;
    } else if (this == End) {
      left += sourceRect.width - contentRect.width;
    }
    return left;
  }

  /// Returns the calculated y position from [sourceRect].
  ///
  /// If [contentRect] is provided, it is considered to be the size of the
  /// content being aligned *if* it were visible.
  num calcTop(Rectangle sourceRect, [Rectangle contentRect]) {
    if (requiresContentSizeToPosition && contentRect == null) {
      throw ArgumentError.notNull('contentRect');
    }
    var top = sourceRect.top;
    if (this == Center) {
      top += sourceRect.height / 2 - contentRect.height / 2;
    } else if (this == End) {
      top += sourceRect.height - contentRect.height;
    }
    return top;
  }

  /// Returns a common CSS class in the format of 'align-x-{{name}}'.
  String get cssClassX => 'align-x-${_displayName.toLowerCase()}';

  /// Returns a common CSS class in the format of 'align-y-{{name}}'.
  String get cssClassY => 'align-y-${_displayName.toLowerCase()}';

  @override
  String toString() => 'Alignment {$_displayName}';
}

abstract class _CustomAlignment extends Alignment {
  const _CustomAlignment(String displayName) : super(displayName, null);

  @override
  void apply(SetPropertyFn setProperty) {
    throw UnsupportedError('Cannot be reflected as a CSS style.');
  }

  @override
  final cssClassX = '';

  @override
  final cssClassY = '';
}

class BeforeCustomAlignment extends _CustomAlignment {
  const BeforeCustomAlignment() : super('Before');

  @override
  final requiresContentSizeToPosition = true;

  @override
  num calcLeft(Rectangle sourceRect, [Rectangle contentRect]) {
    return sourceRect.left + -contentRect.width;
  }

  @override
  num calcTop(Rectangle sourceRect, [Rectangle contentRect]) {
    return sourceRect.top - contentRect.height;
  }
}

class AfterCustomAlignment extends _CustomAlignment {
  const AfterCustomAlignment() : super('After');

  @override
  final requiresContentSizeToPosition = false;

  @override
  num calcLeft(Rectangle sourceRect, [Rectangle contentRect]) {
    return sourceRect.left + sourceRect.width;
  }

  @override
  num calcTop(Rectangle sourceRect, [Rectangle contentRect]) {
    return sourceRect.top + sourceRect.height;
  }
}

/// A position relative to another point in a 2-dimensional plane.
///
/// A pair [originX] and [originY] defines how to align relative to the point.
class RelativePosition {
  /// A set of [RelativePosition]s that are covering the point.
  static const overlapAlignments = [
    RelativePosition(originX: Alignment.Start, originY: Alignment.Start),
    RelativePosition(
        originX: Alignment.End,
        originY: Alignment.Start,
        animationOrigin: _AnimationOrigins.DOWN_LEFT),
    RelativePosition(
        originX: Alignment.Start,
        originY: Alignment.End,
        animationOrigin: _AnimationOrigins.UP_RIGHT),
    RelativePosition(
        originX: Alignment.End,
        originY: Alignment.End,
        animationOrigin: _AnimationOrigins.UP_LEFT),
    RelativePosition(
        originX: Alignment.Center,
        originY: Alignment.Start,
        animationOrigin: _AnimationOrigins.DOWN),
    RelativePosition(
        originX: Alignment.Center,
        originY: Alignment.End,
        animationOrigin: _AnimationOrigins.UP),
  ];

  /// A set of [RelativePosition]s that are appropriate for inline-type editors
  /// such as dropdown(s) that will appear at the point and either flow down or
  /// up; as well as left or right, depending on available space.
  static const InlinePositions = [
    InlineBottom,
    InlineBottomLeft,
    InlineBottomRight,
    InlineTop,
    InlineTopLeft,
    InlineTopRight,
  ];

  /// A position that starts at the origin and flows downwards.
  static const InlineBottom =
      RelativePosition(animationOrigin: _AnimationOrigins.DOWN);

  /// A position that starts at the origin and flows upwards.
  static const InlineTop = RelativePosition(
      originY: Alignment.End, animationOrigin: _AnimationOrigins.UP);

  /// A position that starts at the origin and flows downwards and left
  static const InlineBottomLeft = RelativePosition(
      originX: Alignment.End, animationOrigin: _AnimationOrigins.DOWN_LEFT);

  /// A position that starts at the origin and flows upwards and left
  static const InlineTopLeft = RelativePosition(
      originX: Alignment.End,
      originY: Alignment.End,
      animationOrigin: _AnimationOrigins.UP_LEFT);

  /// A position that starts at the origin and flows downwards and right
  static const InlineBottomRight = RelativePosition(
      originX: Alignment.Start, animationOrigin: _AnimationOrigins.DOWN_RIGHT);

  /// A position that starts at the origin and flows upwards and right
  static const InlineTopRight = RelativePosition(
      originX: Alignment.Start,
      originY: Alignment.End,
      animationOrigin: _AnimationOrigins.UP_RIGHT);

  /// A set of [RelativePosition]s that are appropriate for offset-type menus
  /// that appear usually offset of one of the four points of the origin
  /// (e.g. bottom right, bottom left, top right, top left).
  static const OffsetPositions = [
    OffsetBottomRight,
    OffsetBottomLeft,
    OffsetTopRight,
    OffsetTopLeft
  ];

  /// A position that starts at the origin's bottom right point and flows
  /// downwards and to the right.
  static const OffsetBottomRight = RelativePosition(
      originX: Alignment.After,
      originY: Alignment.After,
      animationOrigin: _AnimationOrigins.DOWN_RIGHT);

  /// A position that starts at the origin's bottom left point and flows
  /// downwards and to the left.
  static const OffsetBottomLeft = RelativePosition(
      originX: Alignment.Before,
      originY: Alignment.After,
      animationOrigin: _AnimationOrigins.DOWN_LEFT);

  /// A position that starts at the origin's top right point and flows upwards
  /// and to the right.
  static const OffsetTopRight = RelativePosition(
      originX: Alignment.After,
      originY: Alignment.Before,
      animationOrigin: _AnimationOrigins.UP_RIGHT);

  /// A position that starts at the origin's top left point and flows upwards
  /// and to the left.
  static const OffsetTopLeft = RelativePosition(
      originX: Alignment.Before,
      originY: Alignment.Before,
      animationOrigin: _AnimationOrigins.UP_LEFT);

  /// Comprehensive offset positions; contains all positions that are
  /// immediately adjacent to but not overlapping the target.
  ///
  /// For corners, we just reuse the already-existing [OffsetPositions]. For
  /// positions adjacent to the edges, we define a bunch of `Adjacent`
  /// positions. The whole set looks like:
  ///
  ///           AB  C  DE
  ///           P+-----+F
  ///            |     |
  ///            |     |
  ///           O|     |G
  ///            |     |
  ///            |     |
  ///           N+-----+H
  ///           ML  K  JI
  ///
  /// A: OffsetTopLeft
  /// B: AdjacentTopLeft
  /// C: AdjacentTop
  /// D: AdjacentTopRight
  /// E: OffsetTopRight
  /// F: AdjacentRightTop
  /// G: AdjacentRight
  /// H: AdjacentRightBottom
  /// I: OffsetBottomRight
  /// J: AdjacentBottomRight
  /// K: AdjacentBottom
  /// L: AdjacentBottomLeft
  /// M: OffsetBottomLeft
  /// N: AdjacentLeftBottom
  /// O: AdjacentLeft
  /// P: AdjacentLeftTop
  ///
  /// Note that the list of positions are listed here in priority order
  /// for hovercard positioning; which is probably a sane default for most basic
  /// pop-ups. That ordering tries all cardinal directions, then the other non-
  /// corner alignments, and finally the corners.
  static const ComprehensiveOffsetPositions = [
    // cardinal directions
    AdjacentCardinal,
    // edges
    AdjacentTopEdge,
    AdjacentRightEdge,
    AdjacentBottomEdge,
    AdjacentLeftEdge,
    // corners
    OffsetPositions,
  ];

  /// Offsets that'll position the popup adjacent to the origin element in one
  /// of the four cardinal directions: directly above, below, to the left, or to
  /// the right.
  static const AdjacentCardinal = [
    AdjacentTop,
    AdjacentRight,
    AdjacentBottom,
    AdjacentLeft
  ];

  /// Offsets that'll position the popup adjacent to the top edge of the origin
  /// element.
  ///
  /// It'll try centering the popup, and will fall back to left- or
  /// right-aligning it.
  static const AdjacentTopEdge = [
    AdjacentTop,
    AdjacentTopLeft,
    AdjacentTopRight
  ];
  static const AdjacentTopLeft = RelativePosition(
      originX: Alignment.Start,
      originY: Alignment.Before,
      animationOrigin: _AnimationOrigins.UP_RIGHT);
  static const AdjacentTop = RelativePosition(
      originX: Alignment.Center,
      originY: Alignment.Before,
      animationOrigin: _AnimationOrigins.UP);
  static const AdjacentTopRight = RelativePosition(
      originX: Alignment.End,
      originY: Alignment.Before,
      animationOrigin: _AnimationOrigins.UP_LEFT);

  /// Offsets that'll position the popup adjacent to the right edge of the
  /// origin element.
  ///
  /// It'll try centering the popup, and will fall back to top- or
  /// bottom-aligning it.
  static const AdjacentRightEdge = [
    AdjacentRight,
    AdjacentRightTop,
    AdjacentRightBottom
  ];
  static const AdjacentRightTop = RelativePosition(
      originX: Alignment.After,
      originY: Alignment.Start,
      animationOrigin: _AnimationOrigins.DOWN_RIGHT);
  static const AdjacentRight = RelativePosition(
      originX: Alignment.After,
      originY: Alignment.Center,
      animationOrigin: _AnimationOrigins.RIGHT);
  static const AdjacentRightBottom = RelativePosition(
      originX: Alignment.After,
      originY: Alignment.End,
      animationOrigin: _AnimationOrigins.UP_RIGHT);

  /// Offsets that'll position the popup adjacent to the bottom edge of the
  /// origin element.
  ///
  /// It'll try centering the popup, and will fall back to left- or
  /// right-aligning it.
  static const AdjacentBottomEdge = [
    AdjacentBottom,
    AdjacentBottomLeft,
    AdjacentBottomRight
  ];
  static const AdjacentBottomRight = RelativePosition(
      originX: Alignment.End,
      originY: Alignment.After,
      animationOrigin: _AnimationOrigins.DOWN_LEFT);
  static const AdjacentBottom = RelativePosition(
      originX: Alignment.Center,
      originY: Alignment.After,
      animationOrigin: _AnimationOrigins.DOWN);
  static const AdjacentBottomLeft = RelativePosition(
      originX: Alignment.Start,
      originY: Alignment.After,
      animationOrigin: _AnimationOrigins.DOWN_RIGHT);

  /// Offsets that'll position the popup adjacent to the top edge of the origin
  /// element.
  ///
  /// It'll try centering the popup, and will fall back to left- or
  /// right-aligning it.
  static const AdjacentLeftEdge = [
    AdjacentLeft,
    AdjacentLeftTop,
    AdjacentLeftBottom
  ];
  static const AdjacentLeftBottom = RelativePosition(
      originX: Alignment.Before,
      originY: Alignment.End,
      animationOrigin: _AnimationOrigins.UP_LEFT);
  static const AdjacentLeft = RelativePosition(
      originX: Alignment.Before,
      originY: Alignment.Center,
      animationOrigin: _AnimationOrigins.LEFT);
  static const AdjacentLeftTop = RelativePosition(
      originX: Alignment.Before,
      originY: Alignment.Start,
      animationOrigin: _AnimationOrigins.DOWN_LEFT);

  final Alignment originX;
  final Alignment originY;
  final String animationOrigin;

  const RelativePosition(
      {this.originX = Alignment.Start,
      this.originY = Alignment.Start,
      this.animationOrigin = _AnimationOrigins.DOWN_RIGHT});

  RelativePosition flipRelativePosition() {
    return RelativePosition(
        originX: _flipAlignment(this.originX),
        originY: this.originY,
        animationOrigin: _flipAnimation(this.animationOrigin));
  }

  Alignment _flipAlignment(Alignment alignment) {
    // Start/End
    if (alignment == Alignment.Start) return Alignment.End;
    if (alignment == Alignment.End) return Alignment.Start;
    // Before/After
    if (alignment == Alignment.Before) return Alignment.After;
    if (alignment == Alignment.After) return Alignment.Before;

    return alignment;
  }

  String _flipAnimation(String animationOrigin) =>
      _AnimationOrigins.flippedAnimationOrigins.containsKey(animationOrigin)
          ? _AnimationOrigins.flippedAnimationOrigins[animationOrigin]
          : animationOrigin;

  @override
  String toString() =>
      'RelativePosition ' + {'originX': originX, 'originY': originY}.toString();
}

/// Origins for Material animation directions.
class _AnimationOrigins {
  static const UP_LEFT = 'bottom right';
  static const UP = 'bottom center';
  static const UP_RIGHT = 'bottom left';

  static const LEFT = 'center right';
  static const OUTWARD = 'center left';
  static const RIGHT = 'center left';

  static const DOWN_LEFT = 'top right';
  static const DOWN = 'top center';
  static const DOWN_RIGHT = 'top left';

  static const Map<String, String> flippedAnimationOrigins = {
    _AnimationOrigins.UP_LEFT: _AnimationOrigins.UP_RIGHT,
    _AnimationOrigins.UP_RIGHT: _AnimationOrigins.UP_LEFT,
    _AnimationOrigins.LEFT: _AnimationOrigins.RIGHT,
    _AnimationOrigins.RIGHT: _AnimationOrigins.LEFT,
    _AnimationOrigins.DOWN_LEFT: _AnimationOrigins.DOWN_RIGHT,
    _AnimationOrigins.DOWN_RIGHT: _AnimationOrigins.DOWN_LEFT,
  };
}
