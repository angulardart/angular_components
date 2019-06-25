// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';
import 'dart:html';

/// DomTreeIterator is tool that will let you traverse the dom in the dom order
/// and find all (or specific element).
///
/// Supports limiting traversal to the scope (element of the scope is included)
/// Supports reverse traversal (find previous element)
///
/// Right now wrapped traversal is supported only if bounded to the scope.
/// wrapped traversal will stop if it hits starting element
class DomTreeIterator implements Iterator<Element> {
  final bool _reverse;
  final bool _wraps;
  final Element _startingElement;
  final Element _scope;
  Element _element;

  /// Creates new dom iterator.
  /// [element] : element to start iteration from.
  /// [reverse] : if true, will iterate back in dom order.
  /// [scope] : scope to limit the iteration.
  /// [wraps] : if set to true, will not stop at the end of scope,
  ///   but instead will wrap through beginning and will end upon hitting
  ///   the starting element instead.
  DomTreeIterator(element,
      {bool reverse = false, Element scope, bool wraps = false})
      : _element = element,
        _startingElement = element,
        _reverse = reverse,
        _scope = scope,
        _wraps = wraps {
    if (_wraps && _scope == null) {
      throw Exception('global wrapping is disallowed, scope is required');
    }
    if (_scope != null && !_scope.contains(_element)) {
      throw Exception('if scope is set, '
          'starting element should be inside of scope');
    }
  }

  /// Returns another iterator, starting from the current element and heading
  /// reverse order.
  /// Scope is retained, while wrapping may be overriden
  /// if wraps is true or inherited from current as true,
  /// new wraps will start from current position.
  DomTreeIterator reversed({wraps}) {
    return DomTreeIterator(_element,
        reverse: !_reverse, scope: _scope, wraps: wraps ?? _wraps);
  }

  /// get current element
  @override
  Element get current => _element;

  /// move to the next element, return false if no more elements there
  @override
  bool moveNext() {
    if (_element == null) {
      return false;
    }

    if (_element == _scope && _element.children.isEmpty) {
      _element = null;
      return false;
    }

    if (_reverse) {
      _navigateBackward();
    } else {
      _navigateForward();
    }

    if (_element == _startingElement) {
      _element = null;
    }

    return (_element != null);
  }

  // Last child first postorder tree traversal.
  // recursive form:
  // traverse(this) {
  //   yield(this);
  //   for (child in children) {
  //     traverse(child);
  //   }
  // }
  //
  // 1) Check if we're the scope (which is the last element in traversal),
  // if we wrap - do wrap, otherwise finish.
  //
  // 2) Check if element has no parent, it likely mean that we are scopeless
  // and just traversed last element.
  //
  // 3) Check if element is first child of it's parent, then parent is next.
  //
  // 4) Go to last descendant of previous sibling, it's next in order.
  void _navigateBackward() {
    if (_element == _scope) {
      // 1
      if (_wraps) {
        _element = lastDescendant(_scope);
      } else {
        _element = null;
      }
    } else if (_element.parent == null) {
      // 2
      _element = null;
    } else if (_element == _firstChild(_element.parent)) {
      // 3
      _element = _element.parent;
    } else {
      // 4
      _element = _element.previousElementSibling;
      while (_element.children.isNotEmpty) {
        _element = _lastChild(_element);
      }
    }
  }

  // First child first preorder tree traversal.
  // Recursive form:
  // traverse(this) {
  //   for (child in children.reversed) {
  //     traverse(child);
  //   }
  //   yield(this);
  // }
  //
  // 1) Check if element has children, if it does -
  // next element is the first child.
  //
  // 2) Climb up until we hit element that has next sibling or until
  // it doesn't and it's parent is either scope or it has no parent.
  //
  // 3) If we hit scope or null parent and element is last sibling,
  // we went through the scope/document, wrap if applicable.
  //
  // 4) Otherwise simply go to the next sibling.
  void _navigateForward() {
    if (_element.children.isNotEmpty) {
      // 1
      _element = _firstChild(_element);
    } else {
      // 2
      while (_element.parent != null &&
          _element.parent != _scope &&
          _element == _lastChild(_element.parent)) {
        _element = _element.parent;
      }
      // 3
      if (_element.parent == null ||
          (_element.parent == _scope &&
              _element == _lastChild(_element.parent))) {
        if (_wraps) {
          _element = _scope;
        } else {
          _element = null;
        }
      } else {
        _element = _element.nextElementSibling;
      }
    }
  }
}

/// Returns last descendant in the [scope] in dom order
Element lastDescendant(Element scope) {
  Element current = scope;
  while (current.children.isNotEmpty) {
    current = _lastChild(current);
  }
  return current;
}

Element _firstChild(Element element) => element.children[0];

Element _lastChild(Element element) {
  ListBase<Element> children = element.children;
  return children[children.length - 1];
}
