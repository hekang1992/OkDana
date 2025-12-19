//
//  Untitled.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/17.
//

import Foundation

class GrowManager: NSObject {
    
    static func availableDiskSpace() -> UInt64 {
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
        do {
            let values = try tempURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
            let capacity = values.volumeAvailableCapacityForImportantUsage ?? -1
            return capacity >= 0 ? UInt64(capacity) : 0
        } catch {
            return 0
        }
    }
    
    static var totalDiskSpace: UInt64 {
        do {
            let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            if let size = attributes[.systemSize] as? NSNumber {
                return size.uint64Value
            }
        } catch {}
        return 0
    }
    
    static var totalMemory: UInt64 {
        return ProcessInfo.processInfo.physicalMemory
    }
    
    static func availableMemory() -> UInt64 {
        var stats = vm_statistics64()
        var count = mach_msg_type_number_t(MemoryLayout.size(ofValue: stats) / MemoryLayout<integer_t>.size)
        
        let statsPtr = UnsafeMutablePointer<vm_statistics64>.allocate(capacity: 1)
        defer { statsPtr.deallocate() }
        statsPtr.initialize(to: stats)
        
        let result = statsPtr.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
            host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
        }
        
        guard result == KERN_SUCCESS else { return 0 }
        stats = statsPtr.pointee
        
        let pageSize = UInt64(vm_kernel_page_size)
        let freeBytes = UInt64(stats.free_count) * pageSize
        let inactiveBytes = UInt64(stats.inactive_count) * pageSize
        
        return freeBytes + inactiveBytes
    }
    
    static func toJson() -> [String: [String: String]] {
        return ["grow": ["fix": "\(availableDiskSpace())",
                         "remove": "\(totalDiskSpace)",
                         "whereas": "\(totalMemory)",
                         "generalization": "\(availableMemory())"]]
    }
}
