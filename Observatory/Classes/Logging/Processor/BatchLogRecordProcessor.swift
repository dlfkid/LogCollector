//
//  BatchLogRecordProcessor.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/21.
//

import Foundation

public struct BatchLogRecordConfig {
    
    let exporter: LogExportable?
    
    var maxQueueSize: Int = 1024
    
    var scheduledDelayMillis: TimeInterval = 1000
    
    var exportTimeoutMillis: TimeInterval = 300000
    
    var maxExportBatchSize: Int = 32
}

public class BatchLogRecordProcessor: LogProcessable {
    
    public func onEmit(logRecord: LogRecordData) {
        logRecordHandleQueue.sync {
            guard config.maxQueueSize < unexportedLogRecords.count else {
                print("[Observatory]: LogProcessor collect limit reached")
                return
            }
            unexportedLogRecords.append(logRecord)
        }
    }
    
    public var exporter: LogExportable? {
        get {
            return config.exporter
        }
    }
    
    private var shuttedDown: Bool = false
    
    private let config: BatchLogRecordConfig
    
    private var timer: DispatchSourceTimer?
    
    private var unexportedLogRecords = [LogRecordData]()
    
    private let logRecordHandleQueue = dispatch_queue_serial_t(label: "observatory_batch_processor_queue")
    
    init(config: BatchLogRecordConfig) {
        self.config = config
        timer = DispatchSource.makeTimerSource(queue: logRecordHandleQueue)

        // Set up the timer configuration
        timer?.schedule(deadline: .now(), repeating: config.scheduledDelayMillis / 1000)

        // Set the timer event handler
        timer?.setEventHandler { [weak self] in
            guard let self = self else {
                return
            }
            var logBatch = [LogRecordData]()
            let maxLength = min(config.maxExportBatchSize, self.unexportedLogRecords.count)
            for index in 0 ... maxLength {
                logBatch.append(self.unexportedLogRecords[index])
            }
            exporter?.export(timeout: config.exportTimeoutMillis / 1000, batch: logBatch, completion: { result in
            })
        }

        // Start the timer
        timer?.resume()
    }
    
    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }
}

extension BatchLogRecordProcessor: ProcedureEndable {
    public var isShuttedDown: Bool {
        return shuttedDown
    }
    
    public func shutdown(timeout: TimeInterval, closure: ProcedureEndClosure?) {
        defer {
            shuttedDown = true
        }
        if isShuttedDown {
            guard let closure = closure else {
                return
            }
            closure(false, .shuttedDown(component: "BatchLogProcessor"))
            return
        }
        exporter?.shutdown(timeout: timeout, closure: closure)
        stopTimer()
    }
    
    public func forceFlush(timeout: TimeInterval, closure: ProcedureEndClosure?) {
        if isShuttedDown {
            guard let closure = closure else {
                return
            }
            closure(false, .shuttedDown(component: "BatchLogProcessor"))
            return
        }
        exporter?.forceFlush(timeout: timeout, closure: closure)
    }
}
