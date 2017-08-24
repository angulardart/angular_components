// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:angular/angular.dart';
import 'package:quiver/iterables.dart' show range;

import '../../utils/disposer/disposer.dart';
import '../../utils/keyboard/keyboard.dart';
import './reorder_events.dart';

export 'reorder_events.dart';

/// Provides a list that can reorder it's children using html5 drag&drop.
/// A vertical reorder-list will use any component in its <ng-content>
/// marked with 'reorderPlaceholder' attribute as a placeholder when moving
/// items.
///
/// Typical use:
/// '''
/// <reorder-list (reorder)="onReorder($event)">
///   <div *ngFor="let item of items" reorderItem>
///     {{item}}
///   </div>
/// </reorder-list>
/// '''
///
/// optional input:
///   multiSelect = true, will enable selection of multiple items (by pressing
///   Shift|Ctrl+clicking with the mouse) and drag them to a new position.
///
/// User is responsible for listening to reorder events
/// and updating order of elements accordingly
@Component(
    selector: 'reorder-list',
    host: const {'role': 'list', 'class': 'themeable'},
    preserveWhitespace: false,
    templateUrl: 'reorder_list.html',
    styleUrls: const ['reorder_list.scss.css'])
class ReorderListComponent implements OnDestroy {
  static final itemSelectedCssClass = 'item-selected';
  final _disposer = new Disposer.oneShot();

  /// Will emit [ReorderEvent] after reordering has finished.
  @Output()
  Stream<ReorderEvent> get reorder => _reorder.stream;
  final _reorder = new StreamController<ReorderEvent>.broadcast(sync: true);

  /// Will emit [ReorderEvent] when the prospective reordering position has
  /// changed.
  @Output()
  Stream<ReorderEvent> get reorderAttempt => _reorderAttempt.stream;
  final _reorderAttempt =
      new StreamController<ReorderEvent>.broadcast(sync: true);

  /// Will emit [int] index of element to delete when delete is triggered.
  @Output()
  Stream<int> get delete => _delete.stream;
  final _delete = new StreamController<int>.broadcast(sync: true);

  /// Will emit [ItemSelectionEvent] indexes of the newly selected elements.
  @Output()
  Stream<ItemSelectionEvent> get itemSelectionChanged =>
      _itemSelectionChanged.stream;
  final _itemSelectionChanged =
      new StreamController<ItemSelectionEvent>.broadcast(sync: true);

  final NgZone _ngZone;

  /// If true (default), items are aligned vertically.
  @HostBinding('class.vertical')
  @Input()
  bool verticalItems = true;

  /// If true, enables selecting multiple items for drag and drop.
  @HostBinding('class.multiselect')
  @Input()
  bool multiSelect = false;

  // Reorderable items in the list
  QueryList<ReorderItemDirective> _items;
  // Map of active drag&drop event subscriptions.
  Map<HtmlElement, List<StreamSubscription>> _subscriptions;
  // Map of active onDrag subscriptions,
  // stored in separate map to be able to
  // temporary deregister one
  Map<HtmlElement, StreamSubscription> _dragSubscriptions;
  // Current top transform value for each element during reorder.
  List<int> _curTransformY;
  // Height or width of each content item at the time reorder starts.
  List<int> _itemSizes;
  // Flag to ensure that drop index is not updated when drop area is outside
  // content-area.
  bool _reorderActive = false;
  // Index of element that is being moved. Set when drag starts.
  int _moveSourceIndex = -1;
  int _currentMoveIndex = -1;
  HtmlElement _dragSourceElement;
  List<int> _selectedElementIndexes = [];
  // The index of the element that will indicate the first item selected
  // for shift multi selection.
  int _pivotItemIndex;

  @ViewChild('placeholder', read: ElementRef)
  ElementRef placeholder;

  ReorderListComponent(this._ngZone) {
    _subscriptions = new Map<HtmlElement, List<StreamSubscription>>();
    _dragSubscriptions = new Map<HtmlElement, StreamSubscription>();
  }

