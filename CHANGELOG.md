## 0.6.0-alpha+1

> NOTE: This code is considered production quality, but depends on angular:
> 4.0.0-alpha+1. The alpha tag represents the evolving nature of the AngularDart
> api, not code quality (4.0.0-alpha is used in production Google apps).

 * Add Material Icon.
 * Deprecate `GlyphComponent` in favor of `MaterialIconComponent`.
 * Update dependency to angular: 4.0.0-alpha+1.
 * Material Checkbox: Add mixin for checkbox with no left margin.
 * Material Chips: Add ability to specify background color for left icon.
 * Material Expansionpanel: Add mixin to allow changes to panels without
   affecting nested panels.
 * Material Input:
   * Add upper and lower bounds validators.
   * Re-calculate text length when custom character counter is set.
   * Prevent mirror-text overflow in multiline material input.
   * Remove unnecessary selector argument from mixins.
 * Material Popup: Only set content removed if the popup is still not visible
   when the timer is finished.
 * Material Radio:
   * Add mixin for radio button with no left margin.
   * Fix mixin to respect disabled status when a theme is applied.
 * Material Select:
   * Fix `MaterialSelectItemComponent` to not cache the label.
   * Add input to material-dropdown-select to define custom a renderer for group
     labels.
   * Fix checkbox display handling and label padding in dropdown.
 * Material Toggle: Set the attribute instead of the property to fix a bug with
   incorrect type, and not setting the right property.
 * Material Tree:
   * Add ability to preserve expansion state.
   * Fix indentation of first child group.
   * Add input `showDisabledCheckboxes`.
   * Add a max-height mixin.
 * Reorder List:
   * Update to recommended syntax for ngFor.
   * Migrate from ManagedZone to NgZone.
 * Scorecard:
   * Replace deprecated Glyph with Material Icon.
   * Invoke inherited click handler from derived click handler.
 * Avoid adding placeholder for deferred content if the element is detached.
 * Selection Models:
   * Add deselect all option.
   * Add a limited filtering model.
   * Fix `selectAll` to only trigger a selection change event for the values
     that were added.
   * Add comparator as optional param to tree selection options for custom
     sorting.
 * Updates to use metadata inheritance.
 * Migrate away from comment-style generic syntax.
 * Migrate stylesheet combinators `/deep/` and `>>>` to `::ng-deep`.
 * Migrate away from use of angular's `@View`.
 * Update animations to new Material specs.
 * Update documentation.
 * Remove unused library statements.

## 0.6.0-alpha

> NOTE: This code is considered production quality, but depends on angular:
> 4.0.0-alpha. The alpha tag represents the evolving nature of the AngularDart
> api, not code quality (4.0.0-alpha is used in production Google apps).

 * Update dependency to `angular: 4.0.0-alpha`.
 * Update SDK dependencies.

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
