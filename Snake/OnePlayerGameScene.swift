//
//  OnePlayerGameScene.swift
//  Snake
//
//  Created by Kevin Largo on 6/30/16.
//  Copyright © 2016 xkevlar. All rights reserved.
//

import UIKit
import SpriteKit

class OnePlayerGameScene: SKScene, SKSceneDelegate {
  weak var onePlayerGameViewController: OnePlayerGameViewController?
  
  var snake = Snake();
  var snakeColor = UIColor.grayColor(); //default color
  let startSize = 5;
  let startDirection = 3;
  let bgColor = UIColor.groupTableViewBackgroundColor();
  
  var field = SKShapeNode();
  var food = SKShapeNode();
  var scoreLabel = SKLabelNode();
  var pauseButton = SKButtonNode();

  var timer = 0;
  var score = 0;
  var delayRate = 5;
  var gamePaused = false;
  var holdSignals = false; //holds responsiveness signals so that animation can catch up
  var gameover = false;
  var gameOverPresented = false;
  
  //relative to center of frame
  var minX = CGFloat();
  var maxX = CGFloat();
  var minY = CGFloat();
  var maxY = CGFloat();
  var fieldOffset = CGFloat(100);
  var fieldWidth = 400;
  var fieldHeight = 400;
  var pixelScale = 10; //number of pixels that make a square segment
  var pixelOffset = CGFloat(5);
  
  //declare gestures
  var swipeUp = UISwipeGestureRecognizer();
  var swipeDown = UISwipeGestureRecognizer();
  var swipeLeft = UISwipeGestureRecognizer();
  var swipeRight = UISwipeGestureRecognizer();
  
  //display buttons
  var yesButton = SKButtonNode();
  var noButton = SKButtonNode();
  var pausedLabel = SKLabelNode();
  var resumeButton = SKButtonNode();
  var quitButton = SKButtonNode();
  
  //arrow buttons
  var upButton = SKButtonNode();
  var downButton = SKButtonNode();
  var leftButton = SKButtonNode();
  var rightButton = SKButtonNode();
  
  
  func swipedUp(sender:UISwipeGestureRecognizer) {
    moveUp();
  }
  
  func swipedDown(sender:UISwipeGestureRecognizer) {
    moveDown();
  }
  
  func swipedLeft(sender:UISwipeGestureRecognizer) {
    moveLeft();
  }
  
  func swipedRight(sender:UISwipeGestureRecognizer) {
    moveRight();
  }
  
  func moveUp() {
    if(holdSignals || gamePaused) {
      return;
    }
    if(snake.direction != 1) { //if not going down
      snake.direction = 0;
    }
    holdSignals = true;
  }
  
  func moveDown() {
    if(holdSignals || gamePaused) {
      return;
    }
    if(snake.direction != 0) { //if not going up
      snake.direction = 1;
    }
    holdSignals = true;
  }
  
  func moveLeft() {
    if(holdSignals || gamePaused) {
      return;
    }
    if(snake.direction != 3) { //if not going right
      snake.direction = 2;
    }
    holdSignals = true;
  }
  
  func moveRight() {
    if(holdSignals || gamePaused) {
      return;
    }
    if(snake.direction != 2) { //if not going left
      snake.direction = 3;
    }
    holdSignals = true;
  }
  
  override func didMoveToView(view: SKView) {
    snakeColor = onePlayerGameViewController!.snakeModel!.snakeColor;
    delayRate = onePlayerGameViewController!.snakeModel!.delayRate;
    initScene();
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch: AnyObject in touches{
      let location = touch.locationInNode(self) //location touched is title
      
      //reload game scene
      if(self.nodeAtPoint(location) == self.yesButton.shapeNode) {
        initScene();
      }
      
      //return to Start Screen View Controller
      if(self.nodeAtPoint(location) == self.noButton.shapeNode) {
        self.onePlayerGameViewController?.performSegueWithIdentifier("exitToStartScreen", sender: self);
      }
      
      if(self.nodeAtPoint(location) == self.pauseButton.shapeNode) {
        if(gameover) {
          return; //don't allow pausing if game over
        }
        if(gamePaused) {
          pauseButton.setText("PAUSE"); //if the game is already paused, change text to "PAUSE"
          gamePaused = false;
          removePaused();
        } else {
          pauseButton.setText("UNPAUSE");
          gamePaused = true;
          presentPaused();
        }
      }
      
      //paused game button
      if(self.nodeAtPoint(location) == self.resumeButton.shapeNode) {
        pauseButton.setText("PAUSE");
        gamePaused = false;
        removePaused();
      }
      
      if(self.nodeAtPoint(location) == self.quitButton.shapeNode) {
        self.onePlayerGameViewController?.performSegueWithIdentifier("exitToStartScreen", sender: self);
      }
      
      //arrows
      if(self.nodeAtPoint(location) == self.upButton.shapeNode) {
        moveUp();
      }
      
      if(self.nodeAtPoint(location) == self.downButton.shapeNode) {
        moveDown();
      }
      
      if(self.nodeAtPoint(location) == self.leftButton.shapeNode) {
        moveLeft();
      }
      
      if(self.nodeAtPoint(location) == self.rightButton.shapeNode) {
        moveRight();
      }
    }
  }
  
