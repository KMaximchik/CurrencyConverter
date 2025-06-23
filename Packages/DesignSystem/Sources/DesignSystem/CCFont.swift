import SwiftUI

// MARK: - CCFont

public enum CCFont {
    public static var largeTitle: Font {
        Font.system(size: 34)
    }

    public static var body: Font {
        Font.system(size: 17)
    }

    public static var callout: Font {
        Font.system(size: 16)
    }

    public static var subheadline: Font {
        Font.system(size: 15)
    }

    public static var footnote: Font {
        Font.system(size: 13)
    }

    public static var caption: Font {
        Font.system(size: 12)
    }

    public static var captionSmall: Font {
        Font.system(size: 10)
    }

}
