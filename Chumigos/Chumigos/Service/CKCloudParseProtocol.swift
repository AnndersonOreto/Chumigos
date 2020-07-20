//
//  CKCloudParseProtocol.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 16/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import CloudKit

protocol CKCloudParseProtocol {
    
    // Function to turn a record into a object
    func toDataObject(_ record: CKRecord) throws -> CKCloudDataProtocol
    
    // Function to turn a object into a record
    func toDataRecord(_ cloudData: CKCloudDataProtocol) throws -> CKRecord
}
