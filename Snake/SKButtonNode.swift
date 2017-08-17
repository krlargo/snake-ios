//
//   SKButtonNode.swift
//  Snake
//
//  Created by Kevin Largo on 6/16/16.
//  Copyright © 2016 xkevlar. All rights reserved.
//
//  Combination of SKShapeNode (for border), SKLabelNode (for text), and SKSPriteNode (for image)

import Foundation
import SpriteKit

class SKButtonNode: SKNode {
  var shapeNode: SKShapeNode;
  var labelNode: SKLabelNode;
  var spriteNode: SKSpriteNode;
  var height: CGFloat;
  var width: CGFloat;
  var minX: CGFloat;
  var midX: CGFloat;
  var maxX: CGFloat;
  var minY: CGFloat;
  var midY: CGFloat;
  var maxY: CGFloat;
  var imageName: String;
  
  override init()
  {
    shapeNode = SKShapeNode();
    labelNode = SKLabelNode();
    spriteNode = SKSpriteNode();
    height = CGFloat();
    width = CGFloat();
    minX = CGFloat();
    midX = CGFloat();
    maxX = CGFloat();
    minY = CGFloat();
    midY = CGFloat();
    maxY = CGFloat();
    imageName = "";
    
    super.init();
  }
  
  //size of actual button
  init(width: CGFloat, height: CGFloat, cornerRadius: CGFloat) {
    shapeNode = SKShapeNode(rectOf: CGSize(width: width, height: height), cornerRadius: cornerRadius);
    labelNode = SKLabelNode(text: "");
    spriteNode = SKSpriteNode();
    
    self.width = width;
    self.height = height;


    //shape is above label
    shapeNode.zPosition = 3;
    labelNode.zPosition = 2;
    
    //center label onto button
    labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center;
    labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center;
    
    minX = 0;
    midX = 0;
    maxX = 0;
    minY = 0;
    midY = 0;
    maxY = 0;
    
    imageName = "";
    
    super.init();
    
    addChild(shapeNode);
    addChild(labelNode);
    addChild(spriteNode);
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setImage(_ imageName: String, size: CGSize) {
    spriteNode.texture = SKTexture(imageNamed: imageName);
    spriteNode.size = size;
    spriteNode.zPosition = 2; //same zPos as labelNode; BELOW shapeNode
  }
  
  func setText(_ text: String) {
    labelNode.text = text;
  }
  
  func setStroke(_ borderWidth: CGFloat, color: SKColor) {
    shapeNode.strokeColor = color;
    shapeNode.lineWidth = borderWidth;
  }
  
  func setPos(_ point: CGPoint) {
    shapeNode.position = point;
    labelNode.position = point;
    spriteNode.position = point;
    
    minX = shapeNode.position.x - width / 2;
    maxX = shapeNode.position.x + width / 2;
    midX = (minX + maxX) / 2;
    
    minY = shapeNode.position.y - height / 2;
    maxY = shapeNode.position.y + height / 2;
    midY = (minY + maxY) / 2;
  }
  
  func setFont(_ fontName: String, fontSize: CGFloat, fontColor: SKColor) {
    labelNode.fontName = fontName;
    labelNode.fontSize = fontSize;
    labelNode.fontColor = fontColor;
  }
}
