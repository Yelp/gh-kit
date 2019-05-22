GHKit
========

The GHKit framework is a set of extensions and utilities for iOS.


Install
-------

### Cocoapods
1. Add `pod 'GHKitYelpFork', '~> version'` to your Podfile
1. Run `pod install`
1. Import the GHKit headers via `#import <GHKit/GHKit.h>`
1. Build the project to verify installation is successful.

### Carthage
1. Add `github "Yelp/gh-kit" ~> version` to your Cartfile
1. Run `carthage update`
1. On your application targets’ _General_ settings tab, in the “Linked Frameworks and Libraries” section, drag and drop `GHKit.framework` from the [Carthage/Build][] folder on disk.
1. On your application targets’ _Build Phases_ settings tab, click the _+_ icon and choose _New Run Script Phase_. Create a Run Script in which you specify your shell (ex: `/bin/sh`), add the following contents to the script area below the shell:

    ```sh
    /usr/local/bin/carthage copy-frameworks
    ```

1. Add the path to the framework under “Input Files":

    ```
    $(SRCROOT)/Carthage/Build/iOS/GHKit.framework
    ```

1. Add the path to the copied framework to the “Output Files”:

    ```
    $(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/GHKit.framework
    ```



Install (Docset)
----------------

- Open Xcode, Preferences and select the Downloads / Documentation tab.
- Select the plus icon (bottom left) and specify: `http://gabriel.github.com/gh-kit/publish/me.rel.GHKit.atom`

Documentation
--------

[API Docs](http://gabriel.github.com/gh-kit/)
