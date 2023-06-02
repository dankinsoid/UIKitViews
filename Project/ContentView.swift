import SwiftUI
import UIKitViews

struct ContentView: View {

	let text = "Hello, world! Hello, world! Hello, world! Hello, world!\nHello, world! Hello, world!"
	@State var size: CGSize = .zero

	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			Color.clear

			UIKitView {
				UILabel().chain
					.text(text)
					.backgroundColor(.systemBlue)
					.numberOfLines(0)
			}
			.logSize()

			Text(text)
				.background(Color.green)
				.logSize()
		}
		.background(Color.black.opacity(0.1))
		.padding()
		.background(Color.black.opacity(0.1))
		.uiKitViewFixedSize(.vertical)
	}
}

extension View {

	func logSize(to size: Binding<CGSize>? = nil) -> some View {
		overlay(GeometryReader { proxy in
			Text("\(Int(proxy.size.width)) × \(Int(proxy.size.height))")
				.foregroundColor(.white)
				.background(.black)
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
