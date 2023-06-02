import UIKit

extension UIView {

	func fittingSizeFor(width: CGFloat?, height: CGFloat?) -> CGSize? {
		let targetSize: CGSize
		if let width, let height {
			return CGSize(width: width, height: height)
		} else if let width {
			targetSize = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
		} else if let height {
			targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: height)
		} else {
			return nil
		}
		return systemLayoutSizeFitting(
			targetSize,
			withHorizontalFittingPriority: width == nil ? .fittingSizeLevel : .required,
			verticalFittingPriority: height == nil ? .fittingSizeLevel : .required
		)
	}
}
