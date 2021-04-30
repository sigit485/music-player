//
//  SubContent.swift
//  Music Player
//
//  Created by Mac on 12/04/21.
//

import UIKit

class SubContent: UIView {
    
    var controller:SubContentData? = nil
    
    private let lableTitle = UILabel()
    private var data:[Music] = []
    private var urlImage:String = ""
    var clickedSong: (([Music]) -> ())? = nil
    
    private let stackView:UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.axis = .vertical
        stack.distribution = .fill
        stack.layoutMargins.left = 10
        stack.layoutMargins.right = 10
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    private var collectionItem:UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        //flowLayout.minimumLineSpacing = 10
        //flowLayout.minimumInteritemSpacing = 10
        //flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flowLayout)

        return collection
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
        addSetup()
        controller = SubContentData(view:self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func addSetup() {
        self.backgroundColor = .white
        addLayout()
        addConstraints()
    }
    
    private func addLayout() {
        addLabelTitle()
        addCollectionView()
        addStackView()
    }
    
    private func addConstraints() {
        let views:[String:Any] = ["lableTitle":lableTitle,"addCollectionView":addCollectionView,"stackView":stackView]
        let metrix:[String:Any] = [:]
        
        var constraints = [NSLayoutConstraint]()
        
        let hStackView = "H:|-0-[stackView]-0-|"
        let vStackView = "V:|-0-[stackView]-0-|"
        
        //MARK: stackView constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hStackView, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vStackView, options: .alignAllLeading, metrics: metrix, views: views)
        
        //MARK: lableTitle constraints
        lableTitle.translatesAutoresizingMaskIntoConstraints = false
        constraints += [NSLayoutConstraint(item: lableTitle, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)]
        
        
        
        NSLayoutConstraint.activate(constraints)
        
        
    }
    
    private func addLabelTitle() {
        lableTitle.font = UIFont.boldSystemFont(ofSize: 18)
        lableTitle.textColor = .black
        lableTitle.numberOfLines = 0
        lableTitle.lineBreakMode = .byCharWrapping
        lableTitle.adjustsFontSizeToFitWidth = true
        self.addSubview(lableTitle)
    }
    
    private func addCollectionView() {
        collectionItem.backgroundColor = .white
        self.addSubview(collectionItem)
    }
    
    private func addStackView() {
        stackView.addArrangedSubview(lableTitle)
        stackView.addArrangedSubview(collectionItem)
        self.addSubview(stackView)
    }
    
    
    
}

extension SubContent {
    func setTitle(title: String) {
        lableTitle.text = title
    }
    
    func setContent(data:[Any]) {
        self.data = data as! [Music]
    }
    
    func getContent() -> [Music] {
        return self.data
    }
    
    func getCollection() -> UICollectionView {
        return collectionItem
    }
    
    func addImageUrl(url:String) {
        self.urlImage = url
    }
    
    func getImageURL() -> String {
        return urlImage
    }
    
}
