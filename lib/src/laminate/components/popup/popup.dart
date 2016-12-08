// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular2_components.laminate.components.popup.popup;

import 'dart:async';
import 'dart:html';

import '../../../components/annotations/rtl_annotation.dart';
import '../../../components/content/deferred_content_aware.dart';
import './base.dart';
import './hierarchy.dart';
import '../../popup/popup.dart';
import '../../portal/portal.dart';
import '../../../model/ui/toggle.dart';
import '../../../utils/browser/dom_service/dom_service.dart';
import '../../../utils/disposer/disposer.dart';
import 'package:angular2/angular2.dart';

export 'src/popup_source_directive.dart';

/// A declarative Angular API to interact with popups.
///
/// See [PopupInterface] for properties and [PopupEvents] for events.
///
/// Child components (e.g. popup contents) may inject the [PopupRef] created.
///
/// Source components may implement the [Toggler] API in order to directly
/// control the popup.
PopupComponent_getResolvedPopupRef(c) => PopupComponent.getResolvedPopupRef(c);

PopupComponent_getHierarchy(c) => c.hierarchy;

@Component(
    selector: 'popup',
    host: const {
      '[attr.pane-id]': 'uniqueId',
    },
    inputs: const [
      'alignContentX',
      'alignContentY',
      'autoDismiss',
      'enforceSpaceConstraints',
      'matchSourceWidth',
      'matchMinSourceWidth',
      'offsetX',
      'offsetY',
      'preferredPositions',
      'source',
      'trackLayoutChanges',
      'visible'
    ],
    outputs: const ['onOpen: open', 'onClose: close', 'onVisible: visible'],
    providers: const [
      const Provider(DeferredContentAware, useExisting: PopupComponent),
      const Provider(PopupHierarchy,
          useFactory: PopupComponent_getHierarchy,
          deps: const [PopupComponent]),
      const Provider(PopupRef,
          useFactory: PopupComponent_getResolvedPopupRef,
          deps: const [PopupComponent])
    ],
    directives: const [PopupRefDirective],
    template: r'''
      <template [popupRef]="resolvedPopupRef">
        <ng-content></ng-content>
      </template>
    ''')
