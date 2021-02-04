//
//  Album+CoreDataProperties.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-03.
//  Copyright © 2021 Kelvin Lau. All rights reserved.
//
//

import Foundation
import CoreData


extension Album {
 
    @NSManaged public var id: Int16
    @NSManaged public var title: String?
    @NSManaged public var userId: Int16

}
