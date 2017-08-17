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
  
  @IBAction func unwindToStartScreenView(_ segue: UIStoryboardSegue) {
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //pass SnakeModel to the game
    if(segue.identifier == "toOnePlayer") {
      let onePlayerVC = segue.destination as! OnePlayerGameViewController;
      onePlayerVC.snakeModel = snakeModel;
    }
      
    else if(segue.identifier == "toTwoPlayer") {
      let twoPlayerVC = segue.destination as! TwoPlayerGameViewController;
      twoPlayerVC.snakeModel = snakeModel;
    }
      
    else if(segue.identifier == "toHighScores") {
      let highScoresVC = segue.destination as! HighScoresViewContoller;
      highScoresVC.snakeModel = snakeModel;
    }
    
    else if(segue.identifier == "toSettings") {
      let settingsVC = segue.destination as! SettingsViewController;
      settingsVC.snakeModel = snakeModel;
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

  }
}
