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
#import "CCGestureRecognizer.h"
#import "MainMenuScene.h"
#import "SettingsManager.h"

#define kNumTrees 30
#define kNumRocks 5
#define kNumSpikes 5 
#define kNumCliff 1
#define kNumCoins 10
#define kNumIce 5
#define kNumArches 5

// HelloWorldLayer implementation
@implementation HelloWorldLayer{
    
    float deadSpeed;
    bool equipAction;
    bool equipActionDone;
    
}

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
        //Path get the path to MyTestList.plist
        NSString *path=[[NSBundle mainBundle] pathForResource:@"equipment" ofType:@"plist"];
        //Next create the dictionary from the contents of the file.
        equipmentDic = [NSDictionary dictionaryWithContentsOfFile:path];
        
        CCGestureRecognizer* recognizer;
        recognizer = [CCGestureRecognizer CCRecognizerWithRecognizerTargetAction:[[[UISwipeGestureRecognizer alloc]init] autorelease] target:self action:@selector(swipe)];
        ((UISwipeGestureRecognizer*)recognizer.gestureRecognizer).direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:recognizer];

        recognizer = [CCGestureRecognizer CCRecognizerWithRecognizerTargetAction:[[[UISwipeGestureRecognizer alloc]init] autorelease] target:self action:@selector(swipeJump)];
        ((UISwipeGestureRecognizer*)recognizer.gestureRecognizer).direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:recognizer];
        
        recognizer = [CCGestureRecognizer CCRecognizerWithRecognizerTargetAction:[[[UISwipeGestureRecognizer alloc]init] autorelease] target:self action:@selector(swipeJump)];
        ((UISwipeGestureRecognizer*)recognizer.gestureRecognizer).direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:recognizer];
        
        singleTap = [CCGestureRecognizer CCRecognizerWithRecognizerTargetAction:[[[UITapGestureRecognizer alloc]init] autorelease] target:self action:@selector(equipTap:)];
        [self addGestureRecognizer:singleTap];
        
        
        
        if([[[SettingsManager sharedSettingsManager] getString:@"equipment"] isEqualToString:@"hammer"]){
            equipmentName = @"mjolnir";
        }else if([[[SettingsManager sharedSettingsManager] getString:@"equipment"] isEqualToString:@"sword"]){
            equipmentName = @"excalibur";
        }else if([[[SettingsManager sharedSettingsManager] getString:@"equipment"] isEqualToString:@"wings"]){
            equipmentName = @"icarus";
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"wings.plist"];
            CCSpriteBatchNode *wingSheet = [CCSpriteBatchNode batchNodeWithFile:@"wings.png"];
            [wingSheet.texture setAliasTexParameters];
            [self addChild:wingSheet];
        }
        
        hitTime = NO;
        fallen = NO;
        tapCount = 0;
        timer = 0;
        _started = NO;
        caught = NO;
        dead = NO;
        scoreFlipper = 0;
        bigJump = NO;
        hitJump = NO;
        tricker = NO;
        ySpeed = 0;
        equipAction = NO;
        equipActionDone = YES;
        self.isTouchEnabled = YES;
        icarus = NO;
        
        //Character Animations
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"yetiturn.plist"];
        CCSpriteBatchNode *yetispriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"yetiturn.png"];
        [yetispriteSheet.texture setAliasTexParameters];
        [self addChild:yetispriteSheet];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"yetijumpright.plist"];
        CCSpriteBatchNode *jumpspriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"yetijumpright.png"];
        [jumpspriteSheet.texture setAliasTexParameters];
        [self addChild:jumpspriteSheet];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"yetijumpleft.plist"];
        CCSpriteBatchNode *jumpleftspriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"yetijumpleft.png"];
        [jumpleftspriteSheet.texture setAliasTexParameters];
        [self addChild:jumpleftspriteSheet];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"yetifalling.plist"];
        CCSpriteBatchNode *fallingpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"yetifalling.png"];
        [fallingpriteSheet.texture setAliasTexParameters];
        [self addChild:fallingpriteSheet];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"yeti_getup.plist"];
        CCSpriteBatchNode *getUpSheet = [CCSpriteBatchNode batchNodeWithFile:@"yeti_getup.png"];
        [getUpSheet.texture setAliasTexParameters];
        [self addChild:getUpSheet];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"yeti_punch.plist"];
        CCSpriteBatchNode *punchSheet = [CCSpriteBatchNode batchNodeWithFile:@"yeti_punch.png"];
        [punchSheet.texture setAliasTexParameters];
        [self addChild:punchSheet];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"yeti_cage.plist"];
        CCSpriteBatchNode *cageSheet = [CCSpriteBatchNode batchNodeWithFile:@"yeti_cage.png"];
        [cageSheet.texture setAliasTexParameters];
        [self addChild:cageSheet];
        
        //Board Animations
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"yetiboardturn.plist"];
        CCSpriteBatchNode *boardspriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"yetiboardturn.png"];
        [boardspriteSheet.texture setAliasTexParameters];
        [self addChild:boardspriteSheet];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"yetiboardjump.plist"];
        CCSpriteBatchNode *boardjumpspriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"yetiboardjump.png"];
        [boardjumpspriteSheet.texture setAliasTexParameters];
        [self addChild:boardjumpspriteSheet];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"yetiboardjumpleft.plist"];
        CCSpriteBatchNode *boardjumpleftspriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"yetiboardjumpleft.png"];
        [boardjumpleftspriteSheet.texture setAliasTexParameters];
        [self addChild:boardjumpleftspriteSheet];
        
        //Hill Object Animations
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"coinspin.plist"];
        CCSpriteBatchNode *coinspriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"coinspin.png"];
        [coinspriteSheet.texture setAliasTexParameters];
        [self addChild:coinspriteSheet];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"coinspins.plist"];
        CCSpriteBatchNode *coinpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"coinspins.png"];
        [coinpriteSheet.texture setAliasTexParameters];
        [self addChild:coinpriteSheet];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"treebreak.plist"];
        CCSpriteBatchNode *treebreakSheet = [CCSpriteBatchNode batchNodeWithFile:@"treebreak.png"];
        [treebreakSheet.texture setAliasTexParameters];
        [self addChild:treebreakSheet];

        //Enemy Animations
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"heli.plist"];
        CCSpriteBatchNode *heliSheet = [CCSpriteBatchNode batchNodeWithFile:@"heli.png"];
        [heliSheet.texture setAliasTexParameters];
        [self addChild:heliSheet];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ladder.plist"];
        CCSpriteBatchNode *ladderSheet = [CCSpriteBatchNode batchNodeWithFile:@"ladder.png"];
        [ladderSheet.texture setAliasTexParameters];
        [self addChild:ladderSheet];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"trapper.plist"];
        CCSpriteBatchNode *trapperSheet = [CCSpriteBatchNode batchNodeWithFile:@"trapper.png"];
        [trapperSheet.texture setAliasTexParameters];
        [self addChild:trapperSheet];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gameovertrapper.plist"];
        CCSpriteBatchNode *gameovertrapperSheet = [CCSpriteBatchNode batchNodeWithFile:@"gameovertrapper.png"];
        [gameovertrapperSheet.texture setAliasTexParameters];
        [self addChild:gameovertrapperSheet];
        
        //Background Animations
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"%@%@", equipmentName, @"_lighting.plist"]];
        CCSpriteBatchNode *lightingSheet = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@%@", equipmentName, @"_lighting.png"]];
        [lightingSheet.texture setAliasTexParameters];
        [self addChild:lightingSheet];
        
        
        _man = [CCSprite spriteWithFile:@"yetiTurning01.png"];  // 4
        _board = [CCSprite spriteWithFile:@"board_turning01.png"];  
        [_man.texture setAliasTexParameters];
        [_board.texture setAliasTexParameters];
        CGSize winSize = [CCDirector sharedDirector].winSize; // 5
        _man.position = ccp(winSize.width * 0.5, winSize.height - 210); // 6
        jumpOrigin = winSize.height - 210;
        dropShadowSprite = [CCSprite spriteWithSpriteFrame:[_man displayedFrame]];
        [dropShadowSprite setOpacity:100];
        [dropShadowSprite setColor:ccBLACK];
        [dropShadowSprite setPosition:ccp(_man.position.x, _man.position.y)];
        [self addChild:dropShadowSprite z:899];
        
        dropShadowBoardSprite = [CCSprite spriteWithSpriteFrame:[_board displayedFrame]];
        [dropShadowBoardSprite setOpacity:100];
        [dropShadowBoardSprite setColor:ccBLACK];
        [dropShadowBoardSprite setPosition:ccp(_board.position.x, _board.position.y)];
        [self addChild:dropShadowBoardSprite z:899];
        
        equipment = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@%@", equipmentName, @".png"]];
        [equipment.texture setAliasTexParameters];
        equipment.position = ccp(_man.position.x + [[[equipmentDic objectForKey:equipmentName] objectForKey:@"x"] intValue], _man.position.y + [[[equipmentDic objectForKey:equipmentName] objectForKey:@"y"] intValue]);
        equipment.anchorPoint = ccp(([(NSNumber *)[[equipmentDic objectForKey:equipmentName] objectForKey:@"anchorX"] floatValue]), ([(NSNumber *)[[equipmentDic objectForKey:equipmentName] objectForKey:@"anchorY"] floatValue]));
        [self addChild:equipment z:900];
        
        cloud1 = [CCSprite spriteWithFile:@"cloud1.png"];
        cloud1.position = ccp(-50, winSize.height - 45);
        cloud2 = [CCSprite spriteWithFile:@"cloud1.png"];
        cloud2.position = ccp(winSize.width+50, winSize.height - 110);
        cloud3 = [CCSprite spriteWithFile:@"cloud2.png"];
        cloud3.position = ccp(-50, winSize.height - 75);
        
        [self addChild:cloud1 z:899];
        [self addChild:cloud2 z:899];
        [self addChild:cloud3 z:899];
        
        [self addChild:_man z:900];
        _board.position = ccp(winSize.width * 0.5, winSize.height - 210);
        [self addChild:_board z:899];
        streak = [CCMotionStreak streakWithFade:0.5 minSeg:0.1 image:@"snowflake.png" width:.1 length:.1 color:ccc4(255, 255, 255, 255)];
        streak.position=ccp(_man.position.x, _man.position.y-20);
        [self addChild:streak z:900];
        
        heli = [CCSprite spriteWithFile:@"heli1.png"];
        heli.position = ccp(winSize.width/2, winSize.height + 140);
        [self addChild:heli z:902];
        NSMutableArray *heliArray = [NSMutableArray array];
        for(int i = 1; i <= 2; ++i) {
            [heliArray addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"heli%d.png", i]]];
        }
        
        CCAnimation *helispin = [CCAnimation animationWithFrames:heliArray delay:0.2f];
        [heli runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:helispin restoreOriginalFrame:NO]]];
        
        ladder = [CCSprite spriteWithFile:@"ladder1.png"];
        ladder.position = ccp(winSize.width/2 + 40, winSize.height + 95);
        [self addChild:ladder z:902];
        NSMutableArray *ladderArray = [NSMutableArray array];
        for(int i = 1; i <= 4; ++i) {
            [ladderArray addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"ladder%d.png", i]]];
        }
        
        CCAnimation *laddershake = [CCAnimation animationWithFrames:ladderArray delay:0.2f];
        [ladder runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:laddershake restoreOriginalFrame:NO]]];
        
        trapper = [CCSprite spriteWithFile:@"trapper_heli1.png"];
        trapper.position = ccp(winSize.width/2 + 30, winSize.height + 38);
        [self addChild:trapper z:902];
        NSMutableArray *trapperArray = [NSMutableArray array];
        for(int i = 1; i <= 2; ++i) {
            [trapperArray addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"trapper_heli%d.png", i]]];
        }
        
        CCAnimation *trappershake = [CCAnimation animationWithFrames:trapperArray delay:0.2f];
        [trapper runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:trappershake restoreOriginalFrame:NO]]];
        
        // 1) Create the CCParallaxNode
        _backgroundNode = [CCParallaxNode node];
        [self addChild:_backgroundNode z:-1];
        
        // 2) Create the sprites we'll add to the CCParallaxNode
        _background1 = [CCSprite spriteWithFile:@"hill1.png"];
        _background2 = [CCSprite spriteWithFile:@"whitebg.png"];
        
        bg = [CCSprite spriteWithFile:@"hill1.png"];
        bg.anchorPoint = ccp(0.5f,1.0f);
        [bg setPosition:ccp(winSize.width/2, winSize.height-161)];
        
        
        CCSprite *top = [CCSprite spriteWithFile:@"static_bg.png"];
        [top setPosition:ccp(winSize.width/2, winSize.height - top.contentSize.height/2)];
        [self addChild:top z:480];
        [self addChild:bg z:500];
        
        lighting = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@%@", equipmentName, @"_bg_animation6.png"]];
        [lighting setPosition:ccp(winSize.width/2, winSize.height - lighting.contentSize.height/2)];
        [lighting.texture setAliasTexParameters];
        [self addChild:lighting z:479];
        
        equipmentText = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@%@", equipmentName, @"_text.png"]];
        [equipmentText setPosition:ccp(winSize.width/2, winSize.height - equipmentText.contentSize.height/2 - 30)];
        [equipmentText.texture setAliasTexParameters];
        [self addChild:equipmentText z:600];
        equipmentText.scale = 0;
        
        // 3) Determine relative movement speeds for space dust and background
        CGPoint dustSpeed = ccp(0, 0.3);
        
        // 4) Add children to CCParallaxNode
        [_backgroundNode addChild:_background1 z:0 parallaxRatio:dustSpeed positionOffset:ccp(winSize.width/2,0)];
        [_backgroundNode addChild:_background2 z:0 parallaxRatio:dustSpeed positionOffset:ccp(winSize.width/2,-(_background1.contentSize.height))];
        
        CCParticleSystemQuad *snowEffect = [CCParticleSystemQuad particleWithFile:@"snow.plist"];
        
        //[self addChild:snowEffect];
        
        self.isAccelerometerEnabled = YES;
        
        _trees = [[CCArray alloc] initWithCapacity:kNumTrees];
        for(int i = 0; i < kNumTrees; ++i) {
            CCSprite *tree;
            /*if(i%2==0){
                tree = [CCSprite spriteWithFile:@"tree.png"];
            }else{
                tree = [CCSprite spriteWithFile:@"treeArch.png"];
            }*/
            tree = [CCSprite spriteWithFile:@"tree_break1.png"];
            [tree.texture setAliasTexParameters];
            tree.visible = NO;
            [self addChild:tree z:490];
            [_trees addObject:tree];
        }
        
        _rocks = [[CCArray alloc] initWithCapacity:kNumRocks];
        for(int i = 0; i < kNumRocks; ++i) {
            CCSprite *rock;
            rock = [CCSprite spriteWithFile:@"rock.png"];
            rock.visible = NO;
            [rock.texture setAliasTexParameters];
            [self addChild:rock z:898];
            [_rocks addObject:rock];
        }
        
        _spikes = [[CCArray alloc] initWithCapacity:kNumSpikes];
        for(int i = 0; i < kNumSpikes; ++i) {
            CCSprite *spike;
            spike = [CCSprite spriteWithFile:@"spikes.png"];
            spike.visible = NO;
            [spike.texture setAliasTexParameters];
            [self addChild:spike z:898];
            [_spikes addObject:spike];
        }
        
        _coins = [[CCArray alloc] initWithCapacity:kNumCoins];
        for(int i = 0; i < kNumCoins; ++i) {
            CCSprite *coin;
            coin = [CCSprite spriteWithFile:@"coin01.png"];
            coin.visible = NO;
            [coin.texture setAliasTexParameters];
            [self addChild:coin z:898];
            [_coins addObject:coin];
        }
        
        _ices = [[CCArray alloc] initWithCapacity:kNumIce];
        for(int i = 0; i < kNumIce; ++i) {
            CCSprite *ice;
            ice = [CCSprite spriteWithFile:@"ice.png"];
            ice.visible = NO;
            [ice.texture setAliasTexParameters];
            [self addChild:ice z:898];
            [_ices addObject:ice];
        }
        
        _arches = [[CCArray alloc] initWithCapacity:kNumArches];
        for(int i = 0; i < kNumArches; ++i) {
            CCSprite *arch;
            arch = [CCSprite spriteWithFile:@"treeArch.png"];
            arch.visible = NO;
            [arch.texture setAliasTexParameters];
            [self addChild:arch z:898];
            [_arches addObject:arch];
        }
        
        cliff = [CCSprite spriteWithFile:@"jump.png"];
        cliff.visible = NO;
        [cliff.texture setAliasTexParameters];
        [self addChild:cliff z:898];
        
        _lives = 4;
        double curTime = CACurrentMediaTime();
        _backgroundSpeed = 3000;
        _randDuration = 2.3;
        
        trail = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"trail4.plist"];
        trail.positionType=kCCPositionTypeFree;
		trail.position=ccp(_man.position.x, _man.position.y-10);
        
        jumpHeight = 0;
        jumping = NO;
        
        score = 0;
        scoreTime = 0;
        coinScore = 0;
        
        CCLabelTTF *scoreDistanceLabel = [CCLabelBMFont labelWithString:@"y" fntFile:@"distance_24pt.fnt"];
        scoreDistanceLabel.position = ccp(winSize.width-18, 25);
        [self addChild:scoreDistanceLabel z:999];
        
        scoreLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", 0] fntFile:@"distance_24pt.fnt"];
        scoreLabel.anchorPoint = ccp(1.0f,0.5f);
        scoreLabel.position = ccp(winSize.width-30, 25);
        
        [self addChild:scoreLabel z:999];
        
        startButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"pauseUI.png"] selectedSprite:[CCSprite spriteWithFile:@"pauseUI.png"] target:self selector:@selector(pause:)];
        CCMenu *starMenu = [CCMenu menuWithItems:startButton, nil];
        starMenu.position = ccp(50, 30);
        [self addChild:starMenu z:999];
        
        CCSprite *coinUI = [CCSprite spriteWithFile:@"coinUI.png"];
        coinUI.position = ccp(winSize.width - 20, winSize.height - 30);
        [self addChild:coinUI z:999];
        
        coinScoreLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", 0] fntFile:@"coin_24pt.fnt"];
        coinScoreLabel.anchorPoint = ccp(1.0f,0.5f);
        coinScoreLabel.position = ccp(winSize.width - 35, winSize.height - 33);
        
        [self addChild:coinScoreLabel z:999];
        
        _previousPointsPerSec = 0;
    }
    return self;
}

