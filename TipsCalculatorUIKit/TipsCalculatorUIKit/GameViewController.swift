//
//  GameViewController.swift
//  TipsCalculatorUIKit
//
//  Created by Kostya Ozhiganov on 08.06.2022.
//

import UIKit


class GameViewController: UIViewController {
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nextDigit: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    lazy var game = Game(countItems: buttons.count, time: 30) { [weak self](status, time) in
        
        guard let self = self else {return}
        
        self.timerLabel.text = time.secondsToString()
        self.updateInfoGame(with: status)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
      
    }
    
    @IBAction func firstButton(_ sender: UIButton) {
        guard let buttonIndex = buttons.firstIndex(of: sender) else {return}
        game.check(index:buttonIndex)
        updateUI()
    }
    
    private func setupScreen(){
        for index in game.items.indices{
            buttons[index].setTitle(game.items[index].title, for: .normal)
            buttons[index].isHidden = false
        }
        nextDigit.text = game.nextItem?.title
        
    }
    
    private func updateUI(){
        for index in game.items.indices{
            buttons[index].isHidden = game.items[index].isFound
        }
        nextDigit.text = game.nextItem?.title
        
        updateInfoGame(with: game.status)
    }
    private func updateInfoGame(with status: StatusGame){
        switch status{
        case .start:
            statusLabel.text = "Game started!"
            statusLabel.textColor = .black
        case .win:
            statusLabel.text = "You win!"
            statusLabel.textColor = .green
        case .lose:
            statusLabel.text = "You lose!"
            statusLabel.textColor = .red
        }
    }
}
