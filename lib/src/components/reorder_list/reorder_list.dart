// Copyright 2016 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';
import 'dart:html';

import 'package:angular2/angular2.dart';

import '../../utils/angular/managed_zone/angular_2.dart';
import '../../utils/async/async.dart';
import '../../utils/disposer/disposer.dart';
import '../../utils/keyboard/keyboard.dart';

/// Provides a list that can reorder it's children using html5 drag&drop.
/// A vertical reorder-list will use any component in its <ng-content>
/// marked with 'reorderPlaceholder' attribute as a placeholder when moving
/// items.
///
/// Typical use:
/// '''
/// <reorder-list (reorder)="onReorder($event)">
///   <div *ngFor="#item of items" reorderItem>
///     {{item}}
///   </div>
/// </reorder-list>
/// '''
///
/// User is responsible for listening to reorder events
/// and updating order of elements accordingly
@Component(
    selector: 'reorder-list',
    host: const {'role': 'list'},
    templateUrl: 'reorder_list.html',
    styleUrls: const ['reorder_list.scss.css'])
class ReorderListComponent implements OnDestroy {
  final _disposer = new Disposer.oneShot();

  /// Will emit [ReorderEvent] after reordering has finished.
  @Output()
  final reorder = new LazyEventEmitter<ReorderEvent>();

  /// Will emit [ReorderEvent] when the prospective reordering position has
  /// changed.
  @Output()
  final reorderAttempt = new LazyEventEmitter<ReorderEvent>();

  /// Will emit [int] index of element to delete when delete is triggered.
  @Output()
  final delete = new LazyEventEmitter<int>();

  final ManagedZone _managedZone;

  /// If true (default), items are aligned vertically.
  @HostBinding('class.vertical')
  @Input()
  bool verticalItems = true;

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

  @ViewChild('placeholder', read: ElementRef)
  ElementRef placeholder;

  ReorderListComponent(
      this._managedZone, @ContentChildren(ReorderItemDirective) this._items) {
    _subscriptions = new Map<HtmlElement, List<StreamSubscription>>();
    _dragSubscriptions = new Map<HtmlElement, StreamSubscription>();
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
    int nextOffset = null;
    int upperStackSize = 0;
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
        } else {
          e.style.transform = offset == 0 ? '' : 'translate(0,${offset}px)';
        }
      }
    }

    placeholder.nativeElement.style
      ..height = "${_dragSourceElement.borderEdge.height}px"
      ..width = "${_dragSourceElement.borderEdge.width}px"
      ..top = "${upperStackSize}px";
    reorderAttempt.add(new ReorderEvent(_moveSourceIndex, toIndex));
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

  _onDragEnd(MouseEvent e) {
    e.stopPropagation();

    _reorderActive = false;
    _dragSourceElement.classes.remove('reorder-list-dragging-active');
    _reorderActive = false;
    _resetChildren();

    reorder.add(new ReorderEvent(_moveSourceIndex, _currentMoveIndex));
  }

  _onKeyDown(KeyboardEvent e, HtmlElement element) {
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
        reorder.add(new ReorderEvent(index, newIndex));
        // Make sure that element will be focused after digest cycle
        _managedZone.onTurnDone.first
            .then((_) => _reorderElements[newIndex].focus());
      }
      e.preventDefault();
      e.stopPropagation();
    } else if ((e.keyCode == KeyCode.DELETE ||
            e.keyCode == KeyCode.NUM_DELETE ||
            e.keyCode == KeyCode.BACKSPACE) &&
        modifiersKeysFor(e)) {
      int index = _getIndex(element);
      if (index == -1) {
        return;
      }
      removeAt(index);
      e.stopPropagation();
      e.preventDefault();
    }
  }

  void removeAt(int index) {
    delete.add(index);
    // Wait for digest and focus new element
    _managedZone.onTurnDone.first.then((_) {
      if (index < _reorderElements.length) {
        _reorderElements[index].focus();
      } else if (_reorderElements.isNotEmpty) {
        _reorderElements[_reorderElements.length - 1].focus();
      }
    });
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

  _onDragOver(MouseEvent event, HtmlElement element) {
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

  bool get showPlaceholder => verticalItems && _reorderActive;
}

typedef void ReorderListHandler(int sourceIndex, int destIndex);

class ReorderEvent {
  int sourceIndex;
  int destIndex;

  ReorderEvent(this.sourceIndex, this.destIndex);
}

/// Indicates that a child will participate in reorder operation inside a
/// reorder-list component. See ReorderListComponent for usage.
@Directive(
    selector: '[reorderItem]',
    host: const {'draggable': 'true', 'role': 'listitem', 'tabindex': '0'})
class ReorderItemDirective {
  final HtmlElement element;

  ReorderItemDirective(ElementRef elementRef)
      : element = elementRef.nativeElement {}
}
