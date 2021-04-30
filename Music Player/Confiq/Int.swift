//
//  Int.swift
//  Music Player
//
//  Created by Mac on 12/04/21.
//

import Foundation
extension Int {
    func convertToSpecificFormat() -> String {
        
        if self >= 60 {
            
            var getSecond = "\((self % 3600) % 60)"
            
            if (self % 3600) % 60 < 10 {
                getSecond = "0\((self % 3600) % 60)"
            }
            
            if self >= 3600 {
                return "\(self / 3600):\((self % 3600) / 60):\(getSecond)"
            }
            return "\((self % 3600) / 60):\(getSecond)"
        }
        
        if self < 10 {
            return "00:0\(self)"
        }
        
        return "00:\(self)"
    }
}
