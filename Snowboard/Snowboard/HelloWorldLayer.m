//
//  HelloWorldLayer.m
//  Snowboard
//
//  Created by Kyle Langille on 12-03-28.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "CCParallaxNode-Extras.h"
#import "SimpleAudioEngine.h"

#define kNumTrees 8
#define kNumRocks 5
#define kNumSpikes 5 
#define kNumCliff 1

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
    if( (self=[super init])) {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic: @"1-07 There Might Be Coffee.m4a"];
        
        timer = 0;
        _started = NO;
        self.isTouchEnabled = YES;
        _man = [CCSprite spriteWithFile:@"snowboard-right.png"];  // 4
        CGSize winSize = [CCDirector sharedDirector].winSize; // 5
        jumpOrigin = winSize.height * 0.72;
        _man.position = ccp(winSize.width * 0.5, winSize.height * 0.72); // 6
        dropShadowSprite = [CCSprite spriteWithSpriteFrame:[_man displayedFrame]];
        //[self addChild:dropShadowSprite z: -1];
        [dropShadowSprite setOpacity:100];
        [dropShadowSprite setColor:ccBLACK];
        [dropShadowSprite setPosition:ccp(winSize.width * 0.5, winSize.height * 0.72)];
        [self addChild:dropShadowSprite];
        [self addChild:_man z:1];
        
        _startLine = [CCSprite spriteWithFile:@"startLineGate.png"];
        _startLine.position = ccp(winSize.width/2, winSize.height-_startLine.contentSize.height/2);
        //[self addChild:_startLine];
        //[_batchNode addChild:_ship z:1]; // 7
        
        // 1) Create the CCParallaxNode
        _backgroundNode = [CCParallaxNode node];
        [self addChild:_backgroundNode z:-1];
        
        // 2) Create the sprites we'll add to the CCParallaxNode
        _background1 = [CCSprite spriteWithFile:@"whitebg.png"];
        _background2 = [CCSprite spriteWithFile:@"whitebg.png"];
        
        // 3) Determine relative movement speeds for space dust and background
        CGPoint dustSpeed = ccp(0, 0.3);
        
        // 4) Add children to CCParallaxNode
        [_backgroundNode addChild:_background1 z:0 parallaxRatio:dustSpeed positionOffset:ccp(winSize.width/2,0)];
        [_backgroundNode addChild:_background2 z:0 parallaxRatio:dustSpeed positionOffset:ccp(winSize.width/2,-(_background1.contentSize.height))];
        
        CCParticleSystemQuad *snowEffect = [CCParticleSystemQuad particleWithFile:@"snow.plist"];
        
       // [self addChild:snowEffect];
        
        self.isAccelerometerEnabled = YES;
        
        _trees = [[CCArray alloc] initWithCapacity:kNumTrees];
        for(int i = 0; i < kNumTrees; ++i) {
            CCSprite *tree;
            if(i%2==0){
                tree = [CCSprite spriteWithFile:@"tree-single.png"];
            }else{
                tree = [CCSprite spriteWithFile:@"tree-double.png"];
            }
            tree.visible = NO;
            [self addChild:tree];
            [_trees addObject:tree];
        }
        
        _rocks = [[CCArray alloc] initWithCapacity:kNumRocks];
        for(int i = 0; i < kNumRocks; ++i) {
            CCSprite *rock;
            rock = [CCSprite spriteWithFile:@"rocker.png"];
            rock.visible = NO;
            [self addChild:rock];
            [_rocks addObject:rock];
        }
        
        _spikes = [[CCArray alloc] initWithCapacity:kNumSpikes];
        for(int i = 0; i < kNumSpikes; ++i) {
            CCSprite *spike;
            spike = [CCSprite spriteWithFile:@"spikes.png"];
            spike.visible = NO;
            [self addChild:spike];
            [_spikes addObject:spike];
        }
        
        cliff = [CCSprite spriteWithFile:@"jump.png"];
        cliff.visible = NO;
        [self addChild:cliff];
        
        _lives = 3;
        double curTime = CACurrentMediaTime();
        _gameOverTime = curTime + 30.0;
        
        _backgroundSpeed = 1000;
        _randDuration = 2.3;
        
        trail = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"trail2.plist"];
        trail.positionType=kCCPositionTypeFree;
		trail.position=ccp(_man.position.x, _man.position.y-20);
        
        ava = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"avalanche.plist"];
        ava.positionType=kCCPositionTypeFree;
		trail.position=ccp(winSize.width/2, winSize.height);
        [self addChild:ava z:998];
        
        //[self scheduleUpdate];
        
        jumpHeight = 0;
        jumping = NO;
        
        score = 0;
        scoreTime = 0;
        
        scoreLabel =[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d ", 0] fontName:@"Verdana" fontSize:22];
        scoreLabel.position = ccp(winSize.width-40, 15);
        scoreLabel.color = ccc3(0, 0, 0);
        
        [self addChild:scoreLabel];
        
        blackSolid = [[[CCSprite alloc] init] autorelease];
        [blackSolid setTextureRectInPixels:CGRectMake(0, 0, winSize.width, winSize.height+20) rotated:NO untrimmedSize:CGSizeMake(winSize.width, winSize.height+20)];
        blackSolid.position = ccp(winSize.width/2, winSize.height+winSize.height/2-10);
        blackSolid.color = ccBLACK;
        [self addChild: blackSolid z:997];

    }
    return self;
}