class PopupComponent extends Object
    with PopupBase, PopupEvents, PopupHierarchyElement
    implements DeferredContentAware, OnDestroy, PopupInterface {
  /// Returns the created [PopupRef] for [component].
  ///
  /// If the internal future is still pending, throws [StateError].
  static PopupRef getResolvedPopupRef(PopupComponent component) {
    if (component.resolvedPopupRef == null) {
      bool tryInitView = true;
      assert(() {
        if (tryInitView) return true;
        // There should not be a case where a child popup is visible before.
        // If a popup child component requires PopupRef injection, ensure it is
        // wrapped by [DeferredContentDirective] or
        // [CachingDeferredContentDirective].
        throw new StateError('No popup reference resolved yet: '
            'Ensure you are using deferredContent on popup child component');
      });

      component._initView();
      if (component._resolvedPopupRef == null) {
        // There should not be a case where a child popup is visible before
        throw new StateError('No popup reference resolved yet.');
      }
    }

    return component._resolvedPopupRef;
  }

  final DomService _domService;
  final Disposer _disposer = new Disposer.oneShot();
  final NgZone _ngZone;
  final PopupService _popupService;
  bool _isRtl;
  PopupHierarchy _hierarchy;

  PopupRef parentPopup;

  PopupRef _resolvedPopupRef;

  bool _viewInitialized = false;
  bool _isDisposed = false;

  /// Create a new popup component, which creates a [PopupRef].
  ///
  /// A [parentPopup] is used to establish a hierarchy if available.
  PopupComponent(
      this._domService,
      @Optional() @SkipSelf() this._hierarchy,
      @Optional() @SkipSelf() PopupRef parentPopup,
      this._ngZone,
      this._popupService,
      @Optional() @Inject(rtlToken) bool rtl) {
    _isRtl = rtl ?? false;
  }

  /// The popup visible hierarchy.
  PopupHierarchy get hierarchy {
    _hierarchy = _hierarchy ?? new PopupHierarchy();
    return _hierarchy;
  }

  @override
  bool get autoDismiss => state.autoDismiss;

  @override
  Stream<bool> get contentVisible => onVisible;

  void _initView() {
    assert(_viewInitialized == false);

    _resolvedPopupRef =
        _popupService.createSync(initialState: state, parent: parentPopup);
    _initPopupRef(_resolvedPopupRef);
    _viewInitialized = true;
  }

  @override
  void ngOnDestroy() {
    _resolvedPopupRef?.dispose();
    detachFromVisibleHierarchy();
    _disposer.dispose();
    _isDisposed = true;
  }

  /// A reference to the popup instance created and managed by the component.
  PopupRef get resolvedPopupRef => _resolvedPopupRef;

  // Once the popup instance was created, listen to events.
  void _initPopupRef(PopupRef popupRef) {
    _resolvedPopupRef = popupRef;
    _disposer
      ..addStreamSubscription(popupRef.onOpen.listen(onPopupOpened))
      ..addStreamSubscription(popupRef.onClose.listen(onPopupClosed))
      ..addStreamSubscription(
          popupRef.onVisibleChanged.listen(onVisibleChanged));
  }

  // TODO(google): Move dismiss logic to PopupRef once old component removed
  void onDismiss() {
    // Wait until the VM turn to allow capture logic on other places on the UI
    // to act (e.g. close or hide the popup via something like a button).
    _domService.nextFrame.then((_) {
      // Re-enter Angular if we are closing the popup.
      if (_resolvedPopupRef.isVisible) {
        _ngZone.run(_resolvedPopupRef.close);
      }
    });
  }

  /// Visible for override.
  void onPopupOpened(PopupEvent popupEvent) {
    onOpen.add(popupEvent);
  }

  /// Visible for override.
  void onPopupClosed(PopupEvent popupEvent) {
    onClose.add(popupEvent);
  }

  /// When the popup's visibility (e.g. open or close finishes) changes, we
  /// should update the internal state and update any listeners.
  ///
  /// Visible for override.
  void onVisibleChanged(bool newVisibility) {
    onVisible.add(newVisibility);
    if (newVisibility) {
      attachToVisibleHierarchy();
    } else {
      detachFromVisibleHierarchy();
    }
  }

  @override
  final PopupState state = new PopupState();

  /// The unique ID of the popup pane, which is added to the DOM for testing.
  String get uniqueId => _resolvedPopupRef?.uniqueId;

  /// Sets preferred positions of material popup and flips preferred positions
  /// for RTL languages.
  @override
  set preferredPositions(Iterable preferredPositions) {
    if (_isRtl) {
      // If [_isRtl] is true flip preferred positions for RTL languages.
      super.preferredPositions = _flipPositions(preferredPositions);
    } else {
      super.preferredPositions = preferredPositions;
    }
  }

  Iterable _flipPositions(Iterable preferredPositions) {
    var flippedPositions = [];
    for (var position in preferredPositions) {
      if (position is Iterable) {
        flippedPositions.add(_flipPositions(position));
      } else {
        flippedPositions.add(position.flipRelativePosition());
      }
    }
    return flippedPositions;
  }

  @override
  set visible(bool visible) {
    if (visible) {
      // If visibility is immediately true, we need to wait until the end of the
      // VM turn to ensure our popup contents are first captured.
      if (!_viewInitialized) {
        _initView();

        _domService.nextFrame.then((_) {
          _ngZone.run(() {
            // This check is necessary to prevent a race condition.
            if (!_isDisposed) _resolvedPopupRef.open();
          });
        });
      } else {
        _resolvedPopupRef.open();
      }
    } else {
      _resolvedPopupRef?.close();
    }
  }

  @override
  void toggle() {
    visible = !(_resolvedPopupRef?.isVisible ?? false);
  }

  @override
  set source(PopupSource source) {
    super.source = source;

    // The [PopupComponent] supports direct control over the [PopupRef] by way
    // of the Toggle library. Here, we register the [PopupRef] as a
    // [Toggleable] iff [source] uses the library.
    if (source is Toggler) {
      (source as Toggler).toggleable = new _DeferredToggleable(this);
    }
  }

  @override
  List<Element> get autoDismissBlockers {
    // If the popup source is based on an element, exclude the source element
    // from the auto dismiss logic, i.e. clicking on the source element does
    // not trigger auto dismiss.
    var sourceElement = state.source is ElementPopupSource
        ? (state.source as ElementPopupSource).sourceElement
        : null;
    return sourceElement?.nativeElement != null
        ? <Element>[sourceElement.nativeElement]
        : <Element>[];
  }

  @override
  Element get container => _popupService.getContainerElement(_resolvedPopupRef);
}

class _DeferredToggleable extends Toggleable {
  final PopupComponent _popupComponent;

  _DeferredToggleable(this._popupComponent);

  @override
  bool get isOn => _popupComponent.resolvedPopupRef?.isOn ?? false;

  @override
  set isOn(bool state) {
    if (_popupComponent.resolvedPopupRef == null) {
      if (!state) return;
      _popupComponent._initView();
    }

    _popupComponent.resolvedPopupRef.isOn = state;
  }
}

@Directive(selector: '[popupRef]', inputs: const ['popupRef'])
class PopupRefDirective extends TemplatePortal {
  PopupRefDirective(TemplateRef templateRef, ViewContainerRef viewContainerRef)
      : super(templateRef, viewContainerRef);

  set popupRef(PopupRef popupRef) {
    if (popupRef != null) {
      popupRef.attach(this);
    } else if (isAttached) {
      detach();
    }
  }
}
