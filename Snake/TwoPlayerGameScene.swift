//
//  TwoPlayerGameScene.swift
//  Snake
//
//  Created by Kevin Largo on 6/9/16.
//  Copyright (c) 2016 xkevlar. All rights reserved.
//

import SpriteKit

class TwoPlayerGameScene: SKScene, SKSceneDelegate {
    weak var twoPlayerGameViewController: TwoPlayerGameViewController?
    
    var score1 = 0;
    var score2 = 0;
    var scoreToWin = 100;
    var winBy = 0;
    
    var score1Label = SKLabelNode();
    var score2Label = SKLabelNode();
    
    var snake1: Snake!;
    var snake2: Snake!;
    let startSize = 5;
    let bgColor = UIColor.groupTableViewBackground;
    
    
    //field & food shouldn't be classes since they're just shapenodes
    var field = SKShapeNode();
    var food = SKShapeNode();
    
    var timer = 0;
    var gamePaused = false;
    var gameover = false;
    var gameOverPresented = false;
    var lossEvaluated = false;
    
    //relative to center of frame
    var minX = CGFloat();
    var maxX = CGFloat();
    var minY = CGFloat();
    var maxY = CGFloat();
    var fieldOffset = CGFloat(0);
    var fieldWidth = 400;
    var fieldHeight = 300;
    var fieldHeightMultiplier = 20; //from previous settings string
    var pixelScale = 10; //number of pixels that make a square segment
    var pixelOffset = CGFloat(5);
    
    //arrow buttons
    var yesButton = SKButtonNode();
    var noButton = SKButtonNode();
    
    var upButton1 = SKButtonNode();
    var downButton1 = SKButtonNode();
    var leftButton1 = SKButtonNode();
    var rightButton1 = SKButtonNode();
    
    var downButton2 = SKButtonNode();
    var upButton2 = SKButtonNode();
    var rightButton2 = SKButtonNode();
    var leftButton2 = SKButtonNode();
    
    //"mutex" so that controls don't beat animation
    var holdSignals1 = false;
    var holdSignals2 = false;
    
    //snake 1 buttons
    func moveUp1() {
        if(holdSignals1 || gamePaused) {
            return;
        }
        if(snake1.direction != .down) { //if not going down
            snake1.direction = .up;
        }
        holdSignals1 = true;
    }
    
    func moveDown1() {
        if(holdSignals1 || gamePaused) {
            return;
        }
        if(snake1.direction != .up) { //if not going up
            snake1.direction = .down;
        }
        holdSignals1 = true;
    }
    
    func moveLeft1() {
        if(holdSignals1 || gamePaused) {
            return;
        }
        if(snake1.direction != .right) { //if not going right
            snake1.direction = .left;
        }
        holdSignals1 = true;
    }
    
    func moveRight1() {
        if(holdSignals1 || gamePaused) {
            return;
        }
        if(snake1.direction != .left) { //if not going left
            snake1.direction = .right;
        }
        holdSignals1 = true;
    }
    
    //snake 2 buttons
    func moveUp2() {
        if(holdSignals2 || gamePaused) {
            return;
        }
        if(snake2.direction != .down) { //if not going down
            snake2.direction = .up;
        }
        holdSignals2 = true;
    }
    
    func moveDown2() {
        if(holdSignals2 || gamePaused) {
            return;
        }
        if(snake2.direction != .up) { //if not going up
            snake2.direction = .down;
        }
        holdSignals2 = true;
    }
    
    func moveLeft2() {
        if(holdSignals2 || gamePaused) {
            return;
        }
        if(snake2.direction != .right) { //if not going right
            snake2.direction = .left;
        }
        holdSignals2 = true;
    }
    
    func moveRight2() {
        if(holdSignals2 || gamePaused) {
            return;
        }
        if(snake2.direction != .left) { //if not going left
            snake2.direction = .right;
        }
        holdSignals2 = true;
    }
    
