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


@implementation PauseLayer

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
    
    CCSprite *characterButton = [CCSprite spriteWithFile:@"yetiTurning01.png"];
    characterButton.position = ccp(winSize.width-80 , winSize.height - 230);
    characterButton.scale = 2;
    [characterButton.texture setAliasTexParameters];
    [self addChild:characterButton z:999];
    
    CCMenuItemSprite *spendCoins = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"spendCoinsButton.png"] selectedSprite:[CCSprite spriteWithFile:@"spendCoinsButton.png"] target:self selector:@selector(showStore:)];
    
    CCMenuItemSprite *continueButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"continue-button.png"] selectedSprite:[CCSprite spriteWithFile:@"continue-button.png"] target:self selector:@selector(pause:)];
    
    CCMenu *menu = [CCMenu menuWithItems:spendCoins,continueButton, nil];
    menu.position = ccp(winSize.width/2, winSize.height - 230);
    [menu alignItemsHorizontallyWithPadding:20];
    [self addChild:menu z:998];
    
    //singleTap = [CCGestureRecognizer CCRecognizerWithRecognizerTargetAction:[[[UITapGestureRecognizer alloc]init] autorelease] target:self action:@selector(pause:)];
    //[continueButton addGestureRecognizer:singleTap];
    
    CCLabelBMFont *settings;
    settings = [CCLabelBMFont labelWithString:@"SETTINGS" fntFile:@"game_over_menu28pt.fnt"];
    [settings.texture setAliasTexParameters];
    CCLabelBMFont *achievements;
    achievements = [CCLabelBMFont labelWithString:@"ACHIEVEMENTS" fntFile:@"game_over_menu28pt.fnt"];
    [achievements.texture setAliasTexParameters];
    CCLabelBMFont *mainmenu;
    mainmenu = [CCLabelBMFont labelWithString:@"MAIN MENU" fntFile:@"game_over_menu28pt.fnt"];
    [mainmenu.texture setAliasTexParameters];
    
    CCMenuItemLabel *settingsItem = [CCMenuItemLabel itemWithLabel:settings target:self selector:@selector(restartTapped:)];
    settingsItem.position = ccp(winSize.width/2, winSize.height - 380);
    CCMenuItemLabel *achievementsItem = [CCMenuItemLabel itemWithLabel:achievements target:self selector:@selector(achievementsTapped:)];
    achievementsItem.position = ccp(winSize.width/2,  winSize.height - 410);
    CCMenuItemLabel *mainmenuItem = [CCMenuItemLabel itemWithLabel:mainmenu target:self selector:@selector(mainmenuTapped:)];
    mainmenuItem.position = ccp(winSize.width/2,  winSize.height - 440);
    
    menu = [CCMenu menuWithItems:settingsItem,achievementsItem,mainmenuItem, nil];
    menu.position = CGPointZero;
    [self addChild:menu z:999];
        
    }
    return self;
}

-(void)pause:(id)sender{
    [self.parent performSelector:@selector(pause:)];
}

- (void)restartTapped:(id)sender {
    if([[CCDirector sharedDirector] isPaused]){
        [[CCDirector sharedDirector] resume];
    }
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];
}

- (void)achievementsTapped:(id)sender {
    [[GameKitHelper sharedGameKitHelper] showAchievements];
}

- (void)mainmenuTapped:(id)sender {
    if([[CCDirector sharedDirector] isPaused]){
        [[CCDirector sharedDirector] resume];
    }
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[MainMenuScene scene]]];
}

-(void)showStore: (id)sender{
    if([[CCDirector sharedDirector] isPaused]){
        [[CCDirector sharedDirector] resume];
    }
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[StoreScene scene]]];
}


@end