  @ContentChildren(ReorderItemDirective)
  set items(QueryList<ReorderItemDirective> value) {
    _items = value;
    _disposer
        .addStreamSubscription(_items.changes.listen((_) => _refreshItems()));
    _refreshItems();
  }

  void _refreshItems() {
    Set<HtmlElement> newElements = _items.map((e) => e.element).toSet();
    Set<HtmlElement> currentlyTracked = new Set.from(_subscriptions.keys);
    for (HtmlElement tracked in currentlyTracked) {
      if (!newElements.contains(tracked)) {
        unTrack(tracked);
      }
    }
    for (HtmlElement newElement in newElements) {
      if (!currentlyTracked.contains(newElement)) {
        track(newElement);
      }
    }
    // When items are refreshed, the selection marks disappears. As for
    // usability, i assumed that the previous selection is not relevant anymore.
    if (multiSelect) _selectedElementIndexes.clear();
  }

  @override
  void ngOnDestroy() {
    _unTrackAll();
    _disposer.dispose();
  }

  void _unTrackAll() {
    // Prevent concurrent modification exception.
    var keys = new List<HtmlElement>.from(_subscriptions.keys);
    for (HtmlElement element in keys) {
      unTrack(element);
    }
  }

  void _moveItem(int fromIndex, int toIndex) {
    List contents = _reorderElements;
    int leftSide = 0;
    int rightSide = 0;
    int childCount = contents.length;
    if (childCount > 0) {
      leftSide = contents.first.parent.offset.left;
      rightSide = contents.first.parent.offset.right;
    }
    int nextOffset;
    int upperStackSize = 0;
    var moveRight = true;
    for (int i = 0; i < childCount; i++) {
      int offset = 0;
      HtmlElement e = contents[i];
      // Calculate offset based on removing original item and inserting into
      // new position.
      if (i == _moveSourceIndex) {
        // move original div off-screen so we only see moving clone.
        offset = -8000;
      } else if (_moveSourceIndex < i && i <= toIndex) {
        // Remove item delta.
        offset -= _itemSizes[_moveSourceIndex];
      } else if (toIndex <= i && i < _moveSourceIndex) {
        // insert item delta.
        offset += _itemSizes[_moveSourceIndex];
      }
      if ((i != _moveSourceIndex && i < toIndex) ||
          (i == toIndex && toIndex > _moveSourceIndex)) {
        upperStackSize += _itemSizes[i];
      }
      if (offset != _curTransformY[i]) {
        _curTransformY[i] = offset;
        if (e.style.transition != 'transform:all 0.2s ease-out') {
          e.style.transition = 'all 0.2s ease-out';
        }

        // If the item aligns horizontally the overflowed items should be
        // handled to wrap to next row. If the item is moved off-screen, it's
        // not necessary to be handled.
        if (!verticalItems && offset != -8000) {
          nextOffset = _horizontalTransformHandler(
              e,
              i == 0 ? null : contents[i - 1],
              offset,
              nextOffset,
              leftSide,
              rightSide);
          if (i == toIndex) {
            moveRight = offset > 0;
          }
        } else {
          e.style.transform = offset == 0 ? '' : 'translate(0,${offset}px)';
        }
      }
    }

    if (verticalItems) {
      placeholder.nativeElement.style
        ..height = "${_dragSourceElement.borderEdge.height}px"
        ..width = "${_dragSourceElement.borderEdge.width}px"
        ..top = "${upperStackSize}px";
    } else {
      HtmlElement e = contents[toIndex];
      // If e move right, take its left as placeholder's left. Else, take
      // its right minus drag source width as placeholder's left.
      var left = moveRight
          ? e.offset.left
          : e.offset.right - _dragSourceElement.borderEdge.width;

      placeholder.nativeElement.style
        ..height = "${_dragSourceElement.borderEdge.height}px"
        ..width = "${_dragSourceElement.borderEdge.width}px"
        ..top = "${e.offset.top}px"
        ..left = "${left}px";
    }
    _reorderAttempt.add(_createReorderEvent(_moveSourceIndex, toIndex));
  }

