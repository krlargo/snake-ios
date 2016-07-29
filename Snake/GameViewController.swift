//
//  GameViewController.swift
//  Snake
//
//  Created by Kevin Largo on 6/9/16.
//  Copyright (c) 2016 xkevlar. All rights reserved.
//

import UIKit
import SpriteKit


//Directly associated with GameScene
class GameViewController: UIViewController {

  weak var snakeModel : SnakeModel?

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
        
        scene.gameViewController = self; //needed for unwinding
        
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