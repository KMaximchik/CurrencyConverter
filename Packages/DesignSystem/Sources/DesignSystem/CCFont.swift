import SwiftUI

// MARK: - CCFont

public enum CCFont {
    /// 34px
    public static var largeTitle: Font {
        Font.system(size: 34)
    }

    /// 17px
    public static var body: Font {
        Font.system(size: 17)
    }

    /// 16px
    public static var callout: Font {
        Font.system(size: 16)
    }

    /// 15px
    public static var subheadline: Font {
        Font.system(size: 15)
    }

    /// 13px
    public static var footnote: Font {
        Font.system(size: 13)
    }

    /// 12px
    public static var caption: Font {
        Font.system(size: 12)
    }

    /// 10px
    public static var captionSmall: Font {
        Font.system(size: 10)
    }

}
