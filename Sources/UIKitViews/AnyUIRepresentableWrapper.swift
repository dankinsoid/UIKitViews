import SwiftUI

struct AnyUIRepresentableWrapper<IOS13: View, IOS16: View>: View {

	@ViewBuilder let iOS13: (CGSize?, @escaping (CGSize?) -> Void) -> IOS13
	@ViewBuilder let iOS16: IOS16
	@Environment(\.uiKitViewFixedSize) private var selfSizedAxis
	@Environment(\.uiKitViewWrapperPolicy) private var uiKitViewWrapperPolicy
	@Environment(\.uiKitViewContentMode) private var uiKitViewContentMode
	@State private var size: CGSize?
	@State private var updateSize: (CGSize) -> Void = { _ in }
	@State private var expectedSize: CGSize?

	var body: some View {
		if #available(iOS 16.0, tvOS 16.0, *), uiKitViewWrapperPolicy == .upToIOS16 {
			iOS16
				.fixedFrame(for: selfSizedAxis, alignment: uiKitViewContentMode.alignment)
		} else {
			iOS13(expectedSize) {
				size = $0
			}
			.fixedSize(
				horizontal: selfSizedAxis.contains(.horizontal),
				vertical: selfSizedAxis.contains(.vertical)
			)
			.frame(
				width: idealWidth,
				height: idealHeight
			)
			.fixedFrame(for: selfSizedAxis, alignment: uiKitViewContentMode.alignment)
			.overlay(
				ZStack {
					GeometryReader { proxy in
						Color.clear
							.preference(key: SizeKey.self, value: proxy.size)
					}
				}
				.allowsHitTesting(false)
			)
			.onPreferenceChange(SizeKey.self) { newValue in
				expectedSize = newValue
			}
		}
	}

	private var idealWidth: CGFloat? {
		selfSizedAxis.contains(.horizontal) || uiKitViewContentMode == .fill ? nil : size?.width
	}

	private var idealHeight: CGFloat? {
		selfSizedAxis.contains(.vertical) || uiKitViewContentMode == .fill ? nil : size?.height
	}
}

private extension View {

	func fixedFrame(for selfSizedAxis: Axis.Set, alignment: Alignment) -> some View {
		frame(
			minWidth: !selfSizedAxis.contains(.horizontal) ? 0 : nil,
			maxWidth: !selfSizedAxis.contains(.horizontal) ? .infinity : nil,
			minHeight: !selfSizedAxis.contains(.vertical) ? 0 : nil,
			maxHeight: !selfSizedAxis.contains(.vertical) ? .infinity : nil,
			alignment: alignment
		)
	}
}

private struct SizeKey: PreferenceKey {

	static var defaultValue: CGSize { .zero }

	static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
		value = nextValue()
	}
}