    override func didMove(to view: SKView) {
        scoreToWin = twoPlayerGameViewController!.snakeModel!.scoreToWin;
        winBy = twoPlayerGameViewController!.snakeModel!.winBy;
        fieldHeight = twoPlayerGameViewController!.snakeModel!.fieldHeight;
        
        initScene();
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let location = touch.location(in: self) //location touched is title
            
            //reload game scene
            if(self.atPoint(location) == self.yesButton.shapeNode) {
                initScene();
                gamePaused = true; //req due to game pausing on restart; unpauses as soon as next rounds starts
            }
            
            //return to Start Screen View Controller
            if(self.atPoint(location) == self.noButton.shapeNode) {
                self.twoPlayerGameViewController?.performSegue(withIdentifier: "exitToStartScreen", sender: self);
            }
            
            if(self.atPoint(location) == self.field) {
                if(gameover) {
                    return; //don't allow pausing if game over
                }
                if(gamePaused) {
                    self.field.fillColor = UIColor.white;
                    gamePaused = false;
                } else {
                    self.field.fillColor = UIColor.lightGray.withAlphaComponent(0.1);
                    gamePaused = true;
                }
            }
            
            //arrows
            if(self.atPoint(location) == self.upButton1.shapeNode) {
                moveUp1();
            }
            
            if(self.atPoint(location) == self.downButton1.shapeNode) {
                moveDown1();
            }
            
            if(self.atPoint(location) == self.leftButton1.shapeNode) {
                moveLeft1();
            }
            
            if(self.atPoint(location) == self.rightButton1.shapeNode) {
                moveRight1();
            }
            
            if(self.atPoint(location) == self.downButton2.shapeNode) {
                moveUp2();
            }
            
            if(self.atPoint(location) == self.upButton2.shapeNode) {
                moveDown2();
            }
            
            if(self.atPoint(location) == self.rightButton2.shapeNode) {
                moveLeft2();
            }
            
            if(self.atPoint(location) == self.leftButton2.shapeNode) {
                moveRight2();
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
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
            moveSnake();
            updateField();
        }
        else if(snake1.lost && !lossEvaluated) {
            if(!snake1.isDead) {
                snake1.die();
                food.removeFromParent();
            } else {
                lossEvaluated = true;
            }
        }
        else if(snake2.lost && !lossEvaluated) {
            if(!snake2.isDead) {
                snake2.die();
                food.removeFromParent();
            } else {
                lossEvaluated = true;
            }
        }
        else if(!gameOverPresented) {
            presentGameOver();
        }
        holdSignals1 = false;
        holdSignals2 = false;
    }
    
    func initScene() {
        //visually reset everything
        removeAllChildren();
        timer = 0;
        score1 = 0;
        score2 = 0;
        gameover = false;
        gameOverPresented = false;
        lossEvaluated = false;
        
        self.backgroundColor = bgColor;
        
        initField(); //comes before snake because snake's position is relative to field
        initSnake();
        initLabels();
        initFood();
        initButtons();
    }
    
    func initSnake() {
        snake1 = Snake(length: startSize, color: UIColor.red, position: CGPoint(x: field.position.x, y: field.position.y - CGFloat(pixelScale)), direction: .right);
        
        snake2 = Snake(length: startSize, color: UIColor.blue, position: CGPoint(x: field.position.x, y: field.position.y + CGFloat(pixelScale)), direction: .left);
        
        for i in 0 ..< startSize {
            addChild(snake1.body[i]);
            addChild(snake2.body[i]);
        }
        
        snake1.isDead = false;
        snake1.lost = false;
        snake2.isDead = false;
        snake2.lost = false;
    }
    