- (void) pause: (id) sender
{
    if([[CCDirector sharedDirector] isPaused]){
        [[CCDirector sharedDirector] resume];
    }else{
        [[CCDirector sharedDirector] pause];
    }
}

- (float)randomValueBetween:(float)low andValue:(float)high {
    return (((float) arc4random() / 0xFFFFFFFFu) * (high - low)) + low;
}

- (void)update:(ccTime)dt {
    CGPoint backgroundScrollVel = ccp(0, _backgroundSpeed);
    CGPoint asteroidScrollVel = ccp(0, _backgroundSpeed/3.4);
    CGPoint asteroidScrollVelDown = ccp(0, _backgroundSpeed/12);
    
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
    
    if(cloud1.position.x > winSize.width){
        cloud1.position = ccp(-50, cloud1.position.y);
    }else{
        cloud1.position = ccp(cloud1.position.x + .8, cloud1.position.y);
    }
    
    if(cloud2.position.x < -50){
        cloud2.position = ccp(winSize.width+50, cloud2.position.y);
    }else{
        cloud2.position = ccp(cloud2.position.x - .7, cloud2.position.y);
    }
    
    if(cloud3.position.x > winSize.width){
        cloud3.position = ccp(-50, cloud3.position.y);
    }else{
        cloud3.position = ccp(cloud3.position.x + .6, cloud3.position.y);
    }
    
    if(!fallen){
    
        if(heli.position.y <= winSize.height + 140){
            heli.position = ccp(heli.position.x, heli.position.y + .5);
            ladder.position = ccp(ladder.position.x, ladder.position.y + .5);
            trapper.position = ccp(trapper.position.x, trapper.position.y + .5);
        }
    
    float newX = _man.position.x + (_shipPointsPerSecY * dt);
    newX = MIN(MAX(newX, minX), maxX);
        
    if(!jumping){
        if(_man.position.y < jumpOrigin + 32 && _man.position.y > jumpOrigin + 25){
            ySpeed += 0.2f;
            _man.position = ccp(newX, _man.position.y - ySpeed);
            _board.position = ccp(newX, _board.position.y - ySpeed);
            [trail resetSystem];
        }else if(_man.position.y > jumpOrigin){
            ySpeed += 0.2f;
            _man.scale = 1.04;
            _man.position = ccp(newX, _man.position.y - ySpeed);
            _board.position = ccp(newX, _board.position.y - ySpeed);
            
        }else if(_man.position.y < jumpOrigin){
            _man.position = ccp(newX, jumpOrigin);
            _board.position = ccp(newX, jumpOrigin);
        }else{
            tricker = NO;
            _man.scale = 1;
            _man.position = ccp(newX, _man.position.y);
            _board.position = ccp(newX, _board.position.y); 
        }
    }else if(icarus && _man.position.y > jumpOrigin+ 140){
        _man.position = ccp(newX, _man.position.y);
        _board.position = ccp(newX, _board.position.y);
        jumping = NO;
        icarus = NO;
        equipment.opacity = 50;
        [equipment runAction:[CCScaleTo actionWithDuration:0.5 scale:0.3]];
    }else if(bigJump && _man.position.y > jumpOrigin + 110){
        jumping = NO;
        bigJump = NO;
        ySpeed = 2;
        timer = timer - 200;
    }else if(bigJump || icarus){
        if(ySpeed > .5)
            ySpeed -= 0.3f;
        _man.scale = 1.09;
        _man.position = ccp(newX, _man.position.y + ySpeed);
        _board.position = ccp(newX, _board.position.y + ySpeed);
    }else{
        ySpeed -= 0.2f;
        _man.scale = 1.09;
        _man.position = ccp(newX, _man.position.y + ySpeed);
        _board.position = ccp(newX, _board.position.y + ySpeed);
    }
            
    NSString *path=[[NSBundle mainBundle] pathForResource:@"equipment" ofType:@"plist"];
    //Next create the dictionary from the contents of the file.
    equipmentDic = [NSDictionary dictionaryWithContentsOfFile:path];
    
        if(![equipmentName isEqualToString:@"icarus"]){
    if(equipment.position.y < _man.position.y + [[[equipmentDic objectForKey:equipmentName] objectForKey:@"y"] intValue] + 1){
        if(equipment.position.x < _man.position.x + [[[equipmentDic objectForKey:equipmentName] objectForKey:@"x"] intValue]){
            equipment.position = ccp(equipment.position.x + ((_man.position.x + [[[equipmentDic objectForKey:equipmentName] objectForKey:@"x"] intValue])-equipment.position.x)/10, equipment.position.y + ((_man.position.y + [[[equipmentDic objectForKey:equipmentName] objectForKey:@"y"] intValue] + 1)-equipment.position.y)/10);
        }else{
            equipment.position = ccp(equipment.position.x - abs(((_man.position.x + [[[equipmentDic objectForKey:equipmentName] objectForKey:@"x"] intValue])-equipment.position.x)/10), equipment.position.y + ((_man.position.y + [[[equipmentDic objectForKey:equipmentName] objectForKey:@"y"] intValue] + 1)-equipment.position.y)/10);
        }
    }else{
        if(equipment.position.x < _man.position.x + [[[equipmentDic objectForKey:equipmentName] objectForKey:@"x"] intValue]){
            equipment.position = ccp(equipment.position.x + ((_man.position.x + [[[equipmentDic objectForKey:equipmentName] objectForKey:@"x"] intValue])-equipment.position.x)/10, equipment.position.y - abs(((_man.position.y + [[[equipmentDic objectForKey:equipmentName] objectForKey:@"y"] intValue] + 1)-equipment.position.y))/10);
        }else{
            equipment.position = ccp(equipment.position.x - abs(((_man.position.x + [[[equipmentDic objectForKey:equipmentName] objectForKey:@"x"] intValue])-equipment.position.x)/10), equipment.position.y - abs(((_man.position.y + [[[equipmentDic objectForKey:equipmentName] objectForKey:@"y"] intValue] + 1)-equipment.position.y))/10);
        }
    }}else{
        equipment.position = ccp((_man.position.x + [[[equipmentDic objectForKey:equipmentName] objectForKey:@"x"] intValue]), (_man.position.y + [[[equipmentDic objectForKey:equipmentName] objectForKey:@"y"] intValue] + 1));
    }
        
        if(equipment.scale < 1) {
            equipment.scale += 0.001;
            if(scoreFlipper == 4){
                if(equipment.opacity < 50){
                    equipment.opacity = 50;
                }else{
                    equipment.opacity += 1;
                }
            }
        }else{
            equipment.scale = 1;
            equipment.opacity = 255;
        }
        NSLog(@"%d", equipment.opacity);


        if(_shipPointsPerSecY < 0 && _previousPointsPerSec >= 0 && _man.position.y == jumpOrigin){
            NSMutableArray *leftturnArray = [NSMutableArray array];
            for(int i = 1; i <= 9; ++i) {
                [leftturnArray addObject:
                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                  [NSString stringWithFormat:@"yetiTurning0%d.png", i]]];
            }
            
            leftturn = [CCAnimation animationWithFrames:leftturnArray delay:0.05f];
            [_man runAction:[CCAnimate actionWithAnimation:leftturn restoreOriginalFrame:NO]];
            
            NSMutableArray *leftboardturnArray = [NSMutableArray array];
            for(int i = 1; i <= 9; ++i) {
                [leftboardturnArray addObject:
                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                  [NSString stringWithFormat:@"board_turning0%d.png", i]]];
            }
            
            boardleftturn = [CCAnimation animationWithFrames:leftboardturnArray delay:0.05f];
            [_board runAction:[CCAnimate actionWithAnimation:boardleftturn restoreOriginalFrame:NO]];
            _previousPointsPerSec = _shipPointsPerSecY;
        }else if (_shipPointsPerSecY > 0 && _previousPointsPerSec <= 0 && _man.position.y == jumpOrigin){
            NSMutableArray *rightturnArray = [NSMutableArray array];
            for(int i = 9; i >= 1; --i) {
                [rightturnArray addObject:
                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                  [NSString stringWithFormat:@"yetiTurning0%d.png", i]]];
            }
            rightturn = [CCAnimation animationWithFrames:rightturnArray delay:0.05f];
            [_man runAction:[CCAnimate actionWithAnimation:rightturn restoreOriginalFrame:NO]];
            
            NSMutableArray *rightboardturnArray = [NSMutableArray array];
            for(int i = 9; i >= 1; --i) {
                [rightboardturnArray addObject:
                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                  [NSString stringWithFormat:@"board_turning0%d.png", i]]];
            }
            
            boardrightturn = [CCAnimation animationWithFrames:rightboardturnArray delay:0.05f];
            [_board runAction:[CCAnimate actionWithAnimation:boardrightturn restoreOriginalFrame:NO]];
            _previousPointsPerSec = _shipPointsPerSecY;
        }
    
    
    
    [dropShadowSprite setDisplayFrame:[_man displayedFrame]];
    dropShadowSprite.position = ccp(newX, jumpOrigin);
    
    [dropShadowBoardSprite setDisplayFrame:[_board displayedFrame]];
    dropShadowBoardSprite.position = ccp(newX, jumpOrigin);
    
    double curTime = CACurrentMediaTime();
    _backgroundSpeed = 840 + timer;

    if (curTime > _nextAsteroidSpawn && !bigJump) {
        CCSprite *newTree = [CCSprite spriteWithFile:@"tree_break1.png"];
        
        float randSecs = [self randomValueBetween:450/_backgroundSpeed andValue:750/_backgroundSpeed];
        _nextAsteroidSpawn = randSecs + curTime;
        
        float randX = [self randomValueBetween:0.0 andValue:winSize.width];
        float randTree = [self randomValueBetween:0.0 andValue:10.0];
        
        CCSprite *asteroid1 = [_trees objectAtIndex:_nextAsteroid];
            _nextAsteroid++;
            
        if (_nextAsteroid >= _trees.count)
                _nextAsteroid = 0;
        
        [asteroid1 stopAllActions];
        asteroid1.position = ccp(randX-20, -150);
        [self reorderChild:asteroid1 z:900];
        [asteroid1 setDisplayFrame:newTree.displayedFrame];
        [asteroid1 setTexture:[[CCSprite spriteWithFile:@"tree_break1.png"]texture]];
        asteroid1.visible = YES;
        
        
        if((int)randTree > 2 && (int)randTree < 4){
        CCSprite *asteroid2 = [_trees objectAtIndex:_nextAsteroid];
        _nextAsteroid++;
        
            if (_nextAsteroid >= _trees.count)
                _nextAsteroid = 0;
            
            [asteroid2 stopAllActions];
            asteroid2.position = ccp(randX + (10 + (randTree/2)), -150);
            [self reorderChild:asteroid2 z:900];
            [asteroid2 setDisplayFrame:newTree.displayedFrame];
            [asteroid2 setTexture:[[CCSprite spriteWithFile:@"tree_break1.png"]texture]];
            asteroid2.visible = YES;
            
        }
        
        if((int)randTree > 7 && randTree < 9){
            CCSprite *asteroid2 = [_trees objectAtIndex:_nextAsteroid];
            _nextAsteroid++;
            
            if (_nextAsteroid >= _trees.count)
                _nextAsteroid = 0;
            
            [asteroid2 stopAllActions];
            asteroid2.position = ccp(randX, -150 + (10 + (randTree/2)));
            [self reorderChild:asteroid2 z:900];
            [asteroid2 setDisplayFrame:newTree.displayedFrame];
            [asteroid2 setTexture:[[CCSprite spriteWithFile:@"tree_break1.png"]texture]];
            asteroid2.visible = YES;
            
        CCSprite *asteroid3 = [_trees objectAtIndex:_nextAsteroid];
        _nextAsteroid++;
        
            if (_nextAsteroid >= _trees.count)
                _nextAsteroid = 0;
        
            [asteroid3 stopAllActions];
            asteroid3.position = ccp(randX + (10 + (randTree/2)), -150);
            [self reorderChild:asteroid3 z:900];
            [asteroid3 setDisplayFrame:newTree.displayedFrame];
            [asteroid3 setTexture:[[CCSprite spriteWithFile:@"tree_break1.png"]texture]];
            asteroid3.visible = YES;
        }
    }
    
    if (curTime > _nextRockSpawn && score > 500 && !bigJump) {
        
        float randSecs = [self randomValueBetween:1000/_backgroundSpeed andValue:2500/_backgroundSpeed];
        _nextRockSpawn = randSecs + curTime;
        
        float randX = [self randomValueBetween:0.0 andValue:winSize.width];
        
        CCSprite *rock = [_rocks objectAtIndex:_nextRock];
        _nextRock++;
        if (_nextRock >= _rocks.count) _nextRock = 0;
        
        [rock stopAllActions];
        rock.position = ccp(randX, -100);
        [self reorderChild:rock z:898];
        rock.visible = YES;
    }
        
    if (curTime > _nextIceSpawn && score > 1000 && !bigJump) {
            
        float randSecs = [self randomValueBetween:4000/_backgroundSpeed andValue:6000/_backgroundSpeed];
        _nextIceSpawn = randSecs + curTime;
            
        float randX = [self randomValueBetween:0.0 andValue:winSize.width];
            
        CCSprite *ice = [_ices objectAtIndex:_nextIce];
        _nextIce++;
        if (_nextIce >= _ices.count) _nextIce = 0;
            
        [ice stopAllActions];
        ice.position = ccp(randX, -100);
        [self reorderChild:ice z:898];
        ice.visible = YES;
    }
    
    if (curTime > _nextSpikeSpawn && score > 1700 && !bigJump) {
        
        float randSecs = [self randomValueBetween:3000/_backgroundSpeed andValue:5000/_backgroundSpeed];
        _nextSpikeSpawn = randSecs + curTime;
        
        float randX = [self randomValueBetween:0.0 andValue:winSize.width];
        
        CCSprite *spike = [_spikes objectAtIndex:_nextSpike];
        _nextSpike++;
        if (_nextSpike >= _spikes.count) _nextSpike = 0;
        
        [spike stopAllActions];
        spike.position = ccp(randX, -100);
        [self reorderChild:spike z:898];
        spike.visible = YES;
    }
        
    if (curTime > _nextArchSpawn && score > 100 && !bigJump) {
            
        float randSecs = [self randomValueBetween:5000/_backgroundSpeed andValue:7000/_backgroundSpeed];
        _nextArchSpawn = randSecs + curTime;
            
        float randX = [self randomValueBetween:0.0 andValue:winSize.width];
            
        CCSprite *arch = [_arches  objectAtIndex:_nextArch];
        _nextArch++;
        if (_nextArch >= _arches.count) _nextArch = 0;
            
        [arch stopAllActions];
        arch.position = ccp(randX, -150);
        [self reorderChild:arch z:900];
        arch.visible = YES;
    }
    
    if (curTime > _nextCoinSpawn && !bigJump) {
        
        float randSecs = [self randomValueBetween:100/_backgroundSpeed andValue:500/_backgroundSpeed];
        _nextCoinSpawn = randSecs + curTime;
        
        float randX = [self randomValueBetween:0.0 andValue:winSize.width];
        
        CCSprite *coin = [_coins objectAtIndex:_nextCoin];
        _nextCoin++;
        if (_nextCoin >= _coins.count) _nextCoin = 0;
        
        [coin stopAllActions];
        coin.position = ccp(randX, -100);
        [self reorderChild:coin z:898];
        coin.visible = YES;
        NSMutableArray *coinArray = [NSMutableArray array];
        for(int i = 1; i <= 10; ++i) {
            [coinArray addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"coin%d.png", i]]];
        }
        
        CCAnimation *coinspin = [CCAnimation animationWithFrames:coinArray delay:0.1f];
        [coin runAction:[CCRepeat actionWithAction:[CCAnimate actionWithAnimation:coinspin restoreOriginalFrame:NO] times:2]];
    }
    
    if (curTime > _nextCliffSpawn && !bigJump) {
        
        float randSecs = [self randomValueBetween:5000/_backgroundSpeed andValue:10000/_backgroundSpeed];
        _nextCliffSpawn = randSecs + curTime;
        
        float randX = [self randomValueBetween:0.0 andValue:winSize.width];
        
        [cliff stopAllActions];
        cliff.position = ccp(randX, -100);
        [self reorderChild:cliff z:898];
        cliff.visible = YES;
    }
    
    if(bigJump && hitJump){
        bigCliff = [CCSprite spriteWithFile:@"Big_jump.png"];
        [bigCliff.texture setAliasTexParameters];
        hitJump = NO;
        bigCliff.position = ccp(winSize.width/2, -450);
        [self addChild:bigCliff z:898];
        //bigCliff.scale = 3.5f;
        bigCliff.visible = YES;
    }
    
    CGRect bigCliffRect = CGRectMake(bigCliff.boundingBox.origin.x, bigCliff.boundingBox.origin.y+80, bigCliff.boundingBox.size.width, 1);
    CGRect cliffRect = CGRectMake(cliff.boundingBox.origin.x, cliff.boundingBox.origin.y+40, cliff.boundingBox.size.width, 1);
    CGRect shiprect = CGRectMake(_man.boundingBox.origin.x+_man.boundingBox.size.width/2, _man.boundingBox.origin.y+_man.boundingBox.size.height/2, _man.boundingBox.size.width/4, _man.boundingBox.size.height/8);
    CGRect manrect = CGRectMake(_man.boundingBox.origin.x, _man.boundingBox.origin.y, _man.boundingBox.size.width, _man.boundingBox.size.height);
    CGRect boardrect = CGRectMake(_board.boundingBox.origin.x, _board.boundingBox.origin.y, _board.boundingBox.size.width, _board.boundingBox.size.height);
    CGRect equipRect = CGRectMake(equipment.boundingBox.origin.x, equipment.boundingBox.origin.y, equipment.boundingBox.size.width, equipment.boundingBox.size.height);
    
    if (CGRectIntersectsRect(shiprect, cliffRect) && _man.position.y == jumpOrigin && cliff.zOrder > 490) {
        if(!jumping && _man.position.y == jumpOrigin){
            //[[SimpleAudioEngine sharedEngine] playEffect:@"bigJump.wav"];
            jumping = YES;
            [self schedule:@selector(jumper) interval:.2];
            [trail stopSystem];
            [self doJump];
            ySpeed = 4;
            timer = timer + 50;
        }
    }
        
    if (CGRectIntersectsRect(shiprect, bigCliffRect) && _man.position.y == jumpOrigin && bigCliff.zOrder > 490) {
        if(!jumping && _man.position.y == jumpOrigin){
            jumping = YES;
            [trail stopSystem];
            [self doJump];
            ySpeed = 8;
            tricker = YES;
        }
    }
    
    if(cliff.position.y > winSize.height-160 && cliff.zOrder > 490){
        [self reorderChild:cliff z:490];
        cliff.position = ccpSub(cliff.position, ccpMult(asteroidScrollVelDown, dt));
    }else if(cliff.zOrder == 490){
        cliff.position = ccpSub(cliff.position, ccpMult(asteroidScrollVelDown, dt));
    }else{
        cliff.position = ccpAdd(cliff.position, ccpMult(asteroidScrollVel, dt));
    }
        
    if(bigCliff.position.y > winSize.height-160 && bigCliff.zOrder > 490){
        [self reorderChild:bigCliff z:490];
        bigCliff.position = ccpSub(bigCliff.position, ccpMult(asteroidScrollVelDown, dt));
    }else if(bigCliff.zOrder == 490){
        bigCliff.position = ccpSub(bigCliff.position, ccpMult(asteroidScrollVelDown, dt));
    }else{
        bigCliff.position = ccpAdd(bigCliff.position, ccpMult(asteroidScrollVel, dt));
    }
    
    for (CCSprite *coin in _coins) {
        if (!coin.visible) continue;
        if(coin.position.y > winSize.height-155 && coin.zOrder > 490){
            [self reorderChild:coin z:490];
            coin.position = ccpSub(coin.position, ccpMult(asteroidScrollVelDown, dt));
        }else if(coin.zOrder == 490){
            coin.position = ccpSub(coin.position, ccpMult(asteroidScrollVelDown, dt));
        }else{
            coin.position = ccpAdd(coin.position, ccpMult(asteroidScrollVel, dt));
        }
        
        CGRect asteroidRect = CGRectMake(coin.boundingBox.origin.x, coin.boundingBox.origin.y, coin.boundingBox.size.width, coin.boundingBox.size.height);
        
        if (CGRectIntersectsRect(manrect, asteroidRect) && !hitTime && coin.zOrder > 700 && _man.position.y < jumpOrigin + 30) {
            NSMutableArray *coinArray = [NSMutableArray array];
            for(int i = 1; i <= 5; ++i) {
                [coinArray addObject:
                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                  [NSString stringWithFormat:@"coins%d.png", i]]];
            }
            
            CCAnimation *coinspin = [CCAnimation animationWithFrames:coinArray delay:0.02f];
            [coin stopAllActions];
            [coin runAction:[CCAnimate actionWithAnimation:coinspin restoreOriginalFrame:NO]];
            
            coinScore++;
            NSString *str = [NSString stringWithFormat:@"%i", coinScore];
            [coinScoreLabel setString:str];
            if(coinScore == 100){
                [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:kAchievementsCoinOne percentComplete:100.0];
            }else if(coinScore == 500){
                [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:kAchievementsCoinTwo percentComplete:100.0];
            }else if(coinScore == 1000){
                [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:kAchievementsCoinThree percentComplete:100.0];
            }
            [self reorderChild:coin z:700];
        }
        
        if (CGRectIntersectsRect(cliffRect, asteroidRect)  && coin.zOrder > 490 && cliff.zOrder > 490) {
            coin.visible = NO;
        }
    }
    
    for (CCSprite *tree in _trees) {
        if (!tree.visible) continue;
        if(tree.position.y > winSize.height-120 && tree.zOrder > 490){
            [self reorderChild:tree z:490];
            tree.position = ccpSub(tree.position, ccpMult(asteroidScrollVelDown, dt));
        }else if(tree.zOrder == 490){
            tree.position = ccpSub(tree.position, ccpMult(asteroidScrollVelDown, dt));
        }else{
            tree.position = ccpAdd(tree.position, ccpMult(asteroidScrollVel, dt));
        }
        
        CGRect asteroidRect = CGRectMake(tree.boundingBox.origin.x + tree.boundingBox.size.width - 20, tree.boundingBox.origin.y, 5, 20);
        
        if (CGRectIntersectsRect(shiprect, asteroidRect) && !hitTime && tree.zOrder > 700 && tree.texture == [[CCSprite spriteWithFile:@"tree_break1.png"]texture]) {
            //[self unscheduleUpdate];
            [self schedule:@selector(hitTime) interval:1];
            hitTime = YES;
            [_board stopAllActions];
            [_man stopAllActions];
            [_man runAction:[CCMoveTo actionWithDuration:0.4 position:ccp(_man.position.x, _man.position.y-40)]];
            NSMutableArray *fallingArray = [NSMutableArray array];
            for(int i = 1; i <= 3; ++i) {
                [fallingArray addObject:
                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                  [NSString stringWithFormat:@"yetifalling%d.png", i]]];
            }
            [self unschedule:@selector(updateBg)];
            CCAnimation *falling = [CCAnimation animationWithFrames:fallingArray delay:0.01f];
            [_man runAction:[CCAnimate actionWithAnimation:falling restoreOriginalFrame:NO]];
            dropShadowSprite.visible = NO;
            dropShadowBoardSprite.visible = NO;
            [trail stopSystem];
            [self unschedule:@selector(updateTimer)];
            [self unschedule:@selector(updateScoreTimer)];
            _lives--;
            fallen = YES;
            ARCH_OPTIMAL_PARTICLE_SYSTEM *fall = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"fall2.plist"];
            fall.positionType=kCCPositionTypeFree;
            fall.position=ccp(_man.position.x, _man.position.y-20);
            [self addChild:fall z:899];
            [self reorderChild:tree z:700];
        }
        
        if (CGRectIntersectsRect(cliffRect, asteroidRect) && tree.zOrder > 490 && cliff.zOrder > 490) {
            //tree.visible = NO;
        }
        
        CGRect treeRect = CGRectMake(tree.boundingBox.origin.x, tree.boundingBox.origin.y, tree.boundingBox.size.width, tree.boundingBox.size.height);
        if (CGRectIntersectsRect(equipRect, treeRect) && !hitTime && tree.zOrder > 700 && !equipActionDone) {
            NSMutableArray *treeArray = [NSMutableArray array];
            for(int i = 1; i <= 3; ++i) {
                [treeArray addObject:
                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                  [NSString stringWithFormat:@"tree_break%d.png", i]]];
            }
            
            [self reorderChild:tree z:700];
            CCAnimation *treebreak = [CCAnimation animationWithFrames:treeArray delay:0.1f];
            [tree runAction:[CCAnimate actionWithAnimation:treebreak restoreOriginalFrame:NO]];
            
        }
    }
    
    for (CCSprite *rock in _rocks) {
        if (!rock.visible) continue;
        CGRect rockRect = CGRectMake(rock.boundingBox.origin.x+rock.boundingBox.size.width/2, rock.boundingBox.origin.y+rock.boundingBox.size.height/2, 1, 1);
        
        if (CGRectIntersectsRect(boardrect, rockRect) && _man.position.y == jumpOrigin && rock.zOrder>490) {
            //[[SimpleAudioEngine sharedEngine] playEffect:@"fall.wav"];
            [_board stopAllActions];
            [_man stopAllActions];
            NSMutableArray *fallingArray = [NSMutableArray array];
            for(int i = 1; i <= 3; ++i) {
                [fallingArray addObject:
                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                  [NSString stringWithFormat:@"yetifalling%d.png", i]]];
            } 
            CCAnimation *falling = [CCAnimation animationWithFrames:fallingArray delay:0.08f];
            [_man runAction:[CCAnimate actionWithAnimation:falling restoreOriginalFrame:NO]];
            [_man runAction:[CCMoveTo actionWithDuration:0.4 position:ccp(_man.position.x, _man.position.y-40)]];
            dropShadowSprite.visible = NO;
            dropShadowBoardSprite.visible = NO;
            ARCH_OPTIMAL_PARTICLE_SYSTEM *fall = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"fall2.plist"];
            fall.positionType=kCCPositionTypeFree;
            fall.position=ccp(_man.position.x, _man.position.y-20);
            [self addChild:fall z:899];
            [self unschedule:@selector(updateBg)];
            [trail stopSystem];
            [self unschedule:@selector(updateScoreTimer)];
            fallen = true;
            dead = TRUE;
            deadSpeed = 1.2;
        }
        
        for (CCSprite *asteroid in _trees) {
            
            if (!asteroid.visible) continue;
            CGRect asteroidRect = CGRectMake(asteroid.boundingBox.origin.x, asteroid.boundingBox.origin.y, asteroid.boundingBox.size.width, asteroid.boundingBox.size.height);
            
            if (CGRectIntersectsRect(asteroidRect, rockRect) && rock.zOrder > 490 && asteroid.zOrder > 490) {
                asteroid.visible = NO;
            }
        }
        
        for (CCSprite *asteroid in _spikes) {
            
            if (!asteroid.visible) continue;
            CGRect asteroidRect = CGRectMake(asteroid.boundingBox.origin.x, asteroid.boundingBox.origin.y, asteroid.boundingBox.size.width, asteroid.boundingBox.size.height);
            
            if (CGRectIntersectsRect(asteroidRect, rockRect) && rock.zOrder > 490 && asteroid.zOrder > 490) {
                asteroid.visible = NO;
            }
        }
        
        CGRect cliffRecter = CGRectMake(cliff.boundingBox.origin.x, cliff.boundingBox.origin.y, cliff.boundingBox.size.width, cliff.boundingBox.size.height);
        CGRect rockRectCliff = CGRectMake(rock.boundingBox.origin.x, rock.boundingBox.origin.y, rock.boundingBox.size.width, rock.boundingBox.size.height);
        if (CGRectIntersectsRect(cliffRecter, rockRectCliff) && rock.zOrder > 490 && cliff.zOrder > 490) {
            NSLog(@"%@", @"rocky cliff");
            rock.visible = NO;
        }
        
        if(rock.position.y > winSize.height-155 && rock.zOrder > 490){
            [self reorderChild:rock z:490];
            rock.position = ccpSub(rock.position, ccpMult(asteroidScrollVelDown, dt));
        }else if(rock.zOrder == 490){
            rock.position = ccpSub(rock.position, ccpMult(asteroidScrollVelDown, dt));
        }else{
            rock.position = ccpAdd(rock.position, ccpMult(asteroidScrollVel, dt));
        }
    }
    
    for (CCSprite *spike in _spikes) {
        if (!spike.visible) continue;
        CGRect spikeRect = CGRectMake(spike.boundingBox.origin.x+spike.boundingBox.size.width/2, spike.boundingBox.origin.y+spike.boundingBox.size.height/2, 1, 1);
    
        if (CGRectIntersectsRect(boardrect, spikeRect) && _man.position.y == jumpOrigin && spike.zOrder > 490) {
            //[[SimpleAudioEngine sharedEngine] playEffect:@"fall.wav"];
            [_board stopAllActions];
            [_man stopAllActions];
            [_man runAction:[CCMoveTo actionWithDuration:0.4 position:ccp(_man.position.x, _man.position.y-40)]];
            NSMutableArray *fallingArray = [NSMutableArray array];
            for(int i = 1; i <= 3; ++i) {
                [fallingArray addObject:
                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                  [NSString stringWithFormat:@"yetifalling%d.png", i]]];
            }
            [self unschedule:@selector(updateBg)];
            CCAnimation *falling = [CCAnimation animationWithFrames:fallingArray delay:0.08f];
            [_man runAction:[CCAnimate actionWithAnimation:falling restoreOriginalFrame:NO]];
            dropShadowSprite.visible = NO;
            dropShadowBoardSprite.visible = NO;
            [trail stopSystem];
            [self unschedule:@selector(updateScoreTimer)];
            ARCH_OPTIMAL_PARTICLE_SYSTEM *fall = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"fall2.plist"];
            fall.positionType=kCCPositionTypeFree;
            fall.position=ccp(_man.position.x, _man.position.y-20);
            [self addChild:fall z:899];
            fallen = true;
            dead = TRUE;
            deadSpeed = 1.2;
        }
        
        for (CCSprite *asteroid in _trees) {
            
            if (!asteroid.visible) continue;
            CGRect asteroidRect = CGRectMake(asteroid.boundingBox.origin.x, asteroid.boundingBox.origin.y, asteroid.boundingBox.size.width, asteroid.boundingBox.size.height);
            
            if (CGRectIntersectsRect(asteroidRect, spikeRect) && spike.zOrder > 490 && asteroid.zOrder > 490) {
                spike.visible = NO;
            }
        }
        
        CGRect cliffRecter = CGRectMake(cliff.boundingBox.origin.x, cliff.boundingBox.origin.y, cliff.boundingBox.size.width, cliff.boundingBox.size.height);
        CGRect spikeRectCliff = CGRectMake(spike.boundingBox.origin.x, spike.boundingBox.origin.y, spike.boundingBox.size.width, spike.boundingBox.size.height);
        if (CGRectIntersectsRect(cliffRecter, spikeRectCliff) && spike.zOrder > 490 && cliff.zOrder > 490) {
            spike.visible = NO;
        }
    
        if(spike.position.y > winSize.height-155 && spike.zOrder > 490){
            [self reorderChild:spike z:490];
            spike.position = ccpSub(spike.position, ccpMult(asteroidScrollVelDown, dt));
        }else if(spike.zOrder == 490){
            spike.position = ccpSub(spike.position, ccpMult(asteroidScrollVelDown, dt));
        }else{
            spike.position = ccpAdd(spike.position, ccpMult(asteroidScrollVel, dt));
        }
    
    }
        
        for (CCSprite *ice in _ices) {
            if (!ice.visible) continue;
            CGRect iceRect = CGRectMake(ice.boundingBox.origin.x+ice.boundingBox.size.width/2, ice.boundingBox.origin.y+ice.boundingBox.size.height/2, 1, 1);
            
            if (CGRectIntersectsRect(boardrect, iceRect) && _man.position.y == jumpOrigin && ice.zOrder > 700) {
                //[[SimpleAudioEngine sharedEngine] playEffect:@"fall.wav"];
                timer = timer + 500;
                [self reorderChild:ice z:700];
                [self schedule:@selector(slowDown) interval:.5];
            }
            
            for (CCSprite *asteroid in _trees) {
                
                if (!asteroid.visible) continue;
                CGRect asteroidRect = CGRectMake(asteroid.boundingBox.origin.x, asteroid.boundingBox.origin.y, asteroid.boundingBox.size.width, asteroid.boundingBox.size.height);
                
                if (CGRectIntersectsRect(asteroidRect, iceRect) && ice.zOrder > 490 && asteroid.zOrder > 490) {
                    ice.visible = NO;
                }
            }
            
            CGRect cliffRecter = CGRectMake(cliff.boundingBox.origin.x, cliff.boundingBox.origin.y, cliff.boundingBox.size.width, cliff.boundingBox.size.height);
            CGRect spikeRectCliff = CGRectMake(ice.boundingBox.origin.x, ice.boundingBox.origin.y, ice.boundingBox.size.width, ice.boundingBox.size.height);
            if (CGRectIntersectsRect(cliffRecter, spikeRectCliff) && ice.zOrder > 490 && cliff.zOrder > 490) {
                ice.visible = NO;
            }
            
            if(ice.position.y > winSize.height-155 && ice.zOrder > 490){
                [self reorderChild:ice z:490];
                ice.position = ccpSub(ice.position, ccpMult(asteroidScrollVelDown, dt));
            }else if(ice.zOrder == 490){
                ice.position = ccpSub(ice.position, ccpMult(asteroidScrollVelDown, dt));
            }else{
                ice.position = ccpAdd(ice.position, ccpMult(asteroidScrollVel, dt));
            }
            
        }
        
        for (CCSprite *arch in _arches) {
            if (!arch.visible) continue;
            if(arch.position.y > winSize.height-120 && arch.zOrder > 490){
                [self reorderChild:arch z:490];
                arch.position = ccpSub(arch.position, ccpMult(asteroidScrollVelDown, dt));
            }else if(arch.zOrder == 490){
                arch.position = ccpSub(arch.position, ccpMult(asteroidScrollVelDown, dt));
            }else{
                arch.position = ccpAdd(arch.position, ccpMult(asteroidScrollVel, dt));
            }
            
            CGRect archLeftRect = CGRectMake(arch.boundingBox.origin.x + 30, arch.boundingBox.origin.y, 5, 30);
            CGRect archRightRect = CGRectMake(arch.boundingBox.origin.x + arch.boundingBox.size.width - 35, arch.boundingBox.origin.y, 5, 30);
            
            if ((CGRectIntersectsRect(shiprect, archLeftRect) || CGRectIntersectsRect(shiprect, archRightRect)) && !hitTime && arch.zOrder > 700) {
                //[self unscheduleUpdate];
                [self schedule:@selector(hitTime) interval:1];
                hitTime = YES;
                [_board stopAllActions];
                [_man stopAllActions];
                [_man runAction:[CCMoveTo actionWithDuration:0.4 position:ccp(_man.position.x, _man.position.y-40)]];
                NSMutableArray *fallingArray = [NSMutableArray array];
                for(int i = 1; i <= 3; ++i) {
                    [fallingArray addObject:
                     [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                      [NSString stringWithFormat:@"yetifalling%d.png", i]]];
                }
                [self unschedule:@selector(updateBg)];
                [self unschedule:@selector(updateTimer)];
                CCAnimation *falling = [CCAnimation animationWithFrames:fallingArray delay:0.08f];
                [_man runAction:[CCAnimate actionWithAnimation:falling restoreOriginalFrame:NO]];
                dropShadowSprite.visible = NO;
                dropShadowBoardSprite.visible = NO;
                [trail stopSystem];
                [self unschedule:@selector(updateScoreTimer)];
                _lives--;
                fallen = YES;
                [self reorderChild:arch z:700];
            }
            
            CGRect cliffRecter = CGRectMake(cliff.boundingBox.origin.x, cliff.boundingBox.origin.y, cliff.boundingBox.size.width, cliff.boundingBox.size.height);
            CGRect archRecter = CGRectMake(arch.boundingBox.origin.x, arch.boundingBox.origin.y, arch.boundingBox.size.width, arch.boundingBox.size.height);
            if (CGRectIntersectsRect(cliffRecter, archRecter) && arch.zOrder > 490 && cliff.zOrder > 490) {
                arch.visible = NO;
            }
            
            for (CCSprite *tree in _trees) {
                if (!tree.visible) continue;
                CGRect asteroidRect = CGRectMake(tree.boundingBox.origin.x, tree.boundingBox.origin.y, tree.boundingBox.size.width, tree.boundingBox.size.height);
                if (CGRectIntersectsRect(asteroidRect, archRecter) && arch.zOrder > 490 && tree.zOrder > 490) {
                    tree.visible = NO;
                }
            }
            
            for (CCSprite *spike in _spikes) {
                if (!spike.visible) continue;
                CGRect asteroidRect = CGRectMake(spike.boundingBox.origin.x, spike.boundingBox.origin.y, spike.boundingBox.size.width, spike.boundingBox.size.height);
                if (CGRectIntersectsRect(asteroidRect, archRecter) && arch.zOrder > 490 && spike.zOrder > 490) {
                    spike.visible = NO;
                }
            }
            
            for (CCSprite *rock in _rocks) {
                if (!rock.visible) continue;
                CGRect asteroidRect = CGRectMake(rock.boundingBox.origin.x, rock.boundingBox.origin.y, rock.boundingBox.size.width, rock.boundingBox.size.height);
                if (CGRectIntersectsRect(asteroidRect, archRecter) && arch.zOrder > 490 && rock.zOrder > 490) {
                    rock.visible = NO;
                }
            }
            
            for (CCSprite *ice in _ices) {
                if (!ice.visible) continue;
                CGRect asteroidRect = CGRectMake(ice.boundingBox.origin.x, ice.boundingBox.origin.y, ice.boundingBox.size.width, ice.boundingBox.size.height);
                if (CGRectIntersectsRect(asteroidRect, archRecter) && arch.zOrder > 490 && ice.zOrder > 490) {
                    ice.visible = NO;
                }
            }
        }
    
    trail.position=ccp(_man.position.x, _man.position.y-10);
    streak.position=ccp(_man.position.x, _man.position.y-20);
    
    if(scoreFlipper == 4){
        score++;
        scoreFlipper = 0;
    }else{
        scoreFlipper++;
    }
    NSString *str = [NSString stringWithFormat:@"%i", (int)score];
    [scoreLabel setString:str];
    if(score == 1000){
        [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:kAchievementsDistanceOne percentComplete:100.0];
    }else if(score == 5000){
        [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:kAchievementsDistanceTwo percentComplete:100.0];
    }else if(score == 10000){
        [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:kAchievementsDistanceThree percentComplete:100.0];
    }
    
    
    if(score == 500){
        bigJump = YES;
        hitJump = YES;
    }else if(score == 1000){
        bigJump = YES;
        hitJump = YES;
    }else if(score == 1700){
        bigJump = YES;
        hitJump = YES;
    }else if(score == 2500){
        bigJump = YES;
        hitJump = YES;
    }else if(score == 4000){
        bigJump = YES;
        hitJump = YES;
    }   
        
    }else{
        double speedY = .9;
        double speedX = .6;
        if(dead){
            speedY = 1.5;
            speedX = 1.2;
        }
        if(!caught){
            if(heli.position.y > _man.position.y + 145 && heli.position.x > _man.position.x - 10){
                heli.position = ccp(heli.position.x - speedX, heli.position.y - speedY);
                ladder.position = ccp(ladder.position.x - speedX, ladder.position.y - speedY);
                trapper.position = ccp(trapper.position.x - speedX, trapper.position.y - speedY);
            }else if(heli.position.y > _man.position.y + 145 && heli.position.x < _man.position.x - 10){
                heli.position = ccp(heli.position.x + speedX, heli.position.y - speedY);
                ladder.position = ccp(ladder.position.x + speedX, ladder.position.y - speedY);
                trapper.position = ccp(trapper.position.x + speedX, trapper.position.y - speedY);
            }else if(heli.position.y > _man.position.y + 145){
                heli.position = ccp(heli.position.x, heli.position.y - speedY);
                ladder.position = ccp(ladder.position.x, ladder.position.y - speedY);
                trapper.position = ccp(trapper.position.x, trapper.position.y - speedY);
            }else{
                caught = YES;
                deadSpeed = 1.2;
            }
        }else{
            if(_man.position.x < -10 && _man.position.y > winSize.height){
                [self unschedule:@selector(updateScoreTimer)];
                [self endScene:kEndReasonLose];
            }else{
                deadSpeed += .03;
                heli.position = ccp(heli.position.x - deadSpeed, heli.position.y + deadSpeed);
                ladder.position = ccp(ladder.position.x  - deadSpeed, ladder.position.y + deadSpeed);
                trapper.position = ccp(trapper.position.x - deadSpeed, trapper.position.y + deadSpeed);
                _man.position = ccp(_man.position.x - deadSpeed, _man.position.y + deadSpeed);
            }
        }
    }
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
    #define kMaxDiffX 0.1
    #define kMaxDiffZ 0.3
    #define kMaxDiffY 0.9
    
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
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];
}

