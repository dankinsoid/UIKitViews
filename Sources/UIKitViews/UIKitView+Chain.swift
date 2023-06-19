import SwiftUI
import VDChain

extension Chain: View where Base: UIKitViewChaining {

	public var body: some View {
        base.body(values: values)
	}
}