  int _horizontalTransformHandler(HtmlElement e, Element prev, int offset,
      int nextOffset, int leftSide, int rightSide) {
    // Update offset from previous calculated 'nextOffset'
    if (nextOffset != null) {
      // If the nextOffset indicate the item moves to different direction
      // of original offset, we should follow the calculated nextOffset.
      // Otherwise, we should accumulate the offsets.
      if (offset.sign == nextOffset.sign) {
        offset = nextOffset;
      } else {
        offset += nextOffset;
      }
    }
    if (e.offset.right + offset > rightSide) {
      // Right side overflow
      nextOffset = e.offset.width;
      e.style.transform = 'translate(${-e.offset.left + leftSide}px,'
          '${e.offset.height}px)';
    } else if (e.offset.left + offset < leftSide) {
      // Left side overflow
      if (e.offset.width < prev.offset.right) {
        // Enough room in last row
        nextOffset = -e.offset.width;
        e.style.transform = 'translate('
            '${prev.offset.right - leftSide + offset}px,'
            '${-e.offset.height}px)';
      } else {
        // No room in last row
        nextOffset = 0;
      }
    } else {
      e.style.transform = 'translate(${offset}px,0px)';
    }
    return nextOffset;
  }

  /// Starts listening to drag events for a child element.
  void track(HtmlElement element) {
    element.draggable = true;
    List subs = _subscriptionsForElement(element);
    subs.add(element.onDragStart.listen((e) {
      // Required for firefox to support drag
      e.dataTransfer.setData("Text", element.id);
      e.dataTransfer.effectAllowed = "copyMove";
      _onDragStart(e);
    }));

    subs.add(element.onDragEnd.listen(_onDragEnd));
    subs.add(element.onKeyDown.listen((e) => _onKeyDown(e, element)));
    _dragSubscriptions[element] =
        element.onDragOver.listen((e) => _onDragOver(e, element));
    // Subscribing to onclick events when multi select is turned on.
    if (multiSelect) {
      subs.add(element.onClick.listen((e) => _onClick(e, element)));
    }
  }

  void unTrack(HtmlElement element) {
    // Cancel subscriptions to events for removed element.
    var subs = _subscriptionsForElement(element);
    for (StreamSubscription s in subs) {
      s.cancel();
    }
    _subscriptions.remove(element);

    if (_dragSubscriptions[element] != null) {
      _dragSubscriptions[element].cancel();
    }
    _dragSubscriptions.remove(element);
  }

  get _reorderElements => _items.map((x) => x.element).toList();

  void _onDragStart(MouseEvent e) {
    // If multiSelect is enabled, clear the selection and replace with the
    // target of the drag start event.
    if (multiSelect) {
      int index = _getIndex(e.currentTarget);
      if (!_selectedElementIndexes.contains(index)) {
        _clearSelection();
        _selectedElementIndexes.add(index);
        _notifySelectionChange();
      }
    }
    _dragSourceElement = e.currentTarget;
    _dragSourceElement.classes.add('reorder-list-dragging-active');
    // Initialize all transforms.
    var contents = _reorderElements;
    int childCount = contents.length;
    _moveSourceIndex = contents.indexOf(_dragSourceElement);
    _curTransformY = new List<int>.filled(childCount, 0);
    _itemSizes = new List<int>(childCount);
    for (int i = 0; i < childCount; i++) {
      _itemSizes[i] =
          verticalItems ? contents[i].offset.height : contents[i].offset.width;
    }
    _reorderActive = true;
    _currentMoveIndex = _moveSourceIndex;
    // Move element off the grid as soon as reorder starts
    _moveItem(_currentMoveIndex, _currentMoveIndex);
  }

  void _onDragEnd(MouseEvent e) {
    e.stopPropagation();

    _reorderActive = false;
    _dragSourceElement.classes.remove('reorder-list-dragging-active');
    _reorderActive = false;
    _resetChildren();

    _reorder.add(_createReorderEvent(_moveSourceIndex, _currentMoveIndex));
    if (multiSelect) {
      _clearSelection();
      _notifySelectionChange();
    }
  }

