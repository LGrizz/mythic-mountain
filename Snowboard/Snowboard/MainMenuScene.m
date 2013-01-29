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
#import "AboutLayer.h"
#import "ControlsLayer.h"
#import "SettingsLayer.h"
#import "StoryLayer.h"

@implementation MainMenuScene{
    CCMenu *mainmenu;
}

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
        
        CCSprite *bg = [CCSprite spriteWithFile:@"start_bg.png"];
        bg.anchorPoint = ccp(0.0f,1.0f);
        [bg setPosition:ccp(0, winSize.height)];
        [self addChild:bg];
        
        CCLayer *menuLayer = [[CCLayer alloc] init];
        [self addChild:menuLayer];
        
        CCLabelTTF *go = [CCLabelBMFont labelWithString:@"PLAY" fntFile:@"main_uni24pt_white.fnt"];
        CCLabelTTF *store = [CCLabelBMFont labelWithString:@"STORE" fntFile:@"main_uni24pt_white.fnt"];
        CCLabelTTF *about = [CCLabelBMFont labelWithString:@"LEGEND" fntFile:@"main_uni24pt_white.fnt"];
        CCLabelTTF *leaderboard = [CCLabelBMFont labelWithString:@"GAMECENTER" fntFile:@"main_uni24pt_white.fnt"];
        CCLabelTTF *settings = [CCLabelBMFont labelWithString:@"SETTINGS" fntFile:@"main_uni24pt_white.fnt"];
        CCLabelTTF *control = [CCLabelBMFont labelWithString:@"CONTROLS" fntFile:@"main_uni24pt_white.fnt"];
        CCMenuItemLabel *startButton = [CCMenuItemLabel itemWithLabel:go target:self selector:@selector(startGame:)];
        CCMenuItemLabel *aboutButton = [CCMenuItemLabel itemWithLabel:about target:self selector:@selector(showAbout:)];
        CCMenuItemLabel *storeButton = [CCMenuItemLabel itemWithLabel:store target:self selector:@selector(showStore:)];
        CCMenuItemLabel *leaderButton = [CCMenuItemLabel itemWithLabel:leaderboard target:self selector:@selector(showLeaderboard:)];
        CCMenuItemLabel *settingsButton = [CCMenuItemLabel itemWithLabel:settings target:self selector:@selector(showSettings:)];
        CCMenuItemLabel *controlButton = [CCMenuItemLabel itemWithLabel:control target:self selector:@selector(showControls:)];
        
        mainmenu = [CCMenu menuWithItems: startButton, aboutButton, storeButton, leaderButton, settingsButton, controlButton, nil];
        [mainmenu alignItemsVerticallyWithPadding:5.0f];
        mainmenu.position = ccp(winSize.width/2, winSize.height - 320);
        [menuLayer addChild: mainmenu];
        
        CCParticleSystemQuad *snowEffect = [CCParticleSystemQuad particleWithFile:@"snow1.plist"];
        snowEffect.position = ccp(winSize.width/2, winSize.height + 10);

        [self addChild:snowEffect z:999];
        
        
    }
    return self;
}

- (void) onEnter {
    [super onEnter];
    
    [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
}

-(void)onExit{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super onExit];
}

- (void) startGame: (id) sender
{
    
    //[[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];
    
    StoryLayer *story = [[StoryLayer alloc] init];
    
    [self addChild:story z:999];
    
    self.isTouchEnabled = NO;
    mainmenu.isTouchEnabled = NO;
}

- (void)showLeaderboard: (id)sender{
    [[GameKitHelper sharedGameKitHelper] showLeaderboard];
}

- (void)showAbout: (id)sender{
    AboutLayer *about = [[AboutLayer alloc] init];
    
    [self addChild:about z:999];
    
    self.isTouchEnabled = NO;
    mainmenu.isTouchEnabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideStore) name:@"hideAbout" object:nil];
}

- (void)showControls: (id)sender{
    ControlsLayer *control = [[ControlsLayer alloc] init];
    
    [self addChild:control z:999];
    
    self.isTouchEnabled = NO;
    mainmenu.isTouchEnabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideStore) name:@"hideControls" object:nil];
}

- (void)showSettings: (id)sender{
    SettingsLayer *settings = [[SettingsLayer alloc] init];
    
    [self addChild:settings z:999];
    
    self.isTouchEnabled = NO;
    mainmenu.isTouchEnabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideStore) name:@"hideSettings" object:nil];
}

- (void)showAchievements: (id)sender{
    [[GameKitHelper sharedGameKitHelper] showAchievements];
}

-(void)showStore: (id)sender{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    StoreScene *store = [[StoreScene alloc] init];
    
    store.position = ccp(0, -winSize.height);
    [self addChild:store z:999];
    
    self.isTouchEnabled = NO;
    
    mainmenu.isTouchEnabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideStore) name:@"hideStore" object:nil];
}

-(void)hideStore{
    mainmenu.isTouchEnabled = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideAbout" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideStore" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideControls" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideSettings" object:nil];
}

- (void) dealloc
{
    
    [super dealloc];
}
@end