- (float)randomValueBetween:(float)low andValue:(float)high {
    return (((float) arc4random() / 0xFFFFFFFFu) * (high - low)) + low;
}

- (void)update:(ccTime)dt {
    
    CGPoint backgroundScrollVel = ccp(0, _backgroundSpeed);
    CGPoint asteroidScrollVel = ccp(0, _backgroundSpeed/3.4);
    _backgroundNode.position = ccpAdd(_backgroundNode.position, ccpMult(backgroundScrollVel, dt));
    
    NSArray *spaceDusts = [NSArray arrayWithObjects:_background1, _background2, nil];
    for (CCSprite *spaceDust in spaceDusts) {
        if ([_backgroundNode convertToWorldSpace:spaceDust.position].y > spaceDust.contentSize.height) {
            [_backgroundNode incrementOffset:ccp(0,-(2*spaceDust.contentSize.height)) forChild:spaceDust];
        }
    }
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    float maxX = winSize.width - _man.contentSize.width/2;
    float minX = _man.contentSize.width/2;
    
    float newX = _man.position.x + (_shipPointsPerSecY * dt);
    newX = MIN(MAX(newX, minX), maxX);
    
    if(!jumping){
        if(_man.position.y == jumpOrigin + 32){
            _man.position = ccp(newX, _man.position.y - 2);
            [trail resetSystem];
        }else if(_man.position.y > jumpOrigin){
            _man.position = ccp(newX, _man.position.y - 2);
        }else{
            _man.position = ccp(newX, _man.position.y);
        }
    }else{
        _man.position = ccp(newX, _man.position.y + 4);
    }
    
    [dropShadowSprite setDisplayFrame:[_man displayedFrame]];
    dropShadowSprite.position = ccp(newX, jumpOrigin);
    
    
    double curTime = CACurrentMediaTime();
    _backgroundSpeed = 1000 + timer;

    if (curTime > _nextAsteroidSpawn) {
        
        float randSecs = [self randomValueBetween:600/_backgroundSpeed andValue:1000/_backgroundSpeed];
        _nextAsteroidSpawn = randSecs + curTime;
        
        float randX = [self randomValueBetween:0.0 andValue:winSize.width];
        
        CCSprite *asteroid = [_trees objectAtIndex:_nextAsteroid];
        _nextAsteroid++;
        if (_nextAsteroid >= _trees.count) _nextAsteroid = 0;
        
        [asteroid stopAllActions];
        asteroid.position = ccp(randX, -100);
        asteroid.visible = YES;
    }
    
    if (curTime > _nextRockSpawn) {
        
        float randSecs = [self randomValueBetween:1200/_backgroundSpeed andValue:2200/_backgroundSpeed];
        _nextRockSpawn = randSecs + curTime;
        
        float randX = [self randomValueBetween:0.0 andValue:winSize.width];
        
        CCSprite *rock = [_rocks objectAtIndex:_nextRock];
        _nextRock++;
        if (_nextRock >= _rocks.count) _nextRock = 0;
        
        [rock stopAllActions];
        rock.position = ccp(randX, -100);
        rock.visible = YES;
    }
    
    if (curTime > _nextSpikeSpawn) {
        
        float randSecs = [self randomValueBetween:1500/_backgroundSpeed andValue:3200/_backgroundSpeed];
        _nextSpikeSpawn = randSecs + curTime;
        
        float randX = [self randomValueBetween:0.0 andValue:winSize.width];
        
        CCSprite *spike = [_spikes objectAtIndex:_nextSpike];
        _nextSpike++;
        if (_nextSpike >= _spikes.count) _nextSpike = 0;
        
        [spike stopAllActions];
        spike.position = ccp(randX, -100);
        spike.visible = YES;
    }
    
    if (curTime > _nextCliffSpawn) {
        
        float randSecs = [self randomValueBetween:5000/_backgroundSpeed andValue:10000/_backgroundSpeed];
        _nextCliffSpawn = randSecs + curTime;
        
        float randX = [self randomValueBetween:0.0 andValue:winSize.width];
        
        [cliff stopAllActions];
        cliff.position = ccp(randX, -100);
        cliff.visible = YES;
    }
    
    cliff.position = ccpAdd(cliff.position, ccpMult(asteroidScrollVel, dt));
    CGRect cliffRect = CGRectMake(cliff.boundingBox.origin.x, cliff.boundingBox.origin.y+40, cliff.boundingBox.size.width, 1);
    CGRect shiprect = CGRectMake(_man.boundingBox.origin.x+_man.boundingBox.size.width/2, _man.boundingBox.origin.y+_man.boundingBox.size.height/2, _man.boundingBox.size.width/4, _man.boundingBox.size.height/8);
    
    
    if (CGRectIntersectsRect(shiprect, cliffRect) && _man.position.y == jumpOrigin) {
        if(!jumping && _man.position.y == jumpOrigin){
            [[SimpleAudioEngine sharedEngine] playEffect:@"bigJump.wav"];
            jumping = YES;
            [self schedule:@selector(jumper) interval:.2];
            //[self schedule:@selector(hideSnow) interval:.001];
            [trail stopSystem];
            [_man runAction:[CCRotateBy actionWithDuration:0.55 angle:360]];
            [dropShadowSprite runAction:[CCRotateBy actionWithDuration:0.55 angle:360]];
            timer = timer + 300;
            [ava runAction:[CCMoveTo actionWithDuration:1.0 position:ccp(ava.position.x, winSize.height+80)]];
            [blackSolid runAction:[CCMoveTo actionWithDuration:1.0 position:ccp(blackSolid.position.x, winSize.height+winSize.height/2+10)]];
        }
    }
    
    for (CCSprite *asteroid in _trees) {
        asteroid.position = ccpAdd(asteroid.position, ccpMult(asteroidScrollVel, dt));
        
        if (!asteroid.visible) continue;
        CGRect asteroidRect = CGRectMake(asteroid.boundingBox.origin.x+10, asteroid.boundingBox.origin.y+20, asteroid.boundingBox.size.width-20, asteroid.boundingBox.size.height-20);
        
        if (CGRectIntersectsRect(shiprect, asteroidRect)) {
            asteroid.visible = NO;
            timer = timer - 500;
            NSLog(@"%f%@%f", ava.position.y, @" ", winSize.height);
            if(ava.position.y <= winSize.height - 40){
                [ava runAction:[CCMoveTo actionWithDuration:1.5 position:ccp(ava.position.x, 0)]];
                [blackSolid runAction:[CCMoveTo actionWithDuration:1.5 position:ccp(blackSolid.position.x, winSize.height/2)]];
                [self unschedule:@selector(gameOverSnow)];
                [_man stopAllActions];
                dropShadowSprite.visible = FALSE;
                [trail stopSystem];
                [self unschedule:@selector(updateScoreTimer)];
                [self endScene:kEndReasonLose];
            }else if(ava.position.y <= winSize.height){
                [ava runAction:[CCMoveTo actionWithDuration:1.0 position:ccp(ava.position.x, winSize.height-40)]];
                [blackSolid runAction:[CCMoveTo actionWithDuration:1.0 position:ccp(blackSolid.position.x, winSize.height+winSize.height/2-25)]];
            }else{
                [ava runAction:[CCMoveTo actionWithDuration:1.0 position:ccp(ava.position.x, winSize.height)]];
                [blackSolid runAction:[CCMoveTo actionWithDuration:1.0 position:ccp(blackSolid.position.x, winSize.height+winSize.height/2)]];
            }
        }
        
        if (CGRectIntersectsRect(cliffRect, asteroidRect)) {
            asteroid.visible = NO;
        }
    }
    
    for (CCSprite *rock in _rocks) {
        rock.position = ccpAdd(rock.position, ccpMult(asteroidScrollVel, dt));
        
        if (!rock.visible) continue;
        CGRect rockRect = CGRectMake(rock.boundingBox.origin.x, rock.boundingBox.origin.y, rock.boundingBox.size.width, rock.boundingBox.size.height);
        
        if (CGRectIntersectsRect(shiprect, rockRect) && _man.position.y == jumpOrigin) {
            //rock.visible = NO;
            [[SimpleAudioEngine sharedEngine] playEffect:@"fall.wav"];
            [_man stopAllActions];
            //_man.visible = FALSE;
            [_man runAction:[CCMoveTo actionWithDuration:0.4 position:ccp(_man.position.x, _man.position.y-50)]];
            [_man runAction:[CCRotateBy actionWithDuration:0.4 angle:180]];
            dropShadowSprite.visible = FALSE;
            [trail stopSystem];
            [self unschedule:@selector(updateScoreTimer)];
            [self endScene:kEndReasonLose];
        }
        
        
        for (CCSprite *asteroid in _trees) {
            
            if (!asteroid.visible) continue;
            CGRect asteroidRect = CGRectMake(asteroid.boundingBox.origin.x, asteroid.boundingBox.origin.y, asteroid.boundingBox.size.width, asteroid.boundingBox.size.height);
            
            if (CGRectIntersectsRect(asteroidRect, rockRect)) {
                asteroid.visible = NO;
            }
        }
        
        if (CGRectIntersectsRect(cliffRect, rockRect)) {
            rock.visible = NO;
        }
    }
    
    for (CCSprite *spike in _spikes) {
        spike.position = ccpAdd(spike.position, ccpMult(asteroidScrollVel, dt));
        
        if (!spike.visible) continue;
        CGRect spikeRect = CGRectMake(spike.boundingBox.origin.x, spike.boundingBox.origin.y, spike.boundingBox.size.width, spike.boundingBox.size.height);
    
        if (CGRectIntersectsRect(shiprect, spikeRect) && _man.position.y == jumpOrigin) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"fall.wav"];
            //rock.visible = NO;
            [_man stopAllActions];
            //_man.visible = FALSE;
            [_man runAction:[CCMoveTo actionWithDuration:0.4 position:ccp(_man.position.x, _man.position.y-20)]];
            [_man runAction:[CCRotateBy actionWithDuration:0.4 angle:180]];
            dropShadowSprite.visible = FALSE;
            [trail stopSystem];
            [self unschedule:@selector(updateScoreTimer)];
            [self endScene:kEndReasonLose];
        }
        
        for (CCSprite *asteroid in _trees) {
            
            if (!asteroid.visible) continue;
            CGRect asteroidRect = CGRectMake(asteroid.boundingBox.origin.x, asteroid.boundingBox.origin.y, asteroid.boundingBox.size.width, asteroid.boundingBox.size.height);
            
            if (CGRectIntersectsRect(asteroidRect, spikeRect)) {
                asteroid.visible = NO;
            }
        }
        
        if (CGRectIntersectsRect(cliffRect, spikeRect)) {
            spike.visible = NO;
        }
    }
    
    if(_shipPointsPerSecY < 0){
        [_man setTexture: [[CCSprite spriteWithFile:@"snowboard-left.png"]texture]];
    }else{
        [_man setTexture: [[CCSprite spriteWithFile:@"snowboard-right.png"]texture]];
    }
    
    
    trail.position=ccp(_man.position.x, _man.position.y-20);
    
    //scoreTime++;
    score++;
    NSString *str = [NSString stringWithFormat:@"%i", (int)score];
    [scoreLabel setString:str];
}

