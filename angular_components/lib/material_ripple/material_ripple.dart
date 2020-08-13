// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:math';

import 'package:angular/angular.dart';
import 'package:angular_components/utils/browser/events/events.dart';
import 'package:angular_components/utils/browser/feature_detector/feature_detector.dart'
    show supportsAnimationApi;
import 'package:angular_components/utils/color/material.dart'
    show rippleOpacity;

// The ripple size is 256x256 for optimal performance (power-of-two texture)
// while maintaining smooth ripple edges (since the texture is being scaled on
// the GPU). 256x256 results in 260 KB of GPU memory per ripple.
const _rippleDiameter = 256;
const _rippleRadius = _rippleDiameter / 2;
const _minOpacity = 0.0;
const _maxOpacity = rippleOpacity;

// After 3 ripples have been created, older ones will be recycled to save GPU
// memory and DOM memory. This means that there can be a maximum of 3 ripples at
// a time.
const _maxRipples = 3;

// All of these variables are outside of the class because it results in faster
// variable access patterns.
int _numRipples = 0;
int _rippleIndex = 0;

// If these were initialized here (and final), dart2js would wait to initialize
// them until the first mousedown event, increasing latency.
List<DivElement> _ripplePool;
DivElement _rippleTemplate;
Map<String, double> _opacityTiming;
List<Map<String, double>> _opacityKeyframes;
Map<String, dynamic> _transformTiming;

// This is outside of the class because it causes dart2js to inline this
// function and use faster variable access patterns.
void _createRipple(
    int clientX, int clientY, HtmlElement container, bool center) {
  // All of the DOM reads occur before the DOM writes.
  final rect = container.getBoundingClientRect();

  // Create a ripple or grab one from the pool.
  DivElement ripple;
  if (_numRipples < _maxRipples) {
    ripple = _rippleTemplate.clone(false) as DivElement;
    _ripplePool[_rippleIndex] = ripple;
    _numRipples++;
  } else {
    ripple = _ripplePool[_rippleIndex];
    ripple.remove();
  }

  if (++_rippleIndex == _maxRipples) _rippleIndex = 0;

  // Apply the animation and append the ripple to the container.
  // The applyAnimation functions are inlined by dart2js.
  if (supportsAnimationApi) {
    _applyAnimation(ripple, center, rect, clientX, clientY);
  } else {
    _applyFallbackAnimation(ripple, center, rect, clientX, clientY);
  }
  container.append(ripple);
}

/// Dynamically generate and apply the ripple animation.
void _applyAnimation(
    DivElement ripple, bool center, Rectangle rect, int clientX, int clientY) {
  // The ripple starting diameter is 60% of the largest container dimension.
  final containerWidth = rect.width;
  final containerHeight = rect.height;
  final maxDimension =
      (containerWidth > containerHeight) ? containerWidth : containerHeight;
  final minScale = (maxDimension * 0.6) / _rippleDiameter;

  // The ripple ends 10px larger than the container.
  // This assumes a rectangular container.
  final maxRadius =
      sqrt(pow(containerWidth / 2, 2) + pow(containerHeight / 2, 2)) + 10;
  final maxScale = maxRadius / _rippleRadius;

  String top;
  String left;
  String initialTransform;
  String finalTransform;

  if (center) {
    top = 'calc(50% - ${_rippleRadius}px)';
    left = 'calc(50% - ${_rippleRadius}px)';
    initialTransform = 'scale($minScale)';
    finalTransform = 'scale($maxScale)';
  } else {
    final offsetX = clientX - rect.left - _rippleRadius;
    final offsetY = clientY - rect.top - _rippleRadius;
    // The ripple drifts from the point of touch to the center of the container.
    final driftX = (containerWidth / 2 - _rippleRadius) - offsetX;
    final driftY = (containerHeight / 2 - _rippleRadius) - offsetY;
    top = '${offsetY}px';
    left = '${offsetX}px';
    initialTransform = 'translate(0, 0) scale($minScale)';
    finalTransform = 'translate(${driftX}px, ${driftY}px) scale($maxScale)';
  }

  final transformKeyframes = [
    {'transform': initialTransform},
    {'transform': finalTransform},
  ];

  ripple.style.cssText = 'top: $top; left: $left; transform: $finalTransform';
  ripple.animate(_opacityKeyframes, _opacityTiming);
  ripple.animate(transformKeyframes, _transformTiming);
}

