//
//  HomeViewController.swift
//  Music Player
//
//  Created by Mac on 09/04/21.
//

import UIKit


class HomeViewController: UIViewController {
    
    static var minHeight: CGFloat {
        return DeviceType.current.isIphoneXClass ? 83 : 50
    }
    static var maxHeight: CGFloat {
        return DeviceType.current.isIphoneXClass ? 125 : 100
    }
    
    let scrollView = UIScrollView()
    let homeStackView:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 12
        stack.layoutMargins.left = 10
        stack.layoutMargins.right = 10
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    let contentGallowParkers = SubContent()
    let contentGallowTooVirgin = SubContent()
    let content_nZk = SubContent()
    let viewInfo = ViewInfo()
    let emptyView = UIView()
    
    lazy var musicPlayerView:UIViewController = {
        let musicVC = MusicPlayerViewController()
        
        if let dt = coreDataStack {
            musicVC.addCoreDataStack(coreData: dt)
        }
        
        
        
        return musicVC
    }()
    
    private var coreDataStack: CoreDataStack? = nil
    
    
    private var queue:Queue? = nil
    var updateSongInfo: (()->())? = nil
    
    private var presenter:HomeViewPresenter? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        presenter = HomeViewPresenter(view: self)
        
        addLayout()
        addConstraints()
        contentGallowParkers.setContent(data: Repo.gallow_ParkestAlbum)
        contentGallowTooVirgin.setContent(data: Repo.gallow_TooVirginAlbum)
        content_nZk.setContent(data: Repo.nZk_BestOfVocalWorks2Album)
        
        contentGallowParkers.setTitle(title: "Gallow: Parkers")
        contentGallowTooVirgin.setTitle(title: "Gallow: To Virgint!!")
        content_nZk.setTitle(title: "SawanoHiroyuki[nZk]: BEST OF VOCAL WORKS [nZk] 2")
        
        contentGallowParkers.addImageUrl(url: "https://i1.sndcdn.com/artworks-000513975783-35fqbz-t500x500.jpg")
        contentGallowTooVirgin.addImageUrl(url: "https://img.discogs.com/LUtxLPZMtlsaBfTY0UlBCV6WK8I=/fit-in/384x379/filters:strip_icc():format(webp):mode_rgb():quality(90)/discogs-images/R-13986286-1565521150-4543.jpeg.jpg")
        content_nZk.addImageUrl(url: "https://images.genius.com/86bb485f11d08b9afcd9da32504cac18.1000x1000x1.jpg")
        
        
        contentGallowParkers.clickedSong = { [weak self] listSong in
            //print("title: \(selectedSong?.title) , artist: \(selectedSong?.artist)")
            
            for lagu in listSong {
                print("title: \(lagu.title) , artist: \(lagu.artist)")
            }
            
            self?.addToQueue(music: listSong)
            self?.setImage(image:self?.contentGallowParkers.getImageURL() ?? "")
            
//            self?.updateConstraints_ViewInfo()
            self?.presenter?.updateViewInfo()
//            (self?.musicPlayerView as? MusicPlayerViewController)?.doUpdate?()
        }
        
        contentGallowTooVirgin.clickedSong = { [weak self] listSong in
            //print("title: \(selectedSong?.title) , artist: \(selectedSong?.artist)")
            for lagu in listSong {
                print("title: \(lagu.title) , artist: \(lagu.artist)")
            }
            self?.addToQueue(music: listSong)
            self?.setImage(image:self?.contentGallowTooVirgin.getImageURL() ?? "")
            
//            self?.updateConstraints_ViewInfo()
            self?.presenter?.updateViewInfo()
//            (self?.musicPlayerView as? MusicPlayerViewController)?.doUpdate?()
        }
        
        content_nZk.clickedSong = { [weak self] listSong in
            //print("title: \(selectedSong?.title) , artist: \(selectedSong?.artist)")
            for lagu in listSong {
                print("title: \(lagu.title) , artist: \(lagu.artist)")
            }
            
            self?.addToQueue(music: listSong)
            self?.setImage(image:self?.content_nZk.getImageURL() ?? "")
            
            //self?.updateConstraints_ViewInfo()
            self?.presenter?.updateViewInfo()
//            (self?.musicPlayerView as? MusicPlayerViewController)?.doUpdate?()
        }
        
