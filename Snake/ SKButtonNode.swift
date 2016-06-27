//
//   SKButtonNode.swift
//  Snake
//
//  Created by Kevin Largo on 6/16/16.
//  Copyright © 2016 xkevlar. All rights reserved.
//

import Foundation
import SpriteKit

class SKButtonNode: SKNode {
  var shapeNode: SKShapeNode;
  var labelNode: SKLabelNode;
  var height: CGFloat;
  var width: CGFloat;
  var minX: CGFloat;
  var midX: CGFloat;
  var maxX: CGFloat;
  var minY: CGFloat;
  var midY: CGFloat;
  var maxY: CGFloat;

  override init()
  {
    shapeNode = SKShapeNode();
    labelNode = SKLabelNode();
    height = CGFloat();
    width = CGFloat();
    minX = CGFloat();
    midX = CGFloat();
    maxX = CGFloat();
    minY = CGFloat();
    midY = CGFloat();
    maxY = CGFloat();
    
    super.init();
  }
  
  //size of actual button
//  init(rectOfSize: CGSize, cornerRadius: CGFloat) {
  init(width: CGFloat, height: CGFloat, cornerRadius: CGFloat) {
    shapeNode = SKShapeNode(rectOfSize: CGSize(width: width, height: height), cornerRadius: cornerRadius);
    labelNode = SKLabelNode(text: "");
    
    self.width = width;
    self.height = height;


    //shape is above label
    shapeNode.zPosition = 3;
    labelNode.zPosition = 2;
    
    //center label onto button
    labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center;
    labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center;
    
    minX = 0;
    midX = 0;
    maxX = 0;
    minY = 0;
    midY = 0;
    maxY = 0;
    
    super.init();
    
    addChild(shapeNode);
    addChild(labelNode);
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setText(text: String) {
    labelNode.text = text;
  }
  
  func setStroke(borderWidth: CGFloat, color: SKColor) {
    shapeNode.strokeColor = color;
    shapeNode.lineWidth = borderWidth;
  }
  
  func setPos(point: CGPoint) {
    shapeNode.position = point;
    labelNode.position = point;
    
    minX = shapeNode.position.x - width / 2;
    maxX = shapeNode.position.x + width / 2;
    midX = (minX + maxX) / 2;
    
    minY = shapeNode.position.y - height / 2;
    maxY = shapeNode.position.y + height / 2;
    midY = (minY + maxY) / 2;
  }
  
  func setFont(fontName: String, fontSize: CGFloat, fontColor: SKColor) {
    labelNode.fontName = fontName;
    labelNode.fontSize = fontSize;
    labelNode.fontColor = fontColor;
  }
}