# OverlayWindow

Display content in a new `UIWindow` on top of other content. Useful for implementing lock-screens or other mandatory modals.

## Installation

### Carthage

```text
LinusU/OverlayWindow ~> 1.0.0
```

### Manually

You can simply drop the single source file [OverlayWindow.swift](OverlayWindow/OverlayWindow.swift) into your project.

## Usage

e.g. for implementing a lock screen

```swift
import OverlayWindow

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UnlockViewControllerDelegate {
    var unlockWindow: OverlayWindow<UnlockViewController>?

    // ...

    func applicationWillResignActive(_ application: UIApplication) {
        // Check that we aren't allready presenting a lock screen
        if self.unlockWindow != nil { return }

        // Show a new overlay window with our UnlockViewController. We don't need to animate the
        // window in, since the app is loosing active status and thus won't be visible. The window
        // will be visible as long as we keep our reference to it.
        self.unlockWindow = OverlayWindow(rootViewController: UnlockViewController(), animated: false)

        // Set the delegate of our UnlockViewController to ourself, so that we can dismiss the
        // window when the app is being unlocked.
        self.unlockWindow!.rootViewController.delegate = self
    }

    func unlockViewControllerDidUnlock() {
      // Hide the overlay window by removing our reference to it. The window will animate itself
      // off the screen, and then free the underlying UIWindow.
      self.unlockWindow = nil
    }
}
```

## API

### `init(rootViewController: T, animated: Bool)`

Create and display a new window on top of the main window, populated with the provided root view controller.

If `animated` is true, the window will slide up from the bottom of the screen.

### `deinit`

When the last reference to `OverlayWindow` is dropped, the window will be animated off the screen.

Having this behaviour in `deinit` instead of a dedicated method gives the compiler the ability to enforce that you cannot access the window content after it has been hidden, and that you cannot try and hide the window more than once.
