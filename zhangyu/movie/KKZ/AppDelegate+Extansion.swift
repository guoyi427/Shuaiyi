//
//  AppDelegate+Extansion.swift
//  KoMovie
//
//  Created by Albert on 13/02/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

import Foundation

extension KKZAppDelegate{
    func configBugly() {
        let config = BuglyConfig()
        #if DEBUG
            config.debugMode = true
        #endif
        config.reportLogLevel = BuglyLogLevel.warn
        // 卡顿监控
        config.blockMonitorEnable = true
        
        config.channel = "App Store"
        
        Bugly.start(withAppId: "c755223fda", config: config)
        
        Bugly.setUserIdentifier(UIDevice.current.name)
        
        Bugly.setUserValue(ProcessInfo.processInfo.processName, forKey: "Process")

//        BLYLogv(.warn, "test", getVaList(["warn"]))
    }
}
