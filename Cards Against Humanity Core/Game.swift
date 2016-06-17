//
//  Game.swift
//  Cards Against Humanity Core
//
//  Created by Ezekiel Elin on 6/17/16.
//  Copyright © 2016 Ezekiel Elin. All rights reserved.
//

import Foundation

class Game {
    
    let HandSize = 10
    
    var blackCards: [BlackCard]
    var whiteCards: [WhiteCard]
    
    var discardedBlackCards = [BlackCard]()
    var discardedWhiteCards = [WhiteCard]()
    
    let playerCount: Int
    
    var players = [Player]()
    
    var currentPlayerIndex = 0
    var currentPlayer: Player {
        return self.players[self.currentPlayerIndex]
    }
    
    var roundCardCzarIndex: Int
    var roundCardCzar: Player {
        return self.players[self.roundCardCzarIndex]
    }
    
    init(players playerNames: [String]) {
        self.playerCount = playerNames.count
        
        self.roundCardCzarIndex = playerCount - 1
        
        //Set up deck
        self.blackCards = Game.buildBlackCardList()
        self.whiteCards = Game.buildWhiteCardList()
        
        //Deal cards
        for i in 0..<playerCount {
            let p = Player(number: i, name: playerNames[i])
            for _ in 1...HandSize {
                p.cards.append(whiteCards.remove(at: 0))
            }
            players.append(p)
        }
    }
    
    enum State {
        case Beginning, RoundStart, CardChoosing, CzarChoosing, RoundEnded, BetweenPlayers, Ended
    }
    
    enum Role {
        case Regular, Czar
    }
    
    private(set) var state = State.Beginning
    
    var _blackCard: BlackCard? = nil
    
    var blackCard: BlackCard {
        get {
            if let c = _blackCard {
                return c
            } else {
                let c = blackCards.remove(at: 0)
                _blackCard = c
                return c
            }
        }
        set(card) {
            self._blackCard = card
        }
    }
    
    func startRound() -> Bool {
        switch state {
        case .Beginning, .RoundEnded:
            do {
                for p in players  {
                    p.role = .Regular
                }
                
                self.state = .RoundStart
                
                self.roundCardCzar.role = .Czar
                
                return true
            }
        default:
            return false
        }
    }
    
    func playerTurn() -> Player {
        
        if self.state != .RoundStart && self.state != .BetweenPlayers {
            print("playerTurn should not be called right now!")
        }
        
        switch self.currentPlayer.role {
        case .Regular:
            self.state = .CardChoosing
        case .Czar:
            self.state = .CzarChoosing
        }
        
        return currentPlayer
    }
    
    /**
     Choose a card for the current player at a certain index
     */
    func regularPlayerChoose(card choices: [Int]) -> Bool {
        
        if !(currentPlayer.role == .Regular && self.state == .CardChoosing) {
            print("This operation is illegal at this time")
            return false
        }
        
        if choices.count != blackCard.pick {
            print("Incorrect number of cards")
            return false
        }
        
        if !currentPlayer.play(cards: choices) {
            return false
        }
        
        self.incrementPlayer()
        
        self.state = .BetweenPlayers
        
        return true
    }
    
    func czarChooseWinner(player: Player) -> Bool {
        if self.players.contains(player) && player.role == .Regular {
            player.points += 1
            
            //Setup Deck and check winners
            for p in players {
                self.discardedWhiteCards.append(contentsOf: p.playedCards)
                p.playedCards.removeAll()
                
                while p.cards.count < HandSize {
                    p.cards.append(whiteCards.remove(at: 0))
                }

                if p.points >= 5 {
                    print("\(p) wins!")
                    
                    self.state = .Ended
                    
                    return true
                }
            }
            
            self.incrementCzar()
            
            self.currentPlayerIndex = self.roundCardCzarIndex + 1
            
            if self.currentPlayerIndex >= self.playerCount {
                self.currentPlayerIndex = 0
            }
            
            self.state = .RoundEnded
            
            return true
        } else {
            return false
        }
    }
    
    func incrementPlayer() {
        self.currentPlayerIndex += 1
        if self.currentPlayerIndex >= self.playerCount {
            self.currentPlayerIndex = 0
        }
    }
    func incrementCzar() {
        self.roundCardCzarIndex += 1
        if self.roundCardCzarIndex >= self.playerCount {
            self.roundCardCzarIndex = 0
        }
    }
}
