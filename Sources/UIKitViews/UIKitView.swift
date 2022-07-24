import UIKit
import SwiftUI
import VDChain

///A `SwiftUI` view that represents a `UIKit` view (`UIView`, `UIViewController`).
///
/// - Overview:
///Create a `UIKitView` object when you want to integrate `UIKit` views into a `SwiftUI` view hierarchy.
///At creation time, specify an autoclosure that creates the `UIKit` view and a closure that updates the view.
///You can set view properties via method chaining and `uiKitViewEnvironment` modifier.
///Use the `UIKitView` like you would any other view.
@dynamicMemberLookup
public struct UIKitView<Content: UIKitRepresentable>: View, Chaining {
    
    private let content: Content
    public var applier: (inout Content.Content) -> Void = { _ in }
    @Environment(\.uiKitView) private var environment

    public var body: some View {
        var result = content
        let updater = result.updater
        result.updater = {
            var view = $0
            updater(view, $1)
            applier(&view)
            environment.apply(for: view)
        }
        return result
    }

    fileprivate init(_ content: Content) {
        self.content = content
    }

    public subscript<T>(dynamicMember keyPath: KeyPath<Content.Content, T>) -> PropertyChain<Self, T> {
        PropertyChain(self, getter: keyPath)
    }
}

extension UIKitView {

    public init<T>(_ make: @escaping @autoclosure () -> Content.Content, update: @escaping (Content.Content, Content.ViewContext) -> Void = { _, _ in }) where Content == _UIViewView<T> {
        var wrapper = Content(make)
        wrapper.updater = update
        self = .init(wrapper)
    }

    public init<T>(_ make: @escaping @autoclosure () -> Content.Content, update: @escaping (Content.Content, Content.ViewContext) -> Void = { _, _ in }) where Content == _UIViewControllerView<T> {
        var wrapper = Content(make)
        wrapper.updater = update
        self = .init(wrapper)
    }
}

public protocol UIKitRepresentable: View {
    
    associatedtype Content
    associatedtype ViewContext
    var updater: (Content, ViewContext) -> Void { get set }
    init(_ make: @escaping () -> Content)
}

// swiftlint:disable: type_name
public struct _UIViewView<Content: UIView>: UIViewRepresentable, UIKitRepresentable {

    let make: () -> Content
    public var updater: (Content, Context) -> Void = { _, _ in }

    public init(_ make: @escaping () -> Content) {
        self.make = make
    }

    public func makeUIView(context: Context) -> Content {
        make()
    }

    public func updateUIView(_ uiView: Content, context: Context) {
        updater(uiView, context)
    }
}

public struct _UIViewControllerView<Content: UIViewController>: UIViewControllerRepresentable, UIKitRepresentable {

    let make: () -> Content
    public var updater: (Content, Context) -> Void = { _, _ in }

    public init(_ make: @escaping () -> Content) {
        self.make = make
    }

    public func makeUIViewController(context: Context) -> Content {
        make()
    }

    public func updateUIViewController(_ uiViewController: Content, context: Context) {
        updater(uiViewController, context)
    }
}
// swiftlint:enable: type_name
