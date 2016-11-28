// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular2_components.laminate.popup.src.popup_controller_base;

import 'dart:async';
import 'dart:math';

import 'package:angular2/angular2.dart';

import '../../enums/alignment.dart';
import './dom_popup_source.dart';
import './popup_event.dart';
import './popup_ref.dart';
import './popup_service.dart';
import './popup_source.dart';
import '../../portal/portal.dart';
import '../../../utils/angular/properties/properties.dart';
import '../../../utils/disposer/disposer.dart';

/// Base class with constructor for [ExperimentalPopupController] to extend.
abstract class PopupControllerBase extends PopupController {
  @override
  final DomPopupSourceFactory domPopupSourceFactory;
  @override
  final PopupService popupService;
  PopupControllerBase(this.domPopupSourceFactory, this.popupService);
}

/// Mixin class shared by [PopupDirective] and [ExperimentalPopupController].
abstract class PopupController implements OnDestroy {
  /// Getters for subclasses to implement.
  DomPopupSourceFactory get domPopupSourceFactory;
  PopupService get popupService;

  /// Override this if there is a parent popup.
  Future<PopupRef> get parentPopupRefFuture => null;

  /// A future that will resolve with an instance of the popup ref. Available
  /// immediately after instantiation as `_popupRefFuture` is not created until
  /// the popup is about to be shown.
  Future<PopupRef> get eagerPopupRefFuture => _eagerPopupRefFuture.future;
  final _eagerPopupRefFuture = new Completer<PopupRef>.sync();

  /// A future that will resolve with an instance of the popup ref.
  Future<PopupRef> _popupRefFuture;
  final disposer = new Disposer.oneShot();

  StreamSubscription _outsideClickListener;
  StreamSubscription _onOpenSubscription;
  StreamSubscription _onCloseSubscription;

  // Lazily loaded.
  // TODO(google): Add LazyStreamController to ads/acx2/async to simplify.
  StreamController<PopupEvent<Rectangle>> _onOpenEmitter;
  StreamController<PopupEvent<bool>> _onCloseEmitter;
  StreamController<bool> _onVisibleEmitter;
  StreamController<PopupRef> _onReadyEmitter;

  // A flag on whether this directive has been destroyed.
  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;

  // Whether popup service has finished creating the popup.
  PopupRef _popupRef;

  // Temporarily hold property setters, flushing when the popup is ready.
  // TODO(google): This is getting out of control, move buffering out.
  String _alignXBuffer;
  String _alignYBuffer;
  bool _autoDismissBuffer;
  bool _enforceSpaceConstraintsBuffer;
  bool _matchSourceWidthBuffer;
  int _offsetXBuffer;
  int _offsetYBuffer;
  Iterable<RelativePosition> _preferredPositionsBuffer;
  var _relativeToBuffer;
  bool _trackLayoutChangesBuffer;
  bool _visibleBuffer;

  /// Whether the popup has been created.
  bool get _isPopupReady => _popupRef != null;

  /// The unique ID of the created popup.
  String get uniqueId => _isPopupReady ? _popupRef.uniqueId : null;

  void _createPopupRef() {
    // TODO(google): Split this up into parts and use async/await.
    assert(!_isPopupReady);
    _popupRefFuture = popupService.create();
    _popupRefFuture.then((popupRef) {
      // If the directive was destroyed before this returned, destroy.
      if (_isDisposed) {
        popupRef.dispose();
        return;
      }
    });
    _popupRefFuture.then((p) => _eagerPopupRefFuture.complete(p));
  }

  void attachPopupContents(TemplatePortal portal, popupRef) {
    portal.attach(popupRef, {'popup': popupRef}).then((_) {
      // If the directive was destroyed before this returned, destroy.
      if (_isDisposed) {
        popupRef.dispose();
        return;
      }
      // Save this popup reference.
      _popupRef = popupRef;
      disposer.addFunction(_popupRef.dispose);
      // If there are any property setters queued, update.
      _syncBufferedValues();
      // Notify the (ready) event if there is a listener.
      if (_onReadyEmitter != null) {
        _onReadyEmitter.add(_popupRef);
      }
      // Listen for visibility changes and add listeners to the document.
      // TODO(google): Move to PopupRef.
      disposer
          .addStreamSubscription(popupRef.onVisibleChanged.listen((visible) {
        if (visible) {
          _addOutsideListener();
        } else {
          _removeOutsideListener();
        }
        // Notify the (visible) event if there is a listener.
        if (_onVisibleEmitter != null) {
          _onVisibleEmitter.add(visible);
        }
      }));
    });
  }

