//
//  Storage.swift
//  ScooterFinder
//
//  Created by Samuel Kebis on 09/05/2022.
//

import Foundation
import os.log

/// Same as `FileManager.default`, but shorter
fileprivate let Filer = FileManager.default


class Storage {
    
    // To create methods to save (and load) objects to default app directory:
    //  1. Add new case to StoragePathEnum.
    //  2. Add two similar methods as following:
    
    // Vehicles
    static func save(vehicles: [Vehicle]) { saveGeneric(.vehicles, object: vehicles) }
    static func vehicles() -> [Vehicle]? { loadGeneric(.vehicles) }
    
    
    private enum StoragePathEnum: String {
        case vehicles
        
        var asUrl: URL {
            let appDirectory = Filer.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            return appDirectory.subFile(rawValue + ".json")
        }
    }
    
    
    // MARK: - Generic save & load
    
    private static func saveGeneric<T: Encodable>(_ pathEnum: StoragePathEnum, object: T) {
        do {
            let data = try JSONEncoder().encode(object)
            let fileUrl = pathEnum.asUrl
            createNeededDirectoriesFor(fileUrl: fileUrl)
            let fileExist = Filer.fileExists(atPath: fileUrl.path)
            
            if fileExist {
                try data.write(to: fileUrl, options: [.atomicWrite])
                log("save (override) - " + pathEnum.rawValue)
            } else {
                let ok = Filer.createFile(atPath: fileUrl.path, contents: data)
                log("save (create) - " + pathEnum.rawValue, type: ok ? .default : .error)
            }
        } catch {
            log("save - " + pathEnum.rawValue + " - " + error.localizedDescription, type: .error)
        }
    }
    
    private static func loadGeneric<T: Decodable>(_ pathEnum: StoragePathEnum) -> T? {
        let url: URL = pathEnum.asUrl
        let debugName: String = pathEnum.rawValue
        
        guard Filer.fileExists(atPath: url.path) else {
            log("load (not found) - " + debugName)
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            log("load - " + debugName, type: .debug)
            return object
        } catch {
            log("load (decode) - " + debugName + " - " + error.localizedDescription, type: .error)
            return nil
        }
    }
    
    
    // MARK: - Utilities
    
    /// Creates directories that doesn't exist yet in url
    private static func createNeededDirectoriesFor(fileUrl: URL) {
        let directoryUrl = fileUrl.deletingLastPathComponent()
        do {
            try Filer.createDirectory(at: directoryUrl, withIntermediateDirectories: true)
        } catch {
            log("new directory - " + directoryUrl.path + " - " + error.localizedDescription, type: .error)
        }
    }
    
    
    // MARK: - Debug
    
    // Use the Console mac app for better filtering or inspecting logs
    
    @available(iOS 14.0, *)
    private static let logger = Logger(oldOSLog)
    private static let oldOSLog = OSLog(subsystem: "com.SamuelKebis.ScooterFinder", category: "storage")
    
    private static func log(_ message: String, type: OSLogType = .default) {
        if #available(iOS 14.0, *) {
            logger.log(level: type, "\(message, privacy: .public)")
        } else {
            os_log("%{public}@", log: oldOSLog, type: type, message)
        }
    }
}
