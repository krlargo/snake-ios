//
//  GameScene.swift
//  Snake
//
//  Created by Kevin Largo on 6/9/16.
//  Copyright (c) 2016 xkevlar. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
  var snake = [SKShapeNode()];
  var startSize = 5;
  var direction = 3;
  var timer = 0;
  
  //relative to center of frame
  var minY = CGFloat(0);
  var maxY = CGFloat(0);
  var minX = CGFloat(0);
  var maxX = CGFloat(0);
  
  var someView: UIView
  
  override func didMoveToView(view: SKView) {
    initSnake();
  }

  /*override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in touches {
      let location = touch.locationInNode(self)
      
//      let sprite = SKSpriteNode(imageNamed:"Spaceship")
      let sprite = SKShapeNode(rectOfSize: CGSize(width: 10, height:10));
      
      sprite.fillColor = SKColor.blueColor();
      sprite.position = location;
      
      //let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
      let action = SKAction.moveTo(location, duration: 1);
      
      snake[0].runAction(action);
    }
  }*/
  
  override func swipe
  
  override func update(currentTime: NSTimeInterval) {
    //used to "delay" frame rate
    if(timer < 5) {
      timer += 1;
      return;
    }
    timer = 0; //reset timer

    //move the rest of snake // 1 --> 0, 2 --> 1
    for i in (1 ..< snake.count).reverse() {
      snake[i].position = snake[i-1].position;
    }

    //move head
    switch(direction) {
      case 0: //UP
        snake[0].position.y += 10;
        if(snake[0].position.y > maxY) {
          snake[0].position.y = minY;
        }
        break;
      case 1: //DOWN
        snake[0].position.y -= 10;
        if(snake[0].position.y < minY) {
          snake[0].position.y = maxY;
        }
        break;
      case 2: //LEFT
        snake[0].position.x -= 10;
        if(snake[0].position.x < minX) {
          snake[0].position.x = maxX;
        }
        break;
      case 3: //RIGHT
        snake[0].position.x += 10;
        if(snake[0].position.x > maxX) {
          snake[0].position.x = minX;
        }
        break;
      default: break
    }

  }

  func initSnake() {
    snake[0] = SKShapeNode(rectOfSize: CGSize(width:10, height:10));
    snake[0].fillColor = SKColor.redColor(); //color the head
    snake[0].position = CGPoint(x: frame.width/2, y: frame.height/2);
    addChild(snake[0]);
      
    for i in 1 ..< startSize {
      let segment = SKShapeNode(rectOfSize: CGSize(width: 10, height:10));
      segment.position = CGPoint(x: frame.width/2 - CGFloat(i*10), y: frame.height/2);
      segment.fillColor = SKColor.blueColor();
      snake.append(segment);
      addChild(snake[i]);
    }
    
    let border = SKShapeNode(rectOfSize: CGSize(width: 410, height: 470));
    border.strokeColor = SKColor.whiteColor();
    border.position = CGPoint(x: frame.width/2, y: frame.height/2 + CGFloat(50));
    border.zPosition = CGFloat(-1);
    addChild(border);
    
    minX = frame.width/2 - 200;
    maxX = frame.width/2 + 200
    minY = frame.height/2 - 180
    maxY = frame.height/2 + 280
  }
}
