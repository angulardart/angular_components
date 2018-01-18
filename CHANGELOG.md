## 0.9.0-alpha+3

> NOTE: This code is considered production quality, but depends on angular:
> 5.0.0-alpha+3. The alpha tag represents the evolving nature of the AngularDart
> api, not code quality (5.0.0-alpha+3 is used in production Google apps).

**NOTE**: As of `angular 5.0.0-alpha+1` [`dependency_overrides`][dep_overrides]
are **required**:

```yaml
dependency_overrides:
  analyzer: ^0.31.0-alpha.1
```

This is because Angular is starting to use and support the Dart 2.0.0 SDK, which
is evolving. We expect to no longer require overrides once we are at a beta
release, but this is unlikely until sometime in early 2018.

[dep_overrides]: https://www.dartlang.org/tools/pub/dependencies#dependency-overrides

 * Add support for package
   [build_runner](https://pub.dartlang.org/packages/build_runner).
 * Material Auto-Suggest Input:
   * Wait for the popup to be visible before activating dropdown items.
   * Stop escape keyboard events from propagating after they are handled.
   * Disallow deselection when clicked on a selected item with single selection
   * models.
   * Ensure input text is initialized correctly regardless of input order.
   * Fix auto-scrolling issue on Firefox.
 * Material Checkbox: Make focusable.
 * Material Fab: Update shadow styles.
 * Material Input: Don't override underline color when the input is invalid.
 * Material Menu: Add button content customization.
 * Material Radio: Update disabled color to match spec.
 * Material Select:
   * Wait for the popup to be visible before activating dropdown items.
   * Stop escape keyboard events from propagating after they are handled.
   * Fix `MaterialSelectItem` displaying two times the label when
     `factoryRenderer` is used.
   * Fix auto-scrolling issue on Firefox.
 * Material Tab: Add two-way binding on fixed strip activeTabIndex.
 * Material Tree: Autofocus the filter when `MaterialTreeDropdown` is opened,
   but not when it closes.
 * Better support for the zippy expansion case in selection model.
 * Deprecate getBool, angular supports it now natively.
 * Fix RTE when using item renderers as highlight renderers when there is a
   custom factory renderer.
 * Fix componentRenderer logic.
 * Add option to disable select all in the table selection model.
 * Add a feature detector for `position: sticky`.
 * Migrate from Glyph to Material Icon.
 * Remove unused table model.
 * Remove the getDynamic method from properties helpers.
 * Remove uses of .runtimeType.
 * Fix uses_bottom_as_dynamic ("fuzzy arrow") errors.
 * Cleanup unneeded `preserveWhitespace: false` and `preserveWhitespace: true`.
 * Cleanup type warnings and other Dart 2.0 fixes.
 * Cleanup unused variables.
 * Update documentation.

## 0.9.0-alpha+2

> NOTE: This code is considered production quality, but depends on angular:
> 5.0.0-alpha+2. The alpha tag represents the evolving nature of the AngularDart
> api, not code quality (5.0.0-alpha+2 is used in production Google apps).

**NOTE**: As of `angular 5.0.0-alpha+1` [`dependency_overrides`][dep_overrides]
are **required**:

```yaml
dependency_overrides:
  analyzer: ^0.31.0-alpha.1
```

This is because Angular is starting to use and support the Dart 2.0.0 SDK, which
is evolving. We expect to no longer require overrides once we are at a beta
release, but this is unlikely until sometime in early 2018.

[dep_overrides]: https://www.dartlang.org/tools/pub/dependencies#dependency-overrides

 * Material Auto-Suggest Input: Add ability to give a tooltip for the clear
   icon.
 * Material Expansionpanel: Add mixin for flat on collapse.
 * Material Input:
   * Protected against input being destroyed and blur event still happening.
   * Add mixin for fixed width error text.
 * Material Menu: Add mixin for lowercase button text.
 * Material Toggle: Add mixin to display label on the right.
 * Material Select: Add mixin to change `material-select-dropdown-item` padding.
 * Allow `material-scrollbar` mixin to be used in global css (without angular).
 * Add directives for Material Menu to `materialDirectives`.
 * Remove `MaterialButtonBase` from `materialDirectives`.
 * Migrate from Glyph to Material Icon.
 * Provide a path to use Component Factories when using code that was previously
   using the `ComponentRenderer` pattern.
 * Generic type fixes.
 * Continue migration from `SlowComponentLoader` to `ComponentLoader`.
 * Continue migration from `LazyStreamController` to `StreamController`.
 * Cleanup Angular static analysis warnings.
 * Rename `Visibility.none` to `Visibility.local`.
 * Add optional punctuation around trackBy functions.

## 0.9.0-alpha+1

> NOTE: This code is considered production quality, but depends on angular:
> 5.0.0-alpha+1. The alpha tag represents the evolving nature of the AngularDart
> api, not code quality (5.0.0-alpha+1 is used in production Google apps).

**NOTE**: As of `angular 5.0.0-alpha+1` [`dependency_overrides`][dep_overrides]
are **required**:

```yaml
dependency_overrides:
  analyzer: ^0.31.0-alpha.1
```

This is because Angular is starting to use and support the Dart 2.0.0 SDK, which
is evolving. We expect to no longer require overrides once we are at a beta
release, but this is unlikely until sometime in early 2018.

[dep_overrides]: https://www.dartlang.org/tools/pub/dependencies#dependency-overrides

 * Add Material Menu component.
 * Update SDK lower bound to 2.0.0-dev.3.0, matching Angular.
 * Material Auto Suggest Input: Replace ngOnChanges(\_) with ngAfterChanges.
 * Material Button:
   * Update dense mixin to only apply to non-icon buttons.
   * Add mixins for no hover highlight.
   * Add mixins to set icon button padding.
 * Material Chips: Update margin on dense theme.
 * Material Fab: Update size mixin.
 * Material Input:
   * Use markForChanges on inputs since they are being set by a directive and
     not the template and so change detection doesn't happen automatically.
   * Allow numerical values to be internationalized in number validators.
   * Add option to have a material number input component format its contents on
     blur.
 * Material Select:
   * Add mixin to set select item padding.
   * Add mixin to set selected item color.
   * Allow customization of Material Dropdown Select's role.
   * Add mixin for pointer events on Material Dropdown Select Items.
   * Fix baseline alignment of dropdown-button in Firefox.
 * Material Tree: Improve latency of `MaterialTreeFilter`.
 * Scoreboard:
   * Fix misalignment on OS X with hl=ja.
   * Selected color input overrides default color value in a selectable
     scoreboard.
 * Avoid reliance on dynamic typing to access properties.
 * Add @input to number validators.
 * Cleanup unneeded `preserveWhitespace: false` and `preserveWhitespace: true`
   when components manage spacing around themselves.
 * Add Observable utilities.
 * Update documentation.

## 0.9.0-alpha

> NOTE: This code is considered production quality, but depends on angular:
> 5.0.0-alpha. The alpha tag represents the evolving nature of the AngularDart
> api, not code quality (5.0.0-alpha is used in production Google apps).

 * Update dependencies to alpha versions.
   * angular: 5.0.0-alpha
   * angular_forms: 1.0.1-alpha
 * Application Layout: Provide list-item changes as a mixin to be used in
   components that wrap drawer contents.
 * Material Auto Suggest Input: Protect against method being called after it is
    destroyed.
 * Material Button:
   * Update hover, focus, and disabled styles to be inline with Material Spec.
   * Update mixin names and fix to prevent styles leaking outside of the
     component.
 * Material Checkbox:
   * Implement onTouched logic.
   * Fix disabled state to match Material Spec which is a light grey not a
     certain opacity of the checkbox.
 * Material Dialog:
   * Remove `preserveWhitespace: false`.
 * Material Expansionpanel:
   * Smooth appearance/disappearance of expansion panel contents.
   * Add mixin to allow change the panel name min width.
   * Remove `preserveWhitespace: false`.
 * Material Input: Fix unexpected `)` in selector for
   `MaterialInputDefaultValueAccessor`.
 * Material Popup:
   * Listen to DomService.trackLayoutChange streams for overlayRepositionLoop
     popups.
 * Material Progress: Fall back to the non-optimized animation if the width is 0
   after view init.
 * Material Select:
   * Add `showButtonBorder` input to Material Dropdown Select component.
   * Cleanup unused styles.
 * Material Tabs: Increase space between labels.
 * Material Tooltip: Fix material-paper-tooltip content that are change detected
   and using deferred content by having the visible property be set in an async
   manner so that the value isn't added in the middle of a change detection
   loop.
 * Material Tree: Clear filter inside the popup when MaterialTreeDropdown
   closes.
 * Material Yes/No Buttons: Update material-yes-no-buttons mixins to use CSS
   shimming.
 * Scorecard: Add a tooltip field.
 * Use generic type for table selection model `SelectableGetter`.
 * Add color contrast ratio utility.
 * Remove deprecated box-sizing styles.
 * Deprecate `ManagedZone` and replace with `NgZone`.
 * Remove unnecessary uses of `::ng-deep`.
 * Add `visibility: Visibility.none` to most components for reduced code size.
 * Update documentation.

## 0.8.0

 * Move entry points to all components out of the lib/src/ directory.
 * Remove all precompiled .css files.
 * Update all import statements in .scss files to use dart style package
   imports.
 * Add dependency on sass_builder package to compile .css files.

## 0.7.1

 * Add Material Auto Suggest Input component.
 * Material Checkbox: Fix disabled state to match material-spec which is a light
   grey not a certain opacity of the checkbox.
 * Material Chips: Add high density mixin.
 * Material Input:
   * Add selectAll function for calling the underlying input element's select
     method that focuses the input and selects all its content.
   * Add ability to update the data on a change instead of keypress or blur for
     the standard Material Input.
   * Remove error color from floating label to conform to material spec.
 * Material Popup:
   * Fix mismatch between the variable used as a reference point for
     repositioning the popup and the variable used to initially set the popup's
     position. This caused issues when the tab was in the background because
     these variables could have changed significantly before the next animation
     frame fired (since requestAnimationFrame is throttled when the tab isn't
     visible).
   * Use `_sourceDimensions` instead of `layoutRects[1]` to take overlay
     container offset into account. Using popupSourceLayoutStream directly
     caused issues when the .acx-overlay-container offset was not (0, 0).
 * Material Select: Fix orientation when groups are used.
 * Scorecard:
   * Fix styling for extra-big cards.
   * Fix to allow selectable scorecards in a "custom" scoreboard.
   * Add a tooltip field enabling scenarios where more information about the
     value can be displayed.
 * Theme: Prepare dark theme for upcoming Visibility.None change.
 * Cleanup unused fields.
 * Update default material scrollbar width to 8px. This is easier to use with a
   mouse or touch input compared to the previous default of 4px.
 * Cleanup unused styles and reorganize `.scss` files.
 * Remove link hover style.
 * Migrate uses of `ElementRef` to `Element`.
 * Remove `visibility: Visibility.none` from all components since compatibility
   is not yet fully supported. Will be added in an upcoming release.
 * Update documentation.

## 0.7.0

 * Material Button: Add raised mixin so that buttons can be made to be raised
   without using the attribute.
 * Material Expansionpanel: Add header minimum height mixin.
 * Material Input: Add support for custom number formatters.
 * Material Popup:
   * Remove `PopupEvent` and reduce asynchrony.
   * Update PopupSizeProvider max-width/height once the popup has been
     positioned.
   * Remove unused `contenWidth` and `contentHeight`.
 * Material Radio: Avoid selecting null when the new selected value is not found
   in the options.
 * Material Tab:
   * Fix logic for the active tab when tabs themselves are changed. Before logic
     was activating/deactivating based on index, but when tabs change the index
     has probably changed.
   * Make mixin to allow text wrapping.
 * Material Tree:
   * Fix bug where state of material tree option cannot be changed by selection
     model.
   * Fix bug where tree_dropdown_select did not auto open correctly using focus.
 * Scorecard: Update colors to match material spec.
 * Deprecate obsolete box-sizing style mixin.
 * Add link color styles and mixin.
 * Add typography style mixins.
 * Set preserveWhitespace: true in preparation for angular flipping the default
   to false.
 * Make functional directive name lowercase to conform with Dart style guide.
 * Replaces deprecated inputs and outputs with inline annotations.
 * Update visibility for provider resolution fix.
 * Update documentation.

### Known Issues
 * Warnings are present when building with dart2js. Specifically:
   _Method type variables are treated as `dynamic` in `as` expressions._

## 0.6.0

 * Update dependency to angular: ^4.0.0.
 * Update SDK dependencies.
 * Add Material Select Searchbox component.
 * Add Application Layout styles and directives.
 * Add Material Icon.
   * Deprecate `GlyphComponent` in favor of `MaterialIconComponent`.
 * App Layout: Fix margins for header icons/links.
 * Dynamic Component: Add ability to use `ComponentFactory` instead of a `Type`.
 * Material Button: Refactor raised styling so it can be used in a mixin.
 * Material Checkbox:
   * Add ability to make readonly.
   * Add mixin for checkbox with no left margin.
 * Material Chips: Add ability to specify background color for left icon.
 * Material Dialog:
   * Support a minimum height.
   * Fix header mixin.
 * Material Expansionpanel:
   * Add high density mixin.
   * Add mixin to allow changes to panels without affecting nested panels.
 * Material Icon: Add back and forward arrows to the list of flipped icons.
 * Material Input:
   * Add support for material dark theme.
   * Fix disabled color.
   * Add leading text color mixin.
   * Make local required errors to make controls invalid even when the control
     has not been interacted with.
   * Add upper and lower bounds validators.
   * Re-calculate text length when custom character counter is set.
   * Prevent mirror-text overflow in multiline material input.
   * Remove unnecessary selector argument from mixins.
 * Material Popup:
   * Constrain popups to the viewport if both `enforceSpaceConstraints` and
     `overlayRepositionLoop` are enabled.
   * Create the material-popup view synchronously.
   * Remove `animationComplete` event.
   * Integrate with Angular CSS shimming and remove `shadowCssClass`.
   * Material design scrollbars by default (instead of the native scrollbars).
   * Add ARIA attributes.
   * Add an option to reposition visible popups every frame with
     `trackLayoutChanges`.
   * Merge laminate/components/popup into Material Popup.
   * Only set content removed if the popup is still not visible when the timer
     is finished.
 * Material Radio:
   * Add mixin for radio button with no left margin.
   * Fix mixin to respect disabled status when a theme is applied.
 * Material Select:
   * Fix selectable menu item property functionality.
   * Allow dropdown to display an error while it's closed.
   * Fix `MaterialSelectItemComponent` to not cache the label.
   * Add input to material-dropdown-select to define custom a renderer for group
     labels.
   * Fix checkbox display handling and label padding in dropdown.
 * Material Toggle: Set the attribute instead of the property to fix a bug with
   incorrect type, and not setting the right property.
 * Material Tooltips: Add ARIA attributes.
 * Material Tree:
   * Update positioning options and borders.
   * Add optional row separator borders.
   * Fix dropdown closing on toggle issue.
   * Added shift selection/deselection.
   * Fix glyphs always shown expanded when `expandAll = true`.
   * Add ability to preserve expansion state.
   * Fix indentation of first child group.
   * Add input `showDisabledCheckboxes`.
   * Add a max-height mixin.
 * Material Yes/No Buttons: Add dense style.
 * Reorder List:
   * Update to recommended syntax for ngFor.
   * Migrate from ManagedZone to NgZone.
 * Scorecard:
   * Update tab index to prevent scroll errors when going through
     buttons with tabs.
   * Replace deprecated Glyph with Material Icon.
   * Invoke inherited click handler from derived click handler.
 * Selection Models:
   * Add deselect all option.
   * Add a limited filtering model.
   * Fix `selectAll` to only trigger a selection change event for the values
     that were added.
   * Add comparator as optional param to tree selection options for custom
     sorting.
 * Avoid adding placeholder for deferred content if the element is detached.
 * Add new color utils.
 * Update animations to new Material specs.
 * Migrate uses of `GlyphComponent` to `MaterialIconComponent`.
 * Migrate uses of `ElementRef` to `Element`.
 * Remove duplicate PopupSourceDirective.
 * Remove deprecated popup `matchSourceWidth` options.
 * Add missing `MaterialIconComponent`, `MaterialPersistentDrawerDirective`,
   `MaterialTemporaryDrawerDirective`, and `MaterialSelectSearchboxComponent` to
   `materialDirectives`.
 * Improve performance of `TreeSelectionOptions` constructor from O(n^2) to O(n)
    in the size of `listOfOptions`.
 * Change DisplayNameRenderDirective to a functional directive.
 * Deprecate LazyEventEmitter and migrate uses to the StreamController model.
 * Additional styling cleanup to support `ng-deep`.
 * Reduce visibility of common directives/components for smaller code size and
   better performance.
 * Remove use of Compass in SASS files.
 * Remove uses of `getBool` in boolean typed inputs.
 * Remove unused alignment parameters.
 * Updates to use metadata inheritance.
 * Migrate away from comment-style generic syntax.
 * Migrate stylesheet combinators `/deep/` and `>>>` to `::ng-deep`.
 * Migrate away from use of angular's `@View`.
 * Remove unused library statements.
 * Refactor Angular annotations to inline versions.
 * Update documentation.

### Known Issues
 * Warnings are present when building with dart2js. Specifically:
   _Method type variables are treated as `dynamic` in `as` expressions._

## 0.5.3+1

> NOTE: SASS files are not used during the build step of this package and are
> provided as reference only. These .scss files were used to generate the
> corresponding .css files in a separate process. We are working on a solution
> to include CSS generation from SASS files during the build process.

 * Add SASS files.
 * Rename .analysis_options -> analysis_options.yaml

## 0.5.3

 * Add Material Tree component.
 * Material Dialog: Add `shouldShowScrollStrokes` option for displaying
   stroke lines when the content is scrollable.
 * Material Dropdown Select: Avoid checking isSelected with deselectLabel.
 * Material Input: UpperBoundsValidator, and LowerBoundsValidator now use
   `Comparable` instead of `num`.
 * Material Popup: Use the real viewport (aka window) size.
 * Scorecard: Add `ng-content` area for a description.
 * Adjust positioning algorithm to account for scrolling within elements.
 * Migrate use of LazyEventController to StreamController.

## 0.5.2

 * Material Progress: Cleanup animations on destroy to prevent memory leaks.
 * Material Select:
   * Support deselect item in Material dropdown select with single selection
     model.
   * Unified template files (deleted material_select_dropdown_item.html).
   * Add support for `Selectable` `SelectionOptions`.
   * Create a `ControlValueAccessor`.
 * Add backspace and delete keys to `KeyboardHandlerMixin`.
 * Add `selectedValue` getter to `RadioGroupSingleSelectionModel`.
 * Add null check to `ObservableComposite`'s `register` method.
 * Add `totalEntitiesCountChange` getter to table selection models.
 * Add `isStandardMouseEvent` utility to test for clicks without modifier keys.
 * Add string selection sanitizing options.
 * Remove `NoopStream` in favor of `Stream.empty()` as provided by the SDK.
 * Migrate use of LazyEventController to StreamController.
 * Fix bug in lazy group creation that would cause multiple groups to be
   created.
 * Strong mode fixes.

## 0.5.1

 * Glyph: Add baseline attribute.
 * Material Expansionpanel:
   * Allow programmatic `expand` and `collapse` requests even if the panel is
     `disabled`.
   * Change `preserveWhitespace` default to false.
   * Add `enterAccepts` flag.
 * Material Input:
   * Show counter regardless of focus.
   * Add error message to `MaterialPercentInputDirective`.
 * Material List: Allow pointer events when disabled.
 * Material Popup: Fix positioning when `matchMinSourceWidth` is true.
 * Material Ripple: Show a centered ripple on keypress.
 * Material Select:
   * Only display underline when border is also set.
   * Add `useCheckMarks` to use check marks instead of checkboxes.
 * Material Tooltips: Resize to fit contents.
 * Material Yes/No Buttons: Add `enterAccepts` flag.
 * Deprecate LazyStreamController and migrate to StreamController.
 * Migrate use of LazyEventController to StreamController.
 * Documentation fixes.
 * Strong mode fixes.

## 0.5.0

 * Rename library to angular_components.

> All previous versions were published as the
> [Pub Package](https://pub.dartlang.org/packages/angular2_components) named
> `angular2_components`.

## 0.4.1-beta

 * Updated dependencies on `pkg/quiver` and `pkg/intl`.

## 0.4.1-alpha

This code is considered production quality, but depends on angular2:
3.0.0-alpha+1. The alpha tag represents the evolving nature of the AngularDart
api, not code quality (3.0.0-alpha+1 is used in production Google apps).

 * Add Dynamic Component.
 * Add Material Select.
 * Add core Material Design .scss files as a reference. Currently not used
   during build.
 * Material Chip: Add option for icon on the left.
 * Material Expansionpanel: Add option to always display expansion icon.
 * Material Input:
   * Add an optional errorRenderer that will allow clients to override/specify
     their own error messages.
   * Add percent input directive.
 * Material Multiline Input: Fix 'hint' typo in inputs list.
 * Material Radio Group: Support deselecting all radio buttons for unmatched
   value.
 * Material Tooltip: Reduce delay.
 * i18l improvements.

## 0.4.0-alpha

This code is considered production quality, but depends on angular2:
3.0.0-alpha+1. The alpha tag represents the evolving nature of the AngularDart
api, not code quality (3.0.0-alpha+1 is used in production Google apps).

### Breaking Changes
 * Update for generic syntax and `FutureOr` type introduced in Dart SDK 1.22.0.
 * Material Toggle: Remove the deprecated `color` theme input.
 * Material Button, Fab, Yes/No:
   * Remove is-disabled and is-raised HTML classes used for styling.
     Custom styles should now use `[disabled]` and `[raised]` instead of
     `.is-disabled` and `.is-raised` when targeting buttons.
   * Remove z-index of 0.

### Other Changes
 * Focus: Fix AX_ARIA_08 a11y issue.
 * Glyph: Option to horizontally flip glyphs when the direction is RTL.
 * Material Chips: Use :host to remove need for wrapper div.
 * Material Expansionpanel: Fix panel overflow issues.
 * Material Input:
   * Add new number accessors and validators.
   * Add ability to override/specify error messages.
   * Fix AX_TEXT_01 a11y issue.
 * Material List:
   * Block pointer events for disabled list items.
   * Remove duplicate mixin.
 * Material Popup: Disable animation delay when there is nothing to animate.
 * Material Radio: Fix styling issue, flex for IE11.
 * Material Tab Panel: Fix issue that prevents displaying tabs on
   initialization.
 * Material Yes/No Buttons: Add submit/cancel buttons.
 * Scorecard:
   * Add support for RTL languages in scrollable scoreboards.
   * Add support for themes.
   * Prevent exceptions during width calculations when scorecard width is
     `auto`.
 * Compute the ARIA roles only once per instance.
 * Fix dom update issues.
 * Add proper types to injected providers.
 * Add missing imports and remove unsupported Angular imports.
 * Strong mode fixes.

## 0.3.1-alpha

This code is considered production quality, but depends on angular2:
3.0.0-alpha. The alpha tag represents the evolving nature of the AngularDart
api, not code quality (3.0.0-alpha is used in production Google apps).

 * Add Material List.
 * Material Expansionpanel: Add `autoDismissable` directive.
 * Material Progress: Handle changes to "indeterminate" state.
 * Scorecard: Add input to display vertically.
 * Update styles to meet Material UI spec.

## 0.3.0-alpha

This code is considered production quality, but depends on angular2:
3.0.0-alpha. The alpha tag represents the evolving nature of the AngularDart
api.

 * Add Material Tooltip.
 * Material Ripple:
   * Add GPU acceleration.
   * `rippleBindings` have been removed as they are no longer used.
 * Internal updates for compatibility with Angular 3.0.0-alpha.
 * Material Expansion Panel:
   * Fix CSS rule that causes header text to turn gray on hover/focus.
   * Support auto-focus on a content element when the material expansion panel
     expands.
   * Fix Yes/No button ordering.
 * Material Input:
   * Add a blur update value accessor.
   * Add multiple attribute.
   * Remove unused properties: rows and maxRows.
 * Material Input Multiline: Add auto grow in size.
 * Material Popup: Update change detection for OnPush.
 * Material Progress: Update to animate when main thread is blocked.
 * Material Radio: Adjust size to 24px.
 * Material Yes/No: Add toggle for yes button visibility.
 * Scorecard: Update change detection.
 * Fix flipped alignment positions when isRtl is used.
 * Fix popup event handling.
 * Remove 'uninitialized' as a default value.
 * Remove unused CSS rules.
 * Update styles to meet Material UI spec.
 * Bug fixes.
 * Strong Mode fixes.

## 0.2.2

 * Add Material Popup, a basic popup component.
 * Update Material Checkbox icon size.
 * Cleanup framework stabilizers since
   [issue #24843](https://github.com/dart-lang/sdk/issues/24843) in the Dart
   SDK has been resolved.
 * Remove unused files.

## 0.2.1

* Rollup of recent changes.
* Includes fix for breaking change in Angular 2.2.0.

## 0.2.0

* Add a modal dialog window called material_dialog.
* Rename MultilineMaterialInputComponent to MaterialMultilineInputComponent.
* Make the deferredContent placeholder element optional, off by default.
* Remove InputTextModel.
* Cleanup linter warnings.
* Refactor color support.
* Many components now support removing whitespace in the templates.
* Refactor tab key index to a mixin.
* Various updates and cleanup.

## 0.1.1

* Small change to README.md

## 0.1.0

* Initial Open Source release.
