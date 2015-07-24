//
//  DKImageBrowserVC.swift
//  DKImageBrowserVC
//
//  Created by ZhangAo on 15/7/20.
//  Copyright (c) 2015年 ZhangAo. All rights reserved.
//

import UIKit

class DKImageBrowserVC: UIViewController, UIScrollViewDelegate {

    private let mainScrollView = UIScrollView()
    private var previousIndex: Int = 0
    var images: Array<String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.mainScrollView)
        self.mainScrollView.backgroundColor = UIColor.blackColor()
        self.mainScrollView.showsHorizontalScrollIndicator = false
        self.mainScrollView.canCancelContentTouches = true
        self.mainScrollView.pagingEnabled = true
        self.mainScrollView.delegate = self
        
        self.images = [
            "http://g.hiphotos.baidu.com/image/pic/item/2e2eb9389b504fc2fbd4d192e6dde71191ef6d99.jpg",
            "http://g.hiphotos.baidu.com/image/pic/item/0d338744ebf81a4cffc545a8d52a6059242da6d8.jpg",
            "http://e.hiphotos.baidu.com/image/pic/item/48540923dd54564e8e86542db1de9c82d0584fc6.jpg",
            "http://e.hiphotos.baidu.com/image/pic/item/aa64034f78f0f736335d21960955b319eac41381.jpg"
        ]
        
        for (index, url) in enumerate(self.images) {
            self.createPageForURL(NSURL(string: url)!, forIndex: index)
        }
        
        self.mainScrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[mainScrollView(==parentView)]-0-|",
            options: .DirectionLeadingToTrailing,
            metrics: nil,
            views: [
                "mainScrollView" : self.mainScrollView,
                "parentView" : self.view
            ]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[mainScrollView(==parentView)]-0-|",
            options: .DirectionLeadingToTrailing,
            metrics: nil,
            views: [
                "mainScrollView" : self.mainScrollView,
                "parentView" : self.view
            ]))
        
        let lastSubview = self.mainScrollView.subviews.last
        self.mainScrollView.addConstraint(NSLayoutConstraint(item: lastSubview!,
            attribute: .Trailing,
            relatedBy: .Equal,
            toItem: self.mainScrollView,
            attribute: .Trailing,
            multiplier: 1,
            constant: 0))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createPageForURL(url: NSURL, forIndex index: NSInteger) {
        let pageScrollView = UIScrollView()
        pageScrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        pageScrollView.maximumZoomScale = 2
        pageScrollView.showsHorizontalScrollIndicator = false
        pageScrollView.showsVerticalScrollIndicator = false
        pageScrollView.delegate = self
        self.mainScrollView.addSubview(pageScrollView)
        
        let imageView = UIImageView()
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        pageScrollView.addSubview(imageView)
        imageView.sd_setImageWithURL(url)
        
        var views: [String : UIView] = [
            "pageScrollView" : pageScrollView,
            "parentView" : self.mainScrollView,
            "imageView" : imageView
        ]
        
        pageScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[imageView(==pageScrollView)]-0-|",
            options: .DirectionLeadingToTrailing,
            metrics: nil,
            views: views))
        pageScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[imageView(==pageScrollView)]-0-|",
            options: .DirectionLeadingToTrailing,
            metrics: nil,
            views: views))
        
        self.mainScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[pageScrollView(==parentView)]|",
            options: .DirectionLeadingToTrailing,
            metrics: nil,
            views: views))
        
        var format: String
        if index == 0 {
            format = "H:|-0-[pageScrollView(==parentView)]"
        } else {
            format = "H:[previousView]-0-[pageScrollView(==parentView)]"
            views["previousView"] = self.mainScrollView.subviews[index - 1] as? UIView
        }
        self.mainScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format,
            options: .DirectionLeadingToTrailing,
            metrics: nil,
            views: views))
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews.first as? UIView
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView == self.mainScrollView {
            var currentIndex = Int(scrollView.contentOffset.x) / Int(scrollView.bounds.width)
            if currentIndex != self.previousIndex {
                let pageScrollView = scrollView.subviews[self.previousIndex] as! UIScrollView
                self.previousIndex = currentIndex
                pageScrollView.zoomScale = 1
            }
        }
    }

}
