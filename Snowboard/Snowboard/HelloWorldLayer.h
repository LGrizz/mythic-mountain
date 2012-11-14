//
//  HelloWorldLayer.h
//  Snowboard
//
//  Created by Kyle Langille on 12-03-28.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

typedef enum {
    kEndReasonWin,
    kEndReasonLose
} EndReason;

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    CCSpriteBatchNode *_batchNode;
    CCSprite *_man;
    
    CCParallaxNode *_backgroundNode;
    CCSprite *_background1;
    CCSprite *_background2;
    CCSprite *_startLine;
    CCSprite *dropShadowSprite;
    float _shipPointsPerSecY;
    float _shipPointsPerSecZ;
    
    CCArray *_trees;
    CCArray *_rocks;
    int _nextAsteroid;
    int _nextRock;
    double _nextAsteroidSpawn;
    double _nextRockSpawn;
    
    int _lives;
    
    double _gameOverTime;
    bool _gameOver;
    
    bool _started;
    
    
    ARCH_OPTIMAL_PARTICLE_SYSTEM *trail;
    
    float _backgroundSpeed; 
    float _randDuration;
    
    int pressTime;
    BOOL jumping;
    float jumpHeight;
    float jumpOrigin;
    int timer;
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
