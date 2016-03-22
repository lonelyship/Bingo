//
//  ViewController.swift
//  BINGO
//
//  Created by 1500007 on 2015/1/29.
//  Copyright (c) 2015年 lonelyship. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lbTotalLines: UILabel!
    @IBOutlet weak var btn00: UIButton!
    @IBOutlet weak var btn01: UIButton!
    @IBOutlet weak var btn02: UIButton!
    @IBOutlet weak var btn10: UIButton!
    @IBOutlet weak var btn11: UIButton!
    @IBOutlet weak var btn12: UIButton!
    @IBOutlet weak var btn20: UIButton!
    @IBOutlet weak var btn21: UIButton!
    @IBOutlet weak var btn22: UIButton!
    @IBOutlet weak var gameModeSwitch: UISwitch!
    @IBOutlet weak var switchHint: UILabel!
    @IBOutlet weak var tvFieldRandom: UITextField!
    @IBOutlet weak var randomHint: UILabel!
    
    var btnArray = Array<Array<UIButton>>();
    var gameStateArray=Array<Array<Character>>();
    var randomNumArray = Array(count: 9, repeatedValue: 0);
    var islegalNum = true;
    var m_bNumIsReapted  = false;
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "images.jpeg")!)
        
        for column in 0...2 {
            btnArray.append(Array(count:3, repeatedValue:UIButton()))
        }
        
        for column in 0...2 {
            gameStateArray.append(Array(count:3, repeatedValue:"G"))
        }
        
        btnArray[0][0]=btn00; btnArray[0][1]=btn01; btnArray[0][2]=btn02;
        btnArray[1][0]=btn10; btnArray[1][1]=btn11; btnArray[1][2]=btn12;
        btnArray[2][0]=btn20; btnArray[2][1]=btn21; btnArray[2][2]=btn22;
        
        var k=0;
        
        for i in 0...2{
            for j in 0...2{
                btnArray[i][j].setTitle("*", forState: .Normal)
                btnArray[i][j].backgroundColor = UIColor.greenColor()
                btnArray[i][j].addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                btnArray[i][j].tag=k;
                k++;
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if(SStaticData.Holder.gameOver == true){
            doInit();
            gameModeSwitch.on = false;
            SStaticData.Holder.gameOver=false;
        } else if(SStaticData.Holder.isFirstTime == false){
            
            checkGameState();
            
            var totalLines=checkLines();
            lbTotalLines.text=String(totalLines);
            
            if(totalLines >= 3){
                showGameOverAlert();
            }
            
        }
        
    }
    
    //初始化
    func doInit() {
        for i in 0...2{
            for j in 0...2{
                btnArray[i][j].setTitle("*", forState: .Normal);
                btnArray[i][j].backgroundColor = UIColor.greenColor();
                gameStateArray[i][j]="G";
                lbTotalLines.text="0";
            }
        }
        
    }
    
    //按下遊戲模式開關
    @IBAction func pressGameModeSwitch(sender: AnyObject) {
        
        if (gameModeSwitch.on == true){
            
            var notYet = false;
            
            for i in 0...2{
                for j in 0...2{
                    if btnArray[i][j].titleLabel?.text == "*" {
                        notYet = true;
                        break;
                    }
                }
                if notYet == true {
                    break;
                }
            }
            
            if(notYet == true){
                gameModeSwitch.setOn(false, animated: true);
                switchHint.text="您還有數字還沒填";
            }else{
                switchHint.text="";
            }
            
        } else {
            doInit();
        }
        
    }
    
    //按下亂數範圍送出鈕
    @IBAction func pressBtnRandom(sender: UIButton) {
        
        if (gameModeSwitch.on == false){
            
            if (tvFieldRandom.text.isEmpty == false && tvFieldRandom.text.toInt()>=9 && tvFieldRandom.text.toInt()<=1000){
                
                randomHint.text="";
                
                getRandomNum(tvFieldRandom.text.toInt()!);
                
                var k=0;
                
                //NSLog("%@",randomNumArray);
                
                for var i = 0; i < 3; i++ {
                    for var j = 0 ; j < 3; j++ {
                        
                        if(btnArray[i][j].titleLabel?.text == "*"){
                            
                            let randomNum = randomNumArray[k];
                            
                            if(checkNumReapted(randomNum) == false){
                                btnArray[i][j].setTitle(String(randomNum), forState: .Normal);
                            } else{
                                j = j-1 ;
                            }
                            k++;
                        }
                    }
                    
                }
            } else {
                randomHint.text="請輸入9~1000的數字";
            }
        }
    }
    
    //檢查數字是否重複
    func checkNumReapted(num: Int) ->Bool{
        for i in 0...2{
            for j in 0...2{
                
                if(btnArray[i][j].titleLabel?.text?.toInt() == num){
                    return true;
                }
                
            }
        }
        return false;
    }
    
    
    //按下棋盤按鈕
    func buttonAction(sender:UIButton!){
        if (gameModeSwitch.on == true){
            
            if(gameStateArray[sender.tag/3][sender.tag%3]=="G"){
                gameStateArray[sender.tag/3][sender.tag%3]="R";
                sender.backgroundColor=UIColor(red:1.0, green:0.0,blue:0.0,alpha:1.0)
            } else{
                gameStateArray[sender.tag/3][sender.tag%3]="G";
                sender.backgroundColor=UIColor(red:0.0, green:1.0,blue:0.0,alpha:1.0)
            }
            
            //println(checkLines());
            var totalLines=checkLines();
            lbTotalLines.text=String(totalLines);
            
            if(totalLines >= 3){
                showGameOverAlert();
            }
            
            
            //SStaticData.Holder.gameStateArrayP1 = gameStateArray;
            var btnPressedNum = sender.titleLabel?.text?;
            SStaticData.Holder.numIsSelectedArray.append(btnPressedNum!);
            //          println(SStaticData.Holder.numIsSelected);
            
            
        } else{                        //當off模式按button時  可以填入數字
            
            showEnterNumAlert(sender);
            
        }
    }
    
    //取得亂數陣列
    func getRandomNum(range: Int){
        
        randomNumArray = Array(count: range, repeatedValue: 0)
        
        for i in 0...range-1{
            randomNumArray[i]=i+1
        }
        
        var randomNum=0,temp=0;
        for i in 0...range-1{
            randomNum = Int(arc4random_uniform(UInt32(range)))
            temp=randomNumArray[i]
            randomNumArray[i]=randomNumArray[randomNum]
            randomNumArray[randomNum]=temp
        }
    }
    
    //顯示獲勝alert
    func showGameOverAlert(){
        
        var gameoverAlert = UIAlertController(title: "恭喜您! Player1 ", message: "B I N G O !!", preferredStyle: UIAlertControllerStyle.Alert);
        gameoverAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                self.gameModeSwitch.setOn(false, animated: true);
                self.doInit();
                SStaticData.doinit();
            case .Cancel:
                break;
                
            case .Destructive:
                break;
            }
        }))
        self.presentViewController(gameoverAlert, animated: true, completion: nil);
    }
    
    //顯示輸入數字alert
    func showEnterNumAlert(sender:UIButton){
        var inputTextField: UITextField!
        let enterNumAlert = UIAlertController(title: "請輸入一個數字", message: "範圍: 1 ~ 1000", preferredStyle: UIAlertControllerStyle.Alert)
        
        if(self.islegalNum == false){
            enterNumAlert.title = "數值範圍限制 1~1000";
            enterNumAlert.message = "請重新輸入";
            self.islegalNum = true;
        } else if(self.m_bNumIsReapted == true){
            enterNumAlert.title = "數值重複!!";
            enterNumAlert.message = "請重新輸入";
        }
        enterNumAlert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            //textField.placeholder = ""
            //textField.secureTextEntry = true
            inputTextField = textField;
            textField.addTarget(self, action: "hintReapted:", forControlEvents: UIControlEvents.EditingChanged);
        })
       
        enterNumAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {action in
            switch action.style{
            case .Default:
                self.m_bNumIsReapted=false;
                self.islegalNum=true;
            case .Cancel:
                break;
                
            case .Destructive:
                break;            }
        }))
        
        enterNumAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
            switch action.style{
            case .Default:
                if(inputTextField.text.toInt() > 0 && inputTextField.text.toInt() <= 1000){
                   
                    if(self.checkNumReapted(inputTextField.text.toInt()!) == true){
                        self.m_bNumIsReapted=true;
                        self.showEnterNumAlert(sender);
                    } else{
                        sender.setTitle(inputTextField.text, forState: .Normal);
                        self.islegalNum = true;
                        self.m_bNumIsReapted=false;
                    }
                    
                } else{
                    self.islegalNum = false;
                    self.showEnterNumAlert(sender);
                }
            case .Cancel:
                break;
                
            case .Destructive:
                break;
            }
            
        }))
        
        presentViewController(enterNumAlert, animated: true, completion: nil);
    }
    
    //提示數字重複
    func hintReapted(sender: UITextField){
        if(sender.text.isEmpty == false){
            if(self.checkNumReapted(sender.text.toInt()!) == true){
                sender.backgroundColor = UIColor.redColor();
            }else{
                sender.backgroundColor = UIColor.whiteColor();
            }
        }else{
            sender.backgroundColor = UIColor.whiteColor();
        }
    }
    
    //算總連線數
    func checkLines() ->Int{
        var countLines=0;
        //算橫連線數
        for i in 0...2{
            var isLine = true;
            for j in 0...2{
                
                if(gameStateArray[i][j] == "G"){
                    isLine = false;
                    break;
                }
                
            }
            
            if (isLine == true){
                countLines++;
            }
        }
        //算直連線數
        for i in 0...2{
            var isLine = true;
            for j in 0...2{
                
                if(gameStateArray[j][i] == "G"){
                    isLine = false;
                    break;
                }
                
            }
            
            if (isLine == true){
                countLines++;
            }
        }
        // 算斜線連線(左上至右下)
        var isSlashLine_1=true;
        for i in 0...2{
            
            if (gameStateArray[i][i] == "G"){
                isSlashLine_1 = false;
                break;
            }
        }
        if (isSlashLine_1 == true){
            countLines++;
        }
        // 算斜線連線(右上至左下)
        var isSlashLine_2=true;
        for i in 0...2{
            if (gameStateArray[i][2-i] == "G"){
                isSlashLine_2 = false;
                break;
            }
        }
        if (isSlashLine_2 == true){
            countLines++;
        }
        return countLines;
    }
    
    //按下重置鈕
    @IBAction func reset(sender: AnyObject) {
        gameModeSwitch.setOn(false, animated: true);
        doInit();
        SStaticData.doinit();
    }
    
    @IBAction func goPlayerTwo(sender: AnyObject) {
        
        if(gameModeSwitch.on == true){
            SStaticData.Holder.gameModeState = true;
        } else{
            SStaticData.Holder.gameModeState = false;
        }
        
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let detailview = storyboard.instantiateViewControllerWithIdentifier("playerTwo") as UIViewController
        detailview.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(detailview, animated: true, completion:nil)
        
    }
    
    func checkGameState(){
        //
        var temp_numIsSelectedArray = SStaticData.Holder.numIsSelectedArray;
        //        //
        //        //        println(temp);
        //
        for i in 0...2{
            for j in 0...2{
                for (var k = 0; k < temp_numIsSelectedArray.count; k++){
                    //  println(btnArrayP2[i][j].titleLabel?.text);
                    if(btnArray[i][j].titleLabel?.text? == temp_numIsSelectedArray[k]){
                        
                        //  println("!");
                        gameStateArray[i][j] = "R";
                        btnArray[i][j].backgroundColor = UIColor(red:1.0, green:0.0,blue:0.0,alpha:1.0)
                        
                    }
                }
            }
        }
    }
    
}

