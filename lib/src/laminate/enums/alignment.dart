// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular_components.laminate.enums.alignment;

import 'dart:math';

import 'src/base.dart';

export 'src/base.dart';

/// Enum for browser display alignment options.
class Alignment implements ElementStyleEnum {
  /// Align content before a container.
  ///
  /// This is *not* equivalent to any CSS positioning model.
  static const Before = const _BeforeCustomAlignment();

  /// Align content to the start of a container.
  ///
  /// This is equivalent to 'flex-start'.
  static const Start = const Alignment._('Start', 'flex-start');

  /// Align content to the center of a container.
  ///
  /// This is equivalent to 'center'.
  static const Center = const Alignment._('Center', 'center');

  /// Align content to the end of a container.
  ///
  /// This is equivalent to 'flex-end'.
  static const End = const Alignment._('End', 'flex-end');

  /// Align content after a container.
  ///
  /// This is *not* equivalent to any CSS positioning model.
  static const After = const _AfterCustomAlignment();

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
      throw new ArgumentError.value(displayName, 'displayName');
    }
  }

  const Alignment._(this._displayName, this._cssPropertyValue);

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
      throw new ArgumentError.notNull('contentRect');
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
      throw new ArgumentError.notNull('contentRect');
    }
    var left = sourceRect.top;
    if (this == Center) {
      left += sourceRect.height / 2 - contentRect.height / 2;
    } else if (this == End) {
      left += sourceRect.height - contentRect.height;
    }
    return left;
  }

  /// Returns a common CSS class in the format of 'align-x-{{name}}'.
  String get cssClassX => 'align-x-${_displayName.toLowerCase()}';

  /// Returns a common CSS class in the format of 'align-y-{{name}}'.
  String get cssClassY => 'align-y-${_displayName.toLowerCase()}';

  @override
  String toString() => 'Alignment {$_displayName}';
}

abstract class _CustomAlignment extends Alignment {
  const _CustomAlignment(String displayName) : super._(displayName, null);

  @override
  void apply(SetPropertyFn setProperty) {
    throw new UnsupportedError('Cannot be reflected as a CSS style.');
  }

  @override
  final cssClassX = '';

  @override
  final cssClassY = '';
}

class _BeforeCustomAlignment extends _CustomAlignment {
  const _BeforeCustomAlignment() : super('Before');

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

class _AfterCustomAlignment extends _CustomAlignment {
  const _AfterCustomAlignment() : super('After');

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
/// A pair [contentX] and [contentY] defines how to align content.
class RelativePosition {
  /// A set of [RelativePosition]s that are covering the point.
  static const overlapAlignments = const [
    const RelativePosition(originX: Alignment.Start, originY: Alignment.Start),
    const RelativePosition(
        originX: Alignment.End,
        originY: Alignment.Start,
        animationOrigin: _AnimationOrigins.DOWN_LEFT),
    const RelativePosition(
        originX: Alignment.Start,
        originY: Alignment.End,
        animationOrigin: _AnimationOrigins.UP_RIGHT),
    const RelativePosition(
        originX: Alignment.End,
        originY: Alignment.End,
        animationOrigin: _AnimationOrigins.UP_LEFT),
    const RelativePosition(
        contentX: Alignment.Center,
        originX: Alignment.Center,
        originY: Alignment.Start,
        animationOrigin: _AnimationOrigins.DOWN),
    const RelativePosition(
        contentX: Alignment.Center,
        originX: Alignment.Center,
        originY: Alignment.End,
        animationOrigin: _AnimationOrigins.UP),
  ];

  /// A set of [RelativePosition]s that are appropriate for inline-type editors
  /// such as dropdown(s) that will appear at the point and either flow down or
  /// up; as well as left or right, depending on available space.
  static const InlinePositions = const [
    InlineBottom,
    InlineBottomLeft,
    InlineBottomRight,
    InlineTop,
    InlineTopLeft,
    InlineTopRight,
  ];