  void _onKeyDown(KeyboardEvent e, HtmlElement element) {
    if ((e.keyCode == KeyCode.UP || e.keyCode == KeyCode.DOWN) &&
        modifiersKeysFor(e)) {
      int index = _getIndex(element);
      if (index == -1) {
        return;
      }

      int newIndex = _getNewIndex(e.keyCode, index);
      _reorderElements[newIndex].focus();

      e.preventDefault();
      e.stopPropagation();
    } else if ((e.keyCode == KeyCode.UP || e.keyCode == KeyCode.DOWN) &&
        modifiersKeysFor(e, shiftKey: true)) {
      int index = _getIndex(element);
      if (index == -1) {
        return;
      }

      int newIndex = _getNewIndex(e.keyCode, index);

      if (newIndex != index) {
        _reorder.add(_createReorderEvent(index, newIndex));
        // Make sure that element will be focused after digest cycle
        _ngZone.onEventDone.first.then((_) {
          // TODO(google): Add support for multiselect keyboard actions.
          // At the moment, only moves the last selected item.
          var element = _reorderElements[newIndex];
          if (multiSelect) {
            _clearSelection();
            element.classes.add(itemSelectedCssClass);
            _selectedElementIndexes.add(newIndex);
            _notifySelectionChange();
          }
          element.focus();
        });
      }
      e.preventDefault();
      e.stopPropagation();
    } else if ((e.keyCode == KeyCode.DELETE ||
            e.keyCode == KeyCode.NUM_DELETE ||
            e.keyCode == KeyCode.BACKSPACE) &&
        modifiersKeysFor(e)) {
      if ((e.target as HtmlElement) != element) return;
      int index = _getIndex(element);
      if (index == -1) {
        return;
      }
      removeAt(index);
      e.stopPropagation();
      e.preventDefault();
    }
  }

  void _onClick(MouseEvent e, HtmlElement element) {
    int index = _getIndex(element);
    if (index == -1) {
      return;
    }

    if (e.shiftKey) {
      _handleShift(index);
    } else if (e.ctrlKey || e.metaKey) {
      _handleCtrl(index, element);
    } else {
      if (!_selectedElementIndexes.contains(index)) {
        _clearSelection();
        _selectedElementIndexes.add(index);
      }
      // When just clicking on an item, it will be the pivot for shift selection
      _pivotItemIndex = index;
    }
    _notifySelectionChange();
  }

  void removeAt(int index) {
    _delete.add(index);
    // Wait for digest and focus new element
    _ngZone.onEventDone.first.then((_) {
      if (index < _reorderElements.length) {
        _reorderElements[index].focus();
      } else if (_reorderElements.isNotEmpty) {
        _reorderElements[_reorderElements.length - 1].focus();
      }
    });
  }

  // Handles selection change call emitting,
  void _notifySelectionChange() {
    var sources = new List<int>.from(_selectedElementIndexes);
    sources.sort();
    _itemSelectionChanged.add(new ItemSelectionEvent(sources));
  }

  // Handles Ctrl|Metakey key selection when onClick event is fired.
  void _handleCtrl(int index, HtmlElement element) {
    // With Ctrl click, the last item selected will be the pivot.
    _pivotItemIndex = index;

    if (element.classes.contains(itemSelectedCssClass)) {
      element.classes.remove(itemSelectedCssClass);
      _selectedElementIndexes.remove(index);
    } else {
      element.classes.add(itemSelectedCssClass);
      _selectedElementIndexes.add(index);
    }
  }

  // Handles shift key selection when onClick event is fired.
  void _handleShift(int index) {
    if (_pivotItemIndex == null) {
      _pivotItemIndex = index;
    }

    var indexes = new List<int>.from(
        range(min(_pivotItemIndex, index), max(_pivotItemIndex, index)));
    // Range gives the values until the biggest index, but not including it.
    // So adding it manually.
    indexes.add(max(_pivotItemIndex, index));
    _clearSelection();
    var allElements = _reorderElements;
    for (var index in indexes) {
      allElements[index].classes.add(itemSelectedCssClass);
      _selectedElementIndexes.add(index);
    }
  }

