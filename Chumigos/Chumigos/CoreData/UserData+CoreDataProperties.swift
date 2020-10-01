//
//  UserData+CoreDataProperties.swift
//  Loggio
//
//  Created by Arthur Bastos Fanck on 18/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//
//

import Foundation
import CoreData

extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var imageName: String?
    @NSManaged public var trail: Data?

}
