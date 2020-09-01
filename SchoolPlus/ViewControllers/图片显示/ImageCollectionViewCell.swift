//
//  ImageCollectionViewCell.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/22.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "Cell"
    var scrollView:UIScrollView!
    var imageView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        scrollView = UIScrollView(frame: self.contentView.bounds)
        self.contentView.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        
        imageView = UIImageView()
        imageView.frame = scrollView.bounds
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        
        let tapSingle=UITapGestureRecognizer(target:self,
                                             action:#selector(tapSingleDid))
        tapSingle.numberOfTapsRequired = 1
        tapSingle.numberOfTouchesRequired = 1
        self.imageView.addGestureRecognizer(tapSingle)
    }
    
    func scaleSize(size:CGSize) -> CGSize {
           let width = size.width
           let height = size.height
           let widthRatio = width/UIScreen.main.bounds.width
           let heightRatio = height/UIScreen.main.bounds.height
           let ratio = max(heightRatio, widthRatio)
           return CGSize(width: width/ratio, height: height/ratio)
        
    }
    
    func resetSize(){
        //scrollView重置，不缩放
        scrollView.frame = self.contentView.bounds
        scrollView.zoomScale = 1.0
        //imageView重置
        if let image = self.imageView.image {
            //设置imageView的尺寸确保一屏能显示的下
            imageView.frame.size = scaleSize(size: image.size)
            //imageView居中
            imageView.center = scrollView.center
        }
    }
     
    //视图布局改变时（横竖屏切换时cell尺寸也会变化）
    override func layoutSubviews() {
        super.layoutSubviews()
        //重置单元格内元素尺寸
        resetSize()
    }
    
    @objc func tapSingleDid(_ ges:UITapGestureRecognizer){
        if let nav = self.responderViewController()?.navigationController {
            nav.popViewController(animated: true)
        }
    }
    
    func responderViewController() -> UIViewController? {
          for view in sequence(first: self.superview, next: { $0?.superview }) {
              if let responder = view?.next {
                  if responder.isKind(of: UIViewController.self){
                      return responder as? UIViewController
                  }
              }
          }
          return nil
      }
}

extension ImageCollectionViewCell:UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
     
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var centerX = scrollView.center.x
        var centerY = scrollView.center.y
        centerX = scrollView.contentSize.width > scrollView.frame.size.width ?
            scrollView.contentSize.width/2:centerX
        centerY = scrollView.contentSize.height > scrollView.frame.size.height ?
            scrollView.contentSize.height/2:centerY
        print(centerX,centerY)
        imageView.center = CGPoint(x: centerX, y: centerY)
    }
}