- (void)achievementsTapped:(id)sender {
    [[GameKitHelper sharedGameKitHelper] showAchievements];
}

- (void)mainmenuTapped:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[MainMenuScene scene]]];
}

- (void)endScene:(EndReason)endReason {
    [self removeGestureRecognizer:singleTap];
    
    if (_gameOver) return;
    _gameOver = true;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CCLayer *gameOverLayer = [CCLayer node];
    
    CCSprite *gameoverBg = [CCSprite spriteWithFile:@"gameoverBg.png"];
    gameoverBg.anchorPoint = ccp(0.0f,1.0f);
    gameoverBg.position = ccp(0, winSize.height);
    gameoverBg.opacity = 130;
    [gameOverLayer addChild:gameoverBg z:990];
    
    CCSprite *gameoverTrapper = [CCSprite spriteWithFile:@"gameovertrapper1.png"];
    gameoverTrapper.position = ccp(115, winSize.height-155);
    [gameoverTrapper.texture setAliasTexParameters];
    [gameOverLayer addChild:gameoverTrapper z:995];
    
    NSMutableArray *gameovertrapperArray = [NSMutableArray array];
    for(int i = 1; i <= 4; ++i) {
        [gameovertrapperArray addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"trapper%d.png", i]]];
    }
    
    CCAnimation *gameovertrapperpump = [CCAnimation animationWithFrames:gameovertrapperArray delay:0.1f];
    [gameoverTrapper runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:gameovertrapperpump restoreOriginalFrame:NO]]];
    
    CCSprite *gameoverCage = [CCSprite spriteWithFile:@"yeti_cage1.png"];
    gameoverCage.position = ccp(220, winSize.height-gameoverCage.boundingBox.size.height/2);
    [gameoverCage.texture setAliasTexParameters];
    [gameOverLayer addChild:gameoverCage z:996];
    
    NSMutableArray *gameoverCageArray = [NSMutableArray array];
    for(int i = 1; i <= 2; ++i) {
        [gameoverCageArray addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"yeti_cage%d.png", i]]];
    }
    
    CCAnimation *cageShake = [CCAnimation animationWithFrames:gameoverCageArray delay:0.1f];
    [gameoverCage runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:cageShake restoreOriginalFrame:NO]]];
    
    CCLabelBMFont *label;
    label = [CCLabelBMFont labelWithString:@"GAME OVER" fntFile:@"game_over40pt.fnt"];
    label.position = ccp(winSize.width/2, winSize.height - 250);
    [gameOverLayer addChild:label z:999];
    
    CCLabelBMFont *yards;
    yards = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"You made it %d yards", (int)score] fntFile:@"game_over_dist_coins16pt.fnt"];
    yards.position = ccp(winSize.width/2, winSize.height - 282);
    [gameOverLayer addChild:yards z:997];
    CCLabelBMFont *coins;
    coins = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"You collected %d coins", (int)coinScore] fntFile:@"game_over_dist_coins16pt.fnt"];
    coins.position = ccp(winSize.width/2, winSize.height - 302);
    [gameOverLayer addChild:coins z:997];
    
    CCSprite *fb = [CCSprite spriteWithFile:@"facebook.png"];
    fb.position = ccp(winSize.width/2 + 15, winSize.height - 330);
    [gameOverLayer addChild:fb z:997];
    
    CCSprite *twitter = [CCSprite spriteWithFile:@"twitter.png"];
    twitter.position = ccp(winSize.width/2 - 15, winSize.height - 330);
    [gameOverLayer addChild:twitter z:997];
    
    CCLabelBMFont *playagain;
    playagain = [CCLabelBMFont labelWithString:@"PLAY AGAIN" fntFile:@"game_over_menu28pt.fnt"];
    CCLabelBMFont *spendcoins;
    spendcoins = [CCLabelBMFont labelWithString:@"SPEND COINS" fntFile:@"game_over_menu28pt.fnt"];
    CCLabelBMFont *achievements;
    achievements = [CCLabelBMFont labelWithString:@"ACHIEVEMENTS" fntFile:@"game_over_menu28pt.fnt"];
    CCLabelBMFont *mainmenu;
    mainmenu = [CCLabelBMFont labelWithString:@"MAIN MENU" fntFile:@"game_over_menu28pt.fnt"];
    
    CCMenuItemLabel *playagainItem = [CCMenuItemLabel itemWithLabel:playagain target:self selector:@selector(restartTapped:)];
    playagainItem.position = ccp(winSize.width/2, winSize.height - 370);
    CCMenuItemLabel *spendcoinsItem = [CCMenuItemLabel itemWithLabel:spendcoins target:self selector:@selector(restartTapped:)];
    spendcoinsItem.position = ccp(winSize.width/2, winSize.height - 400);
    CCMenuItemLabel *achievementsItem = [CCMenuItemLabel itemWithLabel:achievements target:self selector:@selector(achievementsTapped:)];
    achievementsItem.position = ccp(winSize.width/2,  winSize.height - 430);
    CCMenuItemLabel *mainmenuItem = [CCMenuItemLabel itemWithLabel:mainmenu target:self selector:@selector(mainmenuTapped:)];
    mainmenuItem.position = ccp(winSize.width/2,  winSize.height - 460);
    
    
    CCMenu *menu = [CCMenu menuWithItems:playagainItem,spendcoinsItem,achievementsItem,mainmenuItem, nil];
    menu.position = CGPointZero;
    [gameOverLayer addChild:menu z:999];
    
    //[restartItem runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    //[label runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    [self addChild:gameOverLayer z:999];
    
    [self unscheduleUpdate];
    
    [[GameKitHelper sharedGameKitHelper]
     submitScore:(int64_t)score
     category:kHighScoreLeaderboardCategory];
    
    
    int totalCoins = [[SettingsManager sharedSettingsManager] getInt:@"coins"];
    if(totalCoins != 0){
        totalCoins = totalCoins + coinScore;
    }else{
        totalCoins = coinScore;
    }
    [[SettingsManager sharedSettingsManager] setIntValue:totalCoins name:@"coins"];
}

