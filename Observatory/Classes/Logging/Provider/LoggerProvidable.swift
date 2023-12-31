//
//  LoggerProvidable.swift
//  Pods
//
//  Created by LeonDeng on 2023/10/5.
//

import Foundation

public protocol LoggerProvidable {
    func createLoggerIfNeeded(name: String, version: String, schemeaURL: String?, attributes: [String: ObservatoryValue]?)
    
    func log(_ body: String, severity: LogSeverity, timeStamp: TimeInterval?, attributes: [String: ObservatoryValue]?, traceID: Data?, spanID: Data?, flag: LogRecordFlags, name: String, version: String, schemeaURL: String?)
}

