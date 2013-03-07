//
//  PauseLayer.m
//  Snowboard
//
//  Created by Kyle Langille on 2013-01-18.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "PauseLayer.h"
#import "HelloWorldLayer.h"
#import "MainMenuScene.h"
#import "StoreScene.h"
#import "SettingsManager.h"
#import "SettingsLayer.h"
#import "Flurry.h"


@implementation PauseLayer{
    CCMenu *bigButtons;
    CCMenu *smallButtons;
}

-(id)init{
    if ((self = [super init])) {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    //pauseLayer = [CCLayer node];
    
    CCSprite *gameoverBg = [CCSprite spriteWithFile:@"pause_bg.png"];
    gameoverBg.anchorPoint = ccp(0.0f,1.0f);
    gameoverBg.position = ccp(0, winSize.height);
    gameoverBg.opacity = 130;
    [self addChild:gameoverBg z:990];
    
    CCSprite *pauseHeader = [CCSprite spriteWithFile:@"pauseUI.png"];
    pauseHeader.scale = 2;
    pauseHeader.position = ccp(winSize.width/2 + pauseHeader.boundingBox.size.width/4 - 5 , winSize.height - 60);
    [self addChild:pauseHeader z:999];
    
    CCSprite *characterButton = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_store.png", [[SettingsManager sharedSettingsManager] getString:@"character"]]];
    characterButton.position = ccp(winSize.width-80 , winSize.height - 230);
    characterButton.scale = 2;
    [characterButton.texture setAliasTexParameters];
    [self addChild:characterButton z:999];
    
    CCMenuItemSprite *spendCoins = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"spendCoinsButton.png"] selectedSprite:[CCSprite spriteWithFile:@"spendCoinsButton.png"] target:self selector:@selector(showStore:)];
    
    CCMenuItemSprite *continueButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"continue-button.png"] selectedSprite:[CCSprite spriteWithFile:@"continue-button.png"] target:self selector:@selector(pause:)];
    
    bigButtons = [CCMenu menuWithItems:spendCoins,continueButton, nil];
    bigButtons.position = ccp(winSize.width/2, winSize.height - 230);
    [bigButtons alignItemsHorizontallyWithPadding:20];
    [self addChild:bigButtons z:998];
    
    //singleTap = [CCGestureRecognizer CCRecognizerWithRecognizerTargetAction:[[[UITapGestureRecognizer alloc]init] autorelease] target:self action:@selector(pause:)];
    //[continueButton addGestureRecognizer:singleTap];
    
    CCLabelBMFont *restart;
    restart = [CCLabelBMFont labelWithString:@"RESTART" fntFile:@"game_over_menu28pt.fnt"];
    CCLabelBMFont *settings;
    settings = [CCLabelBMFont labelWithString:@"SETTINGS" fntFile:@"game_over_menu28pt.fnt"];
    CCLabelBMFont *achievements;
    achievements = [CCLabelBMFont labelWithString:@"ACHIEVEMENTS" fntFile:@"game_over_menu28pt.fnt"];
    CCLabelBMFont *mainmenu;
    mainmenu = [CCLabelBMFont labelWithString:@"MAIN MENU" fntFile:@"game_over_menu28pt.fnt"];
    
        
    CCMenuItemLabel *restartItem = [CCMenuItemLabel itemWithLabel:restart target:self selector:@selector(restartTapped:)];
    restartItem.position = ccp(winSize.width/2, winSize.height - 360);
    CCMenuItemLabel *settingsItem = [CCMenuItemLabel itemWithLabel:settings target:self selector:@selector(showSettings:)];
    settingsItem.position = ccp(winSize.width/2, winSize.height - 390);
    CCMenuItemLabel *achievementsItem = [CCMenuItemLabel itemWithLabel:achievements target:self selector:@selector(achievementsTapped:)];
    achievementsItem.position = ccp(winSize.width/2,  winSize.height - 420);
    CCMenuItemLabel *mainmenuItem = [CCMenuItemLabel itemWithLabel:mainmenu target:self selector:@selector(mainmenuTapped:)];
    mainmenuItem.position = ccp(winSize.width/2,  winSize.height - 450);
    
    smallButtons = [CCMenu menuWithItems:restartItem, settingsItem, achievementsItem, mainmenuItem, nil];
    smallButtons.position = CGPointZero;
    [self addChild:smallButtons z:999];
        
        [self setOpacityBlank:0];
        [self setOpacity:255];
        
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
            [node runAction:[CCFadeTo actionWithDuration:.5 opacity:opacity]];
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

-(void)pause:(id)sender{
    [self setOpacity:0];
    id callback = [CCCallBlock actionWithBlock:^{
        [self.parent performSelector:@selector(pause:)];
        [self.parent removeChild:self cleanup:YES];
    }];
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.8], callback, nil]];
     
}

- (void)restartTapped:(id)sender {
    if([[CCDirector sharedDirector] isPaused]){
        [[CCDirector sharedDirector] resume];
    }
    
    [Flurry logEvent:@"Restart"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];
}

- (void)achievementsTapped:(id)sender {
    [Flurry logEvent:@"Gamcenter"];
    [[GameKitHelper sharedGameKitHelper] showAchievements];
}

- (void)mainmenuTapped:(id)sender {
    if([[CCDirector sharedDirector] isPaused]){
        [[CCDirector sharedDirector] resume];
    }
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[MainMenuScene scene]]];
}

-(void)onEnter{
    [super onEnter];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideStore) name:@"hideStore" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideStore) name:@"hideSettings" object:nil];
}

-(void)onExit{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super onExit];
}

-(void)showStore: (id)sender{
    [Flurry logEvent:@"Show Store"];
    if([[CCDirector sharedDirector] isPaused]){
        [[CCDirector sharedDirector] resume];
    }
    CGSize winSize = [CCDirector sharedDirector].winSize;
    StoreScene *store = [[StoreScene alloc] init];
    
    store.position = ccp(0, -winSize.height);
    [self addChild:store z:999];
    
    bigButtons.isTouchEnabled = NO;
    smallButtons.isTouchEnabled = NO;
}

-(void)hideStore{
    bigButtons.isTouchEnabled = YES;
    smallButtons.isTouchEnabled = YES;
}

- (void)showSettings: (id)sender{
    SettingsLayer *settings = [[SettingsLayer alloc] init];
    
    [self addChild:settings z:999];
    
    self.isTouchEnabled = NO;
    bigButtons.isTouchEnabled = NO;
    smallButtons.isTouchEnabled = NO;
}


@end
