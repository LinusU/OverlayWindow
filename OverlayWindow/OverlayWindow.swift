import UIKit

open class OverlayWindow<T: UIViewController> {
    open let rootViewController: T
    
    internal var hidden: Bool = false
    internal var window: UIWindow?
    
    init(rootViewController: T, animated: Bool) {
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
    
    func hide(animated: Bool, completion: (() -> Void)? = nil) {
        guard hidden == false else { return }
        guard let window = self.window else { return }
        
        self.hidden = true
        
        let duration = (animated ? 0.5 : 0.0)
        let targetFrame = window.frame.offsetBy(dx: 0, dy: window.frame.height)
        
        UIView.animate(withDuration: duration, animations: { window.frame = targetFrame }, completion: { _ in
            self.window = nil
            completion?()
        })
    }
}
