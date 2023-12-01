//
//  AppState.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 28/11/23.
//

import Foundation
import SwiftUI
import Combine

struct AppState: Equatable {
    var userData = UserData()
}

extension AppState {
    struct UserData: Equatable {
        var songs = [Song]()
        var isLoadingSong = false
        var playerError: String? = nil
        var playback: Playback? = nil
    }
    
}

func == (lhs: AppState, rhs: AppState) -> Bool {
    return lhs.userData == rhs.userData
}

#if DEBUG
extension AppState {
    static var preview: AppState {
        let state = AppState()
        return state
    }
}
#endif
    

