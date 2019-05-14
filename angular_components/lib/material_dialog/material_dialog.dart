// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/focus/focus_trap.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/model/a11y/keyboard_handler_mixin.dart';
import 'package:angular_components/utils/browser/dom_service/dom_service.dart';
import 'package:angular_components/utils/disposer/disposer.dart';
import 'package:angular_components/utils/id_generator/id_generator.dart';

/// A styled container following the Material Spec for Dialogs.
///
/// __Supported Content:__
///
/// - `[header]` -- Header content for the dialog.
/// - `[footer]` -- Footer content for the dialog.
///
/// __Attributes:__
///
///  - `headered` -- Adds a gray background to the dialog header.
///  - `info` -- Styles the dialog as an info dialog.
///
@Component(
  selector: 'material-dialog',
  templateUrl: 'material_dialog.html',
  styleUrls: ['material_dialog.scss.css'],
  directives: [FocusTrapComponent, NgIf],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class MaterialDialogComponent
    with KeyboardHandlerMixin
    implements AfterContentChecked, OnDestroy {
  @HostBinding('attr.role')
  static const hostRole = 'dialog';

  @HostBinding('attr.aria-modal')
  static const ariaModel = 'true';

  @HostBinding('attr.aria-labelledby')
  String get headerId => shouldShowHeader ? _uid : null;

  final HtmlElement _rootElement;
  final DomService _domService;
  final ChangeDetectorRef _changeDetector;
  final NgZone _ngZone;
  final ModalComponent _modal;
  final _disposer = Disposer.oneShot();
  final _uid = SequentialIdGenerator.fromUUID().nextId();

  HtmlElement _mainElement;
  bool _shouldShowHeader = true;
  bool _shouldShowFooter = true;
  bool shouldShowTopScrollStroke = false;
  bool shouldShowBottomScrollStroke = false;

  final _isInFullscreenModeStreamController = StreamController<bool>();
  bool _isInFullscreenMode;
  bool _shouldListenForFullscreenChanges = false;

  MaterialDialogComponent(
    this._rootElement,
    this._domService,
    this._changeDetector,
    this._ngZone,
    @Optional() this._modal,
  ) {
    escapeHandler = _defaultEscapeHandler;
  }

  @ViewChild('main', read: HtmlElement)
  set main(HtmlElement element) {
    _mainElement = element;
    _disposer.addStreamSubscription(element.onScroll.listen((_) {
      _setHeaderFooterScrollBorder();
    }));
    if (_modal == null) return;
    _disposer.addStreamSubscription(_modal.onOpen.listen((_) {
      _setHeaderFooterScrollBorder();
    }));
  }

  /// Function to handle escape key events from the dialog. By default it tries
  /// to close the parent modal, if any.
  @Input()
  KeyboardEventHandler escapeHandler;

  /// Error to show up in the error section of the dialog.
  @Input()
  String error;

  /// Whether to hide the dialog header.
  @Input()
  set hideHeader(bool shouldHideHeader) =>
      _shouldShowHeader = !shouldHideHeader;

  /// Whether to hide the dialog footer.
  @Input()
  set hideFooter(bool shouldHideFooter) =>
      _shouldShowFooter = !shouldHideFooter;

  bool get shouldShowHeader => _shouldShowHeader;

  bool get shouldShowFooter => _shouldShowFooter;

  /// Whether to show the top/bottom borders on the <main> part of the dialog to
  /// indicate whether there is more content that the user can reach by
  /// scrolling.
  @Input()
  bool shouldShowScrollStrokes = true;

  void _setHeaderFooterScrollBorder() {
    if (!shouldShowScrollStrokes) return;
    _disposer.addDisposable(_domService.scheduleRead(() {
      var shouldShowTopScrollStroke =
          _mainElement.scrollTop > 0 && error == null;
      var shouldShowBottomScrollStroke =
          _mainElement.clientHeight < _mainElement.scrollHeight &&
              _mainElement.scrollTop <
                  _mainElement.scrollHeight - _mainElement.clientHeight;
      if (shouldShowTopScrollStroke != this.shouldShowTopScrollStroke ||
          shouldShowBottomScrollStroke != this.shouldShowBottomScrollStroke) {
        this.shouldShowTopScrollStroke = shouldShowTopScrollStroke;
        this.shouldShowBottomScrollStroke = shouldShowBottomScrollStroke;
        // Update the DOM based on the newly modified state.
        _ngZone.runAfterChangesObserved(() {
          _changeDetector.markForCheck();
        });
      }
    }));
  }

  /// Determines whether to listen for when the dialog enters or exits
  /// fullscreen mode.
  @Input('listenForFullscreenChanges')
  set shouldListenForFullscreenChanges(bool shouldListenForFullscreenChanges) {
    // Don't do anything if [shouldListenForFullscreenChanges] is set to false.
    if (!shouldListenForFullscreenChanges) return;

    // If [_shouldListenForFullscreenChanges] is set to true, then that means
    // that we're already listening to fullscreen changes, so don't do anything.
    if (_shouldListenForFullscreenChanges) return;

    _shouldListenForFullscreenChanges = shouldListenForFullscreenChanges;
    _disposer.addStreamSubscription(window.onResize.listen((_) {
      _listenForFullscreenChanges();
    }));
  }

  /// Stream for when the dialog enters or exits fullscreen mode.
  @Output('fullscreenMode')
  Stream<bool> get isInFullscreenMode =>
      _isInFullscreenModeStreamController.stream;

  void _listenForFullscreenChanges() {
    if (!_shouldListenForFullscreenChanges) return;
    _disposer.addDisposable(
        _domService.scheduleRead(_updateForFullscreenChangesInsideDomReadLoop));
  }

  void _updateForFullscreenChangesInsideDomReadLoop() {
    final isInFullscreenMode =
        document.body.clientWidth <= _rootElement.clientWidth &&
            document.body.clientHeight <= _rootElement.clientHeight;
    if (_isInFullscreenMode != isInFullscreenMode) {
      _isInFullscreenMode = isInFullscreenMode;
      _isInFullscreenModeStreamController.add(isInFullscreenMode);
    }
  }

  @override
  void handleEscapeKey(KeyboardEvent event) {
    if (escapeHandler != null) {
      escapeHandler(event);
    }
  }

  void _defaultEscapeHandler(KeyboardEvent event) {
    if (_modal != null) {
      event.preventDefault();
      _modal.close();
    }
  }

  @override
  void ngAfterContentChecked() {
    if (_shouldListenForFullscreenChanges) {
      _updateForFullscreenChangesInsideDomReadLoop();
    }

    // This adds or removes the scroll border when the content within the <main>
    // element has changed.
    _setHeaderFooterScrollBorder();
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
  }
}
