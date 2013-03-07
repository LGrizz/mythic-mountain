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
#import "SettingsManager.h"
#import <Social/Social.h>
#import "SimpleAudioEngine.h"
#import "Flurry.h"

@implementation GameOverLayer{
    CCSprite *gameoverBg;
    CCMenu *menu;
    int d;
    int c;
}

-(id)init:(int)distance coins:(int)coinScore {
    
    if ((self = [super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        d = distance;
        c = coinScore;
        
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
        
        CCSprite *gameoverCage = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_cage1.png", (NSString *)[[SettingsManager sharedSettingsManager] getString:@"character"]]];
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
              [NSString stringWithFormat:@"%@_cage%i.png", (NSString *)[[SettingsManager sharedSettingsManager] getString:@"character"], i]]];
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
        
       /* CCSprite *fb = [CCSprite spriteWithFile:@"facebook.png"];
        fb.position = ccp(winSize.width/2 + 15, winSize.height - 330);
        [self addChild:fb z:997];
        
        CCSprite *twitter = [CCSprite spriteWithFile:@"twitter.png"];
        twitter.position = ccp(winSize.width/2 - 15, winSize.height - 330);
        [self addChild:twitter z:997];*/
        
        CCMenuItemSprite *fb = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"facebook.png"] selectedSprite:[CCSprite spriteWithFile:@"facebook.png"] target:self selector:@selector(shareFacebook)];
        
        CCMenuItemSprite *twitter = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"twitter.png"] selectedSprite:[CCSprite spriteWithFile:@"twitter.png"] target:self selector:@selector(shareTwitter)];
        
        CCMenu *shareButtons = [CCMenu menuWithItems:fb,twitter, nil];
        shareButtons.position = ccp(winSize.width/2, winSize.height - 330);
        [shareButtons alignItemsHorizontallyWithPadding:13];
        [self addChild:shareButtons z:997];
        
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

        if([[[SettingsManager sharedSettingsManager] getString:@"audio"] isEqualToString:@"on"]){
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"gameover.mp3" loop:YES];
            [SimpleAudioEngine sharedEngine].backgroundMusicVolume = .7;
        }
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
    [Flurry logEvent:@"Restart"];
    if([[CCDirector sharedDirector] isPaused]){
        [[CCDirector sharedDirector] resume];
    }
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)achievementsTapped:(id)sender {
    [Flurry logEvent:@"Gamecenter"];
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
    [Flurry logEvent:@"Show Store"];
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

-(void)shareFacebook{
    SLComposeViewController *fbController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            [fbController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                {
                    NSLog(@"Cancelled.....");
                    
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
                    NSLog(@"Posted....");
                }
                    break;
            }};
        
        [fbController setInitialText:[NSString stringWithFormat:@"I just rode %d yd down Mythic Mountain as a %@ and collected %d coins. Get the game free at http://mythicmtn.com", d, [[SettingsManager sharedSettingsManager] getString:@"character"], c]];
        [fbController setCompletionHandler:completionHandler];
        UIViewController* rootVC = [self getRootViewController];
        [rootVC presentViewController:fbController animated:YES
                           completion:nil];
    }else{
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Share feautures"
                                                          message:@"Please configure facebook in your device settings to share."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }

}

-(void)shareTwitter{
    SLComposeViewController *twitController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            [twitController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                {
                    NSLog(@"Cancelled.....");
                    
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
                    NSLog(@"Posted....");
                }
                    break;
            }};
        
        [twitController setInitialText:[NSString stringWithFormat:@"I just rode %d yd down Mythic Mountain as a %@ and collected %d coins. Get the game free at http://mythicmtn.com", d, [[SettingsManager sharedSettingsManager] getString:@"character"], c]];
        [twitController setCompletionHandler:completionHandler];
        UIViewController* rootVC = [self getRootViewController];
        [rootVC presentViewController:twitController animated:YES
                           completion:nil];
    }else{
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Share feautures"
                                                          message:@"Please configure twitter in your device settings to share."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    
}

-(UIViewController*) getRootViewController {
    return [UIApplication
            sharedApplication].keyWindow.rootViewController;
}

@end