    func initLabels() {
        score1 = 0;
        score2 = 0;
        
        score1Label = SKLabelNode(text: "SCORE: " + String(score1));
        score1Label.position = CGPoint(x: minX + CGFloat(4), y: minY + CGFloat(5));
        score1Label.zPosition = 4;
        score1Label.fontName = "Futura";
        score1Label.fontSize = CGFloat(20);
        score1Label.fontColor = UIColor.red.withAlphaComponent(0.7);
        score1Label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left;
        
        score2Label = SKLabelNode(text: "SCORE: " + String(score2));
        score2Label.position = CGPoint(x: maxX - CGFloat(4), y: maxY - CGFloat(5));
        score2Label.zPosition = 4;
        score2Label.zRotation = CGFloat(Double.pi);
        score2Label.fontName = "Futura";
        score2Label.fontSize = CGFloat(20);
        score2Label.fontColor = UIColor.blue.withAlphaComponent(0.7);
        score2Label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left;
        
        addChild(score1Label);
        addChild(score2Label);
    }
    
    func initField() {
        pixelOffset = CGFloat(pixelScale) / 2;
        
        //add pixelScales to width & height to make positions centered
        field = SKShapeNode(rectOf: CGSize(width: fieldWidth + pixelScale, height: fieldHeight + pixelScale));
        field.fillColor = SKColor.white;
        field.strokeColor = SKColor.white;
        field.position = CGPoint(x: frame.midX, y: frame.midY + fieldOffset);
        field.zPosition = CGFloat(-1);
        addChild(field);
        
        minX = field.position.x - CGFloat(fieldWidth/2);
        maxX = field.position.x + CGFloat(fieldWidth/2);
        minY = field.position.y - CGFloat(fieldHeight/2);
        maxY = field.position.y + CGFloat(fieldHeight/2);
    }
    
    func initFood() {
        food = SKShapeNode(circleOfRadius: CGFloat(pixelScale/2));
        food.fillColor = SKColor.green;
        food.position = randomPosition();
        food.zPosition = 3;
        addChild(food);
    }
    
