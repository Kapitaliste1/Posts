//
//  Photo+CoreDataClass.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-05.
//  Copyright © 2021 Kelvin Lau. All rights reserved.
//
//

import Foundation
import CoreData
import ObjectMapper

public class Photo: NSManagedObject, Mappable {
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Photo", in: managedContext)
        super.init(entity: entity!, insertInto: context)
    }
    
    required convenience public init(map: Map) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        self.init(context : managedContext)
        self.mapping(map: map)
    }
    
    public func mapping(map: Map) {
        id   <- (map["id"])
        albumId   <- (map["albumId"])
        title   <- (map["title"])
        url   <- (map["url"])
        thumbnailUrl   <- (map["thumbnailUrl"])
    }
}
