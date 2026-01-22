//
//  SleepPreventer.swift
//  VLCPlayer
//
//  Created by uhimania on 2026/01/22.
//

import Foundation
import IOKit.pwr_mgt

final class SleepPreventer {
    static let shared = SleepPreventer()
    
    private var assertionID: IOPMAssertionID = 0
    
    private init() {}
    
    func disableSleep() {
        guard assertionID == 0 else { return }
        
        IOPMAssertionCreateWithName(
            kIOPMAssertionTypeNoDisplaySleep as CFString,
            IOPMAssertionLevel(kIOPMAssertionLevelOn),
            "movie playing" as CFString,
            &assertionID
        )
    }
    
    func enableSleep() {
        guard assertionID != 0 else { return }
        
        IOPMAssertionRelease(assertionID)
        assertionID = 0
    }
}
