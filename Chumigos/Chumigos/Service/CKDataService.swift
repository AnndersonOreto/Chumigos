//
//  CKDataService.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 15/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import CloudKit

struct CKDataService {
    
    // Public tables
    public enum TableNames: String {
        case teste1 = "Teste1"
    }
    
    // MARK: - Errors
    
    // Error type for CloudKit error handling
    enum CloudKitErrors: Error {
        case recordError
        case recordIDFailure
        case castFailure
        case cursosFailure
    }
    
    // MARK: - Fetch Data
    
    // Standard fetch function
    /// Get all results on database based on a table
    /// - Parameter completion: return the item list on a table
    static func fetch<T: CKCloudDataProtocol>(tableName: String, completion: @escaping (Result<T, Error>) -> ()) {
        
        let predicate = NSPredicate(value: true)
        
        // Criteria to fech value
        let query = CKQuery(recordType: tableName, predicate: predicate)
        
        // Operation to query on database
        let queryOperation = CKQueryOperation(query: query)
        
        // Database return with values on CKRecord
        queryOperation.recordFetchedBlock = { record in
            
            // Dispatch for completion purposes
            DispatchQueue.main.async {
                
                // Getting T value from fetched data
                guard let value = try? T.parse.toDataObject(record) as? T else { return }
                
                completion(.success(value))
            }
        }
        
        // Error handling block
        queryOperation.queryCompletionBlock = { (_, err) in
            
            if let err = err {
                
                completion(.failure(err))
                return
            }
        }
        
        CKContainer.default().publicCloudDatabase.add(queryOperation)
    }
    
    // Save function
    /// Save an item into the database by crating a new record on it
    /// - Parameters:
    ///   - item: item that should be created
    ///   - completion: check if item has been created
    static func create<T: CKCloudDataProtocol>(item: T, completion: @escaping (Result<T, Error>) -> ()) {
        
        // Parse item into a record
        guard let itemRecord = try? T.parse.toDataRecord(item) else { return }
        
        // Saving record into database
        CKContainer.default().publicCloudDatabase.save(itemRecord) { (record, err) in
            
            DispatchQueue.main.async {
                
                // Error handling
                if let err = err {
                    completion(.failure(err))
                    return
                }
                
                // Check if record exists
                guard let record = record else {
                    completion(.failure(CloudKitErrors.recordError))
                    return
                }
                
                // Check if parse succeeded
                guard let value = try? T.parse.toDataObject(record) as? T else {
                    completion(.failure(CloudKitErrors.castFailure))
                    return
                }
                
                completion(.success(value))
            }
        }
    }
    
    // Update a record on the database
    /// Update a record on the database
    /// - Parameters:
    ///   - item: item that will be updated
    ///   - completion: used to check if the item has been deleted or not returning an result object
    static func update<T: CKCloudDataProtocol>(item: T, completion: @escaping (Result<T, Error>) -> ()) {
        
        // Parse item into a record
        guard let recordID = item.recordID else { return }
        
        // Fetches item that has the unique recordID on the database and updates it
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { (record, err) in
            
            // Error handling
            if let err = err {
                DispatchQueue.main.async {
                    completion(.failure(err))
                }
                return
            }
            
            // Check if record exists
            guard record != nil else {
                DispatchQueue.main.async {
                    completion(.failure(CloudKitErrors.recordError))
                }
                return
            }
            
            // Call save function
            create(item: item) { record in
                
                switch record {
                    
                case.failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(error))
                    return
                    
                case .success(let result):
                    completion(.success(result))
                    return
                }
            }
        }
    }
    
    /// Deletes a record from the database
    /// - Parameters:
    ///   - recordID: ID that will be deleted
    ///   - completion: used to check if the record has been deleted or an error occurred
    static func delete(_ recordID: CKRecord.ID, completion: @escaping (Result<CKRecord.ID, Error>) -> ()) {
        
        // Delete the record from the database
        CKContainer.default().publicCloudDatabase.delete(withRecordID: recordID) { (recordID, err) in
            
            // Error handling
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
                guard let recordID = recordID else {
                    completion(.failure(CloudKitErrors.recordIDFailure))
                    return
                }
                completion(.success(recordID))
            }
        }
    }
}
