//
//  Game.swift
//  TipsCalculatorUIKit
//
//  Created by Kostya Ozhiganov on 09.06.2022.
//

import Foundation

enum StatusGame{
    case start
    case win
    case lose
}


class Game{
    
    struct Item{
        var title: String
        var isFound: Bool = false
        
    }
    
    private let data = Array(1...99)
    var items:[Item] = []
    private var countItems:Int
    
    var nextItem:Item?
    
    var status:StatusGame = .start{
        didSet{
            if status != .start{
                stopGame()
            }
        }
    }
    
    private var timerForGame:Int {
        didSet{
            if timerForGame == 0{
                status = .lose
            }
            updateTimer(status, timerForGame)
        }
    }
    
    private var timer:Timer?
    private var updateTimer:((StatusGame, Int)-> Void)
    
    init(countItems: Int, time:Int, updateTimer:@escaping (_ status:StatusGame, _ seconds: Int) -> Void) {
        self.countItems = countItems
        self.timerForGame = time
        self.updateTimer = updateTimer
        setupGame()
    }
    
    private func setupGame(){
        var digits = data.shuffled()
        
        while items.count < countItems{
            let item = Item(title: String(digits.removeFirst()))
            items.append(item)
        }
        nextItem = items.shuffled().first
        updateTimer(status, timerForGame)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self](_) in
            self?.timerForGame -= 1
        })
    }
    
    func check(index:Int){
        if items[index].title == nextItem?.title{
            items[index].isFound = true
            nextItem = items.shuffled().first(where: { (item) -> Bool in
                item.isFound == false
            })
        }
        if nextItem == nil{
            status = .win
        }
    }
    private func stopGame(){
        timer?.invalidate()
    }
}

extension Int{
    func secondsToString()-> String{
        let minutes = self / 60
        let seconds = self % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