        configureMusicPlayer()
        
        
        updateSongInfo = { [weak self] in
            
            
            self?.presenter?.updateQueue()
            (self?.musicPlayerView as? MusicPlayerViewController)?.doUpdate?()
            
        }
        
        (musicPlayerView as? MusicPlayerViewController)?.doUpdateQueue = { [weak self] in
            self?.presenter?.updateQueue()
        }
        
        
        
//        (musicPlayerView as? MusicPlayerViewController)?.doUpdate = { [weak self] in
//            
//            
//        }
        
        updateSongInfo?()
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func addLayout() {
        addScrollView()
        addContentGallowParkers()
        addContentGallowTooVirgin()
        addContent_nZk()
        addEmptyView()
        addHomeStackView()
        addViewInfo()
        
    }
    
    private func addConstraints() {
        let views = ["scrollView":scrollView,"homeStackView":homeStackView,"viewInfo":viewInfo]
        let metrix:[String:Any] = ["view_width":self.view.frame.width]
        
        var constraints = [NSLayoutConstraint]()
        
        //MARK: scrollView constraints
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let hScrollView = "H:|-0-[scrollView]-0-|"
        let vScrollView = "V:|-0-[scrollView]-0-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hScrollView, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vScrollView, options: .alignAllTop, metrics: metrix, views: views)
        
        //MARK: homeStackView constraints
        homeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let hHomeStackView = "H:|-0-[homeStackView(view_width)]-0-|"
        let vHomeStackView = "V:|-30-[homeStackView]-0-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hHomeStackView, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vHomeStackView, options: .alignAllTop, metrics: metrix, views: views)
        constraints += [NSLayoutConstraint(item: homeStackView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)]
        
        //MARK: contentGallowParkers , contentGallowTooVirgin , and content_nZk
        contentGallowParkers.translatesAutoresizingMaskIntoConstraints = false
        contentGallowTooVirgin.translatesAutoresizingMaskIntoConstraints = false
        content_nZk.translatesAutoresizingMaskIntoConstraints = false
        
        constraints += [NSLayoutConstraint(item: contentGallowParkers, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 350)]
        constraints += [NSLayoutConstraint(item: contentGallowTooVirgin, attribute: .height, relatedBy: .equal, toItem: contentGallowParkers, attribute: .height, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: content_nZk, attribute: .height, relatedBy: .equal, toItem: contentGallowParkers, attribute: .height, multiplier: 1, constant: 0)]
        
        //MARK: viewInfo and emptyView constraints
        viewInfo.translatesAutoresizingMaskIntoConstraints = false
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        let hViewInfo = "H:|-0-[viewInfo]-0-|"
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hViewInfo, options: .alignAllBottom, metrics: metrix, views: views)
        constraints += [NSLayoutConstraint(item: viewInfo, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1/9, constant: 0)]
        
        let isAlreadyShow = UserDefaults.standard.value(forKey: "viewInfo") as? Bool ?? false
        
        var constraintBottom:NSLayoutConstraint? = nil
        var constraintEmptyView:NSLayoutConstraint? = nil
        
//        if isAlreadyShow == false {
//            constraintBottom = NSLayoutConstraint(item: viewInfo, attribute: .bottomMargin, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: (view.frame.height/9))
//        } else {
//            constraintBottom = NSLayoutConstraint(item: viewInfo, attribute: .bottomMargin, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
//        }
        
        constraintBottom = self.presenter?.setupViewInfo(item: viewInfo)
        
        constraintEmptyView = NSLayoutConstraint(item: emptyView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1/9, constant: 0)
        
        constraintBottom!.identifier = "viewInfo_constraintBottom"
        constraints += [constraintBottom!]
        
        constraintEmptyView!.identifier = "constraintEmptyView_height"
        constraints += [constraintEmptyView!]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func addScrollView() {
        view.addSubview(scrollView)
    }
    
