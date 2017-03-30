## Preview Release

These are the AngularDart components that Google uses to build many of its web
applications.

These components are a productive and stable set of widgets, contributed to by
hundreds of Googlers. Being able to debug your apps across all layers in Dart,
supporting tree shaking for minimal code size, and strict latency policies make
them an excellent fit for AngularDart projects.

Only a small fragment of all the components is available right now. We want
developers to have an opportunity to play around with the package as soon as
possible.

* ✓ `<glyph>`
* ✓ `<material-button>`
* ✓ `<material-fab>`
* ✓ `<material-checkbox>`
* ✓ `<material-chip>`
* ✓ `<material-expansionpanel>`
* ✓ `<material-progress>`
* ✓ `<material-radio>`
* ✓ `<material-ripple>`
* ✓ `<material-spinner>`
* ✓ `<material-tab>`
* ✓ `<material-toggle>`
* ✓ `<material-yes-no-buttons>`
* ✓ `<reorder-list>`
* ✓ `<acx-scorecard>`
* ✓ `<material-input>`
* ✓ `<material-dialog>`
* ✓ `<material-popup>`
* ✓ `<material-tooltip>`
* ✓ `<material-list>`
* ✓ `<material-select>`
* ☐ `<material-tree>`
* ☐ `<material-auto-suggest-input>`
* ☐ `<material-date-range-picker>`
* ☐ `<material-menu>`
* many more, including a fast table

At this time we are not taking pull requests but please file an issue and we
will work with you.

**Officially Supported Browsers:** The last two versions of Chrome, Edge,
Firefox, and Safari.

## Useful links

* **[Example gallery](https://dart-lang.github.io/angular2_components_example/)**
* [AngularDart pub package](https://pub.dartlang.org/packages/angular2)
* [AngularDart documentation](https://angulardart.org/)
* [Material Design site](https://material.google.com/)
* [Code Lab: AngularDart Components](https://webdev.dartlang.org/codelabs/angular2_components)

## Custom Component Styles

Get access to the core Material Design SASS files used to style these components
by copying them and importing
[lib/src/css/_mixins.scss](https://github.com/dart-lang/angular2_components/blob/master/lib/src/css/_mixins.scss)
in your SASS files.


> NOTE: These .scss files are not used during the build step but we are planning
> to add this support. See
> [issue #45](https://github.com/dart-lang/angular2_components/issues/45).
