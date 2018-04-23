## 0.9.0-alpha+11

> NOTE: This code is considered production quality, but depends on angular:
> 5.0.0-alpha+11. The alpha tag represents the evolving nature of the
> AngularDart API, not code quality (5.0.0-alpha+11 is used in production Google
> apps).

 * Material Auto-Suggest: Prevent marking itself as dirty when it receives
   initial form value.
 * Material Checkbox:
   * Prevent marking itself as dirty when it receives initial form value.
   * Add mixin to remove right margin.
 * Material Datepicker:
   * Re-render calendar and month picker when date limits change.
   * Switch to bool inputs instead of `getBool()`.
 * Material Expansion Panel: Improve animations.
 * Material Input:
   * Add mixin to change the font size.
   * Add `aria-label` and `aria-invalid` attributes back to the input field.
 * Material Popup: Fix border radius mixin.
 * Material Select: Fix selected color mixin on vertical selection indicator.
 * Reorder List: Restrict when a dragged item's target index is incremented or
   decremented.
 * Use new `@HostListener()` argument inference: `$event` is now implicit.
 * Make mouse events with the shift modifier key a non-standard mouse event in
   `isStandardMouseEvent()`.
 * Remove `IntersectionObserver` bindings now that they exist in dart:html.
 * Update documentation.

## 0.9.0-alpha+10

> NOTE: This code is considered production quality, but depends on angular:
> 5.0.0-alpha+10. The alpha tag represents the evolving nature of the
> AngularDart API, not code quality (5.0.0-alpha+10 is used in production Google
> apps).

 * Add Material Slider component.
 * Remove some `visibility.all` from `@Component` annotations. This is
   potentially BREAKING.
 * App Layout: Add support for 0 or 2 drawers.
 * Material Date Range Picker: Improved support for high browser zoom.
 * Material Input:
   * Allow values to be selectable when disabled on all browsers. This is
     potentially BREAKING.
   * Pass aria attributes through to the inner input element. Includes material
     auto suggest.
 * Material Select: Add aria states/properties to indicate selected/checked in
   item.
 * Material FAB Menu:
   * Update close bar style.
   * Change menu width to 280px if menu has icons.
   * Fix transitions.
   * Simplify material-fab-menu animation & allow it to scroll on small screens.
 * Material Menu:
   * Allow mixins to customize popup contents by specifying additional CSS
     classes added to the popup content.
 * Material Popup: Enforce space constraints on content.
 * Protect against a null pointer exception in laminate popup.
 * Add `SingleSelectionModel` interface with `selectedValue()` method.
 * Add `onDisabledChanged()` to all `ControlValueAccessor` implementations.
 * Make `ShowHideDirective` constants private. This is potentially BREAKING.

## 0.9.0-alpha+9

> NOTE: This code is considered production quality, but depends on angular:
> 5.0.0-alpha+9. The alpha tag represents the evolving nature of the AngularDart
> API, not code quality (5.0.0-alpha+9 is used in production Google apps).

 * Remove some `visibility.all` from `@Component` annotations. This is
   potentially BREAKING.
 * Button Decorator: Allow role to be customized.
 * Material Button: Remove override of `min-width` for `yes-no-buttons` as it is
   now the right value in material-button.
 * Material Date Picker: Improved keyboard handling.
 * Material Date Time Picker: Update so that it sets time to default value if
   date is picked but time is not picked.
 * Material Menu:
   * Match the color of the group header label to item.
   * Add mixin to show the same font for group label.
 * Material Expansion Panel: Add mixin for additional padding.
 * Material Input: Add an aria-label that can override the label.
 * Material Select:
   * Add proper aria attributes to make `material-dropdown-select` screen reader
     accessible.
   * Add mixin to set disabled color.
 * Material Time Picker: Fix one hour difference after daylight saving.
 * Selection Model:
   * Add empty, single, and multi constructors.
   * Add `ignoreDeselect` option to `SelectionModel.single` and deprecate
     `RadioGroupSingleSelectionModel`.
 * Add a parameter to fail loudly when `TimeZoneAwareClock` is used before it's
   initialized, to prevent incorrect return values from being ignored.
 * Migrate from `ElementRef` to `Element` or `HtmlElement`.
 * Fix Dart2 runtime cast failures.
 * Update documentation.

## 0.9.0-alpha+8

