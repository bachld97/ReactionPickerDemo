//
//  ReactionCellModel.swift
//  MultiReactionDemo
//
//  Created by Bach Le on 4/10/20.
//  Copyright © 2020 Bach Le. All rights reserved.
//

import Foundation
import UIKit

@objcMembers class ReactionCellModel: NSObject {
    // map reactionId <-> number of reaction
    let cellId: String
    var chosenReactionId: String? = nil
    let reactionFromOthers: [String : Int]
    var reactionFromSelf: [String : Int]
    
    init(cellId: String,
         reactionFromOthers: [String : Int], reactionFromSelf: [String : Int]) {
        self.cellId = cellId
        self.reactionFromOthers = reactionFromOthers
        self.reactionFromSelf = reactionFromSelf
    }
    
    func increaseSelfReaction(reactionId: String) {
        if (reactionFromSelf.keys.contains(reactionId)) {
            reactionFromSelf[reactionId] = reactionFromSelf[reactionId]! + 1
        } else {
            reactionFromSelf[reactionId] = 1
        }
    }
    
    var totalReactionByType: [String : Int] {
        var reactionTotal = [String : Int]()
        for (key, value) in reactionFromOthers {
            let selfValue = reactionFromSelf[key] ?? 0
            reactionTotal.updateValue(value + selfValue, forKey: key)
        }
        return reactionTotal
    }
    
    var totalReactionCount: Int {
        var total: Int = 0
        totalReactionByType.forEach { key, value in
            total += value
        }
        return total
    }
    
    
    static var mockData: [ReactionCellModel] {
        let dataFromStranger = [
            "1": 20,
            "2": 10,
            "3": 5
        ]
        let dataFromSelf = [
            "1": 10,
            "2": 4,
            "3": 0
        ]
        return [
            ReactionCellModel(cellId: "1", reactionFromOthers: dataFromStranger, reactionFromSelf: dataFromSelf),
            ReactionCellModel(cellId: "2", reactionFromOthers: dataFromStranger, reactionFromSelf: dataFromSelf),
            ReactionCellModel(cellId: "3", reactionFromOthers: dataFromStranger, reactionFromSelf: dataFromSelf),
            ReactionCellModel(cellId: "4", reactionFromOthers: dataFromStranger, reactionFromSelf: dataFromSelf),
            ReactionCellModel(cellId: "5", reactionFromOthers: dataFromStranger, reactionFromSelf: dataFromSelf),
            ReactionCellModel(cellId: "6", reactionFromOthers: dataFromStranger, reactionFromSelf: dataFromSelf),
            ReactionCellModel(cellId: "7", reactionFromOthers: dataFromStranger, reactionFromSelf: dataFromSelf),
            ReactionCellModel(cellId: "8", reactionFromOthers: dataFromStranger, reactionFromSelf: dataFromSelf),
            ReactionCellModel(cellId: "9", reactionFromOthers: dataFromStranger, reactionFromSelf: dataFromSelf),
            ReactionCellModel(cellId: "10", reactionFromOthers: dataFromStranger, reactionFromSelf: dataFromSelf),
            ReactionCellModel(cellId: "11", reactionFromOthers: dataFromStranger, reactionFromSelf: dataFromSelf),
            ReactionCellModel(cellId: "12", reactionFromOthers: dataFromStranger, reactionFromSelf: dataFromSelf),
            ReactionCellModel(cellId: "13", reactionFromOthers: dataFromStranger, reactionFromSelf: dataFromSelf),
            ReactionCellModel(cellId: "14", reactionFromOthers: dataFromStranger, reactionFromSelf: dataFromSelf),
            ReactionCellModel(cellId: "15", reactionFromOthers: dataFromStranger, reactionFromSelf: dataFromSelf),
            ReactionCellModel(cellId: "16", reactionFromOthers: dataFromStranger, reactionFromSelf: dataFromSelf),
            ReactionCellModel(cellId: "17", reactionFromOthers: dataFromStranger, reactionFromSelf: dataFromSelf),
            ReactionCellModel(cellId: "18", reactionFromOthers: dataFromStranger, reactionFromSelf: dataFromSelf),
            ReactionCellModel(cellId: "19", reactionFromOthers: dataFromStranger, reactionFromSelf: dataFromSelf),
            ReactionCellModel(cellId: "20", reactionFromOthers: dataFromStranger, reactionFromSelf: dataFromSelf)
        ]
    }
}

@objc protocol ReactionPickerDelegate {
    func didRequestPickReaction(longPressGesture: UILongPressGestureRecognizer,
                                viewThatInitRequest: UIView)
    func didIncreaseReactionForCell(cellModel: ReactionCellModel)
}
