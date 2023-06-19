import SwiftUI

public extension UIKitView {

	init<T>(
        _ make: @escaping () -> Base.Root
	) where Base == UIKitViewChain<AnyUIViewRepresentable<T>> {
		self = UIKitViewChain(AnyUIViewRepresentable(make)).wrap()
	}

	init<C: ValueChaining>(
		_ make: @escaping () -> Chain<C>
	) where Base == UIKitViewChain<AnyUIViewRepresentable<C.Root>> {
		self.init {
			make().apply()
		}
	}

	init<T>(
		_ make: @escaping () -> Base.Root
	) where Base == UIKitViewChain<AnyUIViewControllerRepresentable<T>> {
		self = UIKitViewChain(AnyUIViewControllerRepresentable(make)).wrap()
	}

	init<C: ValueChaining>(
		_ make: @escaping () -> Chain<C>
	) where Base == UIKitViewChain<AnyUIViewControllerRepresentable<C.Root>> {
		self.init {
			make().apply()
		}
	}
}
