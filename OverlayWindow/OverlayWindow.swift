import UIKit

var retainedWindows = Set<UIWindow>()

open class OverlayWindow<T: UIViewController> {
    open let rootViewController: T
    internal let window: UIWindow

    public var tintColor: UIColor! {
        get { return window.tintColor }
        set { window.tintColor = newValue }
    }

    public init(rootViewController: T, animated: Bool) {
        let targetFrame = UIScreen.main.bounds
        let startFrame = targetFrame.offsetBy(dx: 0, dy: targetFrame.height)

        let window = UIWindow(frame: (animated ? startFrame : targetFrame))

        self.rootViewController = rootViewController
        self.window = window

        window.windowLevel = 1
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()

        if animated {
            UIView.animate(withDuration: 0.5, animations: { window.frame = targetFrame })
        }
    }

    deinit {
        let window = self.window
        let targetFrame = window.frame.offsetBy(dx: 0, dy: window.frame.height)

        retainedWindows.insert(window)

        UIView.animate(withDuration: 0.5, animations: { window.frame = targetFrame }, completion: { _ in
            retainedWindows.remove(window)
        })
    }
}
