//
//  SamespacePlayerApp.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 23/11/23.
//

import SwiftUI

struct SamespacePlayerApp: View {
    private let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    var body: some View {
        ContentView()
            .inject(container)
    }
}
