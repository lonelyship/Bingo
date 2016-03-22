//
//  ViewController_Home.swift
//  UICollectionView
//
//  Created by 1500007 on 2015/2/4.
//  Copyright (c) 2015年 Brian Coleman. All rights reserved.
//

import UIKit

class ViewController_Home: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func goNextPageSizeThree(sender: AnyObject) {
        SStaticData.Holder.gameSize=3;
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let gameView = storyboard.instantiateViewControllerWithIdentifier("gamePage") as UIViewController
        gameView.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(gameView, animated: true, completion:nil)
    }
    
    @IBAction func goNextPageSizeFour(sender: AnyObject) {
        SStaticData.Holder.gameSize=4;
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let gameView = storyboard.instantiateViewControllerWithIdentifier("gamePage") as UIViewController
        gameView.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(gameView, animated: true, completion:nil)
    }

    @IBAction func goNextPageSizeFive(sender: AnyObject) {
        SStaticData.Holder.gameSize=5;
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let gameView = storyboard.instantiateViewControllerWithIdentifier("gamePage") as UIViewController
        gameView.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(gameView, animated: true, completion:nil)
    }

    @IBAction func goNextPageSizeSix(sender: AnyObject) {
        SStaticData.Holder.gameSize=6;
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let gameView = storyboard.instantiateViewControllerWithIdentifier("gamePage") as UIViewController
        gameView.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(gameView, animated: true, completion:nil)
    }

    @IBAction func goNextPageSizeSeven(sender: AnyObject) {
        SStaticData.Holder.gameSize=7;
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let gameView = storyboard.instantiateViewControllerWithIdentifier("gamePage") as UIViewController
        gameView.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(gameView, animated: true, completion:nil)
    }

    @IBAction func goNextPageSizeEight(sender: AnyObject) {
        SStaticData.Holder.gameSize=8;
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let gameView = storyboard.instantiateViewControllerWithIdentifier("gamePage") as UIViewController
        gameView.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(gameView, animated: true, completion:nil)
    }

    @IBAction func goNextPageSizeNine(sender: AnyObject) {
        SStaticData.Holder.gameSize=9;
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let gameView = storyboard.instantiateViewControllerWithIdentifier("gamePage") as UIViewController
        gameView.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(gameView, animated: true, completion:nil)
    }

    @IBAction func goNextPageSizeTen(sender: AnyObject) {
        SStaticData.Holder.gameSize=10;
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let gameView = storyboard.instantiateViewControllerWithIdentifier("gamePage") as UIViewController
        gameView.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(gameView, animated: true, completion:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