-(void)equipTap:(UIGestureRecognizer *)gestureRecognizer{
    if(_started == NO){
        [self addChild:trail z:898];
        [trail resetSystem];
        [self scheduleUpdate];
        [self schedule:@selector(updateTimer) interval:.3];
        [self schedule:@selector(updateBg) interval:.1];
        _started = YES;
        [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:kAchievementsTrainingWheels percentComplete:100.0];
    }else{
    
    if(!fallen && !caught && _started && equipActionDone && equipment.scale == 1){
        if([equipmentName isEqualToString:@"mjolnir"]){
            [equipment runAction:[CCRepeat actionWithAction:[CCRotateBy actionWithDuration:.4 angle:360] times:3]];
            CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
            point = [[CCDirector sharedDirector]convertToGL:point];
            equipAction = TRUE;
            equipActionDone = NO;
            id move = [CCMoveTo actionWithDuration:1 position:point];
            id cleaner = [CCCallBlock actionWithBlock:^{
                equipActionDone = YES;
                [equipment runAction:[CCScaleTo actionWithDuration:0.5 scale:0.3]];
            }];
            CCSequence *action = [CCSequence actions:move, cleaner, nil];
            [equipment runAction:action];
        }else if([equipmentName isEqualToString:@"excalibur"]){
            equipActionDone = NO;
            id orbitAction = [CCRotateBy actionWithDuration:1 angle:360];
            id cleaner = [CCCallBlock actionWithBlock:^{
                equipActionDone = YES;
                equipment.opacity = 50;
                [equipment runAction:[CCScaleTo actionWithDuration:0.5 scale:0.3]];
            }];
            CCSequence *action = [CCSequence actions:orbitAction, cleaner, nil];
            [equipment runAction:action];
        }else if([equipmentName isEqualToString:@"icarus"]){
            jumping = YES;
            icarus = YES;
            ySpeed = 6;
            [trail stopSystem];
            NSMutableArray *flapArray = [NSMutableArray array];
            for(int i = 1; i <= 4; ++i) {
                [flapArray addObject:
                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                  [NSString stringWithFormat:@"icarus%d.png", i]]];
            }
            CCAnimation *flap = [CCAnimation animationWithFrames:flapArray delay:0.1f];
            [equipment runAction:[CCRepeat actionWithAction:[CCAnimate actionWithAnimation:flap restoreOriginalFrame:YES] times:12]];
        }
        
        NSString *path=[[NSBundle mainBundle] pathForResource:@"equipment" ofType:@"plist"];
        //Next create the dictionary from the contents of the file.
        equipmentDic = [NSDictionary dictionaryWithContentsOfFile:path];
        NSMutableArray *lightingArray = [NSMutableArray array];
        for(int i = 1; i <= [((NSString *)[[equipmentDic objectForKey:equipmentName] objectForKey:@"frames"]) intValue]; ++i) {
            [lightingArray addObject:
            [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
            [NSString stringWithFormat:[NSString stringWithFormat:@"%@%@", equipmentName, @"_bg_animation%d.png"], i]]];
        }
        CCAnimation *light = [CCAnimation animationWithFrames:lightingArray delay:0.1f];
        id lightClean = [CCCallBlock actionWithBlock:^{
            [equipmentText runAction:[CCScaleTo actionWithDuration:0.3 scale:0]];
            [self reorderChild:lighting z:479];
        }];
        id lightShow = [CCAnimate actionWithAnimation:light restoreOriginalFrame:NO];
        [equipmentText runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
        [self reorderChild:lighting z:481];
        CCSequence *lightAction = [CCSequence actions:lightShow, lightClean, nil];
        [lighting runAction:lightAction];
        }
    }
}