  override func update(currentTime: NSTimeInterval) {
    if(gamePaused) {
      return;
    }
    
    //used to "delay" frame rate
    if(timer < delayRate) {
      timer += 1;
      return;
    }
    timer = 0; //reset timer
    
    if(!gameover) {
      moveSnake();
      updateField();
    }
    else if(!snake.isDead){
      snake.die();
      food.removeFromParent();
    }
    else if(!gameOverPresented){
      presentGameOver();
    }
    holdSignals = false;
  }
  
  func initScene() {
    //visually reset everything
    removeAllChildren();
    snake.direction = 3;
    score = 0;
    timer = 0;
    gameover = false;
    gameOverPresented = false;
    snake.isDead = false; // :)
    
    self.backgroundColor = bgColor;
    
    initField();
    initSnake();
    initFood();
    initGestures();
    initButtons();
  }
  
  func initSnake() {
    snake = Snake(length: startSize, color: snakeColor, position: field.position, direction: startDirection);

    for i in 0 ..< snake.body.count {
      addChild(snake.body[i]);
    }
  }
  
  func initField() {
    pixelOffset = CGFloat(pixelScale) / 2;
    
    //add pixelScales to width & height to make positions centered
    field = SKShapeNode(rectOfSize: CGSize(width: fieldWidth + pixelScale, height: fieldHeight + pixelScale));
    field.fillColor = SKColor.whiteColor();
    field.strokeColor = SKColor.whiteColor();
    field.position = CGPoint(x: frame.midX, y: frame.midY + fieldOffset);
    field.zPosition = CGFloat(-1);
    addChild(field);
    
    minX = field.position.x - CGFloat(fieldWidth/2);
    maxX = field.position.x + CGFloat(fieldWidth/2);
    minY = field.position.y - CGFloat(fieldHeight/2);
    maxY = field.position.y + CGFloat(fieldHeight/2);
    
    scoreLabel = SKLabelNode(text: "SCORE: " + String(score));
    scoreLabel.position = CGPoint(x: minX, y: maxY + CGFloat(pixelScale));
    scoreLabel.fontName = "Futura";
    scoreLabel.fontSize = CGFloat(25);
    scoreLabel.fontColor = snakeColor;
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left;
    addChild(scoreLabel);
  }
  
  func initFood() {
    food = SKShapeNode(circleOfRadius: CGFloat(pixelScale/2));
    food.fillColor = SKColor.greenColor();
    food.position = randomPosition();
    food.zPosition = 3;
    addChild(food);
  }
  
