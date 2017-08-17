//
//  Snake.swift
//  Snake
//
//  Created by Kevin Largo on 6/30/16.
//

import Foundation
import SpriteKit
import UIKit

enum Direction {
  case up, down, left, right
}

class Snake {
  var length = 0;
  var color = UIColor();
  var position = CGPoint(x: 0, y: 0); //the initial position of the snake's head
  var direction = Direction.up;
  var body = [SKShapeNode]();
  var scale = 10;
  var isDead = false;
  var lost = false;
  
  init(length: Int, color: UIColor, position: CGPoint, direction: Direction) {
    self.length = length;
    self.color = color;
    self.position = position;
    self.direction = direction;

    //starting directions determine where the rest of the snake's body is placed
    switch(direction) {
    case .up:
      for i in 0 ..< length {
        let segment = SKShapeNode(rectOf: CGSize(width: scale, height: scale));
        segment.position = CGPoint(x: position.x, y: position.y - CGFloat(i * scale));
        body.append(segment);
      }
      break;
    case .down:
      for i in 0 ..< length {
        let segment = SKShapeNode(rectOf: CGSize(width: scale, height: scale));
        segment.position = CGPoint(x: position.x, y: position.y + CGFloat(i * scale));
        body.append(segment);
      }
      break;
    case .left:
      for i in 0 ..< length {
        let segment = SKShapeNode(rectOf: CGSize(width: scale, height: scale));
        segment.position = CGPoint(x: position.x + CGFloat(i * scale), y: position.y);
        body.append(segment);
      }
      break;
    case .right:
      for i in 0 ..< length {
        let segment = SKShapeNode(rectOf: CGSize(width: scale, height: scale));
        segment.position = CGPoint(x: position.x - CGFloat(i * scale), y: position.y);
        body.append(segment);
      }

      break;
    }
    
    updateColor(); //first color update
  }
  
  //global variable used for updates
  var colorFlashed = false;
  var numFlashes = 0;
  
  func grow() {
    let segment = SKShapeNode(rectOf: CGSize(width: scale, height: scale));
    body.append(segment);
    updateColor();
  }
  
  // begins snake "die" animation
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
    } else { //make snake disappear
      if(body.count > 0) {
        body[body.count - 1].removeFromParent();
        body.removeLast();
      }
      else {
        isDead = true; //
      }
    }
  }
  
  //makes snake transparent
  func flashColor() {
    for i in 0 ..< body.count {
      body[i].fillColor = UIColor.clear;
    }
  }
  
  //makes snake gradient-colored
  func updateColor() {
    var alpha = CGFloat(1);
    let alphaDecrementValue = CGFloat(0.75) / CGFloat(body.count);
    var prevColor = color;
    
    for i in 0 ..< body.count {
      body[i].fillColor = prevColor.withAlphaComponent(alpha);
      alpha -= alphaDecrementValue;
      prevColor = body[i].fillColor;
    }
  }
}
