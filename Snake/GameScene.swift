//
//  GameScene.swift
//  Snake
//
//  Created by Kevin Largo on 6/9/16.
//  Copyright (c) 2016 xkevlar. All rights reserved.
//



import SpriteKit

class GameScene: SKScene, SKSceneDelegate {
  var border = SKShapeNode();
  var snake = [SKShapeNode()];
  var snakeColor = SKColor.redColor();
  var prevColor = SKColor();
  var alphaValue = CGFloat(1);
  var alphaDecrementValue = CGFloat(0);
  var food = SKShapeNode();
  let startSize = 5;
  var direction = 3;
  var timer = 0;
  var score = 0;
  var scoreLabel = SKLabelNode();
  var pauseButton = SKButtonNode();
  var gamePaused = false;
  var holdSignals = false; //holds signals so that animation can catch up

  weak var gameViewController : GameViewController?
  
  //gameover data
  var numFlashes = 0;
  var flashColor = 0; //0 is colored, 1 is white
  var gameover = false;
  var snakeGone = false;
  var gameOverPresented = false;
  
  //relative to center of frame
  var minX = CGFloat();
  var maxX = CGFloat();
  var minY = CGFloat();
  var maxY = CGFloat();
  var fieldCenter = CGPoint();
  var fieldWidth = 400;
  var fieldHeight = 400;
  var pixelScale = 10; //number of pixels that make a square segment
  var pixelOffset = CGFloat(5);
  
  //declare gestures
  var swipeUp = UISwipeGestureRecognizer();
  var swipeDown = UISwipeGestureRecognizer();
  var swipeLeft = UISwipeGestureRecognizer();
  var swipeRight = UISwipeGestureRecognizer();
  
