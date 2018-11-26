This unpublished package (`angular_components_example`) contains the
`build.yaml` file that controls the code generation for the
[AngularDart Components Gallery].
In particular, the build file configures the gallery homepage and specifies
which examples appear in the gallery.

## Build

Build the entire gallery from the `examples/angular_components_example`
directory.

```
pub run build_runner build --output <output directory>
```

## Serve

Run a local development server with a file watcher and incremental rebuilds:

```
pub run build_runner serve web
```

Both of the __build__ and __serve__ commands will accept `--release` to build
with dart2js instead of the default dartdevc.

__Known Issues:__

When building and viewing the gallery these issues are expected at this time:

*   Runtime Warning:

    `SEVERE: OverlayService must be a singleton: Check that there is no nested
    overlayBindings or popupBindings`

[AngularDart Components Gallery]: https://dart-lang.github.io/angular_components/
[build_runner]: https://pub.dartlang.org/packages/build_runner
[build]: https://pub.dartlang.org/packages/build
