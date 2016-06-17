//
//  Util.swift
//  Cards Against Humanity Core
//
//  Created by Ezekiel Elin on 6/17/16.
//  Copyright © 2016 Ezekiel Elin. All rights reserved.
//

import Foundation

func readInt() -> Int {
    while true {
        if let input = readLine(strippingNewline: true), intVal = Int(input) {
            return intVal
        } else {
            print("Please enter a number")
        }
    }
}

func readInt(from: Int, to: Int) -> Int {
    while true {
        let int = readInt()
        if int < from || int > to {
            print("Please enter a number between \(from) and \(to) (inclusive)")
        } else {
            return int
        }
    }
}
