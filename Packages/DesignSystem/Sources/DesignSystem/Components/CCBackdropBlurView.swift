import SwiftUI

// MARK: - BackdropBlurView

fileprivate struct BackdropBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView()
        let blur = UIBlurEffect()
        let animator = UIViewPropertyAnimator()
        animator.addAnimations { view.effect = blur }
        animator.fractionComplete = .zero
        animator.stopAnimation(false)
        animator.finishAnimation(at: .current)
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

// MARK: - CCBackdropBlurView

public struct CCBackdropBlurView: View {
    // MARK: - Public Properties

    public let radius: CGFloat

    // MARK: - Init
    
    public init(radius: CGFloat) {
        self.radius = radius
    }

    // MARK: - Views

    public var body: some View {
        BackdropBlurView().blur(radius: radius, opaque: true)
    }
}
