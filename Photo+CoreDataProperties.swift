//
//  Photo+CoreDataProperties.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-05.
//  Copyright © 2021 Kelvin Lau. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {
    @NSManaged public var id: Int16
    @NSManaged public var albumId: Int16
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var thumbnailUrl: String?

}
