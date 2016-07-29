//
//  SnakeModel.swift
//  Snake
//
//  Created by Kevin Largo on 6/16/16.
//  Copyright © 2016 xkevlar. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class SnakeModel {
  var snakeColor = SKColor();
  var highScores = [HighScore()];
  var delayRate = 5; //7 - Easy, 5 - Medium, 3 - Hard
  
  //two player settings variables
  var fieldHeight = 300;
  var scoreToWin = 100;
  var winBy = 0;

  
  init() {
    snakeColor = SKColor.grayColor();
    delayRate = 5;
    for i in 0 ..< 10 {
      highScores.append(HighScore());
    }
  }
  
  func storeScore(recentScore: Int) {
    for i in 0 ..< 10 {
      if(recentScore > highScores[i].score) {
        //shift scores down to make room for new highscore
        for j in (i ..< 10).reverse() {
          highScores[j] = highScores[j - 1];
        }

        //replace the highscore
        highScores[i].score = recentScore;
        
        return;
      }
    }
  }
}