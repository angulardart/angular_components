// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import '../focus/focus_trap.dart';
import '../../laminate/components/modal/modal.dart';
import '../../utils/angular/properties/properties.dart';
import '../../utils/browser/dom_service/dom_service.dart';
import '../../utils/disposer/disposer.dart';
import 'package:angular2/angular2.dart';

/// A styled container following the Material Spec for Dialogs.
///
/// See <http://www.google.com/design/spec/components/dialogs.html>.
///
/// __Supported Content__:
///
/// - `[header]` -- Header content for the dialog.
/// - `[footer]` -- Footer content for the dialog.
///
/// __Attributes__:
///
///  - `headered` -- Adds a gray background to the dialog header.
///  - `info` -- Styles the dialog as an info dialog.
///
/// __Inputs__:
///
///  - `error: String` -- Error to show up in the error section of the dialog.
///  - `hideHeader: String or bool` -- Whether to hide the dialog header.
///  - `hideFooter: String or bool` -- Whether to hide the dialog footer.
///
/// __Basic Dialog__:
///
/// This should be used in a directive that knows to move content to an overlay.
/// For example, using the [Modal] component:
///
///     <modal [visible]="showDialog">
///       <material-dialog>
///         <div header>
///           <h3>Title</h3>
///           <p>Subtitle</p>
///         </div>
///
///         <p>Content goes here.</p>
///
///         <div footer>
///           <material-button (trigger)="showDialog = false">
///             Close
///           </material-button>
///         </div>
///       </material-dialog>
///     </modal>
///
/// __Headered Dialog__:
///
/// To create a dialog with a dark gray header, add the `headered` attribute.
/// For example:
///
///     <modal [visible]="showDialog">
///       <material-dialog headered>
///         <div header>
///           <h3>Title</h3>
///           <p>Subtitle</p>
///         </div>
///
///         <p>Content goes here.</p>
///
///         <div footer>
///           <material-button (trigger)="showDialog = false">
///             Close
///           </material-button>
///         </div>
///       </material-dialog>
///     </modal>
///
/// __Info Dialog__:
///
/// To create an information dialog, add the `info` attribute and put a material
/// button that uses a glyph for closing the dialog.
/// For example:
///
///     <modal [visible]="showDialog">
///       <material-dialog info>
///
///         <div header>
///           <material-button icon (trigger)="showDialog = false">
///             <glyph icon="close"></glyph>
///           </material-button>
///
///           <h3>Title</h3>
///         </div>
///
///         <p>Content goes here.</p>
///
///       </material-dialog>
///     </modal>
///
@Component(
    selector: 'material-dialog',
    preserveWhitespace: false,
    templateUrl: 'material_dialog.html',
    styleUrls: const ['material_dialog.scss.css'],
    directives: const [FocusTrapComponent, NgIf],
    changeDetection: ChangeDetectionStrategy.OnPush)
class MaterialDialogComponent implements AfterContentChecked, OnDestroy {
  final DomService _domService;
  final ChangeDetectorRef _changeDetector;
  final ModalComponent _modal;
  final _disposer = new Disposer.oneShot();

  HtmlElement _mainElement;
  bool _shouldShowHeader = true;
  bool _shouldShowFooter = true;
  bool shouldShowTopScrollStroke = false;
  bool shouldShowBottomScrollStroke = false;

  MaterialDialogComponent(
      this._domService, this._changeDetector, @Optional() this._modal);

  @ViewChild('main')
  set main(ElementRef elementRef) {
    _mainElement = elementRef.nativeElement;
    if (_modal == null) return;
    _disposer.addStreamSubscription(_modal.onOpen.listen((_) {
      _setHeaderFooterScrollBorder();
    }));
  }

  @Input()
  String error;

  @Input()
  set hideHeader(shouldHideHeader) =>
      _shouldShowHeader = !getBool(shouldHideHeader);

  @Input()
  set hideFooter(shouldHideFooter) =>
      _shouldShowFooter = !getBool(shouldHideFooter);

  bool get shouldShowHeader => _shouldShowHeader;

  bool get shouldShowFooter => _shouldShowFooter;

  void onScroll() => _setHeaderFooterScrollBorder();

  void _setHeaderFooterScrollBorder() {
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
        _changeDetector
          ..markForCheck()
          // This detectChanges() here is for updating the classes when the page
          // initially loads .
          ..detectChanges();
      }
    }));
  }

  @override
  void ngAfterContentChecked() {
    // This adds or removes the scroll border when the content within the <main>
    // element has changed.
    _setHeaderFooterScrollBorder();
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
  }
}
