//
//  TimeInterval+String.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 29/11/23.
//

import Foundation

extension Double {
    var toMinutesAndSeconds: String {
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: self) ?? "0:00"
    }
}
