//
//  CoreDataMusicProtocol.swift
//  Music Player
//
//  Created by Mac on 12/04/21.
//

import Foundation
import CoreData

protocol CoreDataMusicProtocol {
    func addAllSong(managedContext: NSManagedObjectContext, musics: [Music], success: () -> (), failed: () -> ())
    func getAllSong(managedContext: NSManagedObjectContext, success: ([Music]) -> (), failed: () -> ())
    func get_a_Song(managedContext: NSManagedObjectContext, id:Int, success: (Music) -> (), failed: () -> ())
    func deleteAllSong(managedContext: NSManagedObjectContext, success: () -> (), failed: () -> ())
    func add_a_Song(managedContext: NSManagedObjectContext, music: Music, success: () -> (), failed: () -> ())
    func delete_a_song(managedContext: NSManagedObjectContext, music: Music, success: () -> (), failed: () -> ())
}