    private func addHomeStackView() {
        homeStackView.addArrangedSubview(contentGallowParkers)
        homeStackView.addArrangedSubview(contentGallowTooVirgin)
        homeStackView.addArrangedSubview(content_nZk)
        homeStackView.addArrangedSubview(emptyView)
        scrollView.addSubview(homeStackView)
    }
    
    private func addContentGallowParkers() {
        scrollView.addSubview(contentGallowParkers)
    }
    
    private func addContentGallowTooVirgin() {
        scrollView.addSubview(contentGallowTooVirgin)
    }
    
    private func addContent_nZk() {
        scrollView.addSubview(content_nZk)
    }
    
    private func addEmptyView() {
        //emptyView.isHidden = true
        
//        let isAlreadyShow = UserDefaults.standard.value(forKey: "viewInfo") as? Bool ?? false
//        if isAlreadyShow == false {
//            emptyView.isHidden = true
//        } else {
//            emptyView.isHidden = false
//        }
        
        emptyView.isHidden = self.presenter!.setupEmptyView()
        
        scrollView.addSubview(emptyView)
    }
    
    private func addViewInfo() {
        viewInfo.backgroundColor = .white
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showMusicPlayer))
        viewInfo.addGestureRecognizer(gesture)
        viewInfo.addImage(url: UserDefaults.standard.string(forKey: "nowPlayingImage") ?? "")
        view.addSubview(viewInfo)
    }
    
    
    private func configureMusicPlayer() {
        view.addSubview(musicPlayerView.view)
        
        //view.bringSubviewToFront(view)
    }

}

extension HomeViewController {
    func updateConstraints_ViewInfo() {
        
        UserDefaults.standard.set(true, forKey: "viewInfo")
        
        
        var constraints = view.constraints
        NSLayoutConstraint.deactivate(constraints)
        
        let viewInfo_constraintBottom = constraints.firstIndex(where: { (constraint) -> Bool in
            constraint.identifier == "viewInfo_constraintBottom"
        })
        
        let constraintEmptyView_height = constraints.firstIndex(where: { (constraint) -> Bool in
            constraint.identifier == "constraintEmptyView_height"
        })
        
        constraints[viewInfo_constraintBottom!] = NSLayoutConstraint(item: viewInfo, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        constraints[viewInfo_constraintBottom!].identifier = "viewInfo_constraintBottom"
        
//            constraints[constraintEmptyView_height!] = NSLayoutConstraint(item: emptyView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1/9, constant: 0)
//            constraints[constraintEmptyView_height!].identifier = "constraintEmptyView_height"
        
        
        emptyView.isHidden = false
        
        NSLayoutConstraint.activate(constraints)
        
        
    }
    
    @objc private func showMusicPlayer() {
        (musicPlayerView as? MusicPlayerViewController)?.maximizePanelController(animated: true, duration: 0.5, completion: nil)
    }
    
    private func setImage(image:String) {
        if image != "" {
            UserDefaults.standard.setValue(image, forKey: "nowPlayingImage")
            
        }
        
        viewInfo.addImage(url: image)
    }
    
}

extension HomeViewController {
    
    func addCoreDataStack(coreData: CoreDataStack) {
        coreDataStack = coreData
        
        if (musicPlayerView as? MusicPlayerViewController)?.returnCoreDataStack() == nil {
            (musicPlayerView as? MusicPlayerViewController)?.addCoreDataStack(coreData: coreDataStack!)
        }
        
    }
    
    func returnCoreDataStack() -> CoreDataStack? {
        return self.coreDataStack
    }
    
    private func addToQueue(music:[Music]) {
//        coreDataStack?.doInBackground(managedContext: { [weak self] context in
//            self?.coreDataMusic?.deleteAllSong(managedContext: context, success: {
//                self?.coreDataMusic?.addAllSong(managedContext: context, musics: music, success: {
//                    print("add queue success")
//                    self?.updateSongInfo?()
//                }, failed: {
//                    print("add queue failed")
//                })
//            }, failed: {
//                print("delete queue failed")
//            })
//        })
        
        self.presenter?.addQueue(music: music)
        
    }
}