/// Apply a static fallback animation for browsers that don't support the
/// Web Animations API.
void _applyFallbackAnimation(
    DivElement ripple, bool center, Rectangle rect, int clientX, int clientY) {
  String top;
  String left;

  if (center) {
    top = 'calc(50% - ${_rippleRadius}px)';
    left = 'calc(50% - ${_rippleRadius}px)';
  } else {
    final offsetX = clientX - rect.left - _rippleRadius;
    final offsetY = clientY - rect.top - _rippleRadius;
    top = '${offsetY}px';
    left = '${offsetX}px';
  }

  ripple.style.top = top;
  ripple.style.left = left;
}

/// A component that provides a visual effect that other elements can use to
/// simulate a rippling effect emanating from the point of contact.
///
/// The effect can be visualized as a concentric circle with motion.
///
/// The containing element needs to be position: relative.
///
/// By default, the ripple is centered on the point of contact.
@Component(
  selector: 'material-ripple',
  template: '',
  encapsulation: ViewEncapsulation.None,
  styleUrls: ['material_ripple.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class MaterialRippleComponent implements OnDestroy {
  final HtmlElement _element;
  EventListener _onMouseDown;
  EventListener _onKeyDown;

  MaterialRippleComponent(this._element) {
    // These are initialized here instead of when they're declared because
    // dart2js would otherwise wait to initialize them until they are used.
    _ripplePool ??= List<DivElement>(_maxRipples);
    _opacityTiming ??= {
      'duration': 300.0,
    };
    _opacityKeyframes ??= [
      {'opacity': _minOpacity},
      {'opacity': _maxOpacity, 'offset': 0.25},
      {'opacity': _maxOpacity, 'offset': 0.5},
      {'opacity': _minOpacity},
    ];
    _transformTiming ??= {
      'duration': 225.0,
      'easing': 'cubic-bezier(0.4, 0.0, 0.2, 1)',
    };
    // This is className = instead of classes.add because classes.add compiles
    // to a DOM read, conversion to List, and then a DOM write.
    if (_rippleTemplate == null) {
      final className =
          (supportsAnimationApi) ? '__acx-ripple' : '__acx-ripple fallback';
      _rippleTemplate = DivElement()..className = className;
    }

    // This is necessary because if _onMouseDown was a method, a new closure
    // would be created each time it was referenced. That means that
    // _onMouseDown in removeEventListener would point to a different listener,
    // so the listener would not be removed.
    _onMouseDown = (e) {
      // This is inlined by dart2js so we aren't incurring an additional
      // function call here.
      final clientX = (e as MouseEvent).client.x;
      final clientY = (e as MouseEvent).client.y;
      _createRipple(clientX, clientY, _element, center);
    };
    _onKeyDown = (e) {
      if (!isKeyboardTrigger(e)) return;
      // Ripples created by a keypress are always centered.
      _createRipple(0, 0, _element, true);
    };
    // This is about 5x faster than _element.onMouseDown.listen or Angular
    // (mousedown) because this compiles directly to addEventListener, whereas
    // the streams approach adds several layers of slow indirection.
    _element.addEventListener('mousedown', _onMouseDown);
    _element.addEventListener('keydown', _onKeyDown);
  }

  /// Allow the ripple to be created programmatically.
  void createRipple(int clientX, int clientY) =>
      _createRipple(clientX, clientY, _element, center);

  /// Whether the ripple should start from the center of the container.
  @Input()
  bool center = false;

  @override
  void ngOnDestroy() {
    _element.removeEventListener('mousedown', _onMouseDown);
    _element.removeEventListener('keydown', _onKeyDown);
    _ripplePool.forEach((ripple) {
      if (ripple?.parent == _element) {
        ripple.remove();
      }
    });
  }
}