  //arrow buttons
  var yesButton = SKButtonNode();
  var noButton = SKButtonNode();
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
    if(direction != 1) { //if not going down
      direction = 0;
    }
    holdSignals = true;
  }
  
  func moveDown() {
    if(holdSignals || gamePaused) {
      return;
    }
    if(direction != 0) { //if not going up
      direction = 1;
    }
    holdSignals = true;
  }
  
  func moveLeft() {
    if(holdSignals || gamePaused) {
      return;
    }
    if(direction != 3) { //if not going right
      direction = 2;
    }
    holdSignals = true;
  }
  
  func moveRight() {
    if(holdSignals || gamePaused) {
      return;
    }
    if(direction != 2) { //if not going left
      direction = 3;
    }
    holdSignals = true;
  }
  
  override func didMoveToView(view: SKView) {
    initScene();
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch: AnyObject in touches{
      let location = touch.locationInNode(self) //location touched is title
      
      //reload game scene
      if(self.nodeAtPoint(location) == self.yesButton.shapeNode) {
        initScene();
        
/*        if let scene = GameScene(fileNamed:"GameScene") {
          // Configure the view.
          let skView = self.view! as SKView
          skView.showsFPS = true
          skView.showsNodeCount = true
          
          
          /* Sprite Kit applies additional optimizations to improve rendering performance */
          skView.ignoresSiblingOrder = true
          
          /* Set the scale mode to scale to fit the window */
          scene.scaleMode = .AspectFill
          
          skView.presentScene(scene)
        }*/
      }
      
      //return to Start Screen View Controller
      if(self.nodeAtPoint(location) == self.noButton.shapeNode) {
//        self.gameViewController?.performSegueWithIdentifier("gameToStartScreen", sender: self);
        self.gameViewController?.performSegueWithIdentifier("exitToStartScreen", sender: self);
      }
      
      if(self.nodeAtPoint(location) == self.pauseButton.shapeNode) {
        if(gameover) {
          return; //don't allow pausing if game over
        }
        if(gamePaused) {
          pauseButton.setText("PAUSE"); //if the game is already paused, change text to "PAUSE"
          gamePaused = false;
        } else {
          pauseButton.setText("UNPAUSE");
          gamePaused = true;
        }
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
    if(timer < 5) {
      timer += 1;
      return;
    }
    timer = 0; //reset timer

    if(!gameover) {
      updateColor();
      moveSnake();
      updateField();
    }
    else if(!snakeGone){
      killSnake();
    }
    else if(!gameOverPresented){
      presentGameOver();
    }
    holdSignals = false;
  }

  func initScene() {
    //reset
    removeAllChildren();
    direction = 3;
    flashColor = 0;
    numFlashes = 0;
    score = 0;
    timer = 0;
    gameover = false;
    snakeGone = false;
    gameOverPresented = false;
    
    initField();
    initSnake();
    initGestures();
    initButtons();
  }
  
  func initSnake() {
    snake.removeAll();
    
    for i in 0 ..< startSize {
      let segment = SKShapeNode(rectOfSize: CGSize(width: pixelScale, height: pixelScale));
      segment.position = CGPoint(x: fieldCenter.x - CGFloat(i * pixelScale), y: fieldCenter.y);
//      if(i == 0) {
//        segment.zPosition = 1; //head is above rest of body
//        segment.fillColor = snakeColor;
//        prevColor = snakeColor;
//      } else {
//        segment.fillColor = nextColor();
///      }
      snake.append(segment);
      addChild(snake[i]);
    }
  }
  
  func initField() {
    pixelOffset = CGFloat(pixelScale) / 2;
    
    fieldCenter = CGPoint(x: frame.midX, y: frame.midY + 100); //needs to be here; cannot initialize with frame in declaration
    minX = fieldCenter.x - CGFloat(fieldWidth/2);
    maxX = fieldCenter.x + CGFloat(fieldWidth/2);
    minY = fieldCenter.y - CGFloat(fieldHeight/2);
    maxY = fieldCenter.y + CGFloat(fieldHeight/2);

    //add pixelScales to width & height to make positions centered
    border = SKShapeNode(rectOfSize: CGSize(width: fieldWidth + pixelScale, height: fieldHeight + pixelScale));
    border.fillColor = SKColor.whiteColor();
    border.strokeColor = SKColor.whiteColor();
    border.position = fieldCenter;
    border.zPosition = CGFloat(-1);
    addChild(border);
    
    food = SKShapeNode(circleOfRadius: CGFloat(pixelScale/2));
    food.fillColor = SKColor.greenColor();
    food.position = randomPosition();
    food.zPosition = 3;
    addChild(food);
    
    scoreLabel = SKLabelNode(text: "SCORE: " + String(score));
    scoreLabel.position = CGPoint(x: minX, y: maxY + CGFloat(pixelScale));
    scoreLabel.fontName = "Futura";
    scoreLabel.fontSize = CGFloat(25);
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left;
    addChild(scoreLabel);
  }
  
  func initButtons() {
    let offsetMinY = minY - pixelOffset; //use this minY instead to account for the centering offset from the grid
    let buttonSpace = CGFloat(10);
    
    pauseButton = SKButtonNode(width: CGFloat(fieldWidth) + pixelOffset * 2, height: CGFloat(fieldHeight) / 8, cornerRadius: CGFloat(2));
    pauseButton.setText("PAUSE");
    pauseButton.setPos(CGPoint(x: fieldCenter.x, y: offsetMinY - (pauseButton.height / 2) - buttonSpace));
    pauseButton.setFont("Futura", fontSize: CGFloat(25), fontColor: SKColor.whiteColor());
    pauseButton.setStroke(2, color: SKColor.whiteColor());
    
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
    
    upButton = SKButtonNode(width: upDownButtonWidth, height: upDownButtonHeight, cornerRadius: CGFloat(2));
    upButton.setText("UP");
    upButton.setPos(CGPoint(x: fieldCenter.x, y: pauseButton.minY - upDownButtonHeight/2 - buttonSpace));
    upButton.setFont("Futura", fontSize: CGFloat(25), fontColor: SKColor.whiteColor());
    upButton.setStroke(2, color: SKColor.whiteColor());
    
    downButton = SKButtonNode(width: upDownButtonWidth, height: upDownButtonHeight, cornerRadius: CGFloat(2));
    downButton.setText("DOWN");
    downButton.setPos(CGPoint(x: fieldCenter.x, y: upButton.shapeNode.position.y - upButton.height - buttonSpace)); //10 pixels button upButton
    downButton.setFont("Futura", fontSize: CGFloat(25), fontColor: SKColor.whiteColor());
    downButton.setStroke(2, color: SKColor.whiteColor());
    
    leftButton = SKButtonNode(width: leftRightButtonWidth, height: leftRightButtonHeight, cornerRadius: CGFloat(2));
    leftButton.setText("LEFT");
    leftButton.setPos(CGPoint(x: fieldCenter.x - CGFloat(fieldWidth / 2) + (leftRightButtonWidth / 2) - pixelOffset, y: (pauseButton.minY - frame.minY) / 2));
    leftButton.setFont("Futura", fontSize: CGFloat(25), fontColor: SKColor.whiteColor());
    leftButton.setStroke(2, color: SKColor.whiteColor());
    
    rightButton = SKButtonNode(width: leftRightButtonWidth, height: leftRightButtonHeight, cornerRadius: CGFloat(2));
    rightButton.setText("RIGHT");
    rightButton.setPos(CGPoint(x: fieldCenter.x + CGFloat(fieldWidth / 2) - (leftRightButtonWidth / 2) + pixelOffset, y: (pauseButton.minY - frame.minY) / 2));
    rightButton.setFont("Futura", fontSize: CGFloat(25), fontColor: SKColor.whiteColor());
    rightButton.setStroke(2, color: SKColor.whiteColor());
    
    addChild(upButton);
    addChild(downButton);
    addChild(leftButton);
    addChild(rightButton);
    addChild(pauseButton);
  }
  
  func initGestures() {
    //declare swipe gestures
    swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedUp(_:)))
    swipeUp.direction = .Up
    view!.addGestureRecognizer(swipeUp)
    
    swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedDown(_:)))
    swipeDown.direction = .Down
    view!.addGestureRecognizer(swipeDown)
    
    swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedLeft(_:)))
    swipeLeft.direction = .Left
    view!.addGestureRecognizer(swipeLeft)
    
    swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedRight(_:)))
    swipeRight.direction = .Right
    view!.addGestureRecognizer(swipeRight)
  }
  
  func moveSnake() {
    //move the rest of snake // 1 --> 0, 2 --> 1
    for i in (1 ..< snake.count).reverse() {
      snake[i].position = snake[i-1].position;
    }
    
    //move head
    switch(direction) {
    case 0: //UP
      snake[0].position.y += CGFloat(pixelScale);
      if(snake[0].position.y > maxY) {
        snake[0].position.y = minY;
      }
      break;
    case 1: //DOWN
      snake[0].position.y -= CGFloat(pixelScale);
      if(snake[0].position.y < minY) {
        snake[0].position.y = maxY;
      }
      break;
    case 2: //LEFT
      snake[0].position.x -= CGFloat(pixelScale);
      if(snake[0].position.x < minX) {
        snake[0].position.x = maxX;
      }
      break;
    case 3: //RIGHT
      snake[0].position.x += CGFloat(pixelScale);
      if(snake[0].position.x > maxX) {
        snake[0].position.x = minX;
      }
      break;
    default: break
    }
  }
  
  func updateField() {
    //check if food was eaten
    if(snake[0].position == food.position) {
      food.position = randomPosition();
      
      //don't let food spawn in snake body location
      for i in 1 ..< snake.count {
        if(snake[i].position == food.position) {
          food.position = randomPosition();
        }
      }
      
      //increase snake length
      let segment = SKShapeNode(rectOfSize: CGSize(width: pixelScale, height:pixelScale));
      snake.append(segment);
      addChild(snake[snake.count - 1]);

      //increment score
      score += 10;
      scoreLabel.text = "SCORE: " + String(score);
    }
    
    //check to see if we bit ourselves
    for i in 1 ..< snake.count {
      if(snake[0].position == snake[i].position) {
        self.gameover = true;
      }
    }
  }
  
  func randomPosition() -> CGPoint {
    let randX = CGFloat(arc4random_uniform(UInt32(fieldWidth/pixelScale))) - CGFloat(fieldWidth/2/pixelScale); //picks random int from -20 to 20
    let randY = CGFloat(arc4random_uniform(UInt32(fieldHeight/pixelScale))) - CGFloat(fieldHeight/2/pixelScale); //picks random int from -25 to 25
    return CGPoint(x: fieldCenter.x + randX*CGFloat(pixelScale), y: fieldCenter.y + randY*CGFloat(pixelScale));
  }
  
  func killSnake() {
    //flash by moving border above/below everything repeatedly
    if(numFlashes < 3) {
      if(flashColor == 0) {
        border.zPosition = 10; //place on top of everything
        flashColor = 1; //color is white
      }
      else {
        border.zPosition = -1;
        flashColor = 0; //color is blue
        numFlashes += 1;
      }
    }
    else { //make snake disappear :(
      food.removeFromParent(); //remove food too :[
      if(snake.count > 0) {
        snake[snake.count - 1].removeFromParent();
        snake.removeLast();
      }
      else {
        snakeGone = true; // :'(
      }
    }
  }
  
  func presentGameOver() {
    let gameOverLabel = SKLabelNode(text: "GAME OVER");
    gameOverLabel.position = CGPoint(x: fieldCenter.x, y: fieldCenter.y - 20);
    gameOverLabel.zPosition = 2;
    gameOverLabel.fontName = "Futura";
    gameOverLabel.fontSize = CGFloat(40);
    gameOverLabel.fontColor = SKColor.darkGrayColor();
    
    let endScoreLabel = SKLabelNode(text: String(score));
    endScoreLabel.position = CGPoint(x: fieldCenter.x, y: gameOverLabel.position.y + 60);
    endScoreLabel.zPosition = 2;
    endScoreLabel.fontName = "Futura";
    endScoreLabel.fontSize = CGFloat(100);
    endScoreLabel.fontColor = SKColor.grayColor();
    
    let endGamePromptLabel = SKLabelNode(text: "PLAY AGAIN?");
    endGamePromptLabel.position = CGPoint(x: fieldCenter.x, y: gameOverLabel.position.y - 30);
    endGamePromptLabel.zPosition = 2;
    endGamePromptLabel.fontName = "Futura";
    endGamePromptLabel.fontSize = CGFloat(30);
    endGamePromptLabel.fontColor = SKColor.grayColor();
    
    yesButton = SKButtonNode(width: 80, height: 40, cornerRadius: CGFloat(2));
    yesButton.setText("YES");
    yesButton.setPos(CGPoint(x: fieldCenter.x - 50, y: endGamePromptLabel.position.y - 30));
    yesButton.setStroke(1, color: SKColor.darkGrayColor());
    yesButton.setFont("Futura", fontSize: CGFloat(25), fontColor: SKColor.grayColor());
    
    noButton = SKButtonNode(width: 80, height: 40, cornerRadius: CGFloat(2));
    noButton.setText("NO");
    noButton.setPos(CGPoint(x: fieldCenter.x + 50, y: endGamePromptLabel.position.y - 30));
    noButton.setStroke(1, color: SKColor.darkGrayColor());
    noButton.setFont("Futura", fontSize: CGFloat(25), fontColor: SKColor.grayColor());
    
    addChild(gameOverLabel);
    addChild(endScoreLabel);
    addChild(endGamePromptLabel);
    addChild(yesButton);
    addChild(noButton);

    gameOverPresented = true;
  }
  
  //from head to tail will range from alpha:1 to alpha:0.25
  func updateColor() {
    alphaValue = 1;
    alphaDecrementValue = CGFloat(0.75) / CGFloat(snake.count);
    prevColor = snakeColor;
    
    for i in 0 ..< snake.count {
      snake[i].fillColor = prevColor.colorWithAlphaComponent(alphaValue);
      alphaValue -= alphaDecrementValue;
      prevColor = snake[i].fillColor;
    }
  }
}