> NOTE: This code is considered production quality, but depends on angular:
> 5.0.0-alpha+8. The alpha tag represents the evolving nature of the AngularDart
> API, not code quality (5.0.0-alpha+8 is used in production Google apps).

 * Add Material Datepicker components.
 * Add ShowHideDirective and GlobalEscapeDirective.
 * Material Button: Update highlight styling.
 * Material Chips: Allow overriding left-icon-color.
 * Material ExpansionPanel:
   * Allow icon to be hidden and allow additional buttons in the header.
   * Increase mixin specificity.
 * Material Input:
   * Add mixin for hiding underline.
   * Add mixins for trailing text color and padding.
 * Material Menu:
   * Implement `Focusable`.
   * Add a flag to `MenuItemGroup` to explicitly specify a separator.
 * Material Popup: Simplify positioning algorithm.
 * Material Select:
   * Add mixin to allow for error text margin.
   * Refactor `constructEncapsulatedCss` to utils.
 * Material Tab: Make `text-wrap` mixin more generic.
 * Material Tree: Add a `shouldExpandAllWhenFiltered` input.
 * Material Toggle: Fix `aria-pressed` state.
 * Material Tooltip:
   * Allow paper tooltip CSS to be customizable.
   * Allow `'error_outline'` as a valid icon.
   * Prevent paper tooltips from overflowing on small screens.
 * Scorecard: Add stacking context.
 * Delete deprecated `LazyEventEmitter`.
 * Migrate uses of `ElementRef` to `Element` or `HtmlElement`.
 * Cleanup type warnings and other Dart 2 fixes.
 * Update documentation.

## 0.9.0-alpha+7

> NOTE: This code is considered production quality, but depends on angular:
> 5.0.0-alpha+7. The alpha tag represents the evolving nature of the AngularDart
> API, not code quality (5.0.0-alpha+7 is used in production Google apps).

 * Material Button: Add compact mode.
 * Material Expansionpanel: Add option show/hide the cancel button.
 * Material Select:
   * Add option to dropdown to disable deselecting on trigger.
   * Allow content to be projected as list header and list footer in dropdown.
   * Implement Focusable in `DropdownButtonComponent`.
   * Fixed an alignment issue with the icon on dropdowns.
 * Material Menu:
   * Trigger selected event when an item from sub-menu is selected.
   * Change mouse pointer on catagory to make it clear that it is clickable.
 * Material Tooltip: Change `tooltipSource` directive to use `style.cursor`.
 * Allow '\[' for start of word of highlight match.
 * Use @visibleForTesting annotations.
 * Prepare for change of `async` behavior in Dart 2.
 * Make LazyEventEmitter no longer lazy and makes it easy to see why it should
   not be used and a StreamController can be a simple drop in replacement.
 * Update documentation.

## 0.9.0-alpha+6

> NOTE: This code is considered production quality, but depends on angular:
> 5.0.0-alpha+6. The alpha tag represents the evolving nature of the AngularDart
> API, not code quality (5.0.0-alpha+6 is used in production Google apps).

 * App Layout: Add mixin for permanent/persistent drawers and fix mixin for
   temporary drawers.
 * Material Auto Suggest Input: Add aria label to close button.
 * Material Button: Update min-width to new spec.
 * Material Checkbox: Remove negative top margin.
 * Material Dialog: Add support for `<h1>` element in title.
 * Material Icon: Flip half_star icon when in RTL.
 * Material Input:
   * Show character count when maxCount is null.
   * Add attribute to set aria-label when a visible label is not desired.
 * Material Menu:
   * Allow expanding on group title clicks.
   * Add a style variation to menu group to allow emphasizing the first group.
 * Material Popup: Disable constrain-to-viewport in dropdowns via a new,
   separate `@Input`.
 * Material Ripple: Update animation to match new spec.
 * Material Select: Add a `FactoryRenderer` input.
 * Material Tree:
   * Adds an option to select parent nodes in a single selection model tree.
   * Bugfix for auto selection all siblings due to an error being thrown which
     stops event.stopPropagation from firing.
 * Remove position: -webkit-sticky support.
 * Update type of materialProviders so it can be used when bootstrapping.
 * Migrate from `host` to `@HostListener` and `@HostBinding`.
 * Create a new API for caching item renderers.
 * Cleanup type warnings and other Dart 2 fixes.

## 0.9.0-alpha+5

> NOTE: This code is considered production quality, but depends on angular:
> 5.0.0-alpha+5. The alpha tag represents the evolving nature of the AngularDart
> API, not code quality (5.0.0-alpha+5 is used in production Google apps).

 * Material Menu: Add a feature to menu item group to make it expandable.
 * Material Radio: Protect against the group being destroyed before the
   `tabIndex` gets reset.
 * Material Tooltip: Update line height to 20px per ACUX spec.
 * Widen dependencies on observable and quiver.
 * Turn overlayRepositionLoop on by default.
 * Only add touch listeners if the primary input is touch.
 * Cleanup type warnings and other Dart 2 fixes.

## 0.9.0-alpha+4

