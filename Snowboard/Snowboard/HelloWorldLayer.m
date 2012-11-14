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

#define kNumTrees 6 

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
        timer = 0;
        _started = NO;
        self.isTouchEnabled = YES;
        _man = [CCSprite spriteWithFile:@"penguin-right.png"];  // 4
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
        [self addChild:_startLine];
        //[_batchNode addChild:_ship z:1]; // 7
        
        // 1) Create the CCParallaxNode
        _backgroundNode = [CCParallaxNode node];
        [self addChild:_backgroundNode z:-1];
        
        // 2) Create the sprites we'll add to the CCParallaxNode
        _background1 = [CCSprite spriteWithFile:@"bluesnow.png"];
        _background2 = [CCSprite spriteWithFile:@"bluesnow.png"];
        
        // 3) Determine relative movement speeds for space dust and background
        CGPoint dustSpeed = ccp(0, 0.3);
        CGPoint bgSpeed = ccp(0.05, 0.05);
        
        // 4) Add children to CCParallaxNode
        [_backgroundNode addChild:_background1 z:0 parallaxRatio:dustSpeed positionOffset:ccp(winSize.width/2,0)];
        [_backgroundNode addChild:_background2 z:0 parallaxRatio:dustSpeed positionOffset:ccp(winSize.width/2,-(_background1.contentSize.height))]; 
        
        CCParticleSystemQuad *snowEffect = [CCParticleSystemQuad particleWithFile:@"snow.plist"];
        //[self addChild:snowEffect];
        
        self.isAccelerometerEnabled = YES;
        
        _trees = [[CCArray alloc] initWithCapacity:kNumTrees];
        for(int i = 0; i < kNumTrees; ++i) {
            CCSprite *tree;
            if(i%2==0){
                tree = [CCSprite spriteWithFile:@"trees-evergreen.png"];
            }else{
                tree = [CCSprite spriteWithFile:@"dead-tree.png"];
            }
            tree.visible = NO;
            [self addChild:tree];
            [_trees addObject:tree];
        }
        
        _rocks = [[CCArray alloc] initWithCapacity:kNumTrees];
        for(int i = 0; i < kNumTrees; ++i) {
            CCSprite *rock;
            rock = [CCSprite spriteWithFile:@"rock.png"];
            rock.visible = NO;
            [self addChild:rock];
            [_rocks addObject:rock];
        }
        
        _lives = 3;
        double curTime = CACurrentMediaTime();
        _gameOverTime = curTime + 30.0;
        
        _backgroundSpeed = 1000;
        _randDuration = 2.3;
        
        trail = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"trail2.plist"];
        trail.positionType=kCCPositionTypeFree;
		trail.position=ccp(_man.position.x, _man.position.y-20);
        
        //[self scheduleUpdate];
        
        jumpHeight = 0;
        jumping = NO;
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
        
        float randSecs = [self randomValueBetween:500/_backgroundSpeed andValue:1000/_backgroundSpeed];
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
    
    
    CGRect shiprect = CGRectMake(_man.boundingBox.origin.x+_man.boundingBox.size.width/2, _man.boundingBox.origin.y+_man.boundingBox.size.height/2, _man.boundingBox.size.width/4, _man.boundingBox.size.height/8);
    
    for (CCSprite *asteroid in _trees) {
        asteroid.position = ccpAdd(asteroid.position, ccpMult(asteroidScrollVel, dt));
        
        if (!asteroid.visible) continue;
        CGRect asteroidRect = CGRectMake(asteroid.boundingBox.origin.x+10, asteroid.boundingBox.origin.y+20, asteroid.boundingBox.size.width-20, asteroid.boundingBox.size.height-20);
        
        if (CGRectIntersectsRect(shiprect, asteroidRect)) {
            asteroid.visible = NO;
            _lives--;
            timer = timer - 700;
        }
    }
    
    for (CCSprite *rock in _rocks) {
        rock.position = ccpAdd(rock.position, ccpMult(asteroidScrollVel, dt));
        
        if (!rock.visible) continue;
        CGRect asteroidRect = CGRectMake(rock.boundingBox.origin.x+10, rock.boundingBox.origin.y+20, rock.boundingBox.size.width-20, rock.boundingBox.size.height-20);
        
        if (CGRectIntersectsRect(shiprect, asteroidRect) && _man.position.y == jumpOrigin) {
            rock.visible = NO;
            [_man stopAllActions];
            _man.visible = FALSE;
            dropShadowSprite.visible = FALSE;
            [trail stopSystem];
            [self endScene:kEndReasonLose];
        }
    }
    
    
    if (timer + 1000 < 300) {
        [_man stopAllActions];
        _man.visible = FALSE;
        dropShadowSprite.visible = FALSE;
        [trail stopSystem];
        [self endScene:kEndReasonLose];
    } else if (curTime >= _gameOverTime) {
        //[self endScene:kEndReasonWin];
    }
    
    if(_shipPointsPerSecY < 0){
        [_man setTexture: [[CCSprite spriteWithFile:@"penguin-left.png"]texture]];
    }else{
        [_man setTexture: [[CCSprite spriteWithFile:@"penguin-right.png"]texture]];
    }
    
    
    trail.position=ccp(_man.position.x, _man.position.y-20);
    
    NSLog(@"%d", timer);
}

- (void)setInvisible:(CCNode *)node {
    node.visible = NO;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    #define kFilteringFactor .5
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
    [self addChild:label];
    
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
    [self addChild:menu];
    
    [restartItem runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    [label runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    
}

-(void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    if(_started == NO){
        [_startLine runAction:[CCSequence actions:
                             [CCMoveBy actionWithDuration:2 position:ccp(0, winSize.height+100)],[CCCallFuncN actionWithTarget:self selector:@selector(setInvisible:)],nil]];
        [self addChild:trail];
        [self scheduleUpdate];
        [self schedule:@selector(updateTimer) interval:.3];
        _started = YES;
        
    }else{
        /*
        _backgroundSpeed = 2000;
        _randDuration = 1.2;
         
        [self schedule:@selector(countPressTime:) interval:1];
        pressTime = 0;
         
         */
        
        jumping = YES;
        [self schedule:@selector(jumper) interval:.2];
        [trail stopSystem];
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
    timer = timer + 30;
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
