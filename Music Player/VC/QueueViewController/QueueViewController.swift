//
//  QueueViewController.swift
//  Music Player
//
//  Created by Mac on 16/04/21.
//

import UIKit

class QueueViewController: UIViewController {
    
    private let tabBar = UIView()
    private let btnClose = UIButton()
    private let tableContent = UITableView()
    
    private var coreDataStack: CoreDataStack? = nil
    private var presenter: QueueViewPresenter? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        addLayout()
        addConstraints()
        
        presenter = QueueViewPresenter(view: self)
        
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
        addTabBar()
        addCloseButton()
        addTable()
    }
    
    private func addConstraints() {
        let views = ["tabBar":tabBar,"btnClose":btnClose,"tableContent":tableContent]
        let metrix:[String:Any] = [:]
        
        var constraints = [NSLayoutConstraint]()
        
        //MARK: tabBar and tableContent constraints
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tableContent.translatesAutoresizingMaskIntoConstraints = false
        
        let hTabBar = "H:|-0-[tabBar]-0-|"
        let hTableContent = "H:|-0-[tableContent]-0-|"
        let vTabBar_tableContent = "V:|-[tabBar]-0-[tableContent]-0-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hTabBar, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hTableContent, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vTabBar_tableContent, options: .alignAllLeading, metrics: metrix, views: views)
        constraints += [NSLayoutConstraint(item: tabBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)]
        
        //MARK: btnClose constraints
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        
        let hBtnClose = "H:|-10-[btnClose]"
        let vBtnClose = "V:|-0-[btnClose]-0-|"
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hBtnClose, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vBtnClose, options: .alignAllLeading, metrics: metrix, views: views)
        constraints += [NSLayoutConstraint(item: btnClose, attribute: .height, relatedBy: .equal, toItem: tabBar, attribute: .height, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: btnClose, attribute: .width, relatedBy: .equal, toItem: btnClose, attribute: .height, multiplier: 1, constant: 0)]
        
        
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func addTabBar() {
        tabBar.backgroundColor = .white
        view.addSubview(tabBar)
    }
    
    private func addCloseButton() {
        btnClose.setTitle("X", for: .normal)
        btnClose.setTitleColor(.black, for: .normal)
        btnClose.addTarget(self, action: #selector(closeQueue), for: .touchDown)
        tabBar.addSubview(btnClose)
    }
    
    private func addTable() {
        view.addSubview(tableContent)
    }
    
    

}

extension QueueViewController {
    
    @objc private func closeQueue() {
        self.dismiss(animated: true, completion: {
            
        })
    }
    
    func getTable() -> UITableView {
        return tableContent
    }
    
    func addCoreDataStack(coreData: CoreDataStack) {
        coreDataStack = coreData
    }
    
    func returnCoreDataStack() -> CoreDataStack? {
        return self.coreDataStack
    }
    
}

