//
//  Snake.swift
//  Snake
//
//  Created by Kevin Largo on 6/30/16.
//  Copyright © 2016 xkevlar. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

enum Direction {
  case Up, Down, Left, Right
}

class Snake {
  var length = 0;
  var color = UIColor();
  var position = CGPoint(x: 0, y: 0); //the initial position of the snake's head
  var direction: Direction = .Up
  var body = [SKShapeNode]();
  var scale = 10;
  var isDead = false;
  var lost = false;
  
  init(){}
  
  init(length: Int, color: UIColor, position: CGPoint, direction: Direction) {
    self.length = length;
    self.color = color;
    self.position = position;
    self.direction = direction;

    //starting directions determine where the rest of the snake's body is placed
    switch(direction) {
    case .Up: 
      for i in 0 ..< length {
        let segment = SKShapeNode(rectOfSize: CGSize(width: scale, height: scale));
        segment.position = CGPoint(x: position.x, y: position.y - CGFloat(i * scale));
        body.append(segment);
      }
      break;
    case .Down:
      for i in 0 ..< length {
        let segment = SKShapeNode(rectOfSize: CGSize(width: scale, height: scale));
        segment.position = CGPoint(x: position.x, y: position.y + CGFloat(i * scale));
        body.append(segment);
      }
      break;
    case .Left:
      for i in 0 ..< length {
        let segment = SKShapeNode(rectOfSize: CGSize(width: scale, height: scale));
        segment.position = CGPoint(x: position.x + CGFloat(i * scale), y: position.y);
        body.append(segment);
      }
      break;
    case .Right: 
      for i in 0 ..< length {
        let segment = SKShapeNode(rectOfSize: CGSize(width: scale, height: scale));
        segment.position = CGPoint(x: position.x - CGFloat(i * scale), y: position.y);
        body.append(segment);
      }

      break;
    default: break
    }
    
    updateColor(); //first color update
  }
  
  //global variable used for updates
  var colorFlashed = false;
  var numFlashes = 0;
  
  func grow() {
    let segment = SKShapeNode(rectOfSize: CGSize(width: scale, height: scale));
    body.append(segment);
    updateColor();
  }
  
  func die() {
    if(numFlashes < 3) {
      if(colorFlashed) {
        updateColor();
        colorFlashed = false;
        numFlashes += 1;
      } else {
        flashColor();
        colorFlashed = true;
      }
    } else { //make snake disappear :(
      if(body.count > 0) {
        body[body.count - 1].removeFromParent();
        body.removeLast();
      }
      else {
        isDead = true; // :'(
      }
    }
  }
  
  //makes entire snake disappear
  func flashColor() {
    for i in 0 ..< body.count {
      body[i].fillColor = UIColor.clearColor();
    }
  }
  
  //makes snake gradient-colored
  func updateColor() {
    var alpha = CGFloat(1);
    let alphaDecrementValue = CGFloat(0.75) / CGFloat(body.count);
    var prevColor = color;
    
    for i in 0 ..< body.count {
      body[i].fillColor = prevColor.colorWithAlphaComponent(alpha);
      alpha -= alphaDecrementValue;
      prevColor = body[i].fillColor;
    }
  }
}
