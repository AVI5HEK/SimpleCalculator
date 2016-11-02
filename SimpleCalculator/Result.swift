//
//  Result.swift
//  SimpleCalculator
//
//  Created by framgia on 10/25/16.
//  Copyright © 2016 framgia. All rights reserved.
//

import Foundation

class Result: NSObject, NSCoding {
    // MARK: - Properties
    
    var argument1: String
    var argument2: String
    var operation: String
    var result: String
    var dataType: String
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("results")
    
    init?(argument1: String, argument2: String, operation: String, result: String, dataType: String) {
        self.argument1 = argument1
        self.argument2 = argument2
        self.operation = operation
        self.result = result
        self.dataType = dataType
        
        if argument1.isEmpty || argument2.isEmpty || operation.isEmpty || result.isEmpty || dataType.isEmpty {
            return nil
        }
    }
    
    // MARK: - Keys
    
    struct PropertyKey {
        static let argument1Key = "argument1"
        static let argument2Key = "argument2"
        static let operationKey = "operation"
        static let resultKey = "result"
        static let dataTypeKey = "dataType"
    }
    
    // MARK: - NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(argument1, forKey: PropertyKey.argument1Key)
        aCoder.encodeObject(argument2, forKey: PropertyKey.argument2Key)
        aCoder.encodeObject(operation, forKey: PropertyKey.operationKey)
        aCoder.encodeObject(result, forKey: PropertyKey.resultKey)
        aCoder.encodeObject(dataType, forKey: PropertyKey.dataTypeKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let argument1 = aDecoder.decodeObjectForKey(PropertyKey.argument1Key) as! String
        let argument2 = aDecoder.decodeObjectForKey(PropertyKey.argument2Key) as! String
        let operation = aDecoder.decodeObjectForKey(PropertyKey.operationKey) as! String
        let result = aDecoder.decodeObjectForKey(PropertyKey.resultKey) as! String
        let dataType = aDecoder.decodeObjectForKey(PropertyKey.dataTypeKey) as! String
        
        // Must call designated initializer.
        self.init(argument1: argument1, argument2: argument2, operation: operation, result: result, dataType: dataType)
    }
    
    // MARK: NSCoding
    
    static func saveResults(results: [Result]) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(results, toFile: Result.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save meals...")
        }
    }
    
    static func loadResults() -> [Result]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Result.ArchiveURL.path!) as? [Result]
    }
}
