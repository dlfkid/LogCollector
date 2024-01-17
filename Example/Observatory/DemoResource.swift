//
//  DemoResource.swift
//  Observatory_Example
//
//  Created by LeonDeng on 2024/1/14.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import ObservatoryCommon

enum DemoResource {
    static let sharedResource = ResourceBuilder() .serviceName("demmoTelemetry").nameSpace("plainLogger").instanceId("LogSendViewController").version("0.1.0").build()
}