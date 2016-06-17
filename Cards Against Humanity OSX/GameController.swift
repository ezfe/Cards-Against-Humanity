//
//  ViewController.swift
//  Cards Against Humanity OSX
//
//  Created by Ezekiel Elin on 6/17/16.
//  Copyright © 2016 Ezekiel Elin. All rights reserved.
//

import Cocoa

class GameController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let g = Game(players: ["Ezekiel", "Francesca", "Daniel", "Sarah"])
        
        while false && g.state != .Ended {
            switch g.state {
            case .Beginning, .RoundEnded:
                _ = g.startRound()
            case .RoundStart, .BetweenPlayers:
                let player = g.playerTurn()
                switch g.state {
                case .CardChoosing:
                    print("Now: \(player)")
                    print("Black Card: \(g.blackCard)")
                    for (i, c) in player.cards.enumerated() {
                        print("\(i + 1):\t\(c)")
                    }
                    var choices = [Int]()
                    for _ in 1...g.blackCard.pick {
                        print("Choose...")
                        choices.append(readInt(from: 1, to: player.cards.count) - 1)
                    }
                    let res = g.regularPlayerChoose(card: choices)
                    if !res {
                        print("AHHHHH")
                    }
                case .CzarChoosing:
                    print("CZAR TIME")
                    for (i, p) in g.players.enumerated() where p.role == .Regular {
                        print("\(i+1):\t\(p.playedCards)")
                    }
                    let winner = g.players[readInt(from: 1, to: g.players.count) - 1]
                    if !g.czarChooseWinner(player: winner) {
                        print("AHHHHHH")
                    }
                default:
                    print("WHAT STATE OMG")
                }
            default:
                break
            }
        }

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

