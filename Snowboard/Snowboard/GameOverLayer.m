//
//  GameOverLayer.m
//  Snowboard
//
//  Created by Kyle Langille on 2013-01-18.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"
#import "HelloWorldLayer.h"
#import "MainMenuScene.h"
#import "StoreScene.h"

@implementation GameOverLayer{
    CCSprite *gameoverBg;
    CCMenu *menu;
}

-(id)init:(int)distance coins:(int)coinScore {
    
    if ((self = [super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        gameoverBg = [CCSprite spriteWithFile:@"gameoverBg.png"];
        gameoverBg.anchorPoint = ccp(0.0f,1.0f);
        gameoverBg.position = ccp(0, winSize.height);
        gameoverBg.opacity = 160;
        [self addChild:gameoverBg z:990];
        
        CCSprite *gameoverTrapper = [CCSprite spriteWithFile:@"gameovertrapper1.png"];
        gameoverTrapper.position = ccp(115, winSize.height-155);
        [gameoverTrapper.texture setAliasTexParameters];
        [self addChild:gameoverTrapper z:995];
        
        NSMutableArray *gameovertrapperArray = [NSMutableArray array];
        for(int i = 1; i <= 4; ++i) {
            [gameovertrapperArray addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"trapper%d.png", i]]];
        }
        
        CCAnimation *gameovertrapperpump = [CCAnimation animationWithFrames:gameovertrapperArray delay:0.1f];
        [gameoverTrapper runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:gameovertrapperpump restoreOriginalFrame:NO]]];
        
        CCSprite *gameoverCage = [CCSprite spriteWithFile:@"yeti_cage1.png"];
        gameoverCage.position = ccp(220, winSize.height+120);
        [gameoverCage.texture setAliasTexParameters];
        [self addChild:gameoverCage z:996];
        
        id action = [CCMoveTo actionWithDuration:1.2 position:ccp(220, winSize.height-gameoverCage.boundingBox.size.height/2)];
        id ease = [CCEaseBounceOut actionWithAction:action];
        [gameoverCage runAction: ease];
        //[gameoverCage runAction:[CCMoveTo actionWithDuration:1.2 position:ccp(220, winSize.height-gameoverCage.boundingBox.size.height/2)]];
        
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
        [self addChild:label z:999];
        
        CCLabelBMFont *yards;
        yards = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"You made it %d yards", distance] fntFile:@"game_over_dist_coins16pt.fnt"];
        yards.position = ccp(winSize.width/2, winSize.height - 282);
        [self addChild:yards z:997];
        CCLabelBMFont *coins;
        coins = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"You collected %d coins", coinScore] fntFile:@"game_over_dist_coins16pt.fnt"];
        coins.position = ccp(winSize.width/2, winSize.height - 302);
        [self addChild:coins z:997];
        
        CCSprite *fb = [CCSprite spriteWithFile:@"facebook.png"];
        fb.position = ccp(winSize.width/2 + 15, winSize.height - 330);
        [self addChild:fb z:997];
        
        CCSprite *twitter = [CCSprite spriteWithFile:@"twitter.png"];
        twitter.position = ccp(winSize.width/2 - 15, winSize.height - 330);
        [self addChild:twitter z:997];
        
        CCLabelBMFont *playagain;
        playagain = [CCLabelBMFont labelWithString:@"PLAY AGAIN" fntFile:@"game_over_menu28pt.fnt"];
        [playagain.texture setAliasTexParameters];
        CCLabelBMFont *spendcoins;
        spendcoins = [CCLabelBMFont labelWithString:@"SPEND COINS" fntFile:@"game_over_menu28pt.fnt"];
        [spendcoins.texture setAliasTexParameters];
        CCLabelBMFont *achievements;
        achievements = [CCLabelBMFont labelWithString:@"ACHIEVEMENTS" fntFile:@"game_over_menu28pt.fnt"];
        [achievements.texture setAliasTexParameters];
        CCLabelBMFont *mainmenu;
        mainmenu = [CCLabelBMFont labelWithString:@"MAIN MENU" fntFile:@"game_over_menu28pt.fnt"];
        [mainmenu.texture setAliasTexParameters];
        
        CCMenuItemLabel *playagainItem = [CCMenuItemLabel itemWithLabel:playagain target:self selector:@selector(restartTapped:)];
        playagainItem.position = ccp(winSize.width/2, winSize.height - 370);
        CCMenuItemLabel *spendcoinsItem = [CCMenuItemLabel itemWithLabel:spendcoins target:self selector:@selector(showStore:)];
        spendcoinsItem.position = ccp(winSize.width/2, winSize.height - 400);
        CCMenuItemLabel *achievementsItem = [CCMenuItemLabel itemWithLabel:achievements target:self selector:@selector(achievementsTapped:)];
        achievementsItem.position = ccp(winSize.width/2,  winSize.height - 430);
        CCMenuItemLabel *mainmenuItem = [CCMenuItemLabel itemWithLabel:mainmenu target:self selector:@selector(mainmenuTapped:)];
        mainmenuItem.position = ccp(winSize.width/2,  winSize.height - 460);
        
        
        menu = [CCMenu menuWithItems:playagainItem,spendcoinsItem,achievementsItem,mainmenuItem, nil];
        menu.position = CGPointZero;
        [self addChild:menu z:999];

        [self setOpacityBlank:0];
        [self setOpacity:255];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideStore) name:@"hideStore" object:nil];

    }
    return self;
}

// Set the opacity of all of our children that support it
-(void) setOpacity: (GLubyte) opacity
{
    for( CCNode *node in [self children] )
    {
        if( [node conformsToProtocol:@protocol( CCRGBAProtocol)] )
        {
            //[(id<CCRGBAProtocol>) node setOpacity: opacity];
            if(node != gameoverBg){
                [node runAction:[CCFadeTo actionWithDuration:.5 opacity:opacity]];
            }else{
                [node runAction:[CCFadeTo actionWithDuration:.5 opacity:150]];
            }
        }
    }
}

-(void) setOpacityBlank: (GLubyte) opacity
{
    for( CCNode *node in [self children] )
    {
        if( [node conformsToProtocol:@protocol( CCRGBAProtocol)] )
        {
            [(id<CCRGBAProtocol>) node setOpacity: opacity];
        }
    }
}


- (void)restartTapped:(id)sender {
    if([[CCDirector sharedDirector] isPaused]){
        [[CCDirector sharedDirector] resume];
    }
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)achievementsTapped:(id)sender {
    [[GameKitHelper sharedGameKitHelper] showAchievements];
}

- (void)mainmenuTapped:(id)sender {
    if([[CCDirector sharedDirector] isPaused]){
        [[CCDirector sharedDirector] resume];
    }
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[MainMenuScene scene]]];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)showStore: (id)sender{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    StoreScene *store = [[StoreScene alloc] init];
    
    store.position = ccp(0, -winSize.height);
    [self addChild:store z:999];
    id action = [CCMoveTo actionWithDuration:.8 position:ccp(0, 0)];
    id ease = [CCEaseIn actionWithAction:action rate:2];
    [store runAction: ease];
    
    menu.isTouchEnabled = NO;
}

-(void)hideStore{
    menu.isTouchEnabled = YES;
}

@end