  /// A position that starts at the origin and flows downwards.
  static const InlineBottom =
      const RelativePosition(animationOrigin: _AnimationOrigins.DOWN);

  /// A position that starts at the origin and flows upwards.
  static const InlineTop = const RelativePosition(
      contentY: Alignment.End,
      originY: Alignment.End,
      contentX: Alignment.End,
      animationOrigin: _AnimationOrigins.UP);

  /// A position that starts at the origin and flows downwards and left
  static const InlineBottomLeft = const RelativePosition(
      originX: Alignment.End, animationOrigin: _AnimationOrigins.DOWN_LEFT);

  /// A position that starts at the origin and flows upwards and left
  static const InlineTopLeft = const RelativePosition(
      contentY: Alignment.End,
      originX: Alignment.End,
      originY: Alignment.End,
      animationOrigin: _AnimationOrigins.UP_LEFT);

  /// A position that starts at the origin and flows downwards and right
  static const InlineBottomRight = const RelativePosition(
      originX: Alignment.Start, animationOrigin: _AnimationOrigins.DOWN_RIGHT);

  /// A position that starts at the origin and flows upwards and right
  static const InlineTopRight = const RelativePosition(
      contentY: Alignment.End,
      originX: Alignment.Start,
      originY: Alignment.End,
      animationOrigin: _AnimationOrigins.UP_RIGHT);

  /// A set of [RelativePosition]s that are appropriate for offset-type menus
  /// that appear usually offset of one of the four points of the origin
  /// (e.g. bottom right, bottom left, top right, top left).
  static const OffsetPositions = const [
    OffsetBottomRight,
    OffsetBottomLeft,
    OffsetTopRight,
    OffsetTopLeft
  ];

  /// A position that starts at the origin's bottom right point and flows
  /// downwards and to the right.
  static const OffsetBottomRight = const RelativePosition(
      originX: Alignment.After,
      originY: Alignment.After,
      animationOrigin: _AnimationOrigins.DOWN_RIGHT);

  /// A position that starts at the origin's bottom left point and flows
  /// downwards and to the left.
  static const OffsetBottomLeft = const RelativePosition(
      contentX: Alignment.End,
      originX: Alignment.Before,
      originY: Alignment.After,
      animationOrigin: _AnimationOrigins.DOWN_LEFT);

  /// A position that starts at the origin's top right point and flows upwards
  /// and to the right.
  static const OffsetTopRight = const RelativePosition(
      contentY: Alignment.End,
      originX: Alignment.After,
      originY: Alignment.Before,
      animationOrigin: _AnimationOrigins.UP_RIGHT);