    func initButtons() {
        //variable constraints
        let offsetMinY = minY - pixelOffset; //use this minY instead to account for the centering offset from the grid
        let offsetMaxY = maxY + pixelOffset; //used for space above field
        let buttonSpace = CGFloat(10);
        
        var upDownButtonHeight = offsetMinY - frame.minY; //halfway between bottom of field and bottom of screen
        upDownButtonHeight -= 3 * buttonSpace; //subtract space above/between/below buttons (10 each)
        upDownButtonHeight /= 2; //half remaining space to make up button face height
        
        var upDownButtonWidth = CGFloat(fieldWidth);
        upDownButtonWidth /= 2;
        upDownButtonWidth -= 2 * buttonSpace;
        
        var leftRightButtonHeight = (offsetMinY - frame.minY); //space between bottom of field and bottom of screen
        leftRightButtonHeight -= 2 * buttonSpace; //subtact space above/below buttons
        
        var leftRightButtonWidth = CGFloat(fieldWidth);
        leftRightButtonWidth -= (upDownButtonWidth + buttonSpace);
        leftRightButtonWidth /= 2;
        
        //buttons for snake1
        upButton1 = SKButtonNode(width: upDownButtonWidth, height: upDownButtonHeight, cornerRadius: CGFloat(4));
        upButton1.setPos(CGPoint(x: field.position.x, y: offsetMinY - upDownButtonHeight/2 - buttonSpace));
        upButton1.setStroke(2, color: UIColor.red);
        upButton1.setImage("Up Button.pdf", size: CGSize(width: 54, height: 26));
        
        downButton1 = SKButtonNode(width: upDownButtonWidth, height: upDownButtonHeight, cornerRadius: CGFloat(4));
        downButton1.setPos(CGPoint(x: field.position.x, y: upButton1.shapeNode.position.y - upButton1.height - buttonSpace)); //10 pixels button upButton
        downButton1.setStroke(2, color: UIColor.red);
        downButton1.setImage("Down Button.pdf", size: CGSize(width: 54, height: 26));
        
        leftButton1 = SKButtonNode(width: leftRightButtonWidth, height: leftRightButtonHeight, cornerRadius: CGFloat(4));
        leftButton1.setPos(CGPoint(x: field.position.x - CGFloat(fieldWidth / 2) + (leftRightButtonWidth / 2) - pixelOffset, y: (offsetMinY - frame.minY) / 2));
        leftButton1.setStroke(2, color: UIColor.red);
        leftButton1.setImage("Left Button.pdf", size: CGSize(width: 26, height: 54));
        
        
        rightButton1 = SKButtonNode(width: leftRightButtonWidth, height: leftRightButtonHeight, cornerRadius: CGFloat(4));
        rightButton1.setPos(CGPoint(x: field.position.x + CGFloat(fieldWidth / 2) - (leftRightButtonWidth / 2) + pixelOffset, y: (offsetMinY - frame.minY) / 2));
        rightButton1.setStroke(2, color: UIColor.red);
        rightButton1.setImage("Right Button.pdf", size: CGSize(width: 26, height: 54));
        
        
        addChild(upButton1);
        addChild(downButton1);
        addChild(leftButton1);
        addChild(rightButton1);
        
        //buttons for snake2
        upButton2 = SKButtonNode(width: upDownButtonWidth, height: upDownButtonHeight, cornerRadius: CGFloat(4));
        upButton2.setPos(CGPoint(x: field.position.x, y: offsetMaxY + upDownButtonHeight/2 + buttonSpace));
        upButton2.setStroke(2, color: UIColor.blue);
        upButton2.setImage("Down Button.pdf", size: CGSize(width: 54, height: 26)); //absolute down
        upButton2.labelNode.zRotation = CGFloat(Double.pi);
        
        downButton2 = SKButtonNode(width: upDownButtonWidth, height: upDownButtonHeight, cornerRadius: CGFloat(4));
        downButton2.setPos(CGPoint(x: field.position.x, y: upButton2.shapeNode.position.y + downButton1.height + buttonSpace));
        downButton2.setStroke(2, color: UIColor.blue);
        downButton2.setImage("Up Button.pdf", size: CGSize(width: 54, height: 26)); //absolute up
        downButton2.labelNode.zRotation = CGFloat(Double.pi);
        
        
        rightButton2 = SKButtonNode(width: leftRightButtonWidth, height: leftRightButtonHeight, cornerRadius: CGFloat(4));
        rightButton2.setPos(CGPoint(x: field.position.x - CGFloat(fieldWidth / 2) + (leftRightButtonWidth / 2) - pixelOffset, y: (offsetMaxY + frame.maxY) / 2));
        rightButton2.setStroke(2, color: UIColor.blue);
        rightButton2.setImage("Left Button.pdf", size: CGSize(width: 26, height: 54)); //absolute left
        rightButton2.labelNode.zRotation = CGFloat(Double.pi);
        
        
        leftButton2 = SKButtonNode(width: leftRightButtonWidth, height: leftRightButtonHeight, cornerRadius: CGFloat(4));
        leftButton2.setPos(CGPoint(x: field.position.x + CGFloat(fieldWidth / 2) - (leftRightButtonWidth / 2) + pixelOffset, y: (offsetMaxY + frame.maxY) / 2));
        leftButton2.setStroke(2, color: UIColor.blue);
        leftButton2.setImage("Right Button.pdf", size: CGSize(width: 26, height: 54)); //absolute right
        leftButton2.labelNode.zRotation = CGFloat(Double.pi);
        
        addChild(downButton2);
        addChild(upButton2);
        addChild(rightButton2);
        addChild(leftButton2);
    }
    
