//
//  MainMenuScene.m
//  Snowboard
//
//  Created by Kyle Langille on 2012-12-05.
//
//

#import "MainMenuScene.h"
#import "HelloWorldLayer.h"

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
        
        CCLabelTTF *title = [CCLabelTTF labelWithString:@"Main Menu" fontName:@"Courier" fontSize:28];
        title.position =  ccp(winSize.width/2, winSize.height/2+80);
        [self addChild: title];
        
        CCLayer *menuLayer = [[CCLayer alloc] init];
        [self addChild:menuLayer];
        
        CCLabelTTF *go = [CCLabelTTF labelWithString:@"Play" fontName:@"Courier" fontSize:16];
        CCLabelTTF *about = [CCLabelTTF labelWithString:@"About" fontName:@"Courier" fontSize:16];
        CCLabelTTF *store = [CCLabelTTF labelWithString:@"Store" fontName:@"Courier" fontSize:16];
        CCLabelTTF *leaderboard = [CCLabelTTF labelWithString:@"Leaderboard" fontName:@"Courier" fontSize:16];
        CCLabelTTF *achievements = [CCLabelTTF labelWithString:@"Achievements" fontName:@"Courier" fontSize:16];
        CCMenuItemLabel *startButton = [CCMenuItemLabel itemWithLabel:go target:self selector:@selector(startGame:)];
        CCMenuItemLabel *aboutButton = [CCMenuItemLabel itemWithLabel:about target:self selector:@selector(startGame:)];
        CCMenuItemLabel *storeButton = [CCMenuItemLabel itemWithLabel:store target:self selector:@selector(startGame:)];
        CCMenuItemLabel *leaderButton = [CCMenuItemLabel itemWithLabel:leaderboard target:self selector:@selector(showLeaderboard:)];
        CCMenuItemLabel *achievementsButton = [CCMenuItemLabel itemWithLabel:achievements target:self selector:@selector(showAchievements:)];

        
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
    
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
}

- (void)showLeaderboard: (id)sender{
    [[GameKitHelper sharedGameKitHelper] showLeaderboard];
}

- (void)showAchievements: (id)sender{
    [[GameKitHelper sharedGameKitHelper] showAchievements];
}

- (void) dealloc
{
    
    [super dealloc];
}
@end
