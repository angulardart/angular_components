// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular2_components.laminate.popup.src.popup_state;

import 'dart:async';

import 'package:observable/observable.dart';
import 'package:quiver/core.dart';

import '../../enums/alignment.dart';
import './popup_source.dart';
import '../../../utils/angular/properties/properties.dart';

/// The internal state (model) of a popup.
///
/// Changes to the model may impact a rendered popup if it is open, otherwise
/// it is treated as a property bag. Listen to [changes] ([AutoObservable]) to be
/// notified when a property changes;
class PopupState extends Observable {
  // The backing implementation to simplify copying and observability.
  final ObservableMap<Symbol, Object> _backingMap;

  /// Create a new, empty popup state (with defaults).
  factory PopupState(
      {Alignment alignContentX: Alignment.Start,
      Alignment alignContentY: Alignment.Start,
      bool autoDismiss: true,
      bool enforceSpaceConstraints: false,
      bool matchSourceWidth: false,
      bool matchMinSourceWidth: true,
      int offsetX: 0,
      int offsetY: 0,
      Iterable preferredPositions: const [],
      PopupSource source,
      bool trackLayoutChanges: false}) {
    return new PopupState._(new ObservableMap<Symbol, dynamic>.from({
      #alignContentX: alignContentX,
      #alignContentY: alignContentY,
      #autoDismiss: autoDismiss,
      #enforceSpaceConstraints: enforceSpaceConstraints,
      #matchSourceWidth: matchSourceWidth,
      #matchMinSourceWidth: matchMinSourceWidth,
      #offsetX: offsetX,
      #offsetY: offsetY,
      #preferredPositions: preferredPositions,
      #source: source,
      #trackLayoutChanges: trackLayoutChanges
    }));
  }

  /// Create a new popup state from [other].
  factory PopupState.from(PopupState other) {
    // TODO(google): Remove this once it's popup service has a default state.
    if (other == null) return new PopupState();
    return new PopupState._(new ObservableMap.from(other._backingMap));
  }

  PopupState._(this._backingMap);

  @override
  Stream<List<ChangeRecord>> get changes => _backingMap.changes.map((records) {
        // Since users of this class interact with a strongly typed object and not
        // a map let's obscure the fact it's a map and convert into properties.
        var propertyRecords = <ChangeRecord>[];
        for (var record in records) {
          if (record is MapChangeRecord) {
            propertyRecords.add(new PropertyChangeRecord(
                this, record.key, record.oldValue, record.newValue));
          }
        }
        return propertyRecords;
      });

  /// How to align the inner content of the popup on the x-axis.
  ///
  /// This is equivalent to [OverlayState.alignX].
  Alignment get alignContentX => _backingMap[#alignContentX];
  set alignContentX(Alignment alignContentX) {
    _backingMap[#alignContentX] = alignContentX;
  }

  /// How to align the inner content of the popup on the y-axis.
  ///
  /// This is equivalent to [OverlayState.alignY].
  Alignment get alignContentY => _backingMap[#alignContentY];
  set alignContentY(Alignment alignContentY) {
    _backingMap[#alignContentY] = alignContentY;
  }

  /// If set to true, the popup should attempt to close itself when a mouse
  /// click or finger tap is detected outside of the bounds of the popup.
  bool get autoDismiss => _backingMap[#autoDismiss];
  set autoDismiss(bool autoDismiss) {
    _backingMap[#autoDismiss] = autoDismiss;
  }

  /// If true, the popup will attempt to make intelligent decisions about
  /// positioning and layout depending on the size of the inner content and the
  /// distance to the viewport edges.
  bool get enforceSpaceConstraints => _backingMap[#enforceSpaceConstraints];
  set enforceSpaceConstraints(enforceSpaceConstraints) {
    _backingMap[#enforceSpaceConstraints] = getBool(enforceSpaceConstraints);
  }

  /// If true, the popup will automatically resize to the width of [source].
  ///
  /// **NOTE**: This will only happen on initial construction.
  bool get matchSourceWidth => _backingMap[#matchSourceWidth];
  set matchSourceWidth(bool matchSourceWidth) {
    _backingMap[#matchSourceWidth] = matchSourceWidth;
  }

  /// If true, the popup will set a min-width to the width of [source].
  bool get matchMinSourceWidth => _backingMap[#matchMinSourceWidth];
  set matchMinSourceWidth(bool matchMinSourceWidth) {
    _backingMap[#matchMinSourceWidth] = matchMinSourceWidth;
  }

  /// The source of the popup, or where the popup should be seen originating
  /// from.
  ///
  /// For example, in a typical material dropdown menu, the source will be the
  /// selected item.
  PopupSource get source => _backingMap[#source];
  set source(PopupSource source) {
    _backingMap[#source] = source;
  }

  /// How much to transform the x-axis position by.
  int get offsetX => _backingMap[#offsetX];
  set offsetX(int offsetX) {
    _backingMap[#offsetX] = offsetX;
  }

  /// How much to transform the y-axis position by.
  int get offsetY => _backingMap[#offsetY];
  set offsetY(int offsetY) {
    _backingMap[#offsetY] = offsetY;
  }

  /// What positions should be tried when [enforceSpaceConstraints] is enabled.
  ///
  /// Similarly to Angular providers, this supports nested lists of
  /// [RelativePosition]s. Under the hood, we'll flatten out the list and pick
  /// the first position that fits onscreen.
  Iterable /* <RelativePosition | Iterable> */ get preferredPositions =>
      _backingMap[#preferredPositions];
  set preferredPositions(Iterable preferredPositions) {
    _backingMap[#preferredPositions] = preferredPositions;
  }

  /// Whether to track the [source] for changes.
  bool get trackLayoutChanges => _backingMap[#trackLayoutChanges];
  set trackLayoutChanges(bool trackLayoutChanges) {
    _backingMap[#trackLayoutChanges] = trackLayoutChanges;
  }

  @override
  bool operator ==(o) =>
      o is PopupState &&
      o.alignContentX == alignContentX &&
      o.alignContentY == alignContentY &&
      o.autoDismiss == autoDismiss &&
      o.enforceSpaceConstraints == enforceSpaceConstraints &&
      o.matchSourceWidth == matchSourceWidth &&
      o.matchMinSourceWidth == matchMinSourceWidth &&
      o.source == source &&
      o.offsetX == offsetX &&
      o.offsetY == offsetY &&
      o.preferredPositions == preferredPositions &&
      o.trackLayoutChanges == trackLayoutChanges;

  @override
  int get hashCode => hashObjects([
        alignContentX,
        alignContentY,
        autoDismiss,
        enforceSpaceConstraints,
        matchSourceWidth,
        matchMinSourceWidth,
        source,
        offsetX,
        offsetY,
        preferredPositions,
        trackLayoutChanges
      ]);

  @override
  String toString() => 'PopupState ' + _backingMap.toString();
}
