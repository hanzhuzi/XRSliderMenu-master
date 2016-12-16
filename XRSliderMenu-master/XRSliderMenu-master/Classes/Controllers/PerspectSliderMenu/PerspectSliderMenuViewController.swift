//
//  PerspectSliderMenuViewController.swift
//  XRSliderMenu-master
//
//  Created by xuran on 16/12/9.
//  Copyright © 2016年 X.R. All rights reserved.
//

/**
 - 仿酷狗音乐抽屉侧滑菜单效果
 -
 - by  黯丶野火
 */

import UIKit

private let maxDragPostionXOffset: CGFloat = 200.0
private let animationTime: TimeInterval = 0.3
private let dragPostionOffsetToLeftPercent: CGFloat = 0.5
private let scale: CGFloat = 0.3

enum SliderMenuState: Int {
    
    case begin
    case dragging
    case animating
    case open
    case close
}

class PerspectSliderMenuViewController: UIViewController , PerspectTopViewControllerDelegate, PerspectBottomViewControllerDelegate {
    
    var topViewCtrl: PerspectTopViewController!
    var bottomViewCtrl: PerspectBottomViewController!
    var dragFromLeftToRight: Bool = false
    var panGesViewPosX: CGFloat = 0.0
    var percent: CGFloat = 0.0
    var state: SliderMenuState = .begin
    
    func addChildViewCtrlToParant(viewCtrl: UIViewController) {
        
        if !self.childViewControllers.contains(viewCtrl) {
            viewCtrl.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(viewCtrl.view)
            self.addChildViewController(viewCtrl)
            viewCtrl.didMove(toParentViewController: self)
        }
    }
    
    func setupViewCtrollers() {
        
        topViewCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PerspectTopViewController") as! PerspectTopViewController
        topViewCtrl.delegate = self
        
        bottomViewCtrl = PerspectBottomViewController()
        bottomViewCtrl.delegate = self
        
        self.addChildViewCtrlToParant(viewCtrl: bottomViewCtrl)
        self.addChildViewCtrlToParant(viewCtrl: topViewCtrl)
        
        var topTransform = CGAffineTransform(scaleX: 1.0 - scale, y: 1.0 - scale)
        topTransform = topTransform.concatenating(CGAffineTransform(translationX: maxDragPostionXOffset, y: 0.0))
        let tempView = UIView(frame: topViewCtrl.view.frame)
        tempView.transform = topTransform
        bottomViewCtrl.widthForTable = tempView.frame.origin.x
    }
    
    func setup() {
        
        let bgImageView = UIImageView(image: UIImage(named: "bg.jpeg"))
        bgImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(bgImageView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.setup()
        self.setupViewCtrollers()
        self.addPanGesture()
        self.bottomViewCtrl.view.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addPanGesture() {
        
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(self.panHanler(panGes:)))
        self.view.addGestureRecognizer(panGes)
    }
    
    func panHanler(panGes: UIPanGestureRecognizer) {
        
        if state == .animating {
            return
        }
        
        switch panGes.state {
        case .began:
            let veloc = panGes.velocity(in: self.view)
            dragFromLeftToRight = veloc.x > 0
            state = .begin
        case .changed:
            state = .dragging
            var posX = panGesViewPosX + panGes.translation(in: self.view).x
            if posX < 0 {
                posX = 0.0
            }
            else if posX > maxDragPostionXOffset {
                posX = maxDragPostionXOffset
            }
            
            if self.dragFromLeftToRight {
                panGesViewPosX = posX < 0 ? 0 : posX
                panGes.setTranslation(CGPoint.zero, in: self.view)
            }else {
                panGesViewPosX = posX < 0 ? 0 : posX
                panGes.setTranslation(CGPoint.zero, in: self.view)
            }
            
            percent = posX / maxDragPostionXOffset
            if percent >= 1.0 {
                state = .open
            }
            else if percent == 0.0 {
                state = .close
            }
            self.interactiveProgressForView(percent: percent)
        case .ended, .cancelled:
            if percent == 1.0 {
                return
            }
            else {
                if state == .animating || state == .close || state == .open {
                    return
                }
                if percent > dragPostionOffsetToLeftPercent {
                    // 展开
                    self.animateForView(isOpen: true)
                }
                else {
                    // 收回
                    self.animateForView(isOpen: false)
                }
            }
            break
        default:
            break
        }
    }
    
    /**
     - 驱动手势打开/关闭侧滑菜单
     */
    func interactiveProgressForView(percent: CGFloat) {
        
        var topTransform = CGAffineTransform(scaleX: 1.0 - (scale * percent), y: 1.0 - (scale * percent))
        topTransform = topTransform.concatenating(CGAffineTransform(translationX: maxDragPostionXOffset  * percent, y: 0.0))
        self.topViewCtrl.view.transform = topTransform
        
        let bottomTransform = CGAffineTransform(scaleX: (1.0 - scale) * percent + scale, y: (1.0 - scale) * percent + scale)
        self.bottomViewCtrl.view.transform = bottomTransform
    }
    
    /**
     - 动画打开/关闭侧滑菜单
     */
    func animateForView(isOpen: Bool) {
        
        state = .animating
        let scaleTransform = CGAffineTransform(scaleX: 1.0 - scale, y: 1.0 - scale)
        let translateTransform = CGAffineTransform(translationX: maxDragPostionXOffset, y: 0.0)
        let topToTransform = scaleTransform.concatenating(translateTransform)
        let bottomToTransform = CGAffineTransform(scaleX: scale, y: scale)
        
        let openTime = (1.0 - percent) + 0.5
        let closeTime = percent + 0.5
        
        if isOpen {
            UIView.animate(withDuration: animationTime * TimeInterval(openTime),
                           delay: 0.0,
                           options: .curveEaseInOut,
                           animations: { [weak self] in
                            if let weakSelf = self {
                                weakSelf.topViewCtrl.view.transform = topToTransform
                                weakSelf.bottomViewCtrl.view.transform = CGAffineTransform.identity
                            }
                }, completion: { [weak self](flag) in
                    if let weakSelf = self {
                        weakSelf.state = .open
                        weakSelf.percent = 1.0
                        weakSelf.panGesViewPosX = maxDragPostionXOffset
                    }
            })
        }
        else {
            UIView.animate(withDuration: animationTime * TimeInterval(closeTime),
                           delay: 0.0,
                           options: .curveEaseInOut,
                           animations: { [weak self] in
                            if let weakSelf = self {
                                weakSelf.topViewCtrl.view.transform = CGAffineTransform.identity
                                weakSelf.bottomViewCtrl.view.transform = bottomToTransform
                            }
                }, completion: { [weak self](flag) in
                    if let weakSelf = self {
                        weakSelf.state = .close
                        weakSelf.percent = 0.0
                        weakSelf.panGesViewPosX = 0.0
                    }
            })
        }
    }
    
    // MARK: - PerspectTopViewControllerDelegate
    func didTapSettingItem() {
        
        if self.state == .open {
            self.animateForView(isOpen: false)
        }
        else if self.state == .close || self.state == .begin {
            self.animateForView(isOpen: true)
        }
    }
    
    func didTapViewControllerAnywhere() {
        
        if self.state == .open {
            self.animateForView(isOpen: false)
        }
    }
    
    // MARK: - PerspectBottomViewControllerDelegate
    func didTapCloseItem() {
        
        if self.state == .open {
            self.animateForView(isOpen: false)
        }
    }
}