- (void)setInvisible:(CCNode *)node {
    node.visible = NO;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    #define kFilteringFactor .6
    #define kRestAccelX 0
    #define kRestAccelY 0
    #define kRestAccelZ -0.6
    #define kShipMaxPointsPerSecWidth (winSize.width*7)
    #define kShipMaxPointsPerSecHeight (winSize.height*0.5)
    #define kMaxDiffX 0.9
    #define kMaxDiffZ 0.3
    #define kMaxDiffY 0.5
    
    UIAccelerationValue rollingX, rollingY, rollingZ;
    
    rollingX = (acceleration.x * kFilteringFactor);// + (rollingX * (1.0 - kFilteringFactor));
    rollingY = (acceleration.y * kFilteringFactor);// + (rollingY * (1.0 - kFilteringFactor));
    rollingZ = (acceleration.z * kFilteringFactor);// + (rollingZ * (1.0 - kFilteringFactor));
    
    float accelX = acceleration.x - rollingX;
    float accelY = acceleration.y - rollingY;
    float accelZ = acceleration.z - rollingZ;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    float accelDiff = accelX;
    float accelFraction = accelDiff / kMaxDiffX;
    float pointsPerSec = kShipMaxPointsPerSecWidth * accelX;
    
    float accelDiff2 = accelZ - kRestAccelZ;
    float accelFraction2 = accelDiff2 / kMaxDiffZ;
    float pointsPerSec2 = kShipMaxPointsPerSecHeight * accelFraction2;
    
    _shipPointsPerSecY = pointsPerSec;
    _shipPointsPerSecZ = pointsPerSec2;
    
}

