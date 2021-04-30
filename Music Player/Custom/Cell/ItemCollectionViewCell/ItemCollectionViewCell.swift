//
//  ItemCollectionViewCell.swift
//  Music Player
//
//  Created by Mac on 13/04/21.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    private let lblTitle = UILabel()
    private let lblArtist = UILabel()
    private let imageArtist = UIImageView() //note: default icon by <div>Icons made by <a href="https://www.flaticon.com/authors/pixel-perfect" title="Pixel perfect">Pixel perfect</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
    private let viewInfo = UIView()
    private let stackViewContent:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    private let stackViewInfo:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        addLayout()
        addConstraints()
    }
    
    private func setupCell() {
        self.backgroundColor = .black
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
    }
    
    private func addLayout() {
        addImage()
        addViewInfo()
        addTitle()
        addArtist()
        addStackView()
    }
    
    private func addConstraints() {
        let views = ["stackViewContent":stackViewContent,"imageArtist":imageArtist,"viewInfo":viewInfo,"stackViewInfo":stackViewInfo]
        let metrix:[String:Any] = [:]
        
        var constraints = [NSLayoutConstraint]()
        
        //MARK: stackViewContent constraints
        stackViewContent.translatesAutoresizingMaskIntoConstraints = false
        let hStackViewContent = "H:|-1-[stackViewContent]-1-|"
        let vStackViewContent = "V:|-1-[stackViewContent]-1-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hStackViewContent, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vStackViewContent, options: .alignAllLeading, metrics: metrix, views: views)
        
        //MARK: imageArtist and viewInfo constraints
        imageArtist.translatesAutoresizingMaskIntoConstraints = false
        viewInfo.translatesAutoresizingMaskIntoConstraints = false
        
        constraints += [NSLayoutConstraint(item: imageArtist, attribute: .height, relatedBy: .equal, toItem: viewInfo, attribute: .height, multiplier: 5/3, constant: 0)]
        
        //MARK: stackViewInfo constraints
        stackViewInfo.translatesAutoresizingMaskIntoConstraints = false
        let hStackViewInfo = "H:|-10-[stackViewInfo]-10-|"
        let vStackViewInfo = "V:|-10-[stackViewInfo]-10-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hStackViewInfo, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vStackViewInfo, options: .alignAllLeading, metrics: metrix, views: views)
        
        //MARK: lblTitle and lblArtist constraints
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblArtist.translatesAutoresizingMaskIntoConstraints = false
        
        constraints += [NSLayoutConstraint(item: lblTitle, attribute: .height, relatedBy: .equal, toItem: lblArtist, attribute: .height, multiplier: 5/3, constant: 0)]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func addImage() {
        imageArtist.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1)
        contentView.addSubview(imageArtist)
    }
    
    private func addViewInfo() {
        viewInfo.backgroundColor = .white
        contentView.addSubview(viewInfo)
    }
    
    private func addTitle() {
        lblTitle.font = UIFont.boldSystemFont(ofSize: 20)
        lblTitle.numberOfLines = 0
        lblTitle.lineBreakMode = .byTruncatingTail
        lblTitle.adjustsFontSizeToFitWidth = true
        viewInfo.addSubview(lblTitle)
    }
    
    private func addArtist() {
        lblArtist.font = UIFont.boldSystemFont(ofSize: 18)
        lblArtist.numberOfLines = 0
        lblArtist.lineBreakMode = .byTruncatingTail
        lblArtist.adjustsFontSizeToFitWidth = true
        viewInfo.addSubview(lblArtist)
    }
    
    private func addStackView() {
        stackViewInfo.addArrangedSubview(lblTitle)
        stackViewInfo.addArrangedSubview(lblArtist)
        viewInfo.addSubview(stackViewInfo)
        
        stackViewContent.addArrangedSubview(imageArtist)
        stackViewContent.addArrangedSubview(viewInfo)
        contentView.addSubview(stackViewContent)
        
    }
    
    
    
}
extension ItemCollectionViewCell {
    func addData(music:Music,image:UIImage? = nil) {
        lblArtist.text = music.artist
        lblTitle.text = music.title
        
        if let pic = image {
            imageArtist.image = pic
        } else {
            imageArtist.image = #imageLiteral(resourceName: "musicDefault")
        }
        
        
    }
    
    func returnImageArtist_Property() -> UIImageView {
        return imageArtist
    }
    
    func setImage(url:String) {
        imageArtist.setImage(url: url)
    }
}
