// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular2/angular2.dart';

import 'src/wave.dart';
import '../../utils/browser/dom_service/angular_2.dart';
import '../../utils/disposer/disposer.dart';

/// A component that provides a visual effect that other elements can use to
/// simulate a rippling effect emanating from the point of contact.
///
/// The effect can be visualized as a concentric circle with motion.
///
/// Example of use:
///     <div><material-ripple></material-ripple></div>
///
/// `material-ripple` listens to `mouse-down` and `mouse-up` events so it would
/// display ripple effects when touches are on it.
///
/// By default, the ripple is centered on the point of contact.
@Component(
    selector: 'material-ripple',
    providers: const [domServiceBinding],
    host: const {'(mousedown)': r'downAction($event)'},
    template: '', // Removed for performance.
    encapsulation: ViewEncapsulation.None,
    styleUrls: const ['material_ripple.scss.css'],
    changeDetection: ChangeDetectionStrategy.Detached)
class MaterialRippleComponent implements OnDestroy {
  static const String FOCUSED_OPACITY = '.12';
  static const double FOCUSED_OPACITY_INT = 0.12;
  static const String TRANSPARENT_OPACITY = '0';

  HtmlElement _element;
  final Disposer _disposer = new Disposer.multi();
  HtmlElement _background;
  HtmlElement _container;
  final DomService _domService;

  final bool _center;
  final bool _recenter;
  final _waves = <Wave>[];

  bool _isAnimating = false;
  StreamController<bool> _onAnimatingController;

  bool _focused = false;

  /// Creates a new material ripple at [elementRef].
  factory MaterialRippleComponent(
      @Attribute('center') String center,
      @Attribute('recenter') String recenter,
      ElementRef elementRef,
      DomService domService) {
    return new MaterialRippleComponent._(
        elementRef, domService, center != null, recenter != null);
  }

  MaterialRippleComponent._(
      ElementRef elementRef, this._domService, this._center, this._recenter)
      : _element = elementRef.nativeElement;

  @override
  void ngOnDestroy() {
    _disposer.dispose();
    _element = null;
    _background = null;
    _container = null;
  }

  /// Trigger animation.
  ///
  /// All of this is one big DOM Write. Ensure that no DOM reads occur in this
  /// function, and schedule it's execution with a [DomService.scheduleWrite]
  void _animate() {
    if (_element == null) return; // Component was destroyed.
    if (!_isAnimating) {
      _isAnimating = true;
      if (_onAnimatingController != null) {
        _onAnimatingController.add(true);
      }
    }

    var shouldKeepAnimating = false;

    for (var i = 0; i < _waves.length; i++) {
      // Draw every wave.
      final wave = _waves[i];
      if (!wave.isAnimationComplete) {
        shouldKeepAnimating = true;
      }

      wave.draw();

      // Set the background layer opacity.
      if (_focused && wave.outerOpacity < FOCUSED_OPACITY_INT) {
        _background.style.opacity = FOCUSED_OPACITY;
      } else {
        _background.style.opacity = wave.outerOpacity.toString();
      }

      // If the ripple is done animating, remove it.
      if (wave.isOpacityFullyDecayed && !wave.isRestingAtMaxRadius) {
        _removeWave(wave);
      }
    }

    if (!shouldKeepAnimating && _waves.isEmpty) {
      _triggerAnimationComplete();
    } else {
      _domService.nextFrame.then((_) {
        _domService.scheduleWrite(_animate);
      });
    }
  }

  /// An event stream that fires when the animation state changes.
  @Output('animating')
  Stream<bool> get onAnimating {
    if (_onAnimatingController == null) {
      _onAnimatingController = new StreamController<bool>(sync: true);
    }
    return _onAnimatingController.stream;
  }

  /// Triggered when there is a browser event like mouse down.
  void downAction([MouseEvent e]) {
    _initDom();

    final wave = _addWave()..downAction(e?.client);
    _nextMouseUp().then((_) {
      wave.upAction();
      _domService.scheduleWrite(_animate);
    });
    if (!_isAnimating) {
      _domService.scheduleWrite(_animate);
    }
  }

  /// Completes the next time the mouse is released.
  Future _nextMouseUp() {
    final completer = new Completer.sync();
    final maybeComplete = (UIEvent e) {
      if (completer.isCompleted) return;
      completer.complete(e);
      _disposer.dispose(); // Cleanup the document subscriptions.
    };
    _disposer.addStreamSubscription(
        document.onMouseUp.take(1).listen(maybeComplete));
    _disposer.addStreamSubscription(
        document.onDragEnd.take(1).listen(maybeComplete));
    _disposer.addStreamSubscription(
        document.onTouchEnd.take(1).listen(maybeComplete));
    return completer.future;
  }

  /// Trigger the end of animation.
  void _triggerAnimationComplete() {
    _isAnimating = false;
    if (!_focused) {
      _background.style.opacity = TRANSPARENT_OPACITY;
    }
    if (_onAnimatingController != null) {
      _onAnimatingController.add(false);
    }
  }

  void _initDom() {
    // Initialize the background and waves divs.
    if (_element != null && _background == null) {
      _background = new Element.div()
        ..classes.add('__material-ripple_background');
      _container = new Element.div()..classes.add('__material-ripple_waves');
      _element..append(_background)..append(_container);
    }
  }

  Wave _addWave() {
    final wave = new Wave(_container, center: _center, recenter: _recenter);
    _waves.add(wave);
    return wave;
  }

  /// Remove a completed [wave].
  void _removeWave(Wave wave) {
    // Remove the DOM element.
    wave.remove();

    // Remove from the collection of managed waves.
    _waves.remove(wave);
  }

  /// Sets the focus of the ripple.
  @Input()
  set focused(bool value) {
    if (_focused == value) return;
    _focused = value;
    _initDom();

    // Defensively check for the element being created before scheduling an
    // opacity change - if another dom write triggers change detection then a
    // ripple can be created in a DOM write which in turn will process this
    // synchronously.
    if (!_isAnimating && _background != null) {
      _domService.scheduleWrite(() {
        if (_background != null) {
          _background.style.opacity =
              _focused ? FOCUSED_OPACITY : TRANSPARENT_OPACITY;
        }
      });
    }
  }

  bool get focused => _focused;
}
