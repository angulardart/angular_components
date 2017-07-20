// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Enum that specifies checkbox state for selectable item.
///
/// - Selectable - checkbox is visible and enabled.
/// - Disabled - the item is not selectable, checkbox is visible but disabled
///              (ideally with explanation in the tooltip).
/// - Hidden - the item is not selectable, and no checkbox is present.
enum SelectableOption { Selectable, Disabled, Hidden }

typedef SelectableOption SelectableGetter(var entity);

/// Interface for determining if an entity [T] should be shown as selectable.
///
/// This interface is designed to allow metadata to determine if in a given list
/// of selectable entities if certain entities should be shown to the user but
/// not be selectable themselves within the UI.
///
/// __Example use__:
///     class MySelectionOptions = SelectionOptions with Selectable;
abstract class Selectable<T> {
  /// Whether [item] should be shown as selectable.
  SelectableOption getSelectable(T item) => SelectableOption.Selectable;
}

/// Interface for determining if an entity [T] should be shown as selectable.
///
/// This interface serves the same purpose of Selectable<T>, except the
/// getSelectable getter is a member instead of a method.
///
/// __Example use__:
///     class MySelectionOptions = SelectionOptions with SelectableWithComposition;
abstract class SelectableWithComposition<T> {
  /// Whether [item] should be shown as selectable.
  SelectableGetter getSelectable = (T item) => SelectableOption.Selectable;
}

/// An optional interface for describing why an item is/is not selectable.
///
/// __Example use__:
///     MaterialSuggestItem(@Optional() HasSelectableRationale rationale) {
///       // May use rationale.getSelectableRationale to show a tooltip.
///     }
///
/// It is recommended you always make this optional when injecting, or default
/// to [HasSelectionRationale.none] to avoid null checks:
///     selectionRationale ??= const HasSelectionRationale.none();
abstract class HasSelectionRationale<T> {
  /// Create a default [HasSelectionRationale] that always returns `null`.
  const factory HasSelectionRationale.none() = _NullHasSelectionRationale<T>;

  /// Returns a string describing why [item] on why [isSelectable].
  ///
  /// This may be used in the UI to for example, show a tooltip explaining that
  /// the current user lacks privileges to select an item:
  ///     @override
  ///     String getSelectableRationale(T item, [bool isSelectable = false]) {
  ///       if (!isSelectable && (item as FooItem).lacksPrivileges) {
  ///         return 'You lack privileges to select this item.';
  ///       }
  ///     }
  ///
  /// Or to explain why you are able to access certain items:
  ///     @override
  ///     String getSelectableRationale(T item, [bool isSelectable = false]) {
  ///       if (isSelectable && CURRENT_USER.isManager) {
  ///         return 'As a manager, you may select this option.';
  ///       }
  ///     }
  String getSelectableRationale(T item, [bool isSelectable = false]);
}

class _NullHasSelectionRationale<T> implements HasSelectionRationale<T> {
  const _NullHasSelectionRationale();

  @override
  String getSelectableRationale(T item, [bool isSelectable = false]) => null;
}
