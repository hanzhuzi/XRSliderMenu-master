//
//  SliderViewController.swift
//  XRSliderMenu-master
//
//  Created by xuran on 16/2/23.
//  Copyright © 2016年 X.R. All rights reserved.
//

/**
 *  仿QQ侧滑菜单
 *  by X.R
 */

import UIKit

enum MenuState {
    case UN_Display // 没有显示，没有开始拖动
    case DisPlaying // 显示中，拖动中
    case Displayed  // 停止拖动，菜单完全显示
}

let menuDisplayedOffSet: CGFloat = 70.0 // 菜单打开后，主页(mainVc)在屏幕右侧漏出的宽度

class SliderViewController: UIViewController {

    // 主导航控制器
    var mainNavigationCtrl: RootNavigationController!
    // 主页面
    var mainVc: MainViewController!
    // 菜单页控制器
    var menuVc: MenuViewController?
    
    // 菜单页当前的状态
    var currentState = MenuState.UN_Display {
        didSet {
            // 菜单展开，给主页面边缘添加阴影效果
            let shouldShowShadow = currentState != .UN_Display
            self.addShadowWithMainVc(shouldShowShadow)
        }
    }
    
    // 给主页面边缘添加阴影
    func addShadowWithMainVc(isShow: Bool) {
        self.mainNavigationCtrl.view.layer.shadowColor = UIColor.blackColor().CGColor // 阴影颜色
        self.mainNavigationCtrl.view.layer.shadowOffset = CGSizeMake(-2, -2) // 阴影偏移量
        if isShow {
            self.mainNavigationCtrl.view.layer.shadowOpacity = 1.0 // 阴影透明度 0 - 1
        }else {
            self.mainNavigationCtrl.view.layer.shadowOpacity = 0.0
        }
    }
    
    func setupUI() {
        self.mainNavigationCtrl = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("RootNavigationController") as! RootNavigationController
        self.view.addSubview(self.mainNavigationCtrl.view)
        
        self.mainNavigationCtrl.navigationItem.leftBarButtonItem?.action = Selector("tapHeader")
        
        self.mainVc = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        // 拖动手势， 单击手势
        let panGesture = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        mainNavigationCtrl.view.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTapGesture")
        mainNavigationCtrl.view.addGestureRecognizer(tapGesture)
    }
    
    // 点击头像
    func tapHeader() {
        if currentState == .Displayed {
            self.mainVcAnimated(false)
        }else {
            self.mainVcAnimated(true)
        }
    }
    
    // 拖动
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .Began:
            // 开始拖动
            // 判断拖动的方向
            let dragFromLeftToRight = recognizer.velocityInView(self.view).x > 0
            // 刚刚拖动，这时添加侧滑菜单
            if currentState == .UN_Display && dragFromLeftToRight {
                // 改变状态
                currentState = .DisPlaying
                self.addMenuVc()
            }else if currentState != .UN_Display && !dragFromLeftToRight {
                print("rightToLeft")
            }
        case .Changed:
            // 主视图的坐标跟随手指的移动而移动
            var posX = recognizer.view!.frame.origin.x + recognizer.translationInView(self.view).x
            // x等于0则不允许拖动了
            if posX < 0.0 {
                posX = 0.0
            }else if (posX > self.mainNavigationCtrl.view.frame.width - menuDisplayedOffSet) {
                posX = self.mainNavigationCtrl.view.frame.width - menuDisplayedOffSet
            }
            
            recognizer.view?.frame.origin.x = posX < 0 ? 0 : posX
            recognizer.setTranslation(CGPointZero, inView: self.view)
            
        case .Ended:
            // 根据页面滑动是否过半，决定展开还是收起侧滑菜单
            if self.currentState != .UN_Display {
                let hasMoveHalf = recognizer.view?.center.x > self.view!.frame.width
                self.mainVcAnimated(hasMoveHalf)
            }
        default:
            break
        }
    }
    
    // 单击
    func handleTapGesture() {
        // 点击主页面收起菜单
        if currentState == .Displayed {
            self.mainVcAnimated(false)
        }
    }
    
    // 添加菜单页面
    func addMenuVc() {
        if menuVc == nil {
            menuVc = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("MenuViewController") as? MenuViewController
            // 将menuVc的视图插入到当前控制器的视图层，并置顶
            self.view.insertSubview(menuVc!.view, atIndex: 0)
            // 建立父子控制器关系
            self.addChildViewController(menuVc!)
            menuVc?.didMoveToParentViewController(self) // 子控制器加到父控制器中后被调用 （自动调用）
        }
    }
    
    // 主页面自动展开，收起动画
    func mainVcAnimated(isDisplay: Bool) {
        if isDisplay {
            // 更新当前菜单的状态
            currentState = .Displayed
            let targetDistance = self.mainNavigationCtrl.view.frame.width - menuDisplayedOffSet
            self.animatedMainVcWithPositon(targetDistance, completion: { (finied) -> Void in
                
            })
        }else {
            self.animatedMainVcWithPositon(0.0, completion: { (finied) -> Void in
                // 动画结束后更新状态
                self.currentState = .UN_Display
                // 移除左侧视图，释放内存
                self.menuVc!.view.removeFromSuperview()
                self.menuVc = nil
            })
        }
    }
    
    // 主页移动动画
    func animatedMainVcWithPositon(targetPos: CGFloat, completion: ((finied: Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { [weak self]() -> Void in
            if let weakSelf = self {
                weakSelf.mainNavigationCtrl.view.frame.origin.x = targetPos
            }
            }) { (finished) -> Void in
                completion(finied: finished)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