  void _clearSelection() {
    var allElements = _reorderElements;
    for (var index in _selectedElementIndexes) {
      allElements[index].classes.remove(itemSelectedCssClass);
    }
    _selectedElementIndexes.clear();
  }

  int _getNewIndex(int keyCode, int index) {
    if (keyCode == KeyCode.UP && index > 0) {
      return index - 1;
    } else if (keyCode == KeyCode.DOWN && index < _reorderElements.length - 1) {
      return index + 1;
    } else {
      return index;
    }
  }

  void _onDragOver(MouseEvent event, HtmlElement element) {
    if (_dragSourceElement == element) {
      return;
    }

    var elementIndex = _getIndex(element);

    var moveTargetIndex = elementIndex;
    if (_currentMoveIndex < _moveSourceIndex &&
        elementIndex >= _currentMoveIndex) {
      moveTargetIndex++;
    }
    if (_currentMoveIndex > _moveSourceIndex &&
        elementIndex <= _currentMoveIndex) {
      moveTargetIndex--;
    }

    if (_currentMoveIndex != moveTargetIndex &&
        _reorderActive &&
        moveTargetIndex != -1) {
      _moveItem(_currentMoveIndex, moveTargetIndex);
      _currentMoveIndex = moveTargetIndex;

      // Need to temporary remove drag listener for element
      // we're switching with to not trigger another event during transition
      // otherwise we can trigger onDrag during transition and cause flickering
      _dragSubscriptions[element].cancel();
      _dragSubscriptions[element] == null;
      new Future.delayed(new Duration(milliseconds: 250), () {
        // Check if element wasn't untracked
        if (_subscriptions[element] != null) {
          _dragSubscriptions[element] =
              element.onDragOver.listen((e) => _onDragOver(e, element));
        }
      });
    }
  }

  int _getIndex(HtmlElement element) {
    List contents = _reorderElements;
    int childCount = contents.length;
    for (int i = 0; i < childCount; i++) {
      if (element == contents[i]) {
        return i;
      }
    }
    return -1;
  }

  ReorderEvent _createReorderEvent(int sourceIndex, int destIndex) {
    if (multiSelect) {
      var sources = new List<int>.from(_selectedElementIndexes);
      sources.sort();
      return new MultiReorderEvent(sources, destIndex);
    } else {
      return new ReorderEvent(sourceIndex, destIndex);
    }
  }

  /// Resets transforms and transitions for a child after drag&drop event
  /// iscompleted or is canceled.
  void _resetChildren() {
    if (_currentMoveIndex != -1) {
      List contents = _reorderElements;
      int childCount = contents.length;
      for (int i = 0; i < childCount; i++) {
        HtmlElement e = contents[i];
        e.style.transition = '';
        if (_curTransformY[i] != 0) {
          e.style.transform = '';
        }
      }
    }
  }

  /// Lazily creates a list for subscriptions for element.
  List<StreamSubscription> _subscriptionsForElement(HtmlElement elm) {
    var l = _subscriptions[elm];
    if (l == null) {
      l = <StreamSubscription>[];
      _subscriptions[elm] = l;
    }
    return l;
  }

  bool get showPlaceholder => _reorderActive;
}

typedef void ReorderListHandler(int sourceIndex, int destIndex);

/// Indicates that a child will participate in reorder operation inside a
/// reorder-list component. See ReorderListComponent for usage.
// TODO(google): Add back in host value once host attribute bug
// is fixed.
@Directive(
    selector: '[reorderItem]',
    host: const {'draggable': 'true', 'role': 'listitem', 'tabindex': '0'})
class ReorderItemDirective {
  final HtmlElement element;

  ReorderItemDirective(ElementRef elementRef)
      : element = elementRef.nativeElement;
}
