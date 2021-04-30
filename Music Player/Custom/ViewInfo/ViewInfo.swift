//
//  ViewInfo.swift
//  Music Player
//
//  Created by Mac on 15/04/21.
//

import UIKit

class ViewInfo: UIView {
    
    private let imageMusic = UIImageView(image: #imageLiteral(resourceName: "musicDefault"))
    private let songInfo = UILabel()
    private let btnPlay = UIButton()
    private let viewImageContent = UIView()
    
    let contentStackView:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 10
        stack.layoutMargins.left = 10
        stack.layoutMargins.right = 10
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addLayout()
        addConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addLayout() {
        addViewImageContent()
        addImage()
        addSongInfo()
        addButtonPlay()
        addStackView()
    }
    
    private func addConstraints() {
        let views = ["contentStackView":contentStackView,"imageMusic":imageMusic,"songInfo":songInfo,"btnPlay":btnPlay]
        let metrix:[String:Any] = [:]
        
        var constraints = [NSLayoutConstraint]()
        
        //MARK: contentStackView constraints
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let hContentStackView = "H:|-0-[contentStackView]-0-|"
        let vContentStackView = "V:|-0-[contentStackView]-0-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hContentStackView, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vContentStackView, options: .alignAllTop, metrics: metrix, views: views)
        
        
        //MARK: imageMusic constraints
        imageMusic.translatesAutoresizingMaskIntoConstraints = false
        
        let hImageMusic = "H:|-2-[imageMusic]-2-|"
        let vImageMusic = "V:|-2-[imageMusic]-2-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hImageMusic, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vImageMusic, options: .alignAllTop, metrics: metrix, views: views)
        
        
        //MARK: viewImageContent and btnPlay constraints
        viewImageContent.translatesAutoresizingMaskIntoConstraints = false
        //songInfo.translatesAutoresizingMaskIntoConstraints = false
        btnPlay.translatesAutoresizingMaskIntoConstraints = false
        
        constraints += [NSLayoutConstraint(item: viewImageContent, attribute: .width, relatedBy: .equal, toItem: viewImageContent, attribute: .height, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: btnPlay, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 2/9, constant: 0)]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func addViewImageContent() {
        viewImageContent.backgroundColor = .black
        self.addSubview(viewImageContent)
    }
    
    private func addImage() {
        imageMusic.backgroundColor = .white
        viewImageContent.addSubview(imageMusic)
    }
    
    private func addSongInfo() {
        songInfo.text = "artist - Title"
        songInfo.textColor = .black
        self.addSubview(songInfo)
    }
    
    private func addButtonPlay() {
        btnPlay.setTitle("Play", for: .normal)
        btnPlay.setTitleColor(.black, for: .normal)
        self.addSubview(btnPlay)
    }
    
    private func addStackView() {
        contentStackView.addArrangedSubview(viewImageContent)
        contentStackView.addArrangedSubview(songInfo)
        contentStackView.addArrangedSubview(btnPlay)
        self.addSubview(contentStackView)
    }
    
}

extension ViewInfo {
    func addInfo(music: Music) {
        songInfo.text = "\(music.artist) - \(music.title)"
    }
    
    func addImage(url:String) {
        if url == "" {
            imageMusic.image = #imageLiteral(resourceName: "musicDefault")
        } else {
            imageMusic.setImage(url: url)
        }
    }
    
    func getButton() -> UIButton {
        return btnPlay
    }
}