> NOTE: This code is considered production quality, but depends on angular:
> 5.0.0-alpha+5. The alpha tag represents the evolving nature of the AngularDart
> API, not code quality (5.0.0-alpha+5 is used in production Google apps).

 * Material Dialog: Add mixin for bottom border on header.
 * Material Drawer: Add mixin for width.
 * Material Input:
   * Extend the style rules applied on `input[type=text]` to cover the hover and
     focus states.
   * Add mixin padding.
 * Material Popup:
   * Guard against `container = null` in PopupHierarchy.onTriggersOutside().
   * Increase the animation speed according to material specs.
 * Material Radio: Migrate away from QueryList.
 * Material Tree:
   * Add an option to material tree group to render a "View more" link for
     hidden options.
   * Migrate away from QueryList.
 * Scorecard: Only update selected state if the scorecard is selectable.
 * Use a reified Provider for `defaultPopupPositions`.
 * Add IntersectionObserver bindings & onIntersection stream to ScrollHost.
 * Add `materialNumberDirectives` to MaterialDirectives list.
 * Preparation for Angular changing the default value of
   `visibility: Visibility.local`.
 * Cleanup type warnings and other Dart 2 fixes.
 * Update documentation.

## 0.9.0-alpha+3

> NOTE: This code is considered production quality, but depends on angular:
> 5.0.0-alpha+4. The alpha tag represents the evolving nature of the AngularDart
> API, not code quality (5.0.0-alpha+4 is used in production Google apps).

**NOTE**: As of `angular 5.0.0-alpha+1` [`dependency_overrides`][dep_overrides]
are **required**:

```yaml
dependency_overrides:
  analyzer: ^0.31.0-alpha.1
```

This is because Angular is starting to use and support the Dart 2 SDK, which is
evolving. We expect to no longer require overrides once we are at a beta
release, but this is unlikely until sometime in early 2018.

 * Add support for package
   [build_runner](https://pub.dartlang.org/packages/build_runner).
 * Material Auto-Suggest Input:
   * Wait for the popup to be visible before activating dropdown items.
   * Stop escape keyboard events from propagating after they are handled.
   * Disallow deselection when clicked on a selected item with single selection
     models.
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
 * Deprecate getBool(), Angular supports it now natively.
 * Fix RTE when using item renderers as highlight renderers when there is a
   custom factory renderer.
 * Fix componentRenderer logic.
 * Add option to disable select all in the table selection model.
 * Add a feature detector for `position: sticky`.
 * Migrate from Glyph to Material Icon.
 * Remove unused table model.
 * Remove the getDynamic() method from properties helpers.
 * Remove uses of .runtimeType.
 * Fix uses_bottom_as_dynamic ("fuzzy arrow") errors.
 * Cleanup unneeded `preserveWhitespace: false` and `preserveWhitespace: true`.
 * Cleanup type warnings and other Dart 2 fixes.
 * Cleanup unused variables.
 * Update documentation.

## 0.9.0-alpha+2

> NOTE: This code is considered production quality, but depends on angular:
> 5.0.0-alpha+2. The alpha tag represents the evolving nature of the AngularDart
> API, not code quality (5.0.0-alpha+2 is used in production Google apps).

**NOTE**: As of `angular 5.0.0-alpha+1` [`dependency_overrides`][dep_overrides]
are **required**:

```yaml
dependency_overrides:
  analyzer: ^0.31.0-alpha.1
```

This is because Angular is starting to use and support the Dart 2 SDK, which is
evolving. We expect to no longer require overrides once we are at a beta
release, but this is unlikely until sometime in early 2018.

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
> API, not code quality (5.0.0-alpha+1 is used in production Google apps).

**NOTE**: As of `angular 5.0.0-alpha+1` [`dependency_overrides`][dep_overrides]
are **required**:

```yaml
dependency_overrides:
  analyzer: ^0.31.0-alpha.1
```

This is because Angular is starting to use and support the Dart 2 SDK, which is
evolving. We expect to no longer require overrides once we are at a beta
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
> API, not code quality (5.0.0-alpha is used in production Google apps).

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
API, not code quality (3.0.0-alpha+1 is used in production Google apps).

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
API, not code quality (3.0.0-alpha+1 is used in production Google apps).

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
API, not code quality (3.0.0-alpha is used in production Google apps).

 * Add Material List.
 * Material Expansionpanel: Add `autoDismissable` directive.
 * Material Progress: Handle changes to "indeterminate" state.
 * Scorecard: Add input to display vertically.
 * Update styles to meet Material UI spec.

## 0.3.0-alpha

This code is considered production quality, but depends on angular2:
3.0.0-alpha. The alpha tag represents the evolving nature of the AngularDart
API.

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
