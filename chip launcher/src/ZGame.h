//
//  game.h
//  Beltality
//
//  Created by Mac Mini on 30.10.10.
//  Copyright 2010 JoyPeople. All rights reserved.
//

#import "cocos2d.h"
#import "LevelFinishScreen.h"
#import "GUILabelTTF.h"
#import "ActorPlayer.h"
#import "CellsBackground.h"
#import "SpeedWall.h"
#import "ParalaxBackground.h"
#import "HeightLabels.h"

@interface ZGame : CCNode {	
	BOOL isVisible;
	
	BOOL isPause;
	
	int scoreLevel;
	
	float levelTime;
    
    CCLabelBMFont *scoreStr;
    CGPoint scoreStrPos;
    BOOL isNewScoreSound;
    
    float timerAddBall;
    float timerDelayAddBall;
    
    GUILabelTTF *labelScoreStr1;
    GUILabelTTF *labelScoreStr2;
    GUILabelTTF *labelScoreStr3;
    
    GUIPanel* panelSlowMotionLeft;
    int panelBonusFadeSpeed;
    
    CellsBackground *cells;
    ParalaxBackground* paralaxBackground;
    HeightLabels* heightLabels;
    SpeedWall *speedWall;
    
    CCSprite *startPlatform;
    
    int collectedCoins;
    
    BOOL isSlowMotion;
    float timeSlowMotion;
    float delaySlowMotion;
    float timeSlowMotionPause;
    
    float timerBonusShow;
    float delayBonusShow;
    
    float startLineYPosition;
    
    BOOL isPlayerTouch;
    
    NSMutableArray* playerMoveArr;
}

@property (nonatomic, assign) int state;
@property (nonatomic, assign) int oldState;
@property (nonatomic, retain) ActorPlayer *player;

// button actions
- (void) buttonPauseAction;
- (void) buttonLevelRestartAction;
- (void) retartGameProcess;

- (id) init;
- (void) update:(ccTime)dt;
- (void) setPause:(BOOL)_flag;
- (void) levelStart;
- (void) levelRestart;
- (void) prepareToHideGameScreen;
- (void) bonusSlowMotionActivate:(float)_time
                      _timeScale:(float)_timeScale;
- (void) doBonusEffect:(int)_bonusID;
- (void) bonusTouchReaction:(int)_bonusID
                     _scale:(float)_scale;
- (BOOL) ccTouchBegan:(CGPoint)_touchPos;
- (void) ccTouchEnded:(CGPoint)_touchPos;
- (void) ccTouchMoved:(CGPoint)_touchLocation
	   _prevLocation:(CGPoint)_prevLocation
			   _diff:(CGPoint)_diff;
- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;
- (void) show:(BOOL)_flag;
- (void) dealloc;
@end
