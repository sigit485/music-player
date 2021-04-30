//
//  QueueTableViewCell.swift
//  Music Player
//
//  Created by Mac on 21/04/21.
//

import UIKit

class QueueTableViewCell: UITableViewCell {
    
    let labelTitle = UILabel()
    let labelArtist = UILabel()
    private let stackViewContent:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setup() {
        self.backgroundColor = .white
        addLayout()
        addConstraints()
    }
    
    private func addLayout() {
        addLabelTitle()
        addLabelArtist()
        addStackView()
    }
    
    private func addConstraints() {
        let views = ["stackViewContent":stackViewContent]
        let metrix:[String:Any] = [:]
        
        var constraints = [NSLayoutConstraint]()
        
        //MARK: stackViewContent constraints
        
        stackViewContent.translatesAutoresizingMaskIntoConstraints = false
        
        let hStackViewContent = "H:|-5-[stackViewContent]-5-|"
        let vStackViewContent = "V:|-0-[stackViewContent]-0-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hStackViewContent, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vStackViewContent, options: .alignAllLeading, metrics: metrix, views: views)
        
        //MARK: labelTitle and labelArtist constraints
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelArtist.translatesAutoresizingMaskIntoConstraints = false
        
        constraints += [NSLayoutConstraint(item: labelTitle, attribute: .height, relatedBy: .equal, toItem: labelArtist, attribute: .height, multiplier: 5/3, constant: 0)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func addLabelTitle() {
        labelTitle.text = "Title"
        labelTitle.textColor = .black
        self.contentView.addSubview(labelTitle)
    }
    
    private func addLabelArtist() {
        labelArtist.text = "Artist"
        labelArtist.textColor = .darkGray
        self.contentView.addSubview(labelArtist)
    }
    
    private func addStackView() {
        stackViewContent.addArrangedSubview(labelTitle)
        stackViewContent.addArrangedSubview(labelArtist)
        self.contentView.addSubview(stackViewContent)
    }

}

extension QueueTableViewCell {
    func setData(music:Music) {
        labelArtist.text = music.artist
        labelTitle.text = music.title
    }
}
