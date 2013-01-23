//
//  HelloWorldLayer.h
//  Snowboard
//
//  Created by Kyle Langille on 12-03-28.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "PauseLayer.h"
#import "GameOverLayer.h"

typedef enum {
    kEndReasonWin,
    kEndReasonLose
} EndReason;

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    CCSpriteBatchNode *_batchNode;
    CCSpriteBatchNode *turner;
    CCSpriteBatchNode *boardturner;
    CCSpriteBatchNode *jumper;
    CCSprite *_man;
    CCSprite *heli;
    CCSprite *ladder;
    CCSprite *trapper;
    CCSprite *_board;
    CCSprite *cloud1;
    CCSprite *cloud2;
    CCSprite *cloud3;
    CCSprite *equipment;
    CCSprite *equipmentText;
    CCSprite *hillEquipment;
    CCSprite *cabin;
    CCSprite *smoke;
    CCSprite *dummy1;
    CCSprite *dummy2;
    CCSprite *dummy3;
    
    CCParallaxNode *_backgroundNode;
    CCSprite *_background1;
    CCSprite *_background2;
    CCSprite *_startLine;
    CCSprite *dropShadowSprite;
    CCSprite *dropShadowBoardSprite;
    CCSprite *bg;
    CCSprite *lighting;
    float _shipPointsPerSecY;
    float _shipPointsPerSecZ;
    float _previousPointsPerSec;
    
    CCArray *_trees;
    CCArray *_rocks;
    CCArray *_spikes;
    CCArray *_coins;
    CCArray *_ices;
    CCArray *_arches;
    int _nextAsteroid;
    int _nextRock;
    int _nextSpike;
    int _nextCoin;
    int _nextIce;
    int _nextArch;
    double _nextAsteroidSpawn;
    double _nextRockSpawn;
    double _nextSpikeSpawn;
    double _nextCliffSpawn;
    double _nextCoinSpawn;
    double _nextIceSpawn;
    double _nextArchSpawn;
    
    CCSprite *cliff;
    CCSprite *bigCliff;
    float ySpeed;
    
    int _lives;
    
    double _gameOverTime;
    bool _gameOver;
    
    bool _started;
    bool caught;
    bool dead;
    bool bigJump;
    bool hitJump;
    bool tricker;
    bool oneUse;
    
    ARCH_OPTIMAL_PARTICLE_SYSTEM *trail;
    ARCH_OPTIMAL_PARTICLE_SYSTEM *ava;
    CCMotionStreak *streak;
    
    float _backgroundSpeed; 
    float _randDuration;
    
    int pressTime;
    BOOL jumping;
    BOOL fallen;
    float jumpHeight;
    float jumpOrigin;
    int timer;
    int tapCount;
    
    float score;
    float scoreTime;
    int scoreFlipper;
    int coinScore;
    
    CCLabelTTF * scoreLabel;
    CCLabelTTF * coinScoreLabel;
    CCLabelTTF * getUpMessage;
    CCLabelTTF * startMessage;
    CCLabelTTF * jumpMessage;
    
    BOOL hitTime;
    BOOL icarus;
    BOOL midas;
    BOOL begin;
    BOOL firstCliff;
    
    CCLabelTTF *_label;
    
    CCAnimation *leftturn;
    CCAnimation *rightturn;
    CCAnimation *boardleftturn;
    CCAnimation *boardrightturn;
    
    CCGestureRecognizer *singleTap;
    
    NSString *equipmentName;
    NSString *characterName;
    NSDictionary *equipmentDic;
    CCMenuItemSprite *startButton;
    
    CCMenu *pauseMenu;
    PauseLayer *pauseLayer;
    GameOverLayer *gameOverLayer;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
