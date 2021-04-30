//
//  MusicPlayerViewController.swift
//  Music Player
//
//  Created by Mac on 09/04/21.
//

import UIKit

class MusicPlayerViewController: UIViewController {
    
    
    private let progressBar = UISlider()
    private let currentTimeLabel = UILabel()
    private let durationLabel = UILabel()
    private let songDurationStackView:UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.axis = .horizontal
        stack.distribution = .fill
        return stack
    }()
    private let containerSongDuration = UIView()
    private let contentStackView:UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    private let tabBar = TabBarPlayer()
    private let nowPlayingInfo:UICollectionView = {
        
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        //flow.minimumLineSpacing = 10
        //flow.minimumInteritemSpacing = 10
        flow.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flow)
        collectionView.isPagingEnabled = true
        //collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
        collectionView.showsHorizontalScrollIndicator = false
        
        
        return collectionView
    }()
    private let titleLabel = UILabel()
    private let artistLabel = UILabel()
    private let songInfoStack:UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    private let containerSongInfo = UIView()
    private let collectionOfButton:UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let buttonNext = UIButton()
    private let buttonPrevious = UIButton()
    private let buttonPlay_pause = UIButton()
    private let buttonShuffle = UIButton()
    private let buttonRepeat = UIButton()
    
    private var presenter: MusicPlayerViewPresenterRule? = nil
    
    
    private var coreDataStack: CoreDataStack? = nil
    var doUpdate: (() ->())? = nil
    var doUpdateQueue: (() ->())? = nil
    
    private var lastSliderValue:Float = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        addLayout()
        addConstraints()
        
        presenter = MusicPlayerViewPresenter(view: self)
        
        
        closePanelController(animated: false, completion: nil)
        
        tabBar.closeMusicPlayer = {
            self.minimizePanelController(animated: true, duration: 0.5, completion: nil)
        }
        
        tabBar.showQueue = {
            let queue = QueueViewController()
            queue.modalPresentationStyle = .fullScreen
            queue.addCoreDataStack(coreData: self.coreDataStack!)
            self.view.window?.rootViewController?.present(queue, animated: true, completion: {
                
            })
        }
        
        
    }
    
    fileprivate var panelState: MusicPlayerViewControllerPanelState = .isClosed
    private var panelVisibleZoneHeight:CGFloat = 0
    private var isPanelAlreadyInitialized = false
    private var panelInitiateState: MusicPlayerViewControllerPanelIntiateState = .none
    fileprivate let fullView: CGFloat = 0
    fileprivate var partialView: CGFloat {
        return UIScreen.main.bounds.height
    }
    static var isPanelShow = false
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    private func addLayout() {
        addTabBar()
        addNowPlayingInfo()
        addTitleLabel()
        addArtistLabel()
        addCurrentTimeLabel()
        addProgressBar()
        addDurationLabel()
        addButtonShuffle()
        addButtonPrevious()
        addButtonPlay_Pause()
        addButtonNext()
        addButtonRepeat()
        addStackView()
    }
    
    private func addConstraints() {
        let views = ["contentStackView":contentStackView,"tabBar":tabBar,"songDurationStackView":songDurationStackView,"songInfoStack":songInfoStack]
        let metrix:[String:Any] = [:]
        
        var constraints = [NSLayoutConstraint]()
        
        
        //MARK: contentStackView and tabBar constraints
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        let hContentStackView = "H:|-0-[contentStackView]-0-|"
        let hTabBar = "H:|-0-[tabBar]-0-|"
        let vTabBar_ContentStackView = "V:|-0-[tabBar]-0-[contentStackView]-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hTabBar, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hContentStackView, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vTabBar_ContentStackView, options: .alignAllLeading, metrics: metrix, views: views)
        constraints += [NSLayoutConstraint(item: tabBar, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1/9, constant: 0)]
        
        //MARK: songDurationStackView constraints
        songDurationStackView.translatesAutoresizingMaskIntoConstraints = false

        let hSongDurationStackView = "H:|-0-[songDurationStackView]-0-|"
        let vSongDurationStackView = "V:|-0-[songDurationStackView]-0-|"
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hSongDurationStackView, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vSongDurationStackView, options: .alignAllLeading, metrics: metrix, views: views)

        //MARK: songInfoStack , currentTimeLabel , and durationLabel constraints
        songInfoStack.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let hSongInfoStack = "H:|-0-[songInfoStack]-0-|"
        let vSongInfoStack = "V:|-0-[songInfoStack]-0-|"
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hSongInfoStack, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vSongInfoStack, options: .alignAllLeading, metrics: metrix, views: views)
        constraints += [NSLayoutConstraint(item: currentTimeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18)]
        constraints += [NSLayoutConstraint(item: durationLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18)]

        //MARK: nowPlayingInfo , containerSongInfo , and containerSongDuration constraints
        nowPlayingInfo.translatesAutoresizingMaskIntoConstraints = false
        containerSongInfo.translatesAutoresizingMaskIntoConstraints = false
        containerSongDuration.translatesAutoresizingMaskIntoConstraints = false

        constraints += [NSLayoutConstraint(item: nowPlayingInfo, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 5/9, constant: 0)]
        constraints += [NSLayoutConstraint(item: containerSongInfo, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1/9, constant: 0)]
        constraints += [NSLayoutConstraint(item: containerSongDuration, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16)]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func addTabBar() {
        //tabBar.backgroundColor = .gray
        view.addSubview(tabBar)
    }
    
    private func addNowPlayingInfo() {
        nowPlayingInfo.backgroundColor = .white
        view.addSubview(nowPlayingInfo)
    }
    
    private func addTitleLabel() {
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        titleLabel.text = "TITLE"
    }
    
    private func addArtistLabel() {
        artistLabel.textAlignment = .center
        view.addSubview(artistLabel)
        artistLabel.text = "ARTIST"
    }
    
    private func addCurrentTimeLabel() {
        currentTimeLabel.text = "00:00:00"
        view.addSubview(currentTimeLabel)
    }
    
    private func addProgressBar() {
        progressBar.maximumValue = 1
        progressBar.minimumValue = 0
        progressBar.value = 0
        
        
        
        progressBar.addTarget(self, action: #selector(delaySeek), for: .touchDown)
        progressBar.addTarget(self, action: #selector(seek(slider:)), for: .touchUpInside)
        progressBar.addTarget(self, action: #selector(checkValue(slider:)), for: .valueChanged)
        
        view.addSubview(progressBar)
    }
    
    private func addDurationLabel() {
        durationLabel.text = "00:00:00"
        view.addSubview(durationLabel)
    }
    
    private func addButtonShuffle() {
        buttonShuffle.setTitle("Shuffle", for: .normal)
        buttonShuffle.setTitleColor(.black, for: .normal)
        view.addSubview(buttonShuffle)
    }
    
    private func addButtonPrevious() {
        buttonPrevious.setTitle("Prev", for: .normal)
        buttonPrevious.setTitleColor(.black, for: .normal)
        buttonPrevious.addTarget(self, action: #selector(movePrev), for: .touchDown)
        view.addSubview(buttonPrevious)
    }
    
    private func addButtonPlay_Pause() {
        buttonPlay_pause.setTitle("Play", for: .normal)
        buttonPlay_pause.setTitleColor(.black, for: .normal)
        
        buttonPlay_pause.addTarget(self, action: #selector(play_pause), for: .touchDown)
        
        view.addSubview(buttonPlay_pause)
    }
    
    private func addButtonNext() {
        buttonNext.setTitle("Next", for: .normal)
        buttonNext.setTitleColor(.black, for: .normal)
        buttonNext.addTarget(self, action: #selector(moveNext), for: .touchDown)
        view.addSubview(buttonNext)
    }
    
    private func addButtonRepeat() {
        buttonRepeat.setTitle("Repeat", for: .normal)
        buttonRepeat.setTitleColor(.black, for: .normal)
        view.addSubview(buttonRepeat)
    }
    
    private func addStackView(){
        collectionOfButton.addArrangedSubview(buttonShuffle)
        collectionOfButton.addArrangedSubview(buttonPrevious)
        collectionOfButton.addArrangedSubview(buttonPlay_pause)
        collectionOfButton.addArrangedSubview(buttonNext)
        collectionOfButton.addArrangedSubview(buttonRepeat)
        view.addSubview(collectionOfButton)

        songDurationStackView.addArrangedSubview(currentTimeLabel)
        songDurationStackView.addArrangedSubview(progressBar)
        songDurationStackView.addArrangedSubview(durationLabel)
        containerSongDuration.addSubview(songDurationStackView)
        view.addSubview(containerSongDuration)

        songInfoStack.addArrangedSubview(titleLabel)
        songInfoStack.addArrangedSubview(artistLabel)
        containerSongInfo.addSubview(songInfoStack)
        view.addSubview(containerSongInfo)

        contentStackView.addArrangedSubview(nowPlayingInfo)
        contentStackView.addArrangedSubview(containerSongInfo)
        contentStackView.addArrangedSubview(containerSongDuration)
        contentStackView.addArrangedSubview(collectionOfButton)
        view.addSubview(contentStackView)
        
        
    }
    

}

extension MusicPlayerViewController {
    func setDurationLabel(second: Int) {
        durationLabel.text = second.convertToSpecificFormat()
    }
    
    func setProgressLabel(second: Int) {
        currentTimeLabel.text = second.convertToSpecificFormat()
    }
}

extension MusicPlayerViewController: MusicPlayerViewControllerPanelProtocol {
    func maximizePanelController(animated: Bool, duration: Double, completion: (() -> Void)?) {
        let frame = UIScreen.main.bounds
        view.alpha = 1
        if animated {
            maximizePanelMusicPlayer_withAnimation(frame: frame, duration: duration, isFinish: { isFinished in
                guard isFinished else {
                    return
                }
                self.setPanelState(state: .isMaximize)
                completion?()
            })
            
        }
        else {
            setMaximizePanel(frame: frame)
            self.setPanelState(state: .isMaximize)
            completion?()
        }
    }
    
    func minimizePanelController(animated: Bool, duration: Double, completion: (() -> Void)?) {
        let frame = UIScreen.main.bounds
        if animated {
            minimizePanelMusicPlayer_withAnimation(frame: frame, duration: duration, isFinish: { isFinished in
                guard isFinished else {
                    return
                }
                self.setPanelState(state: .isMinimize)
                completion?()
            })
        } else {
            setMinimizePanel(frame: frame)
            self.setPanelState(state: .isMinimize)
            completion?()
        }
    }
    
    func closePanelController(animated: Bool, completion: (() -> Void)?) {
        let frame = UIScreen.main.bounds
        panelInitiateState = .closed
        view.alpha = 0
    }
    
    func initiatePanelController(animated: Bool, completion: (() -> Void)?) {
        panelInitiateState = .initiated
        minimizePanelController(animated: animated, duration: 0.3, completion: {[weak self] in
            
        })
        
        view.alpha = 1
    }
    
    func setHiddenPanelView(_ willHidden: Bool) {
        self.view.alpha = willHidden ? 0 : 1
        self.view.isHidden = willHidden
    }
    
    func getVisibilityState() -> MusicPlayerViewControllerPanelState {
        return panelState
    }
    
    
}

extension MusicPlayerViewController {
    func closePanelMusicPlayer_WithAnimation(frame:CGRect,isFinish:@escaping (Bool)->()) {
        UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.setViewClosePanel(frame:frame)
        }, completion: { isFinished in
            isFinish(isFinished)
        })
    }
    
    func setViewClosePanel(frame:CGRect) {
        print("close frame: \(frame.height - HomeViewController.minHeight)")
        self.view.frame = CGRect(x: 0, y: frame.height,
                                 width: frame.width, height: frame.height - HomeViewController.minHeight)
        self.view.layoutIfNeeded()
        print("close frame result: \(self.view.frame)")
    }
    
    func maximizePanelMusicPlayer_withAnimation(frame:CGRect,duration:Double,isFinish: @escaping (Bool)->()) {
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.setMaximizePanel(frame:frame)
        }, completion: { isFinished in
            isFinish(isFinished)
        })
    }
    
    func setMaximizePanel(frame:CGRect) {
        self.view.frame = CGRect(x: 0, y: self.fullView,
                                 width: frame.width, height: frame.height)
        self.view.layoutIfNeeded()
        print("maximize frame result: \(self.view.frame)")
    }
    
    func minimizePanelMusicPlayer_withAnimation(frame:CGRect,duration:Double,isFinish:@escaping (Bool)->()) {
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.setMinimizePanel(frame:frame)
        }, completion: { isFinished in
            isFinish(isFinished)
        })
    }
    
    func setMinimizePanel(frame:CGRect) {
        self.view.frame = CGRect(x: 0, y: self.partialView,
                                 width: frame.width, height: frame.height)
        self.view.layoutIfNeeded()
        print("minimize frame result: \(self.view.frame)")
    }
    
    func setPanelState(state: MusicPlayerViewControllerPanelState) {
        panelState = state
    }
    
    func setViewAlpha(value:CGFloat) {
        view.alpha = value
    }
}

