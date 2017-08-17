//
//  SettingsViewController.swift
//  Snake
//
//  Created by Kevin Largo on 6/16/16.
//  Copyright © 2016 xkevlar. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class SettingsViewController: UIViewController {

  weak var snakeModel : SnakeModel?;

  //color buttons
  @IBOutlet weak var blackButton: UIButton!
  @IBOutlet weak var purpleButton: UIButton!
  @IBOutlet weak var blueButton: UIButton!
  @IBOutlet weak var greenButton: UIButton!
  @IBOutlet weak var yellowButton: UIButton!
  @IBOutlet weak var orangeButton: UIButton!
  @IBOutlet weak var redButton: UIButton!
  
  //one player settings values
  @IBOutlet weak var difficulty: UILabel!
  
  //two player settings values
  @IBOutlet weak var screenSize: UILabel!
  @IBOutlet weak var scoreToWin: UILabel!
  @IBOutlet weak var winBy: UILabel!
  
  
  @IBAction func blackButtonSelected(_ sender: AnyObject) {
    snakeModel!.snakeColor = SKColor.black;

    blackButton.layer.borderColor = UIColor.green.cgColor;
    purpleButton.layer.borderColor = UIColor.white.cgColor;
    blueButton.layer.borderColor = UIColor.white.cgColor;
    greenButton.layer.borderColor = UIColor.white.cgColor;
    yellowButton.layer.borderColor = UIColor.white.cgColor;
    orangeButton.layer.borderColor = UIColor.white.cgColor;
    redButton.layer.borderColor = UIColor.white.cgColor;

  }
  
  @IBAction func purpleButtonSelected(_ sender: AnyObject) {
    snakeModel!.snakeColor = SKColor.purple;
    
    blackButton.layer.borderColor = UIColor.white.cgColor;
    purpleButton.layer.borderColor = UIColor.green.cgColor;
    blueButton.layer.borderColor = UIColor.white.cgColor;
    greenButton.layer.borderColor = UIColor.white.cgColor;
    yellowButton.layer.borderColor = UIColor.white.cgColor;
    orangeButton.layer.borderColor = UIColor.white.cgColor;
    redButton.layer.borderColor = UIColor.white.cgColor;

  }
  
  @IBAction func blueButtonSelected(_ sender: AnyObject) {
    snakeModel!.snakeColor = SKColor.blue;
    
    blackButton.layer.borderColor = UIColor.white.cgColor;
    purpleButton.layer.borderColor = UIColor.white.cgColor;
    blueButton.layer.borderColor = UIColor.green.cgColor;
    greenButton.layer.borderColor = UIColor.white.cgColor;
    yellowButton.layer.borderColor = UIColor.white.cgColor;
    orangeButton.layer.borderColor = UIColor.white.cgColor;
    redButton.layer.borderColor = UIColor.white.cgColor;

  }
  
  @IBAction func greenButtonSelected(_ sender: AnyObject) {
    snakeModel!.snakeColor = SKColor.green;
    
    blackButton.layer.borderColor = UIColor.white.cgColor;
    purpleButton.layer.borderColor = UIColor.white.cgColor;
    blueButton.layer.borderColor = UIColor.white.cgColor;
    greenButton.layer.borderColor = UIColor.green.cgColor;
    yellowButton.layer.borderColor = UIColor.white.cgColor;
    orangeButton.layer.borderColor = UIColor.white.cgColor;
    redButton.layer.borderColor = UIColor.white.cgColor;

  }
  
  @IBAction func yellowButtonSelected(_ sender: AnyObject) {
    snakeModel!.snakeColor = SKColor.yellow;
    
    blackButton.layer.borderColor = UIColor.white.cgColor;
    purpleButton.layer.borderColor = UIColor.white.cgColor;
    blueButton.layer.borderColor = UIColor.white.cgColor;
    greenButton.layer.borderColor = UIColor.white.cgColor;
    yellowButton.layer.borderColor = UIColor.green.cgColor;
    orangeButton.layer.borderColor = UIColor.white.cgColor;
    redButton.layer.borderColor = UIColor.white.cgColor;

  }
  
  @IBAction func orangeButtonSelected(_ sender: AnyObject) {
    snakeModel!.snakeColor = SKColor.orange;
    
    blackButton.layer.borderColor = UIColor.white.cgColor;
    purpleButton.layer.borderColor = UIColor.white.cgColor;
    blueButton.layer.borderColor = UIColor.white.cgColor;
    greenButton.layer.borderColor = UIColor.white.cgColor;
    yellowButton.layer.borderColor = UIColor.white.cgColor;
    orangeButton.layer.borderColor = UIColor.green.cgColor;
    redButton.layer.borderColor = UIColor.white.cgColor;

  }
  
  @IBAction func redButtonSelected(_ sender: AnyObject) {
    snakeModel!.snakeColor = SKColor.red;
    
    blackButton.layer.borderColor = UIColor.white.cgColor;
    purpleButton.layer.borderColor = UIColor.white.cgColor;
    blueButton.layer.borderColor = UIColor.white.cgColor;
    greenButton.layer.borderColor = UIColor.white.cgColor;
    yellowButton.layer.borderColor = UIColor.white.cgColor;
    orangeButton.layer.borderColor = UIColor.white.cgColor;
    redButton.layer.borderColor = UIColor.green.cgColor;

  }
  
  @IBAction func decDifficulty(_ sender: AnyObject) {
    if(snakeModel!.delayRate < 7) {
      snakeModel!.delayRate += 2;
      updateDifficultyText();
    }
  }

  @IBAction func incDifficulty(_ sender: AnyObject) {
    if(snakeModel!.delayRate > 3) {
      snakeModel!.delayRate -= 2;
      updateDifficultyText();
    }
  }
  
  @IBAction func decScreenHeight(_ sender: AnyObject) {
    if(snakeModel!.fieldHeight > 200) {
      snakeModel!.fieldHeight -= 100;
      updateScreenSizeText();
    }
  }

  @IBAction func incScreenHeight(_ sender: AnyObject) {
    if(snakeModel!.fieldHeight < 400) {
      snakeModel!.fieldHeight += 100;
      updateScreenSizeText();
    }
  }

  @IBAction func decScoreToWin(_ sender: AnyObject) {
    if(snakeModel!.scoreToWin > 50) {
      snakeModel!.scoreToWin -= 10;
      scoreToWin.text = String(snakeModel!.scoreToWin);
    }
  }

  @IBAction func incScoreToWin(_ sender: AnyObject) {
    if(snakeModel!.scoreToWin < 2000) {
      snakeModel!.scoreToWin += 10;
      scoreToWin.text = String(snakeModel!.scoreToWin);
    }
  }

  @IBAction func decWinBy(_ sender: AnyObject) {
    if(snakeModel!.winBy > 0) {
      snakeModel!.winBy -= 10;
      winBy.text = String(snakeModel!.winBy);
    }
  }
  
  @IBAction func incWinBy(_ sender: AnyObject) {
    if(snakeModel!.winBy < 1000) {
      snakeModel!.winBy += 10;
      winBy.text = String(snakeModel!.winBy);
    }
  }

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    blackButton.layer.borderWidth = 2;
    purpleButton.layer.borderWidth = 2;
    blueButton.layer.borderWidth = 2;
    greenButton.layer.borderWidth = 2;
    yellowButton.layer.borderWidth = 2;
    orangeButton.layer.borderWidth = 2;
    redButton.layer.borderWidth = 2;
    
    blackButton.layer.borderColor = UIColor.white.cgColor;
    purpleButton.layer.borderColor = UIColor.white.cgColor;
    blueButton.layer.borderColor = UIColor.white.cgColor;
    greenButton.layer.borderColor = UIColor.white.cgColor;
    yellowButton.layer.borderColor = UIColor.white.cgColor;
    orangeButton.layer.borderColor = UIColor.white.cgColor;
    redButton.layer.borderColor = UIColor.white.cgColor;
    
    updateDifficultyText();
    updateScreenSizeText();
    scoreToWin.text = String(snakeModel!.scoreToWin);
    winBy.text = String(snakeModel!.winBy);
  }
  
  func updateDifficultyText() {
    switch(snakeModel!.delayRate) {
    case 7:
      difficulty.text = "EASY";
      break;
    case 5:
      difficulty.text = "NORMAL";
      break;
    case 3:
      difficulty.text = "HARD";
      break;
    default:
      break;
    }
  }
  
  func updateScreenSizeText() {
    switch(snakeModel!.fieldHeight) {
    case 200:
      screenSize.text = "SMALL";
      break;
    case 300:
      screenSize.text = "MEDIUM";
      break;
    case 400:
      screenSize.text = "LARGE";
      break;
    default:
      break;
    }
  }
}
