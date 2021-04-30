//
//  CoreDataMusic.swift
//  Music Player
//
//  Created by Mac on 12/04/21.
//

import Foundation
import CoreData


class CoreDataMusic{
    
}

extension CoreDataMusic: CoreDataMusicProtocol {
    func addAllSong(managedContext: NSManagedObjectContext, musics: [Music], success: () -> (), failed: () -> ()) {
        
        
        
        do {
            for music in musics {
                let aMusic = Musics(context: managedContext)
                aMusic.id = Int16(music.id)
                aMusic.album = music.album
                aMusic.artist = music.artist
                aMusic.title = music.title
                aMusic.url = music.url
                
                
                try managedContext.save()
                
            }
            
            
            
            success()
            
        } catch let error as NSError {
            print("Count not write \(error), \(error.userInfo)")
            failed()
        }
    }
    
    func getAllSong(managedContext: NSManagedObjectContext, success: ([Music]) -> (), failed: () -> ()) {
        let fetchSong:NSFetchRequest<Musics> = Musics.fetchRequest()
        
        do {
            
            let getAllMusics = try managedContext.fetch(fetchSong)
            
            var list_of_music = [Music]()
            
            for aMusic in getAllMusics {
                if let url = aMusic.url {
                    let music = Music(id: Int(aMusic.id), title: aMusic.title ?? "Unknow Title" , artist: aMusic.artist ?? "Unknow Artist", album: aMusic.album ?? "Unknow Album", url: url)
                    list_of_music.append(music)
                } else {
                    print("url empty")
                }
                
            }
            success(list_of_music)
            
            
        } catch let error as NSError {
            print("Count not fetch \(error), \(error.userInfo)")
            failed()
        }
        
        
    }
    
    func get_a_Song(managedContext: NSManagedObjectContext, id:Int, success: (Music) -> (), failed: () -> ()) {
        let fetchSong:NSFetchRequest<Musics> = Musics.fetchRequest()
        fetchSong.predicate = NSPredicate(format: "%K == %@", (\Musics.id)._kvcKeyPathString! , String(id))
        
        do {
            let getAllMusics = try managedContext.fetch(fetchSong)
            let getOnlyOne = getAllMusics.first
            
            if let result = getOnlyOne, let url = result.url {
                let music = Music(id: Int(result.id), title: result.title ?? "Unknow Title" , artist: result.artist ?? "Unknow Artist", album: result.album ?? "Unknow Album", url: url)
                success(music)
            } else {
                failed()
            }
            
        } catch let error as NSError {
            print("Count not fetch \(error), \(error.userInfo)")
            failed()
        }
        
        
    }
    
    func deleteAllSong(managedContext: NSManagedObjectContext, success: () -> (), failed: () -> ()) {
        
        let fetchSong:NSFetchRequest<Musics> = Musics.fetchRequest()
        
        do {
            
            let getAllMusics = try managedContext.fetch(fetchSong)
            
            for aMusic in getAllMusics {
                managedContext.delete(aMusic)
            }
            
            try managedContext.save()
            success()
            
        } catch let error as NSError {
            print("Count not fetch \(error), \(error.userInfo)")
            failed()
        }
        
        
    }
    
    func add_a_Song(managedContext: NSManagedObjectContext, music: Music, success: () -> (), failed: () -> ()) {
        let aMusic = Musics(context: managedContext)
        aMusic.id = Int16(music.id)
        aMusic.album = music.album
        aMusic.artist = music.artist
        aMusic.title = music.title
        aMusic.url = music.url
        
        do {
            try managedContext.save()
            success()
            
        } catch let error as NSError {
            print("Count not write \(error), \(error.userInfo)")
            failed()
        }
        
    }
    
    func delete_a_song(managedContext: NSManagedObjectContext, music: Music, success: () -> (), failed: () -> ()) {
        let fetchSong:NSFetchRequest<Musics> = Musics.fetchRequest()
        fetchSong.predicate = NSPredicate(format: "%K == %@", (\Musics.id)._kvcKeyPathString! , String(music.id))
        
        do {
            
            let getMusics = try managedContext.fetch(fetchSong)
            let getSelectedMusic = getMusics.first
            
            guard let cehcekSelectedMusic = getSelectedMusic else {
                failed()
                return
            }
            managedContext.delete(cehcekSelectedMusic)
            
            try managedContext.save()
            success()
            
        } catch let error as NSError {
            print("Count not fetch \(error), \(error.userInfo)")
            failed()
        }
        
        
    }
    
}

