//
//  CKCloudData.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 16/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import CloudKit

protocol CKCloudDataProtocol {
    
    // Table name on database
    static var tableName: String { get }
    
    // Object parser
    static var parse: CKCloudParseProtocol { get }
    
    // Record ID from unique identifier on database
    var recordID: CKRecord.ID? { get }
}
