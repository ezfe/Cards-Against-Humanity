//
//  Player.swift
//  Cards Against Humanity Core
//
//  Created by Ezekiel Elin on 7/23/15.
//  Copyright © 2015 Ezekiel Elin. All rights reserved.
//

func ==(a: Game.Player, b: Game.Player) -> Bool {
    return a.playerNumber == b.playerNumber
}

extension Game {
    class Player: CustomStringConvertible, Equatable {
        let playerNumber: Int
        let name: String
        
        var points = 0
        var playedThisRound = false
        var role = Role.Regular
        
        var cards = Array<WhiteCard>()
        var playedCards = Array<WhiteCard>()
        
        func play(cards: [Int]) -> Bool {
            for card in cards {
                if card < 0 && card >= cards.count {
                    return false
                }
            }
            
            for card in cards {
                self.playedCards.append(self.cards[card])
            }
            for card in cards {
                self.cards.remove(at: card)
            }
            
            return true
        }
        
        init(number n: Int, name: String) {
            self.playerNumber = n
            self.name = name
        }
        
        var description: String {
            get {
                if self.role == .Czar {
                    return "\(self.name) (Czar)"
                } else {
                    return "\(self.name)"
                }
            }
        }
    }
}
