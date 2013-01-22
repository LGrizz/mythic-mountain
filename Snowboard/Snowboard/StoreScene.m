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
#import "MythicMtnIAPHelper.h"

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
        CCLabelTTF *buy = [CCLabelBMFont labelWithString:@"Buy Coins" fntFile:@"game_over_dist_coins16pt.fnt"];
        /*CCLabelTTF *about = [CCLabelTTF labelWithString:@"About" fontName:@"Courier" fontSize:16];
        CCLabelTTF *store = [CCLabelTTF labelWithString:@"Store" fontName:@"Courier" fontSize:16];
        CCLabelTTF *leaderboard = [CCLabelTTF labelWithString:@"Leaderboard" fontName:@"Courier" fontSize:16];
        CCLabelTTF *achievements = [CCLabelTTF labelWithString:@"Achievements" fontName:@"Courier" fontSize:16];*/
        CCMenuItemLabel *menuButton = [CCMenuItemLabel itemWithLabel:go target:self selector:@selector(showMainMenu:)];
        CCMenuItemLabel *buyButton = [CCMenuItemLabel itemWithLabel:buy target:self selector:@selector(buyCoins:)];
        /*CCMenuItemLabel *aboutButton = [CCMenuItemLabel itemWithLabel:about target:self selector:@selector(startGame:)];
        CCMenuItemLabel *storeButton = [CCMenuItemLabel itemWithLabel:store target:self selector:@selector(startGame:)];
        CCMenuItemLabel *leaderButton = [CCMenuItemLabel itemWithLabel:leaderboard target:self selector:@selector(showLeaderboard:)];
        CCMenuItemLabel *achievementsButton = [CCMenuItemLabel itemWithLabel:achievements target:self selector:@selector(showAchievements:)];*/
        
        CCSprite *coinUI = [CCSprite spriteWithFile:@"coinUI.png"];
        coinUI.position = ccp(winSize.width - 20, winSize.height - 30);
        [self addChild:coinUI z:999];
        
        int totalCoins = [[SettingsManager sharedSettingsManager] getInt:@"coins"];
        coinScoreLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i", totalCoins] fntFile:@"coin_24pt.fnt"];
        coinScoreLabel.anchorPoint = ccp(1.0f,0.5f);
        coinScoreLabel.position = ccp(winSize.width - 35, winSize.height - 33);
        
        [self addChild:coinScoreLabel z:999];
        
        CCMenu *menu = [CCMenu menuWithItems: menuButton, buyButton, nil];
        [menu alignItemsVerticallyWithPadding:10.0f];
        menu.position = ccp(winSize.width/2, winSize.height-220);
        [menuLayer addChild: menu];
        
        CCMenuItemImage *yetiItem = [CCMenuItemImage itemFromNormalImage:@"yetiTurning01.png" selectedImage:@"yetiTurning01.png" target:self selector:@selector(selectYeti:)];
        CCMenuItemImage *unicornItem = [CCMenuItemImage itemFromNormalImage:@"unicornTurning01.png" selectedImage:@"unicornTurning01.png" target:self selector:@selector(selectUnicorn:)];
            
        CCMenu *menu3 = [CCMenu menuWithItems: yetiItem, unicornItem, nil];
        [menu3 alignItemsHorizontallyWithPadding:10.0f];
        menu3.position = ccp(winSize.width/2, winSize.height-300);
        [self addChild: menu3];
        
        CCMenuItemImage *hammerItem = [CCMenuItemImage itemFromNormalImage:@"mjolnir.png" selectedImage:@"mjolnir.png" target:self selector:@selector(selectHammer:)];
        CCMenuItemImage *swordItem = [CCMenuItemImage itemFromNormalImage:@"excalibur.png" selectedImage:@"excalibur.png" target:self selector:@selector(selectSword:)];
        CCMenuItemImage *wingItem = [CCMenuItemImage itemFromNormalImage:@"icarus.png" selectedImage:@"icarus.png" target:self selector:@selector(selectWings:)];
        CCMenuItemImage *midasItem = [CCMenuItemImage itemFromNormalImage:@"midas.png" selectedImage:@"midas.png" target:self selector:@selector(selectMidas:)];
        
        CCMenu *menu2 = [CCMenu menuWithItems: hammerItem, swordItem, wingItem, midasItem, nil];
        [menu2 alignItemsHorizontallyWithPadding:10.0f];
        menu2.position = ccp(winSize.width/2, winSize.height-380);
        [self addChild: menu2];
        
        [self getInAppList];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    }
    return self;
}

-(void)getInAppList{
    [[MythicMtnIAPHelper sharedHelper] requestProducts];
    /*Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        NSLog(@"No internet connection!");
    } else {
        if ([MythicMtnIAPHelper sharedHelper].products == nil) {
            
            [[MythicMtnIAPHelper sharedHelper] requestProducts];
            //self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            //_hud.labelText = @"Loading comics...";
            //[self performSelector:@selector(timeout:) withObject:nil afterDelay:30.0];
            
        }        
    }*/
}

- (void)productsLoaded:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    SKProduct *product = [[MythicMtnIAPHelper sharedHelper].products objectAtIndex:0];
    NSLog(@"%@", product.productIdentifier);
    //[MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    //self.tableView.hidden = FALSE;
    
    //[self.tableView reloadData];
    
}

- (void)productPurchased:(NSNotification *)notification {
    
    NSLog(@"%@", @"purchased dem coinsk");
    int totalCoins = [[SettingsManager sharedSettingsManager] getInt:@"coins"];
    totalCoins = totalCoins + 10000;
    [[SettingsManager sharedSettingsManager] setIntValue:totalCoins name:@"coins"];
    
    [coinScoreLabel setString:[NSString stringWithFormat:@"%i", totalCoins]];
    
}

-(void)buyCoins:(id)sender{
    [[MythicMtnIAPHelper sharedHelper] buyProduct:[[MythicMtnIAPHelper sharedHelper].products objectAtIndex:0]];
}

-(void)showMainMenu: (id)sender{
    [[SettingsManager sharedSettingsManager] save];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[MainMenuScene scene]]];
}

-(void)selectHammer: (id)sender{
    NSLog(@"Gimme dat hammer");
    [[SettingsManager sharedSettingsManager] setStringValue:@"hammer" name:@"equipment"];
}

-(void)selectMidas: (id)sender{
    NSLog(@"Gimme dat midas");
    [[SettingsManager sharedSettingsManager] setStringValue:@"midas" name:@"equipment"];
}

-(void)selectSword: (id)sender{
    NSLog(@"Gimme dat sword");
    [[SettingsManager sharedSettingsManager] setStringValue:@"sword" name:@"equipment"];
}

-(void)selectWings: (id)sender{
    NSLog(@"Gimme those wangs");
    [[SettingsManager sharedSettingsManager] setStringValue:@"wings" name:@"equipment"];
}

-(void)selectYeti: (id)sender{
    NSLog(@"Let's play yeti style");
    [[SettingsManager sharedSettingsManager] setStringValue:@"yeti" name:@"character"];
}

-(void)selectUnicorn: (id)sender{
    NSLog(@"SeXy horn on me");
    [[SettingsManager sharedSettingsManager] setStringValue:@"unicorn" name:@"character"];
}


- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
    
}
@end