- (void)restartTapped:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];   
}

- (void)endScene:(EndReason)endReason {
    
    if (_gameOver) return;
    _gameOver = true;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    NSString *message;
    if (endReason == kEndReasonWin) {
        message = @"You win!";
    } else if (endReason == kEndReasonLose) {
        message = @"You lose!";
    }
    
    CCLabelBMFont *label;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        label = [CCLabelBMFont labelWithString:message fntFile:@"Arial-hd.fnt"];
    } else {
        label = [CCLabelBMFont labelWithString:message fntFile:@"Arial.fnt"];
    }
    label.scale = 0.1;
    label.position = ccp(winSize.width/2, winSize.height * 0.6);
    [self addChild:label z:999];
    
    CCLabelBMFont *restartLabel;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        restartLabel = [CCLabelBMFont labelWithString:@"Restart" fntFile:@"Arial-hd.fnt"];    
    } else {
        restartLabel = [CCLabelBMFont labelWithString:@"Restart" fntFile:@"Arial.fnt"];    
    }
    
    CCMenuItemLabel *restartItem = [CCMenuItemLabel itemWithLabel:restartLabel target:self selector:@selector(restartTapped:)];
    restartItem.scale = 0.1;
    restartItem.position = ccp(winSize.width/2, winSize.height * 0.4);
    
    CCMenu *menu = [CCMenu menuWithItems:restartItem, nil];
    menu.position = CGPointZero;
    [self addChild:menu z:999];
    
    [restartItem runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    [label runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    
    [self unscheduleUpdate];
    
}

-(void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    if(_started == NO){
        /*[_startLine runAction:[CCSequence actions:
                             [CCMoveBy actionWithDuration:2 position:ccp(0, winSize.height+100)],[CCCallFuncN actionWithTarget:self selector:@selector(setInvisible:)],nil]];*/
        [self addChild:trail];
        [self scheduleUpdate];
        [self schedule:@selector(updateTimer) interval:.3];
        [ava runAction:[CCMoveTo actionWithDuration:1.0 position:ccp(ava.position.x, winSize.height+80)]];
        [blackSolid runAction:[CCMoveTo actionWithDuration:1.0 position:ccp(blackSolid.position.x, winSize.height+winSize.height/2+10)]];
        _started = YES;
        
    }else{
        /*
        _backgroundSpeed = 2000;
        _randDuration = 1.2;
         
        [self schedule:@selector(countPressTime:) interval:1];
        pressTime = 0;
         
         */
        if(!jumping && _man.position.y == jumpOrigin){
            [[SimpleAudioEngine sharedEngine] playEffect:@"jump.wav"];
            jumping = YES;
            [self schedule:@selector(jumper) interval:.2];
            [trail stopSystem];
        }
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /*
    _backgroundSpeed = 1000;
    _randDuration = 2.4;
     */
}

-(void)jumper{
    jumping = NO;
    [self unschedule:@selector(jumper)];
}

-(void)updateTimer{
    if(timer < 0){
        timer = timer + 200;
    }else{
        timer = timer + 20;
    }
}

-(void)hideSnow{
    [self unschedule:@selector(halfSnow)];
    [self unschedule:@selector(fullSnow)];
    [self unschedule:@selector(gameOverSnow)];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    if(ava.position.y < winSize.height + 100){
        ava.position = ccp(ava.position.x, ava.position.y + 1);
    }else{
        [self unschedule:@selector(hideSnow)];
    }

}

-(void)halfSnow{
    [self unschedule:@selector(hideSnow)];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    if(ava.position.y > winSize.height){
        ava.position = ccp(ava.position.x, ava.position.y - 1);
    }else{
        [self unschedule:@selector(halfSnow)];
    }
}

-(void)fullSnow{
    [self unschedule:@selector(hideSnow)];
    [self unschedule:@selector(halfSnow)];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    if(ava.position.y > winSize.height - 50){
        blackSolid.position = ccp(blackSolid.position.x,blackSolid.position.y-1);
        ava.position = ccp(ava.position.x, ava.position.y - 1);
    }else{
        [self unschedule:@selector(fullSnow)];
    }
}

-(void)gameOverSnow{
    [self unschedule:@selector(hideSnow)];
    [self unschedule:@selector(fullSnow)];
    if(ava.position.y > 0){
        NSLog(@"%f", blackSolid.position.y);
        blackSolid.position = ccp(blackSolid.position.x,blackSolid.position.y-5);
        ava.position = ccp(ava.position.x, ava.position.y - 5);
    }else{
        

    }
}

-(void)countPressTime:(ccTime)dt {
    pressTime++;
    
    if ( pressTime == 5 ) {    //If user tapped and hold for 5 seconds...
        NSLog(@"%@", @"Held");
    }
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
