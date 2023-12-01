//
//  ContentView.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 23/11/23.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private(set) var selectedTab: Tab = .forYou
    @State private(set) var error: String? = nil
    
    @Environment(\.injected) var injected
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForYouView()
                .tabItem { Text("For You") }
                .tag(Tab.forYou)
            TopTrack()
                .tabItem { Text("Top Track") }
                .tag(Tab.topTrack)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .safeAreaInset(edge: .bottom) {
            TabBar(selectedTab: $selectedTab)
            MiniPlayerView()
        }
        .overlay(alignment: .top, content: {
            if let error {
                Text("Cannot play song. Skipping to next")
                    .foregroundStyle(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.red)
                    )
                    .transition(.opacity)
                    .animation(.spring, value: error)
            }
        })
        .preferredColorScheme(.dark)
        .onReceive(errorUpdate) { error = $0 }
    }
}

private extension ContentView {
    var errorUpdate: AnyPublisher<String?, Never> {
        injected.appState.updates(for: \.userData.playerError)
    }
}

#Preview {
    ContentView()
}