    func moveSnake() {
        //move snake1
        for i in (1 ..< snake1.body.count).reversed() {
            snake1.body[i].position = snake1.body[i-1].position;
        }
        
        switch(snake1.direction) {
        case .up: //UP
            snake1.body[0].position.y += CGFloat(pixelScale);
            if(snake1.body[0].position.y > maxY) {
                snake1.body[0].position.y = minY;
            }
            break;
        case .down: //DOWN
            snake1.body[0].position.y -= CGFloat(pixelScale);
            if(snake1.body[0].position.y < minY) {
                snake1.body[0].position.y = maxY;
            }
            break;
        case .left: //LEFT
            snake1.body[0].position.x -= CGFloat(pixelScale);
            if(snake1.body[0].position.x < minX) {
                snake1.body[0].position.x = maxX;
            }
            break;
        case .right: //RIGHT
            snake1.body[0].position.x += CGFloat(pixelScale);
            if(snake1.body[0].position.x > maxX) {
                snake1.body[0].position.x = minX;
            }
            break;
        }
        
        //move snake2
        for i in (1 ..< snake2.body.count).reversed() {
            snake2.body[i].position = snake2.body[i-1].position;
        }
        
        switch(snake2.direction) {
        case .up: //UP
            snake2.body[0].position.y += CGFloat(pixelScale);
            if(snake2.body[0].position.y > maxY) {
                snake2.body[0].position.y = minY;
            }
            break;
        case .down: //DOWN
            snake2.body[0].position.y -= CGFloat(pixelScale);
            if(snake2.body[0].position.y < minY) {
                snake2.body[0].position.y = maxY;
            }
            break;
        case .left: //LEFT
            snake2.body[0].position.x -= CGFloat(pixelScale);
            if(snake2.body[0].position.x < minX) {
                snake2.body[0].position.x = maxX;
            }
            break;
        case .right: //RIGHT
            snake2.body[0].position.x += CGFloat(pixelScale);
            if(snake2.body[0].position.x > maxX) {
                snake2.body[0].position.x = minX;
            }
            break;
        }
    }
    
    func updateField() {
        //check if food was eaten
        if(snake1.body[0].position == food.position) {
            
            score1 += 10;
            score1Label.text = "SCORE: " + String(score1);
            
            if(score1 >= scoreToWin && score1 >= score2 + winBy) {
                self.gameover = true;
                snake2.lost = true;
            }
            
            food.position = randomPosition();
            
            //don't let food spawn in snake body location
            for i in 1 ..< snake1.body.count {
                if(snake1.body[i].position == food.position) {
                    food.position = randomPosition();
                } else {
                    break;
                }
            }
            
            //update snake appearance (length & color)
            self.snake1.grow();
            self.addChild(snake1.body[snake1.body.count - 1]);
        }
        
        if(snake2.body[0].position == food.position) {
            
            score2 += 10;
            score2Label.text = "SCORE: " + String(score2);
            
            if(score2 >= scoreToWin && score2 >= score1 + winBy) {
                self.gameover = true;
                snake1.lost = true;
            }
            
            food.position = randomPosition();
            
            //don't let food spawn in snake body location
            for i in 1 ..< snake2.body.count {
                if(snake2.body[i].position == food.position) {
                    food.position = randomPosition();
                } else {
                    break;
                }
            }
            
            //update snake appearance (length & color)
            self.snake2.grow();
            self.addChild(snake2.body[snake2.body.count - 1]);
        }
        
        //check to see if we bit ourselves
        for i in 1 ..< snake1.body.count {
            if(snake1.body[0].position == snake1.body[i].position) {
                self.gameover = true;
                snake1.lost = true;
            }
        }
        
        for i in 1 ..< snake2.body.count {
            if(snake2.body[0].position == snake2.body[i].position) {
                self.gameover = true;
                snake2.lost = true;
            }
        }
    }
    
