//
//  StorageManager.swift
//  REST API
//
//  Created by Дмитрий Тараканов on 07.12.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//

import Foundation
import RealmSwift

enum fileName: String {
    case example = "DaysBase.realme"
}

class StorageManager {
    
    private static let realm       = launchRealm(realmConfiguration())
    static let realmPathDays       = StorageManager.realm.objects(Day.self)
    static let realmPathEvent      = StorageManager.realm.objects(Event.self)
    private static var fileManager = FileManager.default
    
    private static func realmConfiguration() -> Realm.Configuration {
        
        let filePath = StorageManager.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let realmURL = filePath.appendingPathComponent(fileName.example.rawValue, isDirectory: false)
        
        return Realm.Configuration(fileURL: realmURL, schemaVersion: 2)
    }
    
    private static func launchRealm(_ configuration: Realm.Configuration) -> Realm {
        
        var realm: Realm? = nil
        do {
            realm = try Realm(configuration: configuration)
        } catch let error as NSError {
            print(error)
            removeAllRealmeFiles(fileURL: configuration.fileURL!)
            realm = try! Realm(configuration: configuration)
        }
        return realm!
    }
    
    static func updateDB(_ dataFromServer: Event) {
        
        try! realm.write {
            realm.add(dataFromServer, update: .modified)
        }
    }
    
    private static func deleteAll() {
        
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    private static  func removeAllRealmeFiles(fileURL: URL) {
        
        let directory = fileURL.deletingLastPathComponent()
        let fileName  = fileURL.deletingPathExtension().lastPathComponent
        
        do {
            let existFiles = try fileManager.contentsOfDirectory(
                at: directory,
                includingPropertiesForKeys: nil)
                .filter({
                    return $0.lastPathComponent.hasPrefix(fileName as String)
                })
            for oldFile in existFiles {
                try fileManager.removeItem(at: oldFile)
            }
        }
        catch let error as NSError {
            print(error)
        }
    }
}
