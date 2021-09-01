#  Getting Started

## Using Xcode

You can edit, build and run your website Swift package using Xcode.

### Working Directory

For convenience make sure you set the working directory to where your `Package.swift` resides. This way the location of the `www` folder will be the same as when running from the command line.

To set your working directory within Xcode go to `"MySite" Scheme > "Edit Scheme…" > Run (Sidebar) > Options (Tab) > Working Directory > "Use custom working directory:"` and specify your package's root.

### Production Build

By default Xcode generates the development version of your site. To switch to production change your scheme to use Release configuradion instead of the default Debug.

Command line builds on the other hand generate the production version by default. To change this just include the `-Xswiftc DEBUG` option after your command.

```sh
swift run -Xswiftc "DEBUG"
```
