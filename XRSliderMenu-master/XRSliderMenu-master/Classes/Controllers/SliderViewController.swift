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
    case un_Display // 没有显示，没有开始拖动
    case disPlaying // 显示中，拖动中
    case displayed  // 停止拖动，菜单完全显示
}

let menuDisplayedOffSet: CGFloat = 70.0 // 菜单打开后，主页(mainVc)在屏幕右侧漏出的宽度

class SliderViewController: UIViewController {

    // 主导航控制器
    var mainNavigationCtrl: RootNavigationController!
    // 主页面
    var mainVc: MainViewController!
    // 菜单页控制器
    var menuVc: MenuViewController?
    var dragFromLeftToRight: Bool = false
    var dragFromRightToLeft: Bool = false
    
    // 菜单页当前的状态
    var currentState = MenuState.un_Display {
        didSet {
            // 菜单展开，给主页面边缘添加阴影效果
            let shouldShowShadow = currentState != .un_Display
            self.addShadowWithMainVc(shouldShowShadow)
        }
    }
    
    // 给主页面边缘添加阴影
    func addShadowWithMainVc(_ isShow: Bool) {
        self.mainNavigationCtrl.view.layer.shadowColor = UIColor.black.cgColor // 阴影颜色
        self.mainNavigationCtrl.view.layer.shadowOffset = CGSize(width: -2, height: -2) // 阴影偏移量
        if isShow {
            self.mainNavigationCtrl.view.layer.shadowOpacity = 1.0 // 阴影透明度 0 - 1
        }else {
            self.mainNavigationCtrl.view.layer.shadowOpacity = 0.0
        }
    }
    
    func setupUI() {
        self.mainNavigationCtrl = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RootNavigationController") as! RootNavigationController
        self.view.addSubview(self.mainNavigationCtrl.view)
        
        self.mainVc = mainNavigationCtrl.viewControllers.first as! MainViewController
        self.mainVc.tapHeaderClosure = {(btn) -> Void in
            self.tapHeader()
        }
        
        // 拖动手势， 单击手势
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
        mainNavigationCtrl.view.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture))
        mainNavigationCtrl.view.addGestureRecognizer(tapGesture)
    }
    
    // 点击头像
    func tapHeader() {
        if currentState == .displayed {
            self.mainVcAnimated(false, completion: { (finished) -> Void in
                
            })
        }else {
            self.mainVcAnimated(true, completion: { (finished) -> Void in
                
            })
        }
    }
    
    // 拖动
    func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // 开始拖动
            // 判断拖动的方向
            self.dragFromLeftToRight = recognizer.velocity(in: self.view).x > 0
            // 刚刚拖动，这时添加侧滑菜单
            if currentState == .un_Display && self.dragFromLeftToRight {
                // 改变状态
                currentState = .disPlaying
                self.dragFromRightToLeft = false
                self.addMenuVc()
            }else if currentState != .un_Display && !self.dragFromLeftToRight {
                self.dragFromLeftToRight = false
                self.dragFromRightToLeft = true
            }
        case .changed:
            // 主视图的坐标跟随手指的移动而移动
            var posX = recognizer.view!.frame.origin.x + recognizer.translation(in: self.view).x
            let allowDragWidth = self.mainNavigationCtrl.view.frame.width - menuDisplayedOffSet
            // x等于0则不允许拖动了
            if posX < 0.0 {
                posX = 0.0
            }else if (posX > allowDragWidth) {
                posX = allowDragWidth
            }
            if self.dragFromLeftToRight {
                recognizer.view?.frame.origin.x = posX < 0 ? 0 : posX
                
                recognizer.setTranslation(CGPoint.zero, in: self.view)
            }else if self.dragFromRightToLeft {
                recognizer.view?.frame.origin.x = posX < 0 ? 0 : posX
                recognizer.setTranslation(CGPoint.zero, in: self.view)
            }
            // 计算滑动百分比
            let dragPrecent = posX / allowDragWidth
            print("\(dragPrecent)")
            if let menu = self.menuVc {
                menu.view.alpha = dragPrecent
            }
        case .ended:
            // 根据页面滑动是否过半，决定展开还是收起侧滑菜单
            if self.currentState != .un_Display {
                let hasMoveHalf = (recognizer.view?.center.x)! > self.view!.frame.width
                self.mainVcAnimated(hasMoveHalf, completion: { (finished) -> Void in
                    if finished {
                        if self.currentState == .displayed {
                            if let menu = self.menuVc {
                                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                                    menu.view.alpha = 1.0
                                })
                            }
                        }
                    }
                })
            }
        default:
            break
        }
    }
    
    // 单击
    func handleTapGesture() {
        // 点击主页面收起菜单
        if currentState == .displayed {
            self.mainVcAnimated(false, completion: { (finished) -> Void in
                
            })
        }
    }
    
    // 添加菜单页面
    func addMenuVc() {
        if menuVc == nil {
            menuVc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
            
            menuVc?.tapTableClosure = { (indexPath) -> Void in
                let walletVc = WalletViewController()
                self.navigationController?.pushViewController(walletVc, animated: true)
                // 收起菜单
                self.mainVcAnimated(false, completion: { (finished) -> Void in
                    if finished {
                        
                    }
                })
            }
            
            // 将menuVc的视图插入到当前控制器的视图层，并置顶
            self.view.insertSubview(menuVc!.view, at: 0)
            // 建立父子控制器关系
            self.addChildViewController(menuVc!)
            menuVc?.didMove(toParentViewController: self) // 子控制器加到父控制器中后被调用 （自动调用）
        }
    }
    
    // 主页面自动展开，收起动画
    func mainVcAnimated(_ isDisplay: Bool, completion: ((Bool) -> Void)?) {
        if isDisplay {
            // 更新当前菜单的状态
            if self.menuVc == nil {
                self.addMenuVc()
            }
            currentState = .displayed
            let targetDistance = self.mainNavigationCtrl.view.frame.width - menuDisplayedOffSet
            self.animatedMainVcWithPositon(targetDistance, completion: { (finished) -> Void in
                completion!(finished)
            })
        }else {
            self.animatedMainVcWithPositon(0.0, completion: { (finished) -> Void in
                // 动画结束后更新状态
                self.currentState = .un_Display
                // 移除左侧视图，释放内存
                self.menuVc!.view.removeFromSuperview()
                self.menuVc = nil
                completion!(finished)
            })
        }
    }
    
    // 主页移动动画
    func animatedMainVcWithPositon(_ targetPos: CGFloat, completion: ((_ finied: Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { [weak self]() -> Void in
            if let weakSelf = self {
                weakSelf.mainNavigationCtrl.view.frame.origin.x = targetPos
            }
            }) { (finished) -> Void in
                completion(finished)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
