//
//  StartScreenViewController.swift
//  Snake
//
//  Created by Kevin Largo on 6/16/16.
//  Copyright © 2016 xkevlar. All rights reserved.
//

import Foundation
import UIKit

class StartScreenViewController: UIViewController {
  //main instantiation of SnakeModel
  var snakeModel = SnakeModel();
  
  @IBAction func unwindToStartScreenView(segue: UIStoryboardSegue) {
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //pass SnakeModel to the game
    if(segue.identifier == "toOnePlayer") {
      let onePlayerVC = segue.destinationViewController as! OnePlayerGameViewController;
      onePlayerVC.snakeModel = snakeModel;
    }
      
    else if(segue.identifier == "toTwoPlayer") {
      let twoPlayerVC = segue.destinationViewController as! TwoPlayerGameViewController;
      twoPlayerVC.snakeModel = snakeModel;
    }
      
    else if(segue.identifier == "toHighScores") {
      let highScoresVC = segue.destinationViewController as! HighScoresViewContoller;
      highScoresVC.snakeModel = snakeModel;
    }
    
    else if(segue.identifier == "toSettings") {
      let settingsVC = segue.destinationViewController as! SettingsViewController;
      settingsVC.snakeModel = snakeModel;
    }
  }

  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
}