  void _syncBufferedValues() {
    if (_alignXBuffer != null) {
      alignX = _alignXBuffer;
    }
    if (_alignYBuffer != null) {
      alignY = _alignYBuffer;
    }
    if (_autoDismissBuffer != null) {
      autoDismiss = _autoDismissBuffer;
    }
    if (_enforceSpaceConstraintsBuffer != null) {
      enforceSpaceConstraints = _enforceSpaceConstraintsBuffer;
    }
    if (_matchSourceWidthBuffer != null) {
      matchSourceWidth = _matchSourceWidthBuffer;
    }
    if (_offsetXBuffer != null || _offsetYBuffer != null) {
      _updateOffset();
    }
    if (_relativeToBuffer != null) {
      relativeTo = _relativeToBuffer;
    }
    if (_trackLayoutChangesBuffer != null) {
      trackLayoutChanges = _trackLayoutChangesBuffer;
    }
    if (_visibleBuffer != null) {
      visible = _visibleBuffer;
    }
    if (_preferredPositionsBuffer != null) {
      preferredPositions = _preferredPositionsBuffer;
    }
    if (_onOpenEmitter != null && _onOpenSubscription == null) {
      _onOpenSubscription = disposer
          .addStreamSubscription(_popupRef.onOpen.listen(_onOpenEmitter.add));
    }
    if (_onCloseEmitter != null && _onCloseSubscription == null) {
      _onCloseSubscription = disposer
          .addStreamSubscription(_popupRef.onClose.listen(_onCloseEmitter.add));
    }
  }

  // TODO(google): Move this logic into PopupRef.
  void _addOutsideListener() {
    _outsideClickListener =
        popupService.onTriggerOutsideOf(_popupRef).listen((_) {
      // If the popup should auto-close and the popup is visible, close it.
      // This avoids race conditions where the popup is opening (but not open).
      if (_popupRef.state.autoDismiss && _popupRef.isVisible) {
        _popupRef.close();
      }
    });
  }

  // TODO(google): Move this logic into PopupRef.
  void _removeOutsideListener() {
    if (_outsideClickListener != null) {
      _outsideClickListener.cancel();
      _outsideClickListener = null;
    }
  }

  @override
  void ngOnDestroy() {
    _removeOutsideListener();
    _isDisposed = true;
    disposer.dispose();
  }

  /// An event stream proxy to [PopupRef.onOpen].
  Stream<PopupEvent<Rectangle>> get onOpen {
    if (_onOpenEmitter == null) {
      _onOpenEmitter = disposer.addEventSink(
          new StreamController<PopupEvent<Rectangle>>(sync: true));
      if (_isPopupReady) {
        _onOpenSubscription = disposer
            .addStreamSubscription(_popupRef.onOpen.listen(_onOpenEmitter.add));
      }
    }
    return _onOpenEmitter.stream;
  }

  /// An event stream proxy to [PopupRef.onClose].
  Stream<PopupEvent<bool>> get onClose {
    if (_onCloseEmitter == null) {
      _onCloseEmitter = disposer
          .addEventSink(new StreamController<PopupEvent<bool>>(sync: true));
      if (_isPopupReady) {
        _onCloseSubscription = disposer.addStreamSubscription(
            _popupRef.onClose.listen(_onCloseEmitter.add));
      }
    }
    return _onCloseEmitter.stream;
  }

  /// An event stream proxy to [PopupRef.onVisibleChanged].
  Stream<bool> get onVisible {
    if (_onVisibleEmitter == null) {
      _onVisibleEmitter =
          disposer.addEventSink(new StreamController<bool>(sync: true));
      // We do not listen to _popupRef.onVisible here, this happens
      // automatically when it is created since we need that event to add and
      // remove document listeners
      //
      // TODO(google): Once the above logic is moved into PopupRef, revisit.
    }
    return _onVisibleEmitter.stream;
  }

