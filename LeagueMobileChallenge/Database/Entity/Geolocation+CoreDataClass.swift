//
//  Geolocation+CoreDataClass.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-03.
//  Copyright © 2021 Kelvin Lau. All rights reserved.
//
//

import Foundation
import CoreData
import ObjectMapper

public class Geolocation: NSManagedObject, Mappable {
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Geolocation", in: managedContext)
        super.init(entity: entity!, insertInto: context)
    }
    
    required convenience public init(map: Map) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        self.init(context : managedContext)
        self.mapping(map: map)
    }
    
    public func mapping(map: Map) {
        longitude   <- (map["lng"])
        latitude   <- (map["lat"])
    }
}