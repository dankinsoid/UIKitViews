import SwiftUI

struct AnyUIRepresentableWrapper<IOS13: View, IOS16: View>: View {

	@ViewBuilder let iOS13: (@escaping (CGSize?) -> Void) -> IOS13
	@ViewBuilder let iOS16: IOS16
	@Environment(\.uiKitViewFixedSize) private var selfSizedAxis
	@Environment(\.uiKitViewWrapperPolicy) private var uiKitViewWrapperPolicy
	@State private var size: CGSize?

	var body: some View {
		if #available(iOS 16.0, tvOS 16.0, *), uiKitViewWrapperPolicy == .upToIOS16 {
			iOS16
		} else {
			iOS13 {
				size = $0
			}
			.fixedSize(
				horizontal: selfSizedAxis.contains(.horizontal),
				vertical: selfSizedAxis.contains(.vertical)
			)
			.frame(
				width: size?.width == UIView.noIntrinsicMetric || selfSizedAxis.contains(.horizontal) ? nil : size?.width,
				height: size?.height == UIView.noIntrinsicMetric || selfSizedAxis.contains(.vertical) ? nil : size?.height
			)
		}
	}
}
