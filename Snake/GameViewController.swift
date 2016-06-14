//
//  GameViewController.swift
//  Snake
//
//  Created by Kevin Largo on 6/9/16.
//  Copyright (c) 2016 xkevlar. All rights reserved.
//

/*
 - Responsible for managing what UIObjects do
 - Contains instantiation of SnakeGameModel
*/

import UIKit
import SpriteKit

class GameViewController: UIViewController {
  //var scene: GameScene!
  var scene = GameScene()
  
  @IBOutlet weak var TestText: UILabel!
  
  @IBAction func MoveUp(sender: AnyObject) {
//    if(scene.direction != 1) { //can't move up if going down
      TestText.text = "UP";
      scene.direction = 0;
//    }
  }

  @IBAction func MoveDown(sender: AnyObject) {
//    if(scene.direction != 0) { //can't move down if going up
      TestText.text = "DOWN"
      scene.direction = 1;
//    }
  }

  @IBAction func MoveLeft(sender: AnyObject) {
//    if(scene.direction != 3) { //can't move left if going right
      TestText.text = "LEFT"
      scene.direction = 2;
//    }
  }
  
  @IBAction func MoveRight(sender: AnyObject) {
//    if(scene.direction != 2) { //can't move right if going left
      TestText.text = "RIGHT"
      scene.direction = 3;
//    }
  }
  
    override func viewDidLoad() {
      super.viewDidLoad()
      
      if let scene = GameScene(fileNamed:"GameScene") {
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
      }
    }
  
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
