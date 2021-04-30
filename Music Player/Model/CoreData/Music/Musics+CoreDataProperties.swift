//
//  Musics+CoreDataProperties.swift
//  Music Player
//
//  Created by Mac on 12/04/21.
//
//

import Foundation
import CoreData


extension Musics {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Musics> {
        return NSFetchRequest<Musics>(entityName: "Musics")
    }

    @NSManaged public var title: String?
    @NSManaged public var artist: String?
    @NSManaged public var album: String?
    @NSManaged public var url: String?
    @NSManaged public var id: Int16

}

extension Musics : Identifiable {

}
