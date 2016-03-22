//
//  View2Controller.swift
//  BINGO
//
//  Created by 1500007 on 2015/2/2.
//  Copyright (c) 2015年 lonelyship. All rights reserved.
//

import UIKit

class View2Controller: UIViewController {
    
    @IBOutlet weak var lbTotalLinesP2: UILabel!
    @IBOutlet weak var btn00P2: UIButton!
    @IBOutlet weak var btn01P2: UIButton!
    @IBOutlet weak var btn02P2: UIButton!
    @IBOutlet weak var btn10P2: UIButton!
    @IBOutlet weak var btn11P2: UIButton!
    @IBOutlet weak var btn12P2: UIButton!
    @IBOutlet weak var btn20P2: UIButton!
    @IBOutlet weak var btn21P2: UIButton!
    @IBOutlet weak var btn22P2: UIButton!
    // @IBOutlet weak var gameModeSwitch: UISwitch!
    // @IBOutlet weak var switchHint: UILabel!
    @IBOutlet weak var tvFieldRandomP2: UITextField!
    @IBOutlet weak var randomHintP2: UILabel!
    
    var btnArrayP2 = Array<Array<UIButton>>();
    var gameStateArrayP2=Array<Array<Character>>();
    var randomNumArrayP2 = Array(count: 9, repeatedValue: 0);
    var islegalNumP2 = true;
    var m_bNumIsReaptedP2  = false;
    var gameModeStateP2 = false;
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        for column in 0...2 {
            btnArrayP2.append(Array(count:3, repeatedValue:UIButton()))
        }
        
        for column in 0...2 {
            gameStateArrayP2.append(Array(count:3, repeatedValue:"G"))
        }
        
        btnArrayP2[0][0] = btn00P2; btnArrayP2[0][1] = btn01P2; btnArrayP2[0][2] = btn02P2;
        btnArrayP2[1][0] = btn10P2; btnArrayP2[1][1] = btn11P2; btnArrayP2[1][2] = btn12P2;
        btnArrayP2[2][0] = btn20P2; btnArrayP2[2][1] = btn21P2; btnArrayP2[2][2] = btn22P2;
        
        
        var k=0;
        
        for i in 0...2{
            for j in 0...2{
                btnArrayP2[i][j].setTitle("*", forState: .Normal)
                btnArrayP2[i][j].backgroundColor = UIColor.greenColor()
                btnArrayP2[i][j].addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                btnArrayP2[i][j].tag=k;
                k++;
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if(SStaticData.Holder.isFirstTime == false){
            
            gameModeStateP2 = SStaticData.Holder.gameModeState;
            
            for i in 0...2{
                for j in 0...2{
                    btnArrayP2[i][j].setTitle(SStaticData.Holder.btnArrayP2[i][j].titleLabel?.text, forState: .Normal)
                }
            }
            
            checkGameState();
            
            var totalLines=checkLines();
            lbTotalLinesP2.text=String(totalLines);
            
            if(totalLines >= 3){
                showGameOverAlert();
            }
            
            
        }
        
    }
    
    //初始化
    func doInit() {
        for i in 0...2{
            for j in 0...2{
                btnArrayP2[i][j].setTitle("*", forState: .Normal);
                btnArrayP2[i][j].backgroundColor = UIColor.greenColor();
                gameStateArrayP2[i][j]="G";
                lbTotalLinesP2.text="0";
            }
        }
        
    }
    
    //按下棋盤按鈕
    func buttonAction(sender:UIButton!){
        if (gameModeStateP2 == true){
            
            if(gameStateArrayP2[sender.tag/3][sender.tag%3]=="G"){
                gameStateArrayP2[sender.tag/3][sender.tag%3]="R";
                sender.backgroundColor=UIColor(red:1.0, green:0.0,blue:0.0,alpha:1.0)
            } else{
                gameStateArrayP2[sender.tag/3][sender.tag%3]="G";
                sender.backgroundColor=UIColor(red:0.0, green:1.0,blue:0.0,alpha:1.0)
            }
            
            //println(checkLines());
            var totalLines=checkLines();
            lbTotalLinesP2.text=String(totalLines);
            
            if(totalLines >= 3){
                showGameOverAlert();
            }
            
            var btnPressedNum = sender.titleLabel?.text?;
            SStaticData.Holder.numIsSelectedArray.append(btnPressedNum!);
            
            
        } else{                        //當off模式按button時  可以填入數字
            showEnterNumAlert(sender);
            
        }
    }
    
    //取得亂數陣列
    func getRandomNum(range: Int){
        
        randomNumArrayP2 = Array(count: range, repeatedValue: 0)
        
        for i in 0...range-1{
            randomNumArrayP2[i]=i+1
        }
        
        var randomNum=0,temp=0;
        for i in 0...range-1{
            randomNum = Int(arc4random_uniform(UInt32(range)))
            temp=randomNumArrayP2[i]
            randomNumArrayP2[i]=randomNumArrayP2[randomNum]
            randomNumArrayP2[randomNum]=temp
        }
    }
    
    
    
    
    //顯示獲勝alert
    func showGameOverAlert(){
        
        var gameoverAlert = UIAlertController(title: "恭喜您! Player2 ", message: "B I N G O !!", preferredStyle: UIAlertControllerStyle.Alert);
        gameoverAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                self.doInit();
                SStaticData.doinit();
                SStaticData.Holder.gameOver=true;
                self.dismissViewControllerAnimated(true, completion: nil);
                break;
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
    
        if(self.islegalNumP2 == false){
            enterNumAlert.title = "數值範圍限制 1~1000";
            enterNumAlert.message = "請重新輸入";
            self.islegalNumP2 = true;
        } else if(self.m_bNumIsReaptedP2 == true){
            enterNumAlert.title = "數值重複!!";
            enterNumAlert.message = "請重新輸入";
        }
        enterNumAlert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            
            inputTextField = textField;
            
            textField.addTarget(self, action: "hintReapted:", forControlEvents: UIControlEvents.EditingChanged);
        })
        
        enterNumAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {action in
            switch action.style{
            case .Default:
                self.m_bNumIsReaptedP2=false;
                self.islegalNumP2=true;
                break;
            case .Cancel:
                break;
                
            case .Destructive:
                break;
            }
        }))
        
        enterNumAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
            switch action.style{
            case .Default:
                if(inputTextField.text.toInt() > 0 && inputTextField.text.toInt() <= 1000){
                    
                    if(self.checkNumReapted(inputTextField.text.toInt()!) == true){
                        self.m_bNumIsReaptedP2=true;
                        self.showEnterNumAlert(sender);
                    } else{
                        sender.setTitle(inputTextField.text, forState: .Normal);
                        self.islegalNumP2 = true;
                        self.m_bNumIsReaptedP2=false;
                    }
                    
                } else{
                    self.islegalNumP2 = false;
                    self.showEnterNumAlert(sender);
                }
                break;
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
    
    //按下亂數範圍送出鈕
    @IBAction func pressBtnRandom(sender: UIButton) {
        
        if (gameModeStateP2 == false){
            
            if (tvFieldRandomP2.text.isEmpty == false && tvFieldRandomP2.text.toInt()>=9 && tvFieldRandomP2.text.toInt()<=1000){
                
                randomHintP2.text="";
                
                getRandomNum(tvFieldRandomP2.text.toInt()!);
                
                var k=0;
                
                //NSLog("%@",randomNumArray);
                
                for var i = 0; i < 3; i++ {
                    for var j = 0 ; j < 3; j++ {
                        
                        if(btnArrayP2[i][j].titleLabel?.text == "*"){
                            
                            let randomNum = randomNumArrayP2[k];
                            
                            if(checkNumReapted(randomNum) == false){
                                btnArrayP2[i][j].setTitle(String(randomNum), forState: .Normal);
                            } else{
                                j = j-1 ;
                            }
                            k++;
                        }
                    }
                }
                
            } else {
                randomHintP2.text="請輸入9~1000的數字";
            }
        }
        
    }
    
    
    
    
    //檢查數字是否重複
    func checkNumReapted(num: Int) ->Bool{
        for i in 0...2{
            for j in 0...2{
                
                if(btnArrayP2[i][j].titleLabel?.text?.toInt() == num){
                    return true;
                }
                
            }
        }
        return false;
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //算總連線數
    func checkLines() ->Int{
        var countLines=0;
        //算橫連線數
        for i in 0...2{
            var isLine = true;
            for j in 0...2{
                
                if(gameStateArrayP2[i][j] == "G"){
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
                
                if(gameStateArrayP2[j][i] == "G"){
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
            
            if (gameStateArrayP2[i][i] == "G"){
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
            if (gameStateArrayP2[i][2-i] == "G"){
                isSlashLine_2 = false;
                break;
            }
        }
        if (isSlashLine_2 == true){
            countLines++;
        }
        return countLines;
    }
    
    
    func checkGameState(){
        
        var temp_numIsSelectedArray = SStaticData.Holder.numIsSelectedArray;
        for i in 0...2{
            for j in 0...2{
                
                for (var k = 0; k < temp_numIsSelectedArray.count; k++){
                    //  println(btnArrayP2[i][j].titleLabel?.text);
                    if(btnArrayP2[i][j].titleLabel?.text? == temp_numIsSelectedArray[k]){
                        
                        //  println("!");
                        gameStateArrayP2[i][j] = "R";
                        btnArrayP2[i][j].backgroundColor = UIColor(red:1.0, green:0.0,blue:0.0,alpha:1.0)
                        
                    }
                    
                }
                
            }
        }
        
        
    }
    
    
    
    //    //按下重置鈕
    //    @IBAction func reset(sender: AnyObject) {
    //
    //        doInit();
    //    }
    
    
    @IBAction func goPlayerOne(sender: AnyObject) {
        
        
        SStaticData.Holder.btnArrayP2 = btnArrayP2;
        SStaticData.Holder.isFirstTime = false;
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //
    //    @IBAction func goPlayerOne(sender: AnyObject) {
    //        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    //        let detailview = storyboard.instantiateViewControllerWithIdentifier("playerOne") as UIViewController
    //        detailview.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
    //        self.presentViewController(detailview, animated: true, completion:nil)
    //
    //    }
    
    
    
    
    //    override func didReceiveMemoryWarning() {
    //        super.didReceiveMemoryWarning()
    //        // Dispose of any resources that can be recreated.
    //    }
    //
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
