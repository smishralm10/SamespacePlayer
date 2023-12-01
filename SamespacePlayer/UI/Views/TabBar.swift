//
//  TabBar.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 27/11/23.
//

import SwiftUI

struct TabBar: View {
    @Binding var selectedTab: Tab
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    VStack {
                        Text(tab.title)
                            .font(.headline)
                            .foregroundStyle(
                                selectedTab == tab ? .primary : .secondary)
                        if selectedTab == tab {
                            Circle()
                                .fill(.primary)
                                .frame(width: 6)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.snappy) {
                            selectedTab = tab
                        }
                    }
                    Spacer()
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: 70)
        .background(.background)
    }
}

enum Tab: String, CaseIterable {
    case forYou
    case topTrack
    
    var title: String {
        switch self {
        case .forYou:
            "For You"
        case .topTrack:
            "Top Track"
        }
    }
}

#Preview {
    TabBar(selectedTab: .constant(.forYou))
}
