import SwiftUI

// MARK: - OffsetPreferenceKey

private struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue = CGFloat.zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - ViewOffsetReader

private struct ViewOffsetReader: ViewModifier {
    let coordinateSpace: CoordinateSpace
    let onOffsetChange: (CGFloat) -> Void

    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { proxy in
                    Color.clear
                        .preference(
                            key: OffsetPreferenceKey.self,
                            value: proxy.frame(in: coordinateSpace).minY
                        )
                }
            }
            .onPreferenceChange(OffsetPreferenceKey.self) { newValue in
                onOffsetChange(newValue)
            }
    }
}

// MARK: - View+readOffset

public extension View {
    func readOffset(
        in coordinateSpace: CoordinateSpace,
        onOffsetChange: @escaping (CGFloat) -> Void
    ) -> some View {
        modifier(
            ViewOffsetReader(
                coordinateSpace: coordinateSpace,
                onOffsetChange: onOffsetChange
            )
        )
    }
}
