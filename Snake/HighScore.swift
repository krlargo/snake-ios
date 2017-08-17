//
//  HighScore.swift
//  Snake
//
//  Created by Kevin Largo on 7/2/16.
//  Copyright © 2016 xkevlar. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class HighScore {
  
  var name = "";
  var score = 0;
  var position = [SKShapeNode]();
  var color = UIColor.gray;

  init(){}
  
  init(name: String, score: Int, position: [SKShapeNode], color: UIColor) {
    self.name = name;
    self.score = score;
    self.position = position;
    self.color = color;
  }
}
