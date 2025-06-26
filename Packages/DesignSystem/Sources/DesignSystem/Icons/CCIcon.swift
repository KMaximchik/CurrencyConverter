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

        public static var arrowsUpDownIcon: CCIconToken {
            CCIconToken(name: "arrow.up.and.down", sourceType: sourceType)
        }

        public static var arrowsLeftRightIcon: CCIconToken {
            CCIconToken(name: "arrow.left.and.right", sourceType: sourceType)
        }

        public static var arrowRightIcon: CCIconToken {
            CCIconToken(name: "arrow.right", sourceType: sourceType)
        }

        public static var pencilListClipboardIcon: CCIconToken {
            CCIconToken(name: "pencil.and.list.clipboard", sourceType: sourceType)
        }

        public static var magnifyingglassIcon: CCIconToken {
            CCIconToken(name: "magnifyingglass", sourceType: sourceType)
        }

        public static var xmarkIcon: CCIconToken {
            CCIconToken(name: "xmark", sourceType: sourceType)
        }

        public static var arrowClockwiseIcon: CCIconToken {
            CCIconToken(name: "arrow.clockwise", sourceType: sourceType)
        }

        public static var arrowUpIcon: CCIconToken {
            CCIconToken(name: "arrow.up", sourceType: sourceType)
        }
    }
}
