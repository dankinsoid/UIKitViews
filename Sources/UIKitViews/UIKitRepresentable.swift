import SwiftUI

public protocol UIKitRepresentableWrapper {

	associatedtype Representable: UIKitRepresentable
}

public protocol UIKitRepresentable<Content>: View {

	associatedtype Content
	var updater: (Content, UIKitRepresentableContext) -> Void { get set }
	init(_ make: @escaping () -> Content)
}

public struct UIKitRepresentableContext {
    
    public let transaction: Transaction
    public let environment: EnvironmentValues
}