extension MusicPlayerViewController {
    func addCoreDataStack(coreData: CoreDataStack) {
        coreDataStack = coreData
    }
    
    func returnCoreDataStack() -> CoreDataStack? {
        return self.coreDataStack
    }
    
    func getNowPlaying() ->UICollectionView {
        return nowPlayingInfo
    }
    
    func getLabelDuration() -> UILabel {
        return durationLabel
    }
    
    func getCurrentTimeLabel() -> UILabel {
        return currentTimeLabel
    }
    
    func getProgressBar() -> UISlider {
        return progressBar
    }
    
    func getButtonPlayPause() -> UIButton {
        return buttonPlay_pause
    }
    
    func setSongInfo(music:Music) {
        titleLabel.text = music.title
        artistLabel.text = music.artist
    }
    
    @objc private func moveNext() {
        self.presenter?.moveNextQueue()
    }
    
    @objc private func movePrev() {
        self.presenter?.movePrevQueue()
    }
    
    @objc private func play_pause() {
        self.presenter?.playPause()
    }
    
    func returnProgressBar() ->UISlider {
        return progressBar
    }
    
    @objc private func seek(slider: UISlider) {
        
        self.presenter?.seek(value: slider.value)
    }
    
    @objc private func delaySeek() {
        self.presenter?.pause()
    }
    
    @objc private func checkValue(slider: UISlider) {
//        if lastSliderValue < slider.value {
//            print("slider increase")
//        } else if lastSliderValue == slider.value {
//            print("slider equal")
//        } else {
//            print("slider decrease")
//        }
        
        self.presenter?.rotateWhenSeek(oldValue: lastSliderValue, newValue: slider.value)
        
        lastSliderValue = slider.value
    }
    
}

