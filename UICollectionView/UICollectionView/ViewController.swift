//
//  ViewController.swift
//  UICollectionView
//
//  Created by Brian Coleman on 2014-09-04.
//  Copyright (c) 2014 Brian Coleman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let gameSize : Int = SStaticData.Holder.gameSize;
    
    @IBOutlet var collectionView: UICollectionView?
    @IBOutlet weak var lbTotalLines: UILabel!
    @IBOutlet weak var switchHint: UILabel!
    @IBOutlet weak var gameModeSwitch: UISwitch!
    @IBOutlet weak var tvFieldRandom: UITextField!
    @IBOutlet weak var randomHint: UILabel!
    
    var gameStateArray=Array<Array<Character>>();
    var cellNumArray=Array<Array<Int>>();
    var randomNumArray = Array(count: 0, repeatedValue: 0);
    var islegalNum = true;
    var m_bNumIsReapted  = false;
    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = screenSize.width;
        let screenHeight = screenSize.height;
        
        //   Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.itemSize = CGSize(width:(screenWidth - (CGFloat(11 * (gameSize - 1)))) / CGFloat(gameSize), height: (screenWidth - (CGFloat(11 * ((gameSize) - 1)))) / CGFloat(gameSize));
        
        collectionView = UICollectionView(frame:  CGRect(x: 0, y: 0, width: screenWidth, height: ((layout.itemSize.height+2) * CGFloat(gameSize))), collectionViewLayout: layout);
        collectionView!.dataSource = self;
        collectionView!.delegate = self;
        collectionView!.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell");
        //collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!);
        
        for column in 0..<gameSize {
            cellNumArray.append(Array(count:gameSize, repeatedValue: 0));
        }
        
        for column in 0..<gameSize {
            gameStateArray.append(Array(count:gameSize, repeatedValue:"G"));
        }
        
    }
    
    // 隱藏畫面上方狀態欄
    override func prefersStatusBarHidden()->Bool{
        return true;
    }
    
    //設定行數
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return gameSize;
    }
    
    //設定列數
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameSize;
    }
    
    //回傳cell的view
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as CollectionViewCell
        
        cell.backgroundColor = UIColor.greenColor()
        
        if(cellNumArray[indexPath.section][indexPath.row]==0){
            cell.textLabel?.text = "*";
        } else{
            cell.textLabel?.text = String(cellNumArray[indexPath.section][indexPath.row]);
        }
        
        cell.tag = ((indexPath.section) * gameSize) + indexPath.row;
        
        return cell
    }
    
    
    //按下格子時
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)!;
        let tag = cell.tag;
        
        //遊戲模式(on)時改變格子顏色
        if (gameModeSwitch.on == true){
            
            if(gameStateArray[tag / gameSize][tag % gameSize] == "G"){
                gameStateArray[tag / gameSize][tag % gameSize]="R";
                cell.backgroundColor = UIColor(red:1.0, green:0.0,blue:0.0,alpha:1.0);
                
            } else{
                gameStateArray[tag / gameSize][tag % gameSize]="G";
                cell.backgroundColor = UIColor(red:0.0, green:1.0,blue:0.0,alpha:1.0);
            }
            
            var totalLines=checkLines();             //檢查目前總連線數
            lbTotalLines.text = String(totalLines);
            
            if(totalLines >= gameSize){
                showGameOverAlert();                 //顯示勝利畫面
            }
            
        } else{          //遊戲模式(off)時 跳出 Alert 輸入數字
            showEnterNumAlert(cell.tag);
        }
    }
    
    //顯示輸入數字 Alert
    func showEnterNumAlert(sender : Int){
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
            inputTextField = textField;
            textField.addTarget(self, action: "hintReapted:", forControlEvents: UIControlEvents.EditingChanged);
        })
        
        enterNumAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {action in
            switch action.style{
            case .Default:
                self.m_bNumIsReapted = false;
                self.islegalNum = true;
                
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
                        self.cellNumArray[sender / self.gameSize][sender % self.gameSize] = inputTextField.text.toInt()!;
                        self.islegalNum = true;
                        self.m_bNumIsReapted=false;
                        self.collectionView?.reloadData();
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
    
    //檢查數字是否重複
    func checkNumReapted(num: Int) ->Bool{
        for i in 0..<gameSize{
            for j in 0..<gameSize{
                if(cellNumArray[i][j] == num){
                    return true;
                }
                
            }
        }
        return false;
    }
    
    //按下遊戲模式開關
    @IBAction func pressGameModeSwitch(sender: AnyObject) {
        
        if (gameModeSwitch.on == true){
            
            var notYet = false;
            
            for i in 0..<gameSize{
                for j in 0..<gameSize{
                    if (cellNumArray[i][j] == 0) {
                        notYet = true;
                        break;
                    }
                }
                if (notYet == true){
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
    
    //初始化
    func doInit() {
        for i in 0..<gameSize{
            for j in 0..<gameSize{
                cellNumArray[i][j] = 0;
                gameStateArray[i][j] = "G";
                lbTotalLines.text = "0";
            }
        }
        collectionView!.reloadData();
    }

    //按下亂數範圍送出鈕
    @IBAction func pressBtnRandom(sender: UIButton) {
        
        if (gameModeSwitch.on == false){
            
            if (tvFieldRandom.text.isEmpty == false && tvFieldRandom.text.toInt() >= gameSize * gameSize && tvFieldRandom.text.toInt() <= 1000){
                randomHint.text="";
                getRandomNum(tvFieldRandom.text.toInt()!);
                
                var k=0;
                NSLog("%@",randomNumArray);
                
                for (var i = 0; i < gameSize; i++){
                    for (var j = 0 ; j < gameSize; j++){
                        
                        if(cellNumArray[i][j] == 0){
                            
                            let randomNum = randomNumArray[k];
                            
                            if(checkNumReapted(randomNum) == false){
                                cellNumArray[i][j] = randomNum;
                            } else{
                                j = j-1 ;
                            }
                            
                            k++;
                        } //else{}
                    }
                }
            } else {
                randomHint.text="請輸入\(gameSize*gameSize)~1000的數字";
            }
        }
        collectionView!.reloadData();
    }
    
    //取得不重複亂數陣列
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
    
    //按下重置鈕
    @IBAction func reset(sender: AnyObject) {
        gameModeSwitch.setOn(false, animated: true);
        doInit();
    }
    
    //顯示獲勝alert
    func showGameOverAlert(){
        
        var gameoverAlert = UIAlertController(title: "恭喜您! ", message: "B I N G O !!", preferredStyle: UIAlertControllerStyle.Alert);
        gameoverAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                self.gameModeSwitch.setOn(false, animated: true);
                self.doInit();
            case .Cancel:
                break;
                
            case .Destructive:
                break;
            }
        }))
        self.presentViewController(gameoverAlert, animated: true, completion: nil);
    }
    
    //算總連線數
    func checkLines() ->Int{
        var countLines=0;
        //算橫連線數
        for i in 0..<gameSize{
            var isLine = true;
            for j in 0..<gameSize{
                
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
        for i in 0..<gameSize{
            var isLine = true;
            for j in 0..<gameSize{
                
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
        for i in 0..<gameSize{
            
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
        for i in 0..<gameSize{
            if (gameStateArray[i][gameSize-i-1] == "G"){
                isSlashLine_2 = false;
                break;
            }
        }
        if (isSlashLine_2 == true){
            countLines++;
        }
        return countLines;
    }
    
    //回主選單
    @IBAction func goBackToHome(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

