//
//  ScaleMenuViewController.swift
//  XRSliderMenu-master
//
//  Created by xuran on 16/12/9.
//  Copyright © 2016年 X.R. All rights reserved.
//

import UIKit

class ScaleMenuViewController: UIViewController {
    
    var mainViewCtrl: MainViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.red
        mainViewCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
        self.view.addSubview(mainViewCtrl!.view)
        self.addChildViewController(mainViewCtrl!)
        mainViewCtrl?.didMove(toParentViewController: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        UIView.animate(withDuration: 5.0) { [weak self] in
//            if let weakSelf = self {
//                let trans = CGAffineTransform(translationX: 200.0, y: 0.0)
//                let concatTrans = trans.concatenating(CGAffineTransform(scaleX: 0.6, y: 0.6))
//                
//                weakSelf.mainViewCtrl?.view.transform = concatTrans
//            }
//        }
        self.mainViewCtrl!.view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let rotate = CATransform3DMakeRotation(-CGFloat(M_PI / 20.0), 0, 1, 0)
        let scale = CATransform3DMakeScale(0.7, 0.7, 1.0)
        let translate = CATransform3DMakeTranslation(self.view.frame.width * 0.3, 0, 0)
        var concat = CATransform3DConcat(rotate, scale)
        concat = CATransform3DConcat(translate, concat)
        
        let basicAnima = CABasicAnimation(keyPath: "transform")
        basicAnima.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        basicAnima.toValue = NSValue(caTransform3D: CATransform3D.makePerspectTransform3D(t: concat, center: CGPoint(x: 0, y: 0), distence: 300))
        basicAnima.duration = 5.0
        basicAnima.isRemovedOnCompletion = false
        basicAnima.fillMode = kCAFillModeForwards
        basicAnima.repeatCount = 100
        basicAnima.autoreverses = true
        self.mainViewCtrl!.view.layer.add(basicAnima, forKey: "basicAnimation")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
