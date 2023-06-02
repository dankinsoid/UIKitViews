import SwiftUI

public extension UIKitView {

	init<T>(
		_ make: @escaping () -> Base.Root
	) where Base == UIKitViewChaining<AnyUIViewRepresentable<T>> {
		self = UIKitViewChaining(AnyUIViewRepresentable(make)).wrap()
	}

	init<C: ValueChaining>(
		_ make: @escaping () -> Chain<C>
	) where Base == UIKitViewChaining<AnyUIViewRepresentable<C.Root>> {
		self.init {
			make().apply()
		}
	}

	init<T>(
		_ make: @escaping () -> Base.Root
	) where Base == UIKitViewChaining<AnyUIViewControllerRepresentable<T>> {
		self = UIKitViewChaining(AnyUIViewControllerRepresentable(make)).wrap()
	}

	init<C: ValueChaining>(
		_ make: @escaping () -> Chain<C>
	) where Base == UIKitViewChaining<AnyUIViewControllerRepresentable<C.Root>> {
		self.init {
			make().apply()
		}
	}
}
