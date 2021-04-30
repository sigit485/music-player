//
//  TabBarPlayer.swift
//  Music Player
//
//  Created by Mac on 15/04/21.
//

import UIKit

class TabBarPlayer: UIView {
    
    private let buttonClose = UIButton()
    private let buttonShowQueue = UIButton()
    private let buttonMore = UIButton()
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
    
    var closeMusicPlayer: (() -> ())? = nil
    var showQueue: (() -> ())? = nil

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        self.backgroundColor = .white
        addLayout()
        addConstraints()
    }
    
    
    private func addLayout() {
        addButtonClose()
        addButtonShowQueue()
        addButtonMore()
        addStackView()
    }
    
    private func addConstraints() {
        let views = ["contentStackView":contentStackView]
        let metrix:[String:Any] = [:]
        
        var constraints = [NSLayoutConstraint]()
        
        //MARK: contentStackView constraints
        
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        let hContentStackView = "H:|-0-[contentStackView]-0-|"
        let vContentStackView = "V:|-15-[contentStackView]-0-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hContentStackView, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vContentStackView, options: .alignAllTop, metrics: metrix, views: views)
        
        //MARK: buttonClose and buttonMore constraints
        
        buttonClose.translatesAutoresizingMaskIntoConstraints = false
        buttonMore.translatesAutoresizingMaskIntoConstraints = false
        
        constraints += [NSLayoutConstraint(item: buttonClose, attribute: .width, relatedBy: .equal, toItem: buttonClose, attribute: .height, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: buttonMore, attribute: .width, relatedBy: .equal, toItem: buttonMore, attribute: .height, multiplier: 1, constant: 0)]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func addButtonClose() {
        buttonClose.setTitleColor(.black, for: .normal)
        buttonClose.setTitle("Close", for: .normal)
        buttonClose.addTarget(self, action: #selector(doCloseMusicPlayer), for: .touchDown)
        self.addSubview(buttonClose)
    }
    
    private func addButtonShowQueue() {
        buttonShowQueue.setTitleColor(.black, for: .normal)
        buttonShowQueue.setTitle("Show Queue", for: .normal)
        buttonShowQueue.layer.cornerRadius = 5
        buttonShowQueue.layer.borderWidth = 1
        buttonShowQueue.layer.borderColor = UIColor.black.cgColor
        buttonShowQueue.addTarget(self, action: #selector(doOpenQueue), for: .touchDown)
        self.addSubview(buttonShowQueue)
    }
    
    private func addButtonMore() {
        buttonMore.setTitleColor(.black, for: .normal)
        buttonMore.setTitle("More", for: .normal)
        self.addSubview(buttonMore)
    }
    
    private func addStackView() {
        contentStackView.addArrangedSubview(buttonClose)
        contentStackView.addArrangedSubview(buttonShowQueue)
        contentStackView.addArrangedSubview(buttonMore)
        self.addSubview(contentStackView)
    }
    

}

extension TabBarPlayer {
    @objc private func doCloseMusicPlayer() {
        self.closeMusicPlayer?()
    }
    
    @objc private func doOpenQueue() {
        self.showQueue?()
    }
    
}