  func initButtons() {
    let offsetMinY = minY - pixelOffset; //use this minY instead to account for the centering offset from the grid
    let buttonSpace = CGFloat(10);
    
    pauseButton = SKButtonNode(width: CGFloat(fieldWidth) + pixelOffset * 2, height: CGFloat(fieldHeight) / 8, cornerRadius: CGFloat(2));
    pauseButton.setText("PAUSE");
    pauseButton.setPos(CGPoint(x: field.position.x, y: offsetMinY - (pauseButton.height / 2) - buttonSpace));
    pauseButton.setFont("Futura", fontSize: CGFloat(25), fontColor: UIColor.grayColor());
    pauseButton.setStroke(2, color: snakeColor);
    
    var upDownButtonHeight = pauseButton.minY - frame.minY; //halfway between bottom of field and bottom of screen
    upDownButtonHeight -= 3 * buttonSpace; //subtract space above/between/below buttons (10 each)
    upDownButtonHeight /= 2; //half remaining space to make up button face height
    
    var upDownButtonWidth = CGFloat(fieldWidth);
    upDownButtonWidth /= 2;
    upDownButtonWidth -= 2 * buttonSpace;
    
    var leftRightButtonHeight = (pauseButton.minY - frame.minY); //space between bottom of field and bottom of screen
    leftRightButtonHeight -= 2 * buttonSpace; //subtact space above/below buttons
    
    var leftRightButtonWidth = CGFloat(fieldWidth);
    leftRightButtonWidth -= (upDownButtonWidth + buttonSpace);
    leftRightButtonWidth /= 2;
    
    upButton = SKButtonNode(width: upDownButtonWidth, height: upDownButtonHeight, cornerRadius: CGFloat(4));
    upButton.setPos(CGPoint(x: field.position.x, y: pauseButton.minY - upDownButtonHeight/2 - buttonSpace));
    upButton.setStroke(2, color: snakeColor);
    upButton.setImage("Up Button.pdf", size: CGSize(width: 54, height: 26));
    
    downButton = SKButtonNode(width: upDownButtonWidth, height: upDownButtonHeight, cornerRadius: CGFloat(4));
    downButton.setPos(CGPoint(x: field.position.x, y: upButton.shapeNode.position.y - upButton.height - buttonSpace));
    downButton.setStroke(2, color: snakeColor);
    downButton.setImage("Down Button.pdf", size: CGSize(width: 54, height: 26));
    
    leftButton = SKButtonNode(width: leftRightButtonWidth, height: leftRightButtonHeight, cornerRadius: CGFloat(4));
    leftButton.setPos(CGPoint(x: field.position.x - CGFloat(fieldWidth / 2) + (leftRightButtonWidth / 2) - pixelOffset, y: (pauseButton.minY - frame.minY) / 2));
    leftButton.setStroke(2, color: snakeColor);
    leftButton.setImage("Left Button.pdf", size: CGSize(width: 26, height: 54));
    
    rightButton = SKButtonNode(width: leftRightButtonWidth, height: leftRightButtonHeight, cornerRadius: CGFloat(4));
    rightButton.setPos(CGPoint(x: field.position.x + CGFloat(fieldWidth / 2) - (leftRightButtonWidth / 2) + pixelOffset, y: (pauseButton.minY - frame.minY) / 2));
    rightButton.setStroke(2, color: snakeColor);
    rightButton.setImage("Right Button.pdf", size: CGSize(width: 26, height: 54));
    
    addChild(upButton);
    addChild(downButton);
    addChild(leftButton);
    addChild(rightButton);
    addChild(pauseButton);
  }
  
  func initGestures() {
    //declare swipe gestures
    swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(OnePlayerGameScene.swipedUp(_:)))
    swipeUp.direction = .Up
    view!.addGestureRecognizer(swipeUp)
    
    swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(OnePlayerGameScene.swipedDown(_:)))
    swipeDown.direction = .Down
    view!.addGestureRecognizer(swipeDown)
    
    swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(OnePlayerGameScene.swipedLeft(_:)))
    swipeLeft.direction = .Left
    view!.addGestureRecognizer(swipeLeft)
    
    swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(OnePlayerGameScene.swipedRight(_:)))
    swipeRight.direction = .Right
    view!.addGestureRecognizer(swipeRight)
  }
  
  func moveSnake() {
    //move the rest of snake // 1 --> 0, 2 --> 1
    for i in (1 ..< snake.body.count).reverse() {
      snake.body[i].position = snake.body[i-1].position;
    }
    
    //move head
    switch(snake.direction) {
    case 0: //UP
      snake.body[0].position.y += CGFloat(pixelScale);
      if(snake.body[0].position.y > maxY) {
        snake.body[0].position.y = minY;
      }
      break;
    case 1: //DOWN
      snake.body[0].position.y -= CGFloat(pixelScale);
      if(snake.body[0].position.y < minY) {
        snake.body[0].position.y = maxY;
      }
      break;
    case 2: //LEFT
      snake.body[0].position.x -= CGFloat(pixelScale);
      if(snake.body[0].position.x < minX) {
        snake.body[0].position.x = maxX;
      }
      break;
    case 3: //RIGHT
      snake.body[0].position.x += CGFloat(pixelScale);
      if(snake.body[0].position.x > maxX) {
        snake.body[0].position.x = minX;
      }
      break;
    default: break
    }
  }
  
  func updateField() {
    //check if food was eaten
    if(snake.body[0].position == food.position) {
      food.position = randomPosition();
      
      //don't let food spawn in snake body location
      for i in 1 ..< snake.body.count {
        if(snake.body[i].position == food.position) {
          food.position = randomPosition();
        } else {
          break;
        }
      }
      
      //update snake appearance (length & color)
      self.snake.grow();
      self.addChild(snake.body[snake.body.count - 1]);
      
      //increment score
      self.score += 10;
      self.scoreLabel.text = "SCORE: " + String(score);
    }
    
    //check to see if we bit ourselves
    for i in 1 ..< snake.body.count {
      if(snake.body[0].position == snake.body[i].position) {
        self.gameover = true;
      }
    }
  }
  
  func randomPosition() -> CGPoint {
    let randX = CGFloat(arc4random_uniform(UInt32(fieldWidth/pixelScale))) - CGFloat(fieldWidth/2/pixelScale); //picks random int from -20 to 20
    let randY = CGFloat(arc4random_uniform(UInt32(fieldHeight/pixelScale))) - CGFloat(fieldHeight/2/pixelScale); //picks random int from -25 to 25
    return CGPoint(x: field.position.x + randX*CGFloat(pixelScale), y: field.position.y + randY*CGFloat(pixelScale));
  }
  
  func presentPaused() {
    pausedLabel = SKLabelNode(text: "PAUSED");
    pausedLabel.position = CGPoint(x: field.position.x, y: field.position.y);
    pausedLabel.zPosition = 2;
    pausedLabel.fontName = "Futura";
    pausedLabel.fontSize = CGFloat(40);
    pausedLabel.fontColor = SKColor.darkGrayColor();
    
    resumeButton = SKButtonNode(width: CGFloat(fieldWidth/3), height: 40, cornerRadius: CGFloat(2));
    resumeButton.setText("RESUME");
    resumeButton.setPos(CGPoint(x: field.position.x, y: pausedLabel.position.y - 30));
    resumeButton.setStroke(2, color: SKColor.darkGrayColor());
    resumeButton.setFont("Futura", fontSize: CGFloat(25), fontColor: SKColor.grayColor());
    
    quitButton = SKButtonNode(width: CGFloat(fieldWidth/3), height: 40, cornerRadius: CGFloat(2));
    quitButton.setText("QUIT");
    quitButton.setPos(CGPoint(x: field.position.x, y: resumeButton.labelNode.position.y - 50));
    quitButton.setStroke(2, color: SKColor.darkGrayColor());
    quitButton.setFont("Futura", fontSize: CGFloat(25), fontColor: SKColor.grayColor());

    addChild(pausedLabel);
    addChild(resumeButton);
    addChild(quitButton);
  }

  func removePaused() {
    pausedLabel.removeFromParent();
    resumeButton.removeFromParent();
    quitButton.removeFromParent();
  }

  func presentGameOver() {
    let gameOverLabel = SKLabelNode(text: "GAME OVER");
    gameOverLabel.position = CGPoint(x: field.position.x, y: field.position.y - 20);
    gameOverLabel.zPosition = 2;
    gameOverLabel.fontName = "Futura";
    gameOverLabel.fontSize = CGFloat(40);
    gameOverLabel.fontColor = SKColor.darkGrayColor();
    
    let endScoreLabel = SKLabelNode(text: String(score));
    endScoreLabel.position = CGPoint(x: field.position.x, y: gameOverLabel.position.y + 60);
    endScoreLabel.zPosition = 2;
    endScoreLabel.fontName = "Futura";
    endScoreLabel.fontSize = CGFloat(100);
    endScoreLabel.fontColor = snakeColor;
    
    let endGamePromptLabel = SKLabelNode(text: "PLAY AGAIN?");
    endGamePromptLabel.position = CGPoint(x: field.position.x, y: gameOverLabel.position.y - 30);
    endGamePromptLabel.zPosition = 2;
    endGamePromptLabel.fontName = "Futura";
    endGamePromptLabel.fontSize = CGFloat(30);
    endGamePromptLabel.fontColor = SKColor.grayColor();
    
    yesButton = SKButtonNode(width: 80, height: 40, cornerRadius: CGFloat(2));
    yesButton.setText("YES");
    yesButton.setPos(CGPoint(x: field.position.x - 50, y: endGamePromptLabel.position.y - 30));
    yesButton.setStroke(2, color: SKColor.darkGrayColor());
    yesButton.setFont("Futura", fontSize: CGFloat(25), fontColor: SKColor.grayColor());
    
    noButton = SKButtonNode(width: 80, height: 40, cornerRadius: CGFloat(2));
    noButton.setText("NO");
    noButton.setPos(CGPoint(x: field.position.x + 50, y: endGamePromptLabel.position.y - 30));
    noButton.setStroke(2, color: SKColor.darkGrayColor());
    noButton.setFont("Futura", fontSize: CGFloat(25), fontColor: SKColor.grayColor());
    
    addChild(gameOverLabel);
    addChild(endScoreLabel);
    addChild(endGamePromptLabel);
    addChild(yesButton);
    addChild(noButton);
    
    gameOverPresented = true;
  }
  
}