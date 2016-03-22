//
//  SStaticData.swift
//  BINGO
//
//  Created by 1500007 on 2015/2/2.
//  Copyright (c) 2015年 lonelyship. All rights reserved.
//

import Foundation
import UIKit

class SStaticData{
    
    
    struct Holder {
        static var gameStateArrayP1 = Array<Array<Character>>();
        static var gameStateArrayP2 = Array<Array<Character>>();
        static var btnArrayP2    = Array<Array<UIButton>>();
        static var numIsSelectedArray = Array<String>();
        static var isFirstTime = true;
        static var gameModeState = false;
        static var gameOver = false;
    }
    
    
    class func doinit() {
     Holder.gameStateArrayP1 = Array<Array<Character>>();
     Holder.gameStateArrayP2 = Array<Array<Character>>();
     Holder.btnArrayP2    = Array<Array<UIButton>>();
     Holder.numIsSelectedArray = Array<String>();
     Holder.isFirstTime = true;
     Holder.gameModeState = false;
    }
    
//    class func alert() {        // type method
//        println("There are 1 foos")
//    }
//    
//    
//    class func getNum() -> Int{
//        
//        return 42;
//    }
//    
   
    
    
}