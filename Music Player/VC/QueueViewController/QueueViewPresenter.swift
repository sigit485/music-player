//
//  QueueViewPresenter.swift
//  Music Player
//
//  Created by Mac on 21/04/21.
//

import Foundation
import UIKit

class QueueViewPresenter:NSObject {
    private var view: QueueViewController? = nil
    
    private var nowPlaying: Music? = nil
    private var listQueue = [Music]()
    private var queue: Queue? = nil
    
    private var doReload: (()->())? = nil
    override init() {
        super.init()
    }
    
    convenience init(view:QueueViewController) {
        self.init()
        self.view = view
        
        self.view?.getTable().register(QueueTableViewCell.self, forCellReuseIdentifier: "queueCell")
        self.view?.getTable().delegate = self
        self.view?.getTable().dataSource = self
        queue = Queue(coreData: (self.view?.returnCoreDataStack())!)
        
//        queue?.getPlayedSong(result: { music in
//            self.nowPlaying = music
//            self.doReload?()
//        })
//
//        queue?.getQueue(result: { listMusic in
//            var temp = listMusic
//            temp.remove(at: 0)
//            self.listQueue = temp
//            self.doReload?()
//        })
        
        
        self.nowPlaying = QueueTemp.queue[0]
        var temp = QueueTemp.queue
        temp.remove(at: 0)
        self.listQueue = temp
        
//        doReload = {
//            if self.nowPlaying != nil && self.listQueue.count != 0 {
//                DispatchQueue.main.async {
//                    self.view?.getTable().reloadData()
//                }
//            }
//        }
        
        
    }
    
}

extension QueueViewPresenter:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return listQueue.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "queueCell", for: indexPath) as? QueueTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.section == 0 {
            if let play = nowPlaying {
                cell.setData(music: play)
            }
        } else {
            cell.setData(music: listQueue[indexPath.row])
        }
        
        
        
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Now Playing"
        } else {
            return "Queue"
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}


