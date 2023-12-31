//
//  Resource.swift
//  Pods
//
//  Created by LeonDeng on 2023/10/5.
//

import Foundation

public struct Resource {
    
    private let serviceNameKey = "service.name"
    
    private let nameSpaceKey = "service.namespace"
    
    private let instanceIdKey = "service.instance.id"
    
    private let versionKey = "service.version"
    
    fileprivate var serviceName: String?
    fileprivate var nameSpace: String?
    fileprivate var instanceId: String?
    fileprivate var version: String?
    fileprivate var otherAttributes: [String: ObservatoryValue]?
    
    var metaData: [String: ObservatoryValue] {
        var result = [String: ObservatoryValue]()
        if let otherAttributes = otherAttributes {
            otherAttributes.forEach { (key: String, value: ObservatoryValue) in
                result[key] = value
            }
        }
        result[serviceNameKey] = .string(serviceName ?? "")
        result[nameSpaceKey] = .string(nameSpace ?? "")
        result[instanceIdKey] = .string(instanceId ?? "")
        result[versionKey] = .string(version ?? "")
        return result
    }
    
    fileprivate init(serviceName: String? = nil, nameSpace: String? = nil, instanceId: String? = nil, version: String? = nil, otherAttributes: [String : ObservatoryValue]? = nil) {
        self.serviceName = serviceName
        self.nameSpace = nameSpace
        self.instanceId = instanceId
        self.version = version
        self.otherAttributes = otherAttributes
    }
}

public class ResourceBuilder {
    var limit = LimitConfig()
    var resourceSample = Resource()
    
    public init() {}
    
    public func serviceName(_ serviceName: String) -> ResourceBuilder {
        resourceSample.serviceName = serviceName
        return self
    }
    public func nameSpace(_ nameSpace: String) -> ResourceBuilder {
        resourceSample.nameSpace = nameSpace
        return self
    }
    public func instanceId(_ instanceId: String) -> ResourceBuilder {
        resourceSample.instanceId = instanceId
        return self
    }
    public func version(_ version: String) -> ResourceBuilder {
        resourceSample.version = version
        return self
    }
    public func otherAttributes(_ otherAttributes: [String: ObservatoryValue]) -> ResourceBuilder {
        var attributeCount = 0
        for (key, value) in otherAttributes {
            if attributeCount >= limit.maximumNumberOfAttributes ?? 0 {
                // dropped attribute
                continue
            }
            resourceSample.otherAttributes?[key] = value
            attributeCount += 1
        }
        return self
    }
    
    public func build() -> Resource {
        return resourceSample
    }
}