  /// A position that starts at the origin's top left point and flows upwards
  /// and to the left.
  static const OffsetTopLeft = const RelativePosition(
      contentX: Alignment.End,
      contentY: Alignment.End,
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
  static const ComprehensiveOffsetPositions = const [
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
  static const AdjacentCardinal = const [
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
  static const AdjacentTopEdge = const [
    AdjacentTop,
    AdjacentTopLeft,
    AdjacentTopRight
  ];
  static const AdjacentTopLeft = const RelativePosition(
      originX: Alignment.Start,
      originY: Alignment.Before,
      animationOrigin: _AnimationOrigins.UP_RIGHT);
  static const AdjacentTop = const RelativePosition(
      originX: Alignment.Center,
      originY: Alignment.Before,
      animationOrigin: _AnimationOrigins.UP);
  static const AdjacentTopRight = const RelativePosition(
      originX: Alignment.End,
      originY: Alignment.Before,
      animationOrigin: _AnimationOrigins.UP_LEFT);

  /// Offsets that'll position the popup adjacent to the right edge of the
  /// origin element.
  ///
  /// It'll try centering the popup, and will fall back to top- or
  /// bottom-aligning it.
  static const AdjacentRightEdge = const [
    AdjacentRight,
    AdjacentRightTop,
    AdjacentRightBottom
  ];
  static const AdjacentRightTop = const RelativePosition(
      originX: Alignment.After,
      originY: Alignment.Start,
      animationOrigin: _AnimationOrigins.DOWN_RIGHT);
  static const AdjacentRight = const RelativePosition(
      originX: Alignment.After,
      originY: Alignment.Center,
      animationOrigin: _AnimationOrigins.RIGHT);
  static const AdjacentRightBottom = const RelativePosition(
      originX: Alignment.After,
      originY: Alignment.End,
      animationOrigin: _AnimationOrigins.UP_RIGHT);

  /// Offsets that'll position the popup adjacent to the bottom edge of the
  /// origin element.
  ///
  /// It'll try centering the popup, and will fall back to left- or
  /// right-aligning it.
  static const AdjacentBottomEdge = const [
    AdjacentBottom,
    AdjacentBottomLeft,
    AdjacentBottomRight
  ];
  static const AdjacentBottomRight = const RelativePosition(
      contentX: Alignment.End,
      originX: Alignment.End,
      originY: Alignment.After,
      animationOrigin: _AnimationOrigins.DOWN_LEFT);
  static const AdjacentBottom = const RelativePosition(
      originX: Alignment.Center,
      originY: Alignment.After,
      animationOrigin: _AnimationOrigins.DOWN);
  static const AdjacentBottomLeft = const RelativePosition(
      originX: Alignment.Start,
      originY: Alignment.After,
      animationOrigin: _AnimationOrigins.DOWN_RIGHT);

  /// Offsets that'll position the popup adjacent to the top edge of the origin
  /// element.
  ///
  /// It'll try centering the popup, and will fall back to left- or
  /// right-aligning it.
  static const AdjacentLeftEdge = const [
    AdjacentLeft,
    AdjacentLeftTop,
    AdjacentLeftBottom
  ];
  static const AdjacentLeftBottom = const RelativePosition(
      originX: Alignment.Before,
      originY: Alignment.End,
      animationOrigin: _AnimationOrigins.UP_LEFT);
  static const AdjacentLeft = const RelativePosition(
      originX: Alignment.Before,
      originY: Alignment.Center,
      animationOrigin: _AnimationOrigins.LEFT);
  static const AdjacentLeftTop = const RelativePosition(
      originX: Alignment.Before,
      originY: Alignment.Start,
      animationOrigin: _AnimationOrigins.DOWN_LEFT);

  final Alignment contentX;
  final Alignment contentY;
  final Alignment originX;
  final Alignment originY;
  final String animationOrigin;

  const RelativePosition(
      {this.contentX: Alignment.Start,
      this.contentY: Alignment.Start,
      this.originX: Alignment.Start,
      this.originY: Alignment.Start,
      this.animationOrigin: _AnimationOrigins.DOWN_RIGHT});

  RelativePosition flipRelativePosition() {
    return new RelativePosition(
        contentX: _flipAlignment(this.contentX),
        contentY: this.contentY,
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
      'RelativePosition ' +
      {
        'contentX': contentX,
        'contentY': contentY,
        'originX': originX,
        'originY': originY
      }.toString();
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

  static Map<String, String> flippedAnimationOrigins = <String, String>{
    _AnimationOrigins.UP_LEFT: _AnimationOrigins.UP_RIGHT,
    _AnimationOrigins.UP_RIGHT: _AnimationOrigins.UP_LEFT,
    _AnimationOrigins.LEFT: _AnimationOrigins.RIGHT,
    _AnimationOrigins.RIGHT: _AnimationOrigins.LEFT,
    _AnimationOrigins.DOWN_LEFT: _AnimationOrigins.DOWN_RIGHT,
    _AnimationOrigins.DOWN_RIGHT: _AnimationOrigins.DOWN_LEFT,
  };
}
