import UIKit

// MARK: - UIView+embed

public extension UIView {
    @discardableResult
    func embed(
        in view: UIView,
        insets: UIEdgeInsets = .zero,
        useSafeAreaGuide: Bool = false,
        useMarginsGuide: Bool = false
    ) -> Self {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false

        if useMarginsGuide {
            NSLayoutConstraint.activate(
                [
                    view.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: insets.top),
                    view.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -insets.bottom),
                    view.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: insets.left),
                    view.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -insets.right)
                ]
            )
        } else if useSafeAreaGuide {
            NSLayoutConstraint.activate(
                [
                    view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: insets.top),
                    view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom),
                    view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: insets.left),
                    view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -insets.right)
                ]
            )
        } else {
            NSLayoutConstraint.activate(
                [
                    view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
                    view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
                    view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
                    view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right)
                ]
            )
        }

        return self
    }
}
