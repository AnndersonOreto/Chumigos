//
//  UserData+CoreDataProperties.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 01/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var name: String?
    @NSManaged public var uuid: UUID?

}
