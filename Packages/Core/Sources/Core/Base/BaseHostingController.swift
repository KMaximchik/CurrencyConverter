import SwiftUI

// MARK: - BaseHostingControllerInterface

public protocol BaseHostingControllerInterface: AnyObject {}

// MARK: - BaseHostingController

open class BaseHostingController<Content>: UIHostingController<Content>, BaseHostingControllerInterface where Content: View {
    // MARK: - Private Properties

    private let ignoresKeyboard: Bool

    // MARK: - Init

    public init(
        rootView: Content,
        ignoresKeyboard: Bool = false
    ) {
        self.ignoresKeyboard = ignoresKeyboard

        super.init(rootView: rootView)

        if ignoresKeyboard {
            guard let viewClass = object_getClass(view) else { return }

            let viewSubclassName = String(cString: class_getName(viewClass)).appending("_IgnoresKeyboard")
            if let viewSubclass = NSClassFromString(viewSubclassName) {
                object_setClass(view, viewSubclass)
            } else {
                guard let viewClassNameUtf8 = (viewSubclassName as NSString).utf8String else { return }
                guard let viewSubclass = objc_allocateClassPair(viewClass, viewClassNameUtf8, 0) else { return }

                if let method = class_getInstanceMethod(
                    viewClass,
                    NSSelectorFromString("keyboardWillShowWithNotification:")
                ) {
                    let keyboardWillShow: @convention(block) (AnyObject, AnyObject) -> Void = { _, _ in }
                    class_addMethod(
                        viewSubclass,
                        NSSelectorFromString("keyboardWillShowWithNotification:"),
                        imp_implementationWithBlock(keyboardWillShow),
                        method_getTypeEncoding(method)
                    )
                }
                objc_registerClassPair(viewSubclass)
                object_setClass(view, viewSubclass)
            }
        }
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
