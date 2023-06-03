import SwiftUI
import UIKitViews

struct ContentView: View {

	private let text = "Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!"
	@State private var value = 0.0

	var body: some View {
		VStack {
			Spacer()
			HStack {
				Color.red
					.frame(width: value)
				UIKitView {
					UILabel().chain
						.numberOfLines(0)
						.text(text)
						.backgroundColor(.systemBlue)
						.textColor(.white)
						.do {
							$0.setContentHuggingPriority(.required, for: .vertical)
						}
				}
				.background(Color.red)
				.uiKitViewFixedSize(.vertical)
				.uiKitViewContentMode(.fit(.leading))
			}
			HStack {
				Color.red
					.frame(width: value)
				Text(text)
					.background(Color.green)
					.foregroundColor(.white)
			}
			Slider(value: $value, in: 0 ... 300)
		}
		.padding()
	}
}

extension View {

	func logSize(to size: Binding<CGSize>? = nil) -> some View {
		overlay(GeometryReader { proxy in
			Text("\(Int(proxy.size.width)) × \(Int(proxy.size.height))")
				.foregroundColor(.white)
				.background(Color.black)
				.font(.footnote)
				.onChange(of: proxy.size) { newValue in
					size?.wrappedValue = newValue
				}
				.onAppear {
					size?.wrappedValue = proxy.size
				}
		})
	}
}

struct ContentView_Previews: PreviewProvider {

	static var previews: some View {
		ContentView()
	}
}
