//
//  Queue.swift
//  Music Player
//
//  Created by Mac on 20/04/21.
//

import Foundation

class Queue {
    
    private var coreData: CoreDataStack? = nil
    private let musicCoreData = CoreDataMusic()
    
    init(coreData:CoreDataStack?) {
        self.coreData = coreData
    }
    
}

extension Queue {
    func getPlayedSong(result:@escaping (Music?)->()) {
        coreData?.doInBackground(managedContext: { [weak self] context in
            self?.musicCoreData.getAllSong(managedContext: context, success: { allMusic in
                
                result(allMusic.first)
                
            }, failed: {
                print("failed get queue")
            })
        })
    }
    func getQueue(result:@escaping ([Music])->()) {
        coreData?.doInBackground(managedContext: { [weak self] context in
            self?.musicCoreData.getAllSong(managedContext: context, success: { allMusic in
                
                result(allMusic)
                
            }, failed: {
                print("failed get queue")
            })
        })
    }
}