  /// An event that will fire when the popup is created.
  Stream<PopupRef> get onReady {
    if (_onReadyEmitter == null) {
      _onReadyEmitter =
          disposer.addEventSink(new StreamController<PopupRef>(sync: true));
      if (_isPopupReady) {
        _onReadyEmitter.add(_popupRef);
      }
    }
    return _onReadyEmitter.stream;
  }

  // Property setters
  // ---------------------------------------------------------------------------

  /// Sets the x-axis alignment of the popup.
  set alignX(String alignX) {
    if (_isPopupReady) {
      _popupRef.setAlignX(alignX);
    } else {
      _alignXBuffer = alignX;
    }
  }

  /// Sets the y-axis alignment of the popup.
  set alignY(String alignY) {
    if (_isPopupReady) {
      _popupRef.setAlignY(alignY);
    } else {
      _alignYBuffer = alignY;
    }
  }

  /// Sets whether the popup should dismiss itself on document press.
  set autoDismiss(bool autoDismiss) {
    if (_isPopupReady) {
      _popupRef.setAutoDismiss(autoDismiss);
    } else {
      _autoDismissBuffer = autoDismiss;
    }
  }

  /// Sets whether the popup should enforce space constraints.
  set enforceSpaceConstraints(enforceSpaceConstraints) {
    var value = getBool(enforceSpaceConstraints);
    if (_isPopupReady) {
      _popupRef.setEnforceSpaceConstraints(value);
    } else {
      _enforceSpaceConstraintsBuffer = value;
    }
  }

  /// Sets whether the popup should match the width of the relative element.
  set matchSourceWidth(bool matchSourceWidth) {
    if (_isPopupReady) {
      _popupRef.setMatchSourceWidth(matchSourceWidth);
    } else {
      _matchSourceWidthBuffer = matchSourceWidth;
    }
  }

  /// Sets the x offset to where the popup will be positioned ultimately.
  set offsetX(int offsetX) {
    _offsetXBuffer = offsetX;
    if (_isPopupReady) {
      _updateOffset();
    }
  }

  /// Sets the y offset to where the popup will be positioned ultimately.
  set offsetY(int offsetY) {
    _offsetYBuffer = offsetY;
    if (_isPopupReady) {
      _updateOffset();
    }
  }

  /// Sets the [positions] to use for [enforceSpaceConstraints].
  set preferredPositions(Iterable<RelativePosition> positions) {
    if (_isPopupReady) {
      _popupRef.setPreferredPositions(positions);
    } else {
      _preferredPositionsBuffer = positions;
    }
  }

  /// Sets whether to use [trackLayoutChanges].
  set trackLayoutChanges(dynamic trackLayoutChanges) {
    var value = getBool(trackLayoutChanges);
    if (_isPopupReady) {
      _popupRef.state.trackLayoutChanges = value;
    } else {
      _trackLayoutChangesBuffer = value;
    }
  }

  void _updateOffset() {
    _popupRef.state.offsetX = _offsetXBuffer ?? 0;
    _popupRef.state.offsetY = _offsetYBuffer ?? 0;
  }

  /// Sets what the popup should be created relative to.
  set relativeTo(/* ElementRef|Element|PopupSource */ element) {
    // TODO(google): Purposefully not typed, it will change to ElementRef.
    if (_isPopupReady) {
      final popupSource = element is PopupSource
          ? element
          : element is ElementRef
              ? domPopupSourceFactory.create(element.nativeElement)
              : domPopupSourceFactory.create(element);
      _popupRef.state.source = popupSource;
    } else {
      _relativeToBuffer = element;
    }
  }

  /// Sets whether the popup should be visible.
  set visible(bool visible) {
    if (_isPopupReady) {
      _popupRef.setVisible(visible);
    } else {
      if (visible == true && _popupRefFuture == null) {
        _createPopupRef();
      }
      _visibleBuffer = visible;
    }
  }
}
