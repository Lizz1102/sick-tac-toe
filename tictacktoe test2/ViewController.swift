//
//  ViewController.swift
//  tictacktoe
//
//  Created by Liza on 2/22/17.
//  Copyright © 2017 self. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
   
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    
  
    let winningCombinations = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]
    var playerOneMoves = Set<Int>()
    var playerTwoMoves = Set<Int>()
    var possibleMove = Array<Int>()
    var playerTurn = 1
    
    var allSpaces: Set<Int> = [1,2,3,4,5,6,7,8,9]
    
    
    
    @IBAction func newGameButtonClicked(_ sender: Any) {
        
        newGame()
        
    }
    
    


    @IBAction func btnPressed(_ sender: UIButton) {
              
        
        if playerTwoMoves.contains(sender.tag) || playerOneMoves.contains(sender.tag) {
            statusLabel.text = "Square already used!"
        } else {
            if playerTurn % 2 != 0 {
                
                playerOneMoves.insert(sender.tag)
                sender.setImage(UIImage(named: "o2.jpg")?.withRenderingMode(.alwaysOriginal), for: UIControlState())
                statusLabel.text = "AI's turn..."
                
                isWinner(player: 1)
                
                if isWinner(player: 1) == 0 && playerTurn < 9 {
                    
                   
                   DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                        
                        // if no winner play defense
                        let nextMove = self.playDefense()
                        self.playerTwoMoves.insert(nextMove)
                        let tmpButton = self.view.viewWithTag(nextMove) as! UIButton
                        tmpButton.setImage(UIImage(named: "x2")?.withRenderingMode(.alwaysOriginal), for: UIControlState())
                    
                        self.statusLabel.text = "Your turn..."
                        self.isWinner(player: 2)

                    })
                    
                    //check and see if computer won
                    
                }
            }
            
            
            playerTurn += 1
            if playerTurn > 9 && isWinner(player: 1) < 1 {
                //statusLabel.text = "Game Draw!-_-"
                winnerLabel.isHidden   = false
                newGameButton.isHidden = false
                statusLabel.isHidden   = true
                
                
                winnerLabel.text = "Game Draw!!"
                
                
                UIView.animate(withDuration: 1, animations: {
                    
                    self.winnerLabel.center   = CGPoint(x: self.winnerLabel.center.x + 500, y: self.winnerLabel.center.y)
                    self.newGameButton.center = CGPoint(x: self.newGameButton.center.x + 500, y: self.newGameButton.center.y)
                    
                })
                
                                
                for index in 1 ... 9 {
                    let tile = self.view.viewWithTag(index) as! UIButton
                    tile.isEnabled = false
                }
            }
            
            
        }
        
 
    }
    
    
    
    func newGame() {
        
        playerOneMoves.removeAll()
        playerTwoMoves.removeAll()
        
        winnerLabel.isHidden   = true
        newGameButton.isHidden = true
        statusLabel.isHidden   = false 
        
        winnerLabel.center   = CGPoint(x: winnerLabel.center.x - 500, y: winnerLabel.center.y)
        newGameButton.center = CGPoint(x: newGameButton.center.x - 500, y: newGameButton.center.y)
        
        statusLabel.text = "Your turn..."
        playerTurn = 1
        
        for index in 1 ... 9 {
            let tile = self.view.viewWithTag(index) as! UIButton
            tile.isEnabled = true
            tile.setImage(nil, for: .normal)
        }
        
        
    }

    
    
    
    func isWinner(player: Int) -> Int {
        var winner = 0
        var moveList = Set<Int>()
        //make sure we are looking at right player moves
        if player == 1 {
            moveList = playerOneMoves
        } else {
            moveList = playerTwoMoves
        }
        
        // check and see if there are any winning combinations
        for combo in winningCombinations  {
            if moveList.contains(combo[0]) && moveList.contains(combo[1]) && moveList.contains(combo[2]) && moveList.count >= 3 {
                
                winner = player
               // statusLabel.text = "Player \(player) won the game!"      //testing , commented out 
               
                winnerLabel.isHidden   = false
                newGameButton.isHidden = false
                statusLabel.isHidden   = true
                
                if winner == 1 {
                
                    winnerLabel.text = "You won the Game!!"
                
                } else {
                
                    winnerLabel.text = "AI has won!!"
                }
                
                
                UIView.animate(withDuration: 1, animations: {
                    
                    self.winnerLabel.center   = CGPoint(x: self.winnerLabel.center.x + 500, y: self.winnerLabel.center.y)
                    self.newGameButton.center = CGPoint(x: self.newGameButton.center.x + 500, y: self.newGameButton.center.y)
                    
                })
                
                
                for index in 1 ... 9 {
                    let tile = self.view.viewWithTag(index) as! UIButton
                    tile.isEnabled = false
                }
            }
        }
        return winner
    }
    
    
    
    func playDefense() -> Int{
        var possibleLoses = Array<Array<Int>>()
        var possibleWins = Array<Array<Int>>()
        var nextMove:Int?  = nil
        
        
        // determine what spaces are open
        let spacesLeft = allSpaces.subtracting(playerOneMoves.union(playerTwoMoves))
        // check for any possible winning/losing plays for human player
        // checks each possible winning combo and sees if human player is holding 2 spaces with computer holding none or vis a versa
        for combo in winningCombinations {
            var count = 0
            for play in combo {
                
                if playerOneMoves.contains(play) {
                    
                    count += 1
                    
                }
                
                if playerTwoMoves.contains(play) {
                    
                    count -= 1
                    
                }
                
                if count == 2 {
                    
                    possibleLoses.append(combo)
                    count = 0
                    
                }
                
                if count == -2 {
                    
                    possibleWins.append(combo)
                    count = 0
                    
                }
                
            }
            
            
        }
        
        // if finds any possible winning moves add them to possible moves set
        if possibleWins.count > 0 {
            for combo in possibleWins {
                for space in combo {
                    if playerTwoMoves.contains(space) || playerOneMoves.contains(space) {
                        
                    } else {
                        return space
                    }
                }
            }
        }
        
        // if finds any possible losing moves add them to possible moves set
        if possibleLoses.count > 0 {
            for combo in possibleLoses {
                for space in combo {
                    if playerOneMoves.contains(space) || playerTwoMoves.contains(space) {
                        
                    } else {
                        possibleMove.append(space)
                    }
                }
            }
        }
        
        // if no possible wins or loses pick an empty spot
        if possibleMove.count > 0 {
            
            nextMove = possibleMove[Int(arc4random_uniform(UInt32(possibleMove.count)))]
            
        } else {
            
            if allSpaces.subtracting(playerOneMoves.union(playerTwoMoves)).count > 0 {
                
                //nextMove = spacesLeft[spacesLeft.startIndex.advancedBy(Int(arc4random_uniform(UInt32(spacesLeft.count))))]
                nextMove = spacesLeft[spacesLeft.index(spacesLeft.startIndex, offsetBy: Int(arc4random_uniform(UInt32(spacesLeft.count))))]
            
                
            }
        }
        
        possibleMove.removeAll(keepingCapacity: false)
        possibleLoses.removeAll(keepingCapacity: false)
        possibleWins.removeAll(keepingCapacity: false)
        
        playerTurn += 1
        
        return nextMove!
    }

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        newGame()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

