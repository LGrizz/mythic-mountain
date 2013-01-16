//
//  MainMenuScene.m
//  Snowboard
//
//  Created by Kyle Langille on 2012-12-05.
//
//

#import "MainMenuScene.h"
#import "HelloWorldLayer.h"
#import "SettingsManager.h"
#import "StoreScene.h"

@implementation MainMenuScene

+(id) scene
{
    CCScene *scene = [CCScene node];
    
    MainMenuScene *layer = [MainMenuScene node];
    
    [scene addChild: layer];
    
    return scene;
}

-(id) init
{
    
    if( (self=[super init] )) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *top = [CCSprite spriteWithFile:@"static_bg.png"];
        [top setPosition:ccp(winSize.width/2, winSize.height - top.contentSize.height/2)];
        [self addChild:top];
        
        CCSprite *bg = [CCSprite spriteWithFile:@"hill1.png"];
        bg.anchorPoint = ccp(0.5f,1.0f);
        [bg setPosition:ccp(winSize.width/2, winSize.height-161)];
        [self addChild:bg];
        
        CCLabelTTF *title = [CCLabelBMFont labelWithString:@"Main Menu" fntFile:@"game_over_menu28pt.fnt"];
        title.position =  ccp(winSize.width/2, winSize.height-50);
        [self addChild: title];
        
        CCLayer *menuLayer = [[CCLayer alloc] init];
        [self addChild:menuLayer];
        
        CCLabelTTF *go = [CCLabelBMFont labelWithString:@"Play" fntFile:@"game_over_dist_coins16pt.fnt"];
        CCLabelTTF *about = [CCLabelBMFont labelWithString:@"About" fntFile:@"game_over_dist_coins16pt.fnt"];
        CCLabelTTF *store = [CCLabelBMFont labelWithString:@"Store" fntFile:@"game_over_dist_coins16pt.fnt"];
        CCLabelTTF *leaderboard = [CCLabelBMFont labelWithString:@"Leaderboard" fntFile:@"game_over_dist_coins16pt.fnt"];
        CCLabelTTF *achievements = [CCLabelBMFont labelWithString:@"Achievements" fntFile:@"game_over_dist_coins16pt.fnt"];
        CCMenuItemLabel *startButton = [CCMenuItemLabel itemWithLabel:go target:self selector:@selector(startGame:)];
        CCMenuItemLabel *aboutButton = [CCMenuItemLabel itemWithLabel:about target:self selector:@selector(startGame:)];
        CCMenuItemLabel *storeButton = [CCMenuItemLabel itemWithLabel:store target:self selector:@selector(showStore:)];
        CCMenuItemLabel *leaderButton = [CCMenuItemLabel itemWithLabel:leaderboard target:self selector:@selector(showLeaderboard:)];
        CCMenuItemLabel *achievementsButton = [CCMenuItemLabel itemWithLabel:achievements target:self selector:@selector(showAchievements:)];

        CCSprite *coinUI = [CCSprite spriteWithFile:@"coinUI.png"];
        coinUI.position = ccp(winSize.width - 20, winSize.height - 30);
        [self addChild:coinUI z:999];
        
        int totalCoins = [[SettingsManager sharedSettingsManager] getInt:@"coins"];
        CCLabelTTF *coinScoreLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i", totalCoins] fntFile:@"coin_24pt.fnt"];
        coinScoreLabel.anchorPoint = ccp(1.0f,0.5f);
        coinScoreLabel.position = ccp(winSize.width - 35, winSize.height - 33);
        
        [self addChild:coinScoreLabel z:999];
        
        CCMenu *menu = [CCMenu menuWithItems: startButton, aboutButton, storeButton, leaderButton, achievementsButton, nil];
        [menu alignItemsVerticallyWithPadding:10.0f];
        menu.position = ccp(winSize.width/2, winSize.height/2-20);
        [menuLayer addChild: menu];
        
        CCParticleSystemQuad *snowEffect = [CCParticleSystemQuad particleWithFile:@"snow.plist"];

       // [self addChild:snowEffect z:999];
    }
    return self;
}

- (void) onEnter {
    [super onEnter];
    
    [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
}

- (void) startGame: (id) sender
{
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];
}

- (void)showLeaderboard: (id)sender{
    [[GameKitHelper sharedGameKitHelper] showLeaderboard];
}

- (void)showAchievements: (id)sender{
    [[GameKitHelper sharedGameKitHelper] showAchievements];
}

-(void)showStore: (id)sender{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[StoreScene scene]]];
}

- (void) dealloc
{
    
    [super dealloc];
}
@end