    func randomPosition() -> CGPoint {
        let randX = CGFloat(arc4random_uniform(UInt32(fieldWidth/pixelScale))) - CGFloat(fieldWidth/2/pixelScale); //picks random int from -20 to 20
        let randY = CGFloat(arc4random_uniform(UInt32(fieldHeight/pixelScale))) - CGFloat(fieldHeight/2/pixelScale); //picks random int from -25 to 25
        return CGPoint(x: field.position.x + randX*CGFloat(pixelScale), y: field.position.y + randY*CGFloat(pixelScale));
    }
    
    func presentGameOver() {
        let gameOverLabel = SKLabelNode(text: "GAME OVER");
        gameOverLabel.zPosition = 2;
        gameOverLabel.fontName = "Futura";
        gameOverLabel.fontSize = CGFloat(40);
        gameOverLabel.fontColor = SKColor.darkGray;
        
        
        let endScoreLabel = SKLabelNode();
        endScoreLabel.zPosition = 2;
        endScoreLabel.fontName = "Futura";
        endScoreLabel.fontSize = CGFloat(65);
        
        let endGamePromptLabel = SKLabelNode(text: "PLAY AGAIN?");
        endGamePromptLabel.zPosition = 2;
        endGamePromptLabel.fontName = "Futura";
        endGamePromptLabel.fontSize = CGFloat(30);
        endGamePromptLabel.fontColor = SKColor.gray;
        
        yesButton = SKButtonNode(width: 80, height: 40, cornerRadius: CGFloat(2));
        yesButton.setText("YES");
        yesButton.setStroke(2, color: SKColor.darkGray);
        yesButton.setFont("Futura", fontSize: CGFloat(25), fontColor: SKColor.gray);
        
        noButton = SKButtonNode(width: 80, height: 40, cornerRadius: CGFloat(2));
        noButton.setText("NO");
        noButton.setStroke(2, color: SKColor.darkGray);
        noButton.setFont("Futura", fontSize: CGFloat(25), fontColor: SKColor.gray);
        
        if(snake1.isDead) {
            gameOverLabel.position = CGPoint(x: field.position.x, y: field.position.y + 20);
            gameOverLabel.zRotation = CGFloat(Double.pi);
            endScoreLabel.position = CGPoint(x: field.position.x, y: gameOverLabel.position.y - 60);
            endScoreLabel.zRotation = CGFloat(Double.pi);
            endGamePromptLabel.position = CGPoint(x: field.position.x, y: gameOverLabel.position.y + 30);
            endGamePromptLabel.zRotation = CGFloat(Double.pi);
            endScoreLabel.text = "BLUE WINS";
            endScoreLabel.fontColor = SKColor.blue;
            endScoreLabel.zRotation = CGFloat(Double.pi);
            yesButton.setPos(CGPoint(x: field.position.x + 50, y: endGamePromptLabel.position.y + 30));
            yesButton.labelNode.zRotation = CGFloat(Double.pi);
            noButton.setPos(CGPoint(x: field.position.x - 50, y: endGamePromptLabel.position.y + 30));
            noButton.labelNode.zRotation = CGFloat(Double.pi);
        } else if(snake2.isDead) {
            endScoreLabel.text = "RED WINS";
            endScoreLabel.fontColor = SKColor.red;
            gameOverLabel.position = CGPoint(x: field.position.x, y: field.position.y - 20);
            endScoreLabel.position = CGPoint(x: field.position.x, y: gameOverLabel.position.y + 60);
            endGamePromptLabel.position = CGPoint(x: field.position.x, y: gameOverLabel.position.y - 30);
            yesButton.setPos(CGPoint(x: field.position.x - 50, y: endGamePromptLabel.position.y - 30));
            noButton.setPos(CGPoint(x: field.position.x + 50, y: endGamePromptLabel.position.y - 30));
        }
        
        addChild(gameOverLabel);
        addChild(endScoreLabel);
        addChild(endGamePromptLabel);
        addChild(yesButton);
        addChild(noButton);
        
        gameOverPresented = true;
    }
}