-(void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    
        if(!jumping && _man.position.y == jumpOrigin && !fallen){
           /* if(_shipPointsPerSecY > 0){
                NSMutableArray *punchArray = [NSMutableArray array];
                for(int i = 1; i <= 3; ++i) {
                    [punchArray addObject:
                    [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                    [NSString stringWithFormat:@"yetiPunching%d.png", i]]];
                }
                CCAnimation *punch = [CCAnimation animationWithFrames:punchArray delay:0.1f];
                [_man runAction:[CCAnimate actionWithAnimation:punch restoreOriginalFrame:YES]];
            }else{
                NSMutableArray *punchArray = [NSMutableArray array];
                for(int i = 4; i <= 6; ++i) {
                    [punchArray addObject:
                     [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                      [NSString stringWithFormat:@"yetiPunching%d.png", i]]];
                }
                CCAnimation *punch = [CCAnimation animationWithFrames:punchArray delay:0.1f];
                [_man runAction:[CCAnimate actionWithAnimation:punch restoreOriginalFrame:YES]];
            }
            
            for (CCSprite *tree in _trees) {
                CGRect treeRect = CGRectMake(tree.boundingBox.origin.x, tree.boundingBox.origin.y, tree.boundingBox.size.width, tree.boundingBox.size.height);
                CGRect manrect = CGRectMake(_man.boundingBox.origin.x, _man.boundingBox.origin.y, _man.boundingBox.size.width, _man.boundingBox.size.height);
                if (CGRectIntersectsRect(manrect, treeRect) && !hitTime && tree.zOrder > 700) {
                    NSMutableArray *treeArray = [NSMutableArray array];
                    for(int i = 1; i <= 3; ++i) {
                        [treeArray addObject:
                         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                          [NSString stringWithFormat:@"tree_break%d.png", i]]];
                    }
                    CCAnimation *treebreak = [CCAnimation animationWithFrames:treeArray delay:0.05f];
                    tree.position = ccp(tree.position.x - 45, tree.position.y);
                    [tree runAction:[CCAnimate actionWithAnimation:treebreak restoreOriginalFrame:NO]];
                }
            }*/
        }if(fallen && tapCount < 10 && !caught && !dead && ![[CCDirector sharedDirector] isPaused]){
            tapCount++;
            NSMutableArray *getupArray = [NSMutableArray array];
            for(int i = 1; i <= 3; ++i) {
                [getupArray addObject:
                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                  [NSString stringWithFormat:@"yeti_getup%d.png", i]]];
            }
            CCAnimation *getup = [CCAnimation animationWithFrames:getupArray delay:0.1f];
            [_man runAction:[CCAnimate actionWithAnimation:getup restoreOriginalFrame:NO]];
        }else if(fallen && tapCount == 10){
            _man.position = ccp(_man.position.x, _man.position.y+40);
            NSMutableArray *fallingArray = [NSMutableArray array];
            for(int i = 3; i >= 0; --i) {
                [fallingArray addObject:
                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                  [NSString stringWithFormat:@"yetifalling%d.png", i]]];
            }
            CCAnimation *falling = [CCAnimation animationWithFrames:fallingArray delay:0.08f];
            [_man runAction:[CCAnimate actionWithAnimation:falling restoreOriginalFrame:NO]];
            [trail resetSystem];
            hitTime = NO;
            fallen = NO;
            dropShadowSprite.visible = YES;
            dropShadowBoardSprite.visible = YES;
           // [self scheduleUpdate];
            [self schedule:@selector(updateTimer) interval:.3];
            [self schedule:@selector(updateBg) interval:.1];
            tapCount = 0;
            [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:kAchievementsChumbawumba percentComplete:100.0];
        }
    
}

