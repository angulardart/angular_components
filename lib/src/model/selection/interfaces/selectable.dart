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

typedef SelectableGetter<T> = SelectableOption Function(T entity);

/// Interface for determining if an entity [T] should be shown as selectable.
///
/// This interface is designed to allow metadata to determine if in a given list
/// of selectable entities if certain entities should be shown to the user but
/// not be selectable themselves within the UI.
///
/// __Example use__:
///     class MySelectionOptions = SelectionOptions with Selectable;
abstract class Selectable<T> {
  /// Returns `true` if [item] is described to have [option] in [isMaybeModel].
  ///
  /// This is a helper function for implementing a behavioral check that on a
  /// [isMaybeModel] that _may_ implement the [Selectable] interface, and if it
  /// does, may describe [item] to have the selectability of [option].
  ///
  /// See [isSelectableIn], [isDisabledIn], and [isHiddenIn].
  static bool _isOptionCheck<T>(
    Object isMaybeModel,
    T item,
    SelectableOption option,
    bool defaultIfMissingInterface,
  ) {
    if (isMaybeModel is Selectable<T>) {
      return identical(isMaybeModel.getSelectable(item), option);
    }
    return defaultIfMissingInterface;
  }

  /// Returns the selectability of option [item] in [isMaybeModel].
  static SelectableOption getOptionIn<T>(
    Object isMaybeModel,
    T item, [
    SelectableOption defaultIfMissingInterface = SelectableOption.Selectable,
  ]) {
    if (isMaybeModel is Selectable<T>) {
      return isMaybeModel.getSelectable(item);
    }
    return defaultIfMissingInterface;
  }

  /// Returns a filter function based on [item] being selectable.
  static bool Function(T) filterWhereSelectable<T>(
    Object isMaybeModel, [
    bool defaultIfMissingInterface = true,
  ]) {
    bool Function(T) isSelectable = (_) => defaultIfMissingInterface;
    if (isMaybeModel is Selectable<T>) {
      isSelectable = (option) {
        return identical(
          isMaybeModel.getSelectable(option),
          SelectableOption.Selectable,
        );
      };
    }
    return isSelectable;
  }

  /// Returns whether [model] has [item] as a [SelectableOption.Selectable].
  static bool isSelectableIn<T>(
    Object model,
    T item, [
    bool defaultIfMissingInterface = true,
  ]) {
    return _isOptionCheck(
      model,
      item,
      SelectableOption.Selectable,
      defaultIfMissingInterface,
    );
  }

  /// Returns whether [model] has [item] as a [SelectableOption.Disabled].
  static bool isDisabledIn<T>(
    Object model,
    T item, [
    bool defaultIfMissingInterface = false,
  ]) {
    return _isOptionCheck(
      model,
      item,
      SelectableOption.Disabled,
      defaultIfMissingInterface,
    );
  }

  /// Returns whether [model] has [item] as a [SelectableOption.Hidden].
  static bool isHiddenIn<T>(
    Object model,
    T item, [
    bool defaultIfMissingInterface = false,
  ]) {
    return _isOptionCheck(
      model,
      item,
      SelectableOption.Hidden,
      defaultIfMissingInterface,
    );
  }

  /// Whether [item] should be shown as selectable.
  SelectableOption getSelectable(T item) => SelectableOption.Selectable;
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
