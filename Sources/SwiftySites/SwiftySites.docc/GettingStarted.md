# Getting Started

In SwiftySites you define your website within a Swift project. All your content metadata is made out of custom native types while the content itself may be specified on Markdown or HTML. Templates use string interpolation to produce web pages from your content and it all gets tied together when calling your site type's initializer.

## Using Xcode

You can edit, build and run your website Swift package using Xcode.

### Working Directory

For convenience make sure you set the working directory to where your `Package.swift` resides. This way the location of the `www` folder will be the same as when running from the command line.

To set your working directory within Xcode go to `"MySite" Scheme > "Edit Scheme…" > Run (Sidebar) > Options (Tab) > Working Directory > "Use custom working directory:"` and specify your package's root.

### Production Build

By default Xcode generates the development version of your site. To switch to production change your scheme to use `Release` configuradion instead of the default Debug.

Command line builds also generate debug builds by default. To change this use the `-c` option and specify `release` as configuration.

```sh
swift run -c release
```

## Passing parameters

```sh
swift run -c release MySite --clean
```

Options passed directly to ``Site/render(clean:skipSitemap:skipStatic:)`` method override those specified on the command line.

To get all available options.

```sh
swift run MySite --help
```

To generate an auto-completion script.

```sh
swift run MySite --generate-completion-script zsh
```
