//
//  StoreScene.m
//  Snowboard
//
//  Created by Kyle Langille on 2013-01-15.
//
//

#import "StoreScene.h"
#import "HelloWorldLayer.h"
#import "SettingsManager.h"
#import "MainMenuScene.h"

@implementation StoreScene

+(id) scene
{
    CCScene *scene = [CCScene node];
    
    StoreScene *layer = [StoreScene node];
    
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
        
       /* CCSprite *hammer = [CCSprite spriteWithFile:@"mjolnir.png"];
        [hammer setPosition:ccp(winSize.width/2 - 20, 200)];
        [self addChild:hammer];
        
        CCSprite *sword = [CCSprite spriteWithFile:@"excalibur.png"];
        [sword setPosition:ccp(winSize.width/2 + 20, 200)];
        [self addChild:sword];*/
        
        CCLabelTTF *title = [CCLabelBMFont labelWithString:@"Store" fntFile:@"game_over_menu28pt.fnt"];
        title.position =  ccp(winSize.width/2, winSize.height-40);
        [self addChild: title];
        
        CCLayer *menuLayer = [[CCLayer alloc] init];
        [self addChild:menuLayer];
        
        CCLabelTTF *go = [CCLabelBMFont labelWithString:@"Main Menu" fntFile:@"game_over_dist_coins16pt.fnt"];
        /*CCLabelTTF *about = [CCLabelTTF labelWithString:@"About" fontName:@"Courier" fontSize:16];
        CCLabelTTF *store = [CCLabelTTF labelWithString:@"Store" fontName:@"Courier" fontSize:16];
        CCLabelTTF *leaderboard = [CCLabelTTF labelWithString:@"Leaderboard" fontName:@"Courier" fontSize:16];
        CCLabelTTF *achievements = [CCLabelTTF labelWithString:@"Achievements" fontName:@"Courier" fontSize:16];*/
        CCMenuItemLabel *menuButton = [CCMenuItemLabel itemWithLabel:go target:self selector:@selector(showMainMenu:)];
        /*CCMenuItemLabel *aboutButton = [CCMenuItemLabel itemWithLabel:about target:self selector:@selector(startGame:)];
        CCMenuItemLabel *storeButton = [CCMenuItemLabel itemWithLabel:store target:self selector:@selector(startGame:)];
        CCMenuItemLabel *leaderButton = [CCMenuItemLabel itemWithLabel:leaderboard target:self selector:@selector(showLeaderboard:)];
        CCMenuItemLabel *achievementsButton = [CCMenuItemLabel itemWithLabel:achievements target:self selector:@selector(showAchievements:)];*/
        
        CCSprite *coinUI = [CCSprite spriteWithFile:@"coinUI.png"];
        coinUI.position = ccp(winSize.width - 20, winSize.height - 30);
        [self addChild:coinUI z:999];
        
        int totalCoins = [[SettingsManager sharedSettingsManager] getInt:@"coins"];
        CCLabelTTF *coinScoreLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i", totalCoins] fntFile:@"coin_24pt.fnt"];
        coinScoreLabel.anchorPoint = ccp(1.0f,0.5f);
        coinScoreLabel.position = ccp(winSize.width - 35, winSize.height - 33);
        
        [self addChild:coinScoreLabel z:999];
        
        CCMenu *menu = [CCMenu menuWithItems: menuButton, nil];
        [menu alignItemsVerticallyWithPadding:10.0f];
        menu.position = ccp(winSize.width/2, winSize.height/2-20);
        [menuLayer addChild: menu];
        
        CCMenuItemImage *hammerItem = [CCMenuItemImage itemFromNormalImage:@"mjolnir.png" selectedImage:@"mjolnir.png" target:self selector:@selector(selectHammer:)];
        CCMenuItemImage *swordItem = [CCMenuItemImage itemFromNormalImage:@"excalibur.png" selectedImage:@"excalibur.png" target:self selector:@selector(selectSword:)];
        CCMenuItemImage *wingItem = [CCMenuItemImage itemFromNormalImage:@"icarus.png" selectedImage:@"icarus.png" target:self selector:@selector(selectWings:)];
        
        CCMenu *menu2 = [CCMenu menuWithItems: hammerItem, swordItem, wingItem, nil];
        [menu2 alignItemsHorizontallyWithPadding:10.0f];
        menu2.position = ccp(winSize.width/2, winSize.height/2-100);
        [self addChild: menu2];
    }
    return self;
}

-(void)showMainMenu: (id)sender{
    [[SettingsManager sharedSettingsManager] save];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[MainMenuScene scene]]];
}

-(void)selectHammer: (id)sender{
    NSLog(@"Gimme dat hammer");
    [[SettingsManager sharedSettingsManager] setStringValue:@"hammer" name:@"equipment"];
}

-(void)selectSword: (id)sender{
    NSLog(@"Gimme dat sword");
    [[SettingsManager sharedSettingsManager] setStringValue:@"sword" name:@"equipment"];
}

-(void)selectWings: (id)sender{
    NSLog(@"Gimme those wangs");
    [[SettingsManager sharedSettingsManager] setStringValue:@"wings" name:@"equipment"];
}

- (void) dealloc
{
    
    [super dealloc];
}
@end
