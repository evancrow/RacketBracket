//
//  ViewExtensions.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/18/22.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    /// Similar to the React hook, combines `onAppear` and `onChange`.
    func useEffect<T: Equatable>(deps: T, perform updater: @escaping (T) -> Void) -> some View {
        self.onChange(of: deps, perform: updater)
            .onAppear { updater(deps) }
    }
}
