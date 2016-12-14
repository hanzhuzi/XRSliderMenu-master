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

private let maxDragPosX: CGFloat = 200.0
private let animationTime: TimeInterval = 0.3
private let scale: CGFloat = 0.3

enum SliderMenuState: Int {
    
    case begin
    case dragging
    case animating
    case open
    case close
}

class PerspectSliderMenuViewController: UIViewController, CAAnimationDelegate {
    
    var topViewCtrl: PerspectTopViewController!
    var bottomViewCtrl: PerspectBottomViewController!
    var dragFromLeftToRight: Bool = false
    var panGesViewPosX: CGFloat = 0.0
    var precent: CGFloat = 0.0
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
        topViewCtrl.tapSettingClosure = { [weak self] in
            if let weakSelf = self {
                if weakSelf.state == .open {
                    weakSelf.animateForView(isOpen: false)
                }
                else if weakSelf.state == .close {
                    weakSelf.animateForView(isOpen: true)
                }
            }
        }
        
        bottomViewCtrl = PerspectBottomViewController()
        bottomViewCtrl.tapCloseBtnClosure = { [weak self] in
            if let weakSelf = self {
                if weakSelf.state == .open {
                    weakSelf.animateForView(isOpen: false)
                }
                else if weakSelf.state == .close {
                    weakSelf.animateForView(isOpen: true)
                }
            }
        }
        self.addChildViewCtrlToParant(viewCtrl: bottomViewCtrl)
        self.addChildViewCtrlToParant(viewCtrl: topViewCtrl)
        
        var topTransform = CGAffineTransform(scaleX: 1.0 - scale, y: 1.0 - scale)
        topTransform = topTransform.translatedBy(x: maxDragPosX, y: 0)
        let tempView = UIView(frame: topViewCtrl.view.frame)
        tempView.transform = topTransform
        bottomViewCtrl.widthForTable = tempView.frame.origin.x
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        let bgImageView = UIImageView(image: UIImage(named: "bg.jpeg"))
        bgImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(bgImageView)
        
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
            else if posX > maxDragPosX {
                posX = maxDragPosX
            }
            
            if self.dragFromLeftToRight {
                panGesViewPosX = posX < 0 ? 0 : posX
                panGes.setTranslation(CGPoint.zero, in: self.view)
            }else {
                panGesViewPosX = posX < 0 ? 0 : posX
                panGes.setTranslation(CGPoint.zero, in: self.view)
            }
            
            precent = posX / maxDragPosX
            if precent >= 1.0 {
                state = .open
            }
            else if precent == 0.0 {
                state = .close
            }
            debugPrint("posX: \(posX)  precent: \(precent)")
            self.interactiveProgressForView(precent: precent)
        case .ended, .cancelled:
            if precent == 1.0 {
                return
            }
            else {
                if state == .animating || state == .close || state == .open {
                    return
                }
                if precent > 0.5 {
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
    func interactiveProgressForView(precent: CGFloat) {
        
        var topTransform = CGAffineTransform(scaleX: 1.0 - (scale * precent), y: 1.0 - (scale * precent))
        topTransform = topTransform.translatedBy(x: maxDragPosX  * precent, y: 0)
        self.topViewCtrl.view.transform = topTransform
        
        let bottomTransform = CGAffineTransform(scaleX: (1.0 - scale) * precent + scale, y: (1.0 - scale) * precent + scale)
        self.bottomViewCtrl.view.transform = bottomTransform
    }
    
    /**
     - 动画打开/关闭侧滑菜单
     */
    func animateForView(isOpen: Bool) {
        
        state = .animating
        let topToTransform = CGAffineTransform(scaleX: 1.0 - scale, y: 1.0 - scale).translatedBy(x: maxDragPosX, y: 0)
        let bottomToTransform = CGAffineTransform(scaleX: scale, y: scale)
        
        if isOpen {
            UIView.animate(withDuration: animationTime * TimeInterval(1.0 - precent + 0.5),
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
                        weakSelf.precent = 1.0
                        weakSelf.panGesViewPosX = maxDragPosX
                    }
            })
        }
        else {
            UIView.animate(withDuration: animationTime * TimeInterval(precent + 0.5),
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
                        weakSelf.precent = 0.0
                        weakSelf.panGesViewPosX = 0.0
                    }
            })
        }
    }
    
    
}



