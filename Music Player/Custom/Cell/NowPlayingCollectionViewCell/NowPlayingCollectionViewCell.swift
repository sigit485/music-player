//
//  NowPlayingCollectionViewCell.swift
//  Music Player
//
//  Created by Mac on 22/04/21.
//

import UIKit

class NowPlayingCollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let circleInside = UIView()
    var doRotate: ((Float) -> ())? = nil
    var in_rotateImage: (() -> ())? = nil
    private var count:Double = 0.0
    var reset_rotation: (() -> ())? = nil
    var doPrepareRotate: (() ->())? = nil
    var doRotateEnd: (() ->())? = nil
    var rotateWhenSeek: ((Int) ->())? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        //addImage()
        addLayout()
        addConstraints()
        setToCircle()
        setEmpryHoleToCircle()
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(rotateImage))
        rotate.delegate = self
        
        //let touch = UIGestureRecognizer(target: self, action: #selector(imageTouch))
        
        //imageView.addGestureRecognizer(touch)
        imageView.addGestureRecognizer(rotate)
        imageView.isUserInteractionEnabled = true
        
        in_rotateImage = { [weak self] in
            
            let rotation = CGAffineTransform(rotationAngle: CGFloat(self!.count))
            
            self?.imageView.transform = rotation
            
            self?.count = self!.count + 0.014
        }
        
        reset_rotation = { [weak self] in
            let rotation = CGAffineTransform(rotationAngle: CGFloat((self!.count * -1)))
            
            self?.imageView.transform = rotation
            
            self?.count = 0
        }
        
        rotateWhenSeek = { [weak self] status in
            if status == -1 {
                let rotation = CGAffineTransform(rotationAngle: CGFloat(self!.count))
                
                self?.imageView.transform = rotation
                
                self?.count = self!.count - 0.014
            } else if status == 1 {
                let rotation = CGAffineTransform(rotationAngle: CGFloat(self!.count))
                
                self?.imageView.transform = rotation
                
                self?.count = self!.count + 0.014
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addLayout() {
        addImage()
        //createEmptyHole()
    }
    
    private func addConstraints() {
        let views = ["imageView":imageView,"circleInside":circleInside]
        let metrix:[String:Any] = [:]
        
        var constraints = [NSLayoutConstraint]()
        
        //MARK: imageView constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let hImageView = "H:|-20-[imageView]-20-|"
        let vImageView = "V:|-20-[imageView]-20-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hImageView, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vImageView, options: .alignAllLeading, metrics: metrix, views: views)
        
        //MARK: circleInside constraints
//        circleInside.translatesAutoresizingMaskIntoConstraints = false
//        let hCircleInside = "H:|-99-[circleInside]-99-|"
//        let vCircleInside = "V:|-100-[circleInside]-100-|"
//
//        constraints += NSLayoutConstraint.constraints(withVisualFormat: hCircleInside, options: .alignAllTop, metrics: metrix, views: views)
//        constraints += NSLayoutConstraint.constraints(withVisualFormat: vCircleInside, options: .alignAllLeading, metrics: metrix, views: views)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func addImage() {
        imageView.image = #imageLiteral(resourceName: "musicDefault")
        self.contentView.addSubview(imageView)
    }
    
    private func setToCircle() {
        imageView.layoutIfNeeded()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        
        
        
        createEmptyHole()
    }
    
    private func createEmptyHole() {
        
        let circlePath_inner1 = UIBezierPath(arcCenter: CGPoint(x: imageView.bounds.width / 2, y: imageView.bounds.width / 2), radius: CGFloat(imageView.bounds.width / 8), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        let circlePath_inner2 = UIBezierPath(arcCenter: CGPoint(x: imageView.bounds.width / 2, y: imageView.bounds.width / 2), radius: CGFloat(imageView.bounds.width / 16), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        let circlePath_core = UIBezierPath(arcCenter: CGPoint(x: imageView.bounds.width / 2, y: imageView.bounds.width / 2), radius: CGFloat(imageView.bounds.width / 30), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        
        let shapeLayer_core = CAShapeLayer()
        shapeLayer_core.path = circlePath_core.cgPath
        shapeLayer_core.fillColor = UIColor.white.cgColor
        shapeLayer_core.strokeColor = UIColor.clear.cgColor
        shapeLayer_core.lineWidth = 1
        
        let shapeLayer_inner2 = CAShapeLayer()
        shapeLayer_inner2.path = circlePath_inner2.cgPath
        shapeLayer_inner2.fillColor = UIColor.clear.cgColor
        shapeLayer_inner2.strokeColor = UIColor.white.cgColor
        shapeLayer_inner2.lineWidth = 1
        shapeLayer_inner2.addSublayer(shapeLayer_core)
        
        let shapeLayer_inner1 = CAShapeLayer()
        shapeLayer_inner1.path = circlePath_inner1.cgPath
        shapeLayer_inner1.fillColor = UIColor.clear.cgColor
        shapeLayer_inner1.strokeColor = UIColor.white.cgColor
        shapeLayer_inner1.lineWidth = 1
        shapeLayer_inner1.addSublayer(shapeLayer_inner2)
        
        
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: imageView.bounds.width / 2, y: imageView.bounds.width / 2), radius: CGFloat(imageView.bounds.width / 6), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
            
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
            
        // Change the fill color
        shapeLayer.fillColor = UIColor.black.cgColor
        // You can change the stroke color
        shapeLayer.strokeColor = UIColor.white.cgColor
        // You can change the line width
        shapeLayer.lineWidth = 3.0
        shapeLayer.addSublayer(shapeLayer_inner1)
        imageView.layer.addSublayer(shapeLayer)
    }
    
    private func setEmpryHoleToCircle() {
        circleInside.layoutIfNeeded()
        circleInside.clipsToBounds = true
        circleInside.layer.cornerRadius = circleInside.bounds.width / 2
    }
    
}

extension NowPlayingCollectionViewCell {
    
    func returnImageView() ->UIImageView {
        return imageView
    }
    
    func setImage(image:String) {
        imageView.setImage(url: image)
    }
}

extension NowPlayingCollectionViewCell {
    
    @objc private func imageTouch() {
        
    }
    
    @objc private func rotateImage(gesture: UIRotationGestureRecognizer) {
        
        
        if gesture.state == .began {
            print("rotation - began")
            doPrepareRotate?()
            
        } else if gesture.state == .changed {
            let rotate = (gesture.view?.transform)!.rotated(by: gesture.rotation)
            //print("rotation - gesture.rotation: \(gesture.rotation)")
            let aGesture = gesture.rotation
            gesture.view?.transform = rotate
            gesture.rotation = 0
            //print("transform: \(rotate)")
    //        print("rotation - degree: \(degrees)")
            
            
            if aGesture != 0 {
                if aGesture.sign == .minus {
                    print("rotation - kiri")
                    doRotate?(-0.01)
                } else {
                    print("rotation - kanan")
                    doRotate?(0.01)
                }
            }
        } else if gesture.state == .ended {
            print("rotation - ended")
            doRotateEnd?()
        }
        
        
        
    }
    
}

extension NowPlayingCollectionViewCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
