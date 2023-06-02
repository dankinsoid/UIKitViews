import SwiftUI

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
			targetSize = UIView.layoutFittingCompressedSize
		}
		return systemLayoutSizeFitting(
			targetSize,
			withHorizontalFittingPriority: width == nil ? .fittingSizeLevel : .required,
			verticalFittingPriority: height == nil ? .fittingSizeLevel : .required
		)
	}
	
	@available(iOS 16.0, tvOS 16.0, *)
	func fittingSizeFor(size proposal: ProposedViewSize, dimensions selfSizedAxis: Axis.Set) -> CGSize? {
		if proposal.width == nil, proposal.height == nil, selfSizedAxis == [] {
			return nil
		}
		return fittingSizeFor(
			width: selfSizedAxis.contains(.horizontal) ? nil : proposal.width,
			height: selfSizedAxis.contains(.vertical) ? nil : proposal.height
		)
	}
}