-(void)swipe{
    if(!jumping && _man.position.y == jumpOrigin && !fallen && ![[CCDirector sharedDirector] isPaused]){
        _man.scale = 1.1;
        //[[SimpleAudioEngine sharedEngine] playEffect:@"jump.wav"];
        jumping = YES;
        [self schedule:@selector(jumper) interval:.2];
        [trail stopSystem];
        
        ySpeed = 4;
        [self doJump];
    }
}

-(void)swipeJump{
    if(jumping && _man.position.y > jumpOrigin && !fallen && ![[CCDirector sharedDirector] isPaused] && tricker){
        [_man runAction:[CCRotateBy actionWithDuration:0.55 angle:360]];
        [dropShadowSprite runAction:[CCRotateBy actionWithDuration:0.55 angle:360]];
    }
}



-(void)doJump{
    if(_shipPointsPerSecY > 0){
        NSMutableArray *jumpArray = [NSMutableArray array];
        for(int i = 1; i <= 5; ++i) {
            [jumpArray addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"yetiJumping%d.png", i]]];
        }
        
        leftturn = [CCAnimation animationWithFrames:jumpArray delay:0.1f];
        [_man runAction:[CCAnimate actionWithAnimation:leftturn restoreOriginalFrame:YES]];
        
        NSMutableArray *rightboardturnArray = [NSMutableArray array];
        for(int i = 5; i >= 1; --i) {
            [rightboardturnArray addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"board_jumping%d.png", i]]];
        }
        
        boardrightturn = [CCAnimation animationWithFrames:rightboardturnArray delay:0.1f];
        [_board runAction:[CCAnimate actionWithAnimation:boardrightturn restoreOriginalFrame:YES]];
    }else{
        NSMutableArray *jumpArray = [NSMutableArray array];
        for(int i = 1; i <= 5; ++i) {
            [jumpArray addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"yetiJumpingleft%d.png", i]]];
        }
        
        leftturn = [CCAnimation animationWithFrames:jumpArray delay:0.1f];
        [_man runAction:[CCAnimate actionWithAnimation:leftturn restoreOriginalFrame:YES]];
        
        NSMutableArray *rightboardturnArray = [NSMutableArray array];
        for(int i = 5; i >= 1; --i) {
            [rightboardturnArray addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"board_jumpingleft%d.png", i]]];
        }
        
        boardrightturn = [CCAnimation animationWithFrames:rightboardturnArray delay:0.1f];
        [_board runAction:[CCAnimate actionWithAnimation:boardrightturn restoreOriginalFrame:YES]];
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

}

