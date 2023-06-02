import SwiftUI

public protocol UIKitRepresentableWrapper {

	associatedtype Representable: UIKitRepresentable
}

public protocol UIKitRepresentable<Content>: View {

	associatedtype Content
	var updater: (Content) -> Void { get set }
	init(_ make: @escaping () -> Content)
}
