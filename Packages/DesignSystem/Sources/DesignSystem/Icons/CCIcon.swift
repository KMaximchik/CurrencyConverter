import UIKit

// MARK: - CCIcon

public enum CCIcon {
    public enum System {
        private static let sourceType = CCIconSourceType.system

        public static var dollarIcon: CCIconToken {
            CCIconToken(name: "dollarsign.circle", sourceType: sourceType)
        }

        public static var listIcon: CCIconToken {
            CCIconToken(name: "list.clipboard", sourceType: sourceType)
        }
    }
}