-(void)jumper{
    jumping = NO;
    ySpeed = 2;
    [self unschedule:@selector(jumper)];
}

-(void)bigJump{
    bigJump = NO;
    [self unschedule:@selector(bigJump)];
}

-(void)updateTimer{
    if(timer <= 0){
        timer = timer + 70;
    }else if(timer > 0 && timer <= 200){
        timer = timer + 7;
    }else if(timer > 200 && timer <= 500){
        timer = timer + 5;
    }else if(timer > 500 && timer <= 700){
        timer = timer + 3;
    }else if(timer > 700){
        timer = timer + 1;
    }
    
}

-(void)updateBg{
    if(bg.texture == [[CCSprite spriteWithFile:@"hill1.png"]texture]){
        [bg setTexture:[[CCSprite spriteWithFile:@"hill2.png"]texture]];
    }else if(bg.texture == [[CCSprite spriteWithFile:@"hill2.png"]texture]){
        [bg setTexture:[[CCSprite spriteWithFile:@"hill3.png"]texture]];
    }else if(bg.texture == [[CCSprite spriteWithFile:@"hill3.png"]texture]){
        [bg setTexture:[[CCSprite spriteWithFile:@"hill1.png"]texture]];
    }
}

-(void)slowDown{
    timer = timer - 500;
    [self unschedule:@selector(slowDown)];
}

-(void)hitTime{
    hitTime = NO;
    [self unschedule:@selector(hitTime)];
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
