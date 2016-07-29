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
  
  
  @IBAction func blackButtonSelected(sender: AnyObject) {
    snakeModel!.snakeColor = SKColor.blackColor();

    blackButton.layer.borderColor = UIColor.greenColor().CGColor;
    purpleButton.layer.borderColor = UIColor.whiteColor().CGColor;
    blueButton.layer.borderColor = UIColor.whiteColor().CGColor;
    greenButton.layer.borderColor = UIColor.whiteColor().CGColor;
    yellowButton.layer.borderColor = UIColor.whiteColor().CGColor;
    orangeButton.layer.borderColor = UIColor.whiteColor().CGColor;
    redButton.layer.borderColor = UIColor.whiteColor().CGColor;

  }
  
  @IBAction func purpleButtonSelected(sender: AnyObject) {
    snakeModel!.snakeColor = SKColor.purpleColor();
    
    blackButton.layer.borderColor = UIColor.whiteColor().CGColor;
    purpleButton.layer.borderColor = UIColor.greenColor().CGColor;
    blueButton.layer.borderColor = UIColor.whiteColor().CGColor;
    greenButton.layer.borderColor = UIColor.whiteColor().CGColor;
    yellowButton.layer.borderColor = UIColor.whiteColor().CGColor;
    orangeButton.layer.borderColor = UIColor.whiteColor().CGColor;
    redButton.layer.borderColor = UIColor.whiteColor().CGColor;

  }
  
  @IBAction func blueButtonSelected(sender: AnyObject) {
    snakeModel!.snakeColor = SKColor.blueColor();
    
    blackButton.layer.borderColor = UIColor.whiteColor().CGColor;
    purpleButton.layer.borderColor = UIColor.whiteColor().CGColor;
    blueButton.layer.borderColor = UIColor.greenColor().CGColor;
    greenButton.layer.borderColor = UIColor.whiteColor().CGColor;
    yellowButton.layer.borderColor = UIColor.whiteColor().CGColor;
    orangeButton.layer.borderColor = UIColor.whiteColor().CGColor;
    redButton.layer.borderColor = UIColor.whiteColor().CGColor;

  }
  
  @IBAction func greenButtonSelected(sender: AnyObject) {
    snakeModel!.snakeColor = SKColor.greenColor();
    
    blackButton.layer.borderColor = UIColor.whiteColor().CGColor;
    purpleButton.layer.borderColor = UIColor.whiteColor().CGColor;
    blueButton.layer.borderColor = UIColor.whiteColor().CGColor;
    greenButton.layer.borderColor = UIColor.greenColor().CGColor;
    yellowButton.layer.borderColor = UIColor.whiteColor().CGColor;
    orangeButton.layer.borderColor = UIColor.whiteColor().CGColor;
    redButton.layer.borderColor = UIColor.whiteColor().CGColor;

  }
  
  @IBAction func yellowButtonSelected(sender: AnyObject) {
    snakeModel!.snakeColor = SKColor.yellowColor();
    
    blackButton.layer.borderColor = UIColor.whiteColor().CGColor;
    purpleButton.layer.borderColor = UIColor.whiteColor().CGColor;
    blueButton.layer.borderColor = UIColor.whiteColor().CGColor;
    greenButton.layer.borderColor = UIColor.whiteColor().CGColor;
    yellowButton.layer.borderColor = UIColor.greenColor().CGColor;
    orangeButton.layer.borderColor = UIColor.whiteColor().CGColor;
    redButton.layer.borderColor = UIColor.whiteColor().CGColor;

  }
  
  @IBAction func orangeButtonSelected(sender: AnyObject) {
    snakeModel!.snakeColor = SKColor.orangeColor();
    
    blackButton.layer.borderColor = UIColor.whiteColor().CGColor;
    purpleButton.layer.borderColor = UIColor.whiteColor().CGColor;
    blueButton.layer.borderColor = UIColor.whiteColor().CGColor;
    greenButton.layer.borderColor = UIColor.whiteColor().CGColor;
    yellowButton.layer.borderColor = UIColor.whiteColor().CGColor;
    orangeButton.layer.borderColor = UIColor.greenColor().CGColor;
    redButton.layer.borderColor = UIColor.whiteColor().CGColor;

  }
  
  @IBAction func redButtonSelected(sender: AnyObject) {
    snakeModel!.snakeColor = SKColor.redColor();
    
    blackButton.layer.borderColor = UIColor.whiteColor().CGColor;
    purpleButton.layer.borderColor = UIColor.whiteColor().CGColor;
    blueButton.layer.borderColor = UIColor.whiteColor().CGColor;
    greenButton.layer.borderColor = UIColor.whiteColor().CGColor;
    yellowButton.layer.borderColor = UIColor.whiteColor().CGColor;
    orangeButton.layer.borderColor = UIColor.whiteColor().CGColor;
    redButton.layer.borderColor = UIColor.greenColor().CGColor;

  }
  
  @IBAction func decDifficulty(sender: AnyObject) {
    if(snakeModel!.delayRate < 7) {
      snakeModel!.delayRate += 2;
      updateDifficultyText();
    }
  }

  @IBAction func incDifficulty(sender: AnyObject) {
    if(snakeModel!.delayRate > 3) {
      snakeModel!.delayRate -= 2;
      updateDifficultyText();
    }
  }
  
  @IBAction func decScreenHeight(sender: AnyObject) {
    if(snakeModel!.fieldHeight > 200) {
      snakeModel!.fieldHeight -= 100;
      updateScreenSizeText();
    }
  }

  @IBAction func incScreenHeight(sender: AnyObject) {
    if(snakeModel!.fieldHeight < 400) {
      snakeModel!.fieldHeight += 100;
      updateScreenSizeText();
    }
  }

  @IBAction func decScoreToWin(sender: AnyObject) {
    if(snakeModel!.scoreToWin > 50) {
      snakeModel!.scoreToWin -= 10;
      scoreToWin.text = String(snakeModel!.scoreToWin);
    }
  }

  @IBAction func incScoreToWin(sender: AnyObject) {
    if(snakeModel!.scoreToWin < 2000) {
      snakeModel!.scoreToWin += 10;
      scoreToWin.text = String(snakeModel!.scoreToWin);
    }
  }

  @IBAction func decWinBy(sender: AnyObject) {
    if(snakeModel!.winBy > 0) {
      snakeModel!.winBy -= 10;
      winBy.text = String(snakeModel!.winBy);
    }
  }
  
  @IBAction func incWinBy(sender: AnyObject) {
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
    
    blackButton.layer.borderColor = UIColor.whiteColor().CGColor;
    purpleButton.layer.borderColor = UIColor.whiteColor().CGColor;
    blueButton.layer.borderColor = UIColor.whiteColor().CGColor;
    greenButton.layer.borderColor = UIColor.whiteColor().CGColor;
    yellowButton.layer.borderColor = UIColor.whiteColor().CGColor;
    orangeButton.layer.borderColor = UIColor.whiteColor().CGColor;
    redButton.layer.borderColor = UIColor.whiteColor().CGColor;
    
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