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
#import "CCScrollLayer.h"
#import "CCMenu+Layout.h"
#import "Reachability.h"
#import "Flurry.h"
#import "DecoderAppEventTracking.h"

@implementation StoreScene{
    CCSprite *overlay;
    NSArray *products;
}

/*+(id) scene
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CCScene *scene = [CCScene node];
    
    StoreScene *layer = [StoreScene node];
    
    layer.position = ccp(0, -winSize.height);
    
    [scene addChild: layer];
    
    [layer runAction:[CCMoveTo a ctionWithDuration:2 position:ccp(0, 0)]];
    
    return scene;
}*/

-(id) init
{
    
    if( (self=[super init] )) {
        
        self.isTouchEnabled = YES;
        
        selected = @"home";
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"storeplatform.plist"];
        CCSpriteBatchNode *platformSheet = [CCSpriteBatchNode batchNodeWithFile:@"storeplatform.png"];
        [self addChild:platformSheet];
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        overlay = [CCSprite spriteWithFile:@"overlay.png"];
        overlay.position = ccp(0, winSize.height);
        overlay.anchorPoint = ccp(0.0f, 1.0f);
        overlay.opacity = 0;
        [self addChild:overlay];
        
        CCSprite *bg = [CCSprite spriteWithFile:@"storebg.png"];
        bg.anchorPoint = ccp(0.0f, 1.0f);
        [bg setPosition:ccp(0, winSize.height-18)];
        [self addChild:bg];
        
        CCSprite *shopTitle = [CCSprite spriteWithFile:@"shop_text.png"];
        [shopTitle setPosition:ccp(winSize.width/2 + 5, winSize.height-150)];
        [self addChild:shopTitle];
        
       /* CCSprite *hammer = [CCSprite spriteWithFile:@"mjolnir.png"];
        [hammer setPosition:ccp(winSize.width/2 - 20, 200)];
        [self addChild:hammer];
        
        CCSprite *sword = [CCSprite spriteWithFile:@"mjolnir.png"];
        [sword setPosition:ccp(winSize.width/2 + 20, 200)];
        [self addChild:sword];*/
        
        /*CCLabelTTF *title = [CCLabelBMFont labelWithString:@"Shop" fntFile:@"game_over_menu28pt.fnt"];
        title.position =  ccp(winSize.width/2, winSize.height-40);
        [self addChild: title];*/
        
        homeLayer = [[CCLayer alloc] init];
        CCLabelTTF *go = [CCLabelBMFont labelWithString:@"BACK" fntFile:@"uni_16_white_no_shadow.fnt"];
        CCMenuItemLabel *menuButton = [CCMenuItemLabel itemWithLabel:go target:self selector:@selector(back:)];
        CCMenu *menu = [CCMenu menuWithItems: menuButton, nil];
        menu.position = ccp(36, winSize.height-152);
        [self addChild: menu];
        
        CCSprite *plat1 = [CCSprite spriteWithFile:@"platform1.png"];
        CCMenuItemSprite *plat1Item = [CCMenuItemSprite itemFromNormalSprite:plat1 selectedSprite:nil target:self selector:@selector(characterSelect:)];
        CCMenu *plat1Menu = [CCMenu menuWithItems: plat1Item, nil];
        plat1Menu.position = ccp(120, winSize.height - 260);
        [homeLayer addChild:plat1Menu z:800];
        
        CCSprite *plat2 = [CCSprite spriteWithFile:@"platform1.png"];
        CCMenuItemSprite *plat2Item = [CCMenuItemSprite itemFromNormalSprite:plat2 selectedSprite:nil target:self selector:@selector(equipmentSelect:)];
        CCMenu *plat2Menu = [CCMenu menuWithItems: plat2Item, nil];
        plat2Menu.position = ccp(winSize.width-110, winSize.height - 260);
        [homeLayer addChild:plat2Menu z:800];
        
        CCSprite *plat3 = [CCSprite spriteWithFile:@"platform1.png"];
        CCMenuItemSprite *plat3Item = [CCMenuItemSprite itemFromNormalSprite:plat3 selectedSprite:nil target:self selector:@selector(buyCoins:)];
        CCMenu *plat3Menu = [CCMenu menuWithItems: plat3Item, nil];
        plat3Menu.position = ccp(120, winSize.height - 390);
        [homeLayer addChild:plat3Menu z:800];
        
        CCSprite *plat4 = [CCSprite spriteWithFile:@"platform1.png"];
        CCMenuItemSprite *plat4Item = [CCMenuItemSprite itemFromNormalSprite:plat4 selectedSprite:nil target:self selector:@selector(powerUpSelect:)];
        CCMenu *plat4Menu = [CCMenu menuWithItems: plat4Item, nil];
        plat4Menu.position = ccp(winSize.width-110, winSize.height - 390);
        [homeLayer addChild:plat4Menu z:800];
        
        NSMutableArray *platArray = [NSMutableArray array];
        for(int i = 1; i <= 4; ++i) {
            [platArray addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"platform%d.png", i]]];
        }
        
        CCAnimation *platAn = [CCAnimation animationWithFrames:platArray delay:0.1f];
        [plat1 runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:platAn restoreOriginalFrame:NO]]];
        [plat2 runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:platAn restoreOriginalFrame:NO]]];
        [plat3 runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:platAn restoreOriginalFrame:NO]]];
        [plat4 runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:platAn restoreOriginalFrame:NO]]];
        
        if([[[SettingsManager sharedSettingsManager] getString:@"character"] isEqualToString:@"yeti"]){
            characterItem = [CCMenuItemImage itemFromNormalImage:@"yetiTurning01.png" selectedImage:@"yetiTurning01.png" target:self selector:@selector(characterSelect:)];
        }else if([[[SettingsManager sharedSettingsManager] getString:@"character"] isEqualToString:@"unicorn"]){
            characterItem = [CCMenuItemImage itemFromNormalImage:@"unicorn_store.png" selectedImage:@"unicorn_store.png" target:self selector:@selector(characterSelect:)];
        }else if([[[SettingsManager sharedSettingsManager] getString:@"character"] isEqualToString:@"mermaid"]){
            characterItem = [CCMenuItemImage itemFromNormalImage:@"mermaid_store.png" selectedImage:@"mermaid_store.png" target:self selector:@selector(characterSelect:)];
        }
        
        menu3 = [CCMenu menuWithItems: characterItem, nil];
        menu3.position = ccp(120, winSize.height-245);
        [menu3 alignItemsHorizontally];
        
        if([[[SettingsManager sharedSettingsManager] getString:@"equipment"] isEqualToString:@"hammer"]){
            equipmentItem = [CCMenuItemImage itemFromNormalImage:@"mjolnir_store.png" selectedImage:@"mjolnir_store.png" target:self selector:@selector(equipmentSelect:)];
            equipmentItem.scale = .5;
        }else if([[[SettingsManager sharedSettingsManager] getString:@"equipment"] isEqualToString:@"sword"]){
            equipmentItem = [CCMenuItemImage itemFromNormalImage:@"excalibur_store.png" selectedImage:@"excalibur_store.png" target:self selector:@selector(equipmentSelect:)];
            equipmentItem.scale = .5;
        }else if([[[SettingsManager sharedSettingsManager] getString:@"equipment"] isEqualToString:@"wings"]){
            equipmentItem = [CCMenuItemImage itemFromNormalImage:@"icarus_store.png" selectedImage:@"icarus_store.png" target:self selector:@selector(equipmentSelect:)];
            equipmentItem.scale = .5;
        }else if([[[SettingsManager sharedSettingsManager] getString:@"equipment"] isEqualToString:@"midas"]){
            equipmentItem = [CCMenuItemImage itemFromNormalImage:@"midas_store.png" selectedImage:@"midas_store.png" target:self selector:@selector(equipmentSelect:)];
            equipmentItem.scale = .5;
        }else{
            equipmentItem = [CCMenuItemImage itemFromNormalImage:@"excalibur_yellow.png" selectedImage:@"excalibur_yellow.png" target:self selector:@selector(equipmentSelect:)];
        }
    
        menu4 = [CCMenu menuWithItems: equipmentItem, nil];
        menu4.position = ccp(winSize.width - 110, winSize.height-245);
        [menu4 alignItemsHorizontally];
        //[homeLayer addChild: menu3];*/
        
        if([[[SettingsManager sharedSettingsManager] getString:@"powerup"] isEqualToString:@"griffin"]){
            powerupItem = [CCMenuItemImage itemFromNormalImage:@"griffin1.png" selectedImage:@"griffin1.png" target:self selector:@selector(powerUpSelect:)];
        }else if([[[SettingsManager sharedSettingsManager] getString:@"powerup"] isEqualToString:@"pheonix"]){
            powerupItem = [CCMenuItemImage itemFromNormalImage:@"pheonix1.png" selectedImage:@"pheonix1.png" target:self selector:@selector(powerUpSelect:)];
        }else{
            powerupItem = [CCMenuItemImage itemFromNormalImage:@"griffin_yellow.png" selectedImage:@"griffin_yellow.png" target:self selector:@selector(powerUpSelect:)];
        }
        menu2 = [CCMenu menuWithItems: powerupItem, nil];
        menu2.position = ccp(winSize.width - 110, winSize.height-375);
        [menu2 alignItemsHorizontally];
        
        CCMenuItemImage *coinItem = [CCMenuItemImage itemFromNormalImage:@"store_coin.png" selectedImage:@"store_coin.png" target:self selector:@selector(buyCoins:)];
        CCMenu *menu1 = [CCMenu menuWithItems: coinItem, nil];
        menu1.position = ccp(120, winSize.height-375);
        [menu1 alignItemsHorizontally];
        
        CCLabelTTF *mythical = [CCLabelBMFont labelWithString:@"MYTHICAL\nCREATURES" fntFile:@"uni_8_white_no_shadow.fnt" width:120 alignment:UITextAlignmentCenter];
        mythical.position = ccp(120, winSize.height - 320);
        [homeLayer addChild:mythical];
        CCLabelTTF *tools = [CCLabelBMFont labelWithString:@"TOOLS\nOF LORE" fntFile:@"uni_8_white_no_shadow.fnt" width:100 alignment:UITextAlignmentCenter];
        tools.position = ccp(winSize.width -110, winSize.height - 320);
        [homeLayer addChild:tools];
        CCLabelTTF *powerups = [CCLabelBMFont labelWithString:@"POWER\nUPS" fntFile:@"uni_8_white_no_shadow.fnt" width:100 alignment:UITextAlignmentCenter];
        powerups.position = ccp(winSize.width -110, winSize.height - 450);
        [homeLayer addChild:powerups];
        CCLabelTTF *coins = [CCLabelBMFont labelWithString:@"BUY\nCOINS" fntFile:@"uni_8_white_no_shadow.fnt" width:100 alignment:UITextAlignmentCenter];
        coins.position = ccp(120, winSize.height - 450);
        [homeLayer addChild:coins];
        
        /*CCMenu *menu3 = [CCMenu menuWithItems: mythicalButton, toolsButton,powerupsButton, coinsButton, nil];
        [menu3 alignItemsInGridWithPadding:ccp(45, 40) columns:2];
        menu3.position = ccp(winSize.width/4, winSize.height - 410);
        menu3.anchorPoint = ccp(.5f, .5f);*/
        [homeLayer addChild: menu3];
        [homeLayer addChild: menu4];
        [homeLayer addChild: menu2];
        [homeLayer addChild: menu1];
        //[homeLayer addChild: equipmentItem];
        
        [self addChild:homeLayer];
        
        CCLabelTTF *youhaveLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"YOU HAVE"] fntFile:@"uni_8_yellow_no_shadow.fnt" width:80 alignment:UITextAlignmentCenter];
        youhaveLabel.position = ccp(winSize.width - 38, winSize.height-122);
        [self addChild:youhaveLabel z:800];
        
        int totalCoins = [[SettingsManager sharedSettingsManager] getInt:@"coins"];
        coinScoreLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i\nCOINS", totalCoins] fntFile:@"uni_8_yellow_no_shadow.fnt" width:80 alignment:UITextAlignmentCenter];
        coinScoreLabel.position = ccp(winSize.width - 38, winSize.height-175);
        [self addChild:coinScoreLabel z:800];
        
        CCSprite *coinIcon = [CCSprite spriteWithFile:@"store_coin.png"];
        coinIcon.position = ccp(winSize.width - 35, winSize.height-145);
        [self addChild:coinIcon z:800];
        
        [self getInAppList];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
        
        
        id action = [CCMoveTo actionWithDuration:.8 position:ccp(0, 0)];
        id ease = [CCEaseIn actionWithAction:action rate:2];
        id callback = [CCCallBlock actionWithBlock:^{
            [overlay runAction:[CCFadeIn actionWithDuration:.5]];
        }];

        [self runAction: [CCSequence actions:ease, callback, nil]];
        
    }
    return self;
}

-(void)getInAppList{ 
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        NSLog(@"No internet connection!");
    } else {
        if ([MythicMtnIAPHelper sharedHelper].products == nil) {
            
            [[MythicMtnIAPHelper sharedHelper] requestProducts];
            
        }        
    }
}

- (void)productsLoaded:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    /*(SKProduct *product1 = [[MythicMtnIAPHelper sharedHelper].products objectAtIndex:0];
    NSLog(@"%@", product1.productIdentifier);
    
    NSLog(@"%u", [[MythicMtnIAPHelper sharedHelper].products count]);
    
    SKProduct *product2 = [[MythicMtnIAPHelper sharedHelper].products objectAtIndex:1];
    NSLog(@"%@", product2.productIdentifier);
    
    SKProduct *product3 = [[MythicMtnIAPHelper sharedHelper].products objectAtIndex:2];
    NSLog(@"%@", product3.productIdentifier);*/
}

- (void)productPurchased:(NSNotification *)notification {
    int amount;
    float fAmount;
    NSString *sAmount;
    if([notification.object isEqualToString:@"coins1"]){
        amount = 10000;
        fAmount = 0.99;
        sAmount = @"0.99";
    }else if([notification.object isEqualToString:@"coins2"]){
        amount = 25000;
        fAmount = 1.99;
        sAmount = @"1.99";
    }else if([notification.object isEqualToString:@"coins4"]){
        amount = 50000;
        fAmount = 2.99;
        sAmount = @"2.99";
    }
    int totalCoins = [[SettingsManager sharedSettingsManager] getInt:@"coins"];
    totalCoins = totalCoins + amount;
    [[SettingsManager sharedSettingsManager] setIntValue:totalCoins name:@"coins"];
    [[SettingsManager sharedSettingsManager] save];
    [coinScoreLabel setString:[NSString stringWithFormat:@"%i\nCOINS", totalCoins]];
    
    [[CCDirector sharedDirector] resume];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    dialogLayer = [[CCLayer alloc] init];
    CCSprite *dialogBox = [CCSprite spriteWithFile:@"dialog_bg.png"];
    dialogBox.position = ccp(winSize.width/2, winSize.height/2);
    [dialogLayer addChild:dialogBox];
    
    CCLabelTTF *purchase = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"You bought %i coins!", amount] fntFile:@"uni_16_white_no_shadow.fnt" width:220 alignment:UITextAlignmentCenter];
    purchase.anchorPoint = ccp(0.5f, 0.5f);
    purchase.position = ccp(winSize.width/2, winSize.height/2 + 35);
    [dialogLayer addChild:purchase];
    
    CCMenuItemImage *cancel = [CCMenuItemImage itemFromNormalImage:@"continue_btn.png" selectedImage:@"continue_btn.png" target:self selector:@selector(hideDialog)];
    CCMenu *dialogMenu = [CCMenu menuWithItems: cancel, nil];
    dialogMenu.position = ccp(winSize.width/2, winSize.height/2 - 35);
    [dialogMenu alignItemsHorizontallyWithPadding:12.0f];
    [dialogLayer addChild:dialogMenu];
    
    NSDictionary *purchaseParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"PurchaseAmount", [NSString stringWithFormat:@"%i", amount], // Capture user status
     nil];
    
    [Flurry logEvent:@"Coin purchase" withParameters:purchaseParams];
    
    [DecoderAppEventTracking trackEventWithDescription:notification.object amount:fAmount amountDescription:sAmount sourceAppDescription:@"MythicMountain"];
    
    [self addChild:dialogLayer z:999];
}

-(void)buyCoin1{
    [[MythicMtnIAPHelper sharedHelper] buyProduct:[[MythicMtnIAPHelper sharedHelper].products objectAtIndex:0]];
}

-(void)buyCoin2{
    [[MythicMtnIAPHelper sharedHelper] buyProduct:[[MythicMtnIAPHelper sharedHelper].products objectAtIndex:1]];
}

-(void)buyCoin3{
    [[MythicMtnIAPHelper sharedHelper] buyProduct:[[MythicMtnIAPHelper sharedHelper].products objectAtIndex:2]];
}

-(void)buyCoins:(id)sender{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus != NotReachable){
    selected = @"coins";
    [self removeChild:homeLayer cleanup:NO];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    labelBG = [CCSprite spriteWithFile:@"label_background.png"];
    labelBG.position = ccp(winSize.width/2 + 2, winSize.height - 188);
    [self addChild:labelBG];
    
    labelHeader = [CCLabelBMFont labelWithString:@"COINS" fntFile:@"uni_16_white_no_shadow.fnt" width:180 alignment:UITextAlignmentCenter];
    labelHeader.position = ccp(winSize.width/2, winSize.height-188);
    [self addChild:labelHeader z:800];
    
    /////////////////////////
    
    coins1 = [[CCLayer alloc] init];
    
    CCSprite *rightButton = [CCSprite spriteWithFile:@"left_right_button.png"];
    rightButton.flipX = YES;
    rightButton.position = ccp(winSize.width - 40, winSize.height-270);
    [coins1 addChild:rightButton];
    
    CCMenuItemImage *coin = [CCMenuItemImage itemFromNormalImage:@"coins1.png" selectedImage:@"coins1.png" target:self selector:nil];
    CCMenu *coinMenu = [CCMenu menuWithItems: coin, nil];
    //coin.scale = 2;
    coinMenu.position =ccp(winSize.width/2, winSize.height - 280);
    [coins1 addChild:coinMenu];
    
    CCLabelTTF *coin1Cost = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%@", ((SKProduct *)[[MythicMtnIAPHelper sharedHelper].products objectAtIndex:0]).price] fntFile:@"uni_16_white_no_shadow.fnt" width:100 alignment:UITextAlignmentCenter];
     coin1Cost.anchorPoint = ccp(0.0f, 1.0f);
     coin1Cost.position = ccp(65, winSize.height-372);
     [coins1 addChild:coin1Cost z:800];
     
     CCSprite *coin1Icon = [CCSprite spriteWithFile:@"store_coin.png"];
     coin1Icon.anchorPoint = ccp(0.0f, 1.0f);
     coin1Icon.position = ccp(40, winSize.height-370);
     [coins1 addChild:coin1Icon z:800];
    
    CCLabelTTF *coin1Name = [CCLabelBMFont labelWithString:@"10,000 Coins" fntFile:@"uni_16_white_no_shadow.fnt" width:200 alignment:UITextAlignmentCenter];
    coin1Name.anchorPoint = ccp(0.0f, 1.0f);
    coin1Name.position = ccp(40, winSize.height-392);
    [coins1 addChild:coin1Name z:800];
    
    CCLabelTTF *coin1Description = [CCLabelBMFont labelWithString:@"A little bit of walking around money. Spend it on new a creature, put it towards an epic weapon, or treat yourself to a power-up." fntFile:@"cc_13pt_white.fnt" width:250 alignment:UITextAlignmentLeft];
    coin1Description.anchorPoint = ccp(0.0f, 1.0f);
    coin1Description.position = ccp(40, winSize.height-420);
    [coins1 addChild:coin1Description z:800];
    
    CCMenuItemImage *getIt = [CCMenuItemImage itemFromNormalImage:@"buy_button.png" selectedImage:@"buy_button.png" target:self selector:@selector(buyCoin1)];
    CCMenu *coins1GetItMenu = [CCMenu menuWithItems: getIt, nil];
    coins1GetItMenu.anchorPoint = ccp(0.0f, 1.0f);
    coins1GetItMenu.position =ccp(winSize.width - 60, winSize.height - 387);
    coins1GetItMenu.tag = 4444;
    [coins1 addChild:coins1GetItMenu];
    
    /////////////////////////
    
    
     coins2 = [[CCLayer alloc] init];
     
     CCSprite *leftButton = [CCSprite spriteWithFile:@"left_right_button.png"];
     leftButton.flipX = NO;
     leftButton.position = ccp(40, winSize.height-270);
     [coins2 addChild:leftButton];
    
    rightButton = [CCSprite spriteWithFile:@"left_right_button.png"];
    rightButton.flipX = YES;
    rightButton.position = ccp(winSize.width - 40, winSize.height-270);
    [coins2 addChild:rightButton];
     
     coin = [CCMenuItemImage itemFromNormalImage:@"coins2.png" selectedImage:@"coins2.png" target:self selector:nil];
     coinMenu = [CCMenu menuWithItems: coin, nil];
     //coin.scale = 2;
     coinMenu.position =ccp(winSize.width/2, winSize.height - 280);
     [coins2 addChild:coinMenu];
     
     CCLabelTTF *coin2Cost = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%@", ((SKProduct *)[[MythicMtnIAPHelper sharedHelper].products objectAtIndex:1]).price] fntFile:@"uni_16_white_no_shadow.fnt" width:100 alignment:UITextAlignmentCenter];
     coin2Cost.anchorPoint = ccp(0.0f, 1.0f);
     coin2Cost.position = ccp(65, winSize.height-372);
     [coins2 addChild:coin2Cost z:800];
     
     CCSprite *coin2Icon = [CCSprite spriteWithFile:@"store_coin.png"];
     coin2Icon.anchorPoint = ccp(0.0f, 1.0f);
     coin2Icon.position = ccp(40, winSize.height-370);
     [coins2 addChild:coin2Icon z:800];
     
     CCLabelTTF *coin2Name = [CCLabelBMFont labelWithString:@"25,000 Coins" fntFile:@"uni_16_white_no_shadow.fnt" width:200 alignment:UITextAlignmentCenter];
     coin2Name.anchorPoint = ccp(0.0f, 1.0f);
     coin2Name.position = ccp(40, winSize.height-392);
     [coins2 addChild:coin2Name z:800];
     
     CCLabelTTF *coin2Description = [CCLabelBMFont labelWithString:@"Shopping spree, here you come. Take your newfound wealth to the shop and take your pick of creature, power-up, or legendary item." fntFile:@"cc_13pt_white.fnt" width:250 alignment:UITextAlignmentLeft];
     coin2Description.anchorPoint = ccp(0.0f, 1.0f);
     coin2Description.position = ccp(40, winSize.height-420);
     [coins2 addChild:coin2Description z:800];
     
     getIt = [CCMenuItemImage itemFromNormalImage:@"buy_button.png" selectedImage:@"buy_button.png" target:self selector:@selector(buyCoin2)];
     CCMenu *coins2GetItMenu = [CCMenu menuWithItems: getIt, nil];
     coins2GetItMenu.anchorPoint = ccp(0.0f, 1.0f);
     coins2GetItMenu.position =ccp(winSize.width - 60, winSize.height - 387);
     coins2GetItMenu.tag = 4444;
     [coins2 addChild:coins2GetItMenu];
    
    
    ////////////////////////
    
    coins3 = [[CCLayer alloc] init];
    
    leftButton = [CCSprite spriteWithFile:@"left_right_button.png"];
    leftButton.flipX = NO;
    leftButton.position = ccp(40, winSize.height-270);
    [coins3 addChild:leftButton];
    
    coin = [CCMenuItemImage itemFromNormalImage:@"coins3.png" selectedImage:@"coins3.png" target:self selector:nil];
    coinMenu = [CCMenu menuWithItems: coin, nil];
    //coin.scale = 2;
    coinMenu.position =ccp(winSize.width/2, winSize.height - 280);
    [coins3 addChild:coinMenu];
        
    CCLabelTTF *coin3Cost = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%@", ((SKProduct *)[[MythicMtnIAPHelper sharedHelper].products objectAtIndex:2]).price] fntFile:@"uni_16_white_no_shadow.fnt" width:100 alignment:UITextAlignmentCenter];
    coin3Cost.anchorPoint = ccp(0.0f, 1.0f);
    coin3Cost.position = ccp(65, winSize.height-372);
    [coins3 addChild:coin3Cost z:800];
    
    CCSprite *coin3Icon = [CCSprite spriteWithFile:@"store_coin.png"];
    coin3Icon.anchorPoint = ccp(0.0f, 1.0f);
    coin3Icon.position = ccp(40, winSize.height-370);
    [coins3 addChild:coin3Icon z:800];
    
    CCLabelTTF *coin3Name = [CCLabelBMFont labelWithString:@"50,000 Coins" fntFile:@"uni_16_white_no_shadow.fnt" width:200 alignment:UITextAlignmentCenter];
    coin3Name.anchorPoint = ccp(0.0f, 1.0f);
    coin3Name.position = ccp(40, winSize.height-392);
    [coins3 addChild:coin3Name z:800];
    
    CCLabelTTF *coin3Description = [CCLabelBMFont labelWithString:@"A virtual fortune. With this many coins, you could unlock every creature and weapon, and still have plenty of coins left over for power-ups." fntFile:@"cc_13pt_white.fnt" width:250 alignment:UITextAlignmentLeft];
    coin3Description.anchorPoint = ccp(0.0f, 1.0f);
    coin3Description.position = ccp(40, winSize.height-420);
    [coins3 addChild:coin3Description z:800];
    
    getIt = [CCMenuItemImage itemFromNormalImage:@"buy_button.png" selectedImage:@"buy_button.png" target:self selector:@selector(buyCoin3)];
    CCMenu *coins3GetItMenu = [CCMenu menuWithItems: getIt, nil];
    coins3GetItMenu.anchorPoint = ccp(0.0f, 1.0f);
    coins3GetItMenu.position =ccp(winSize.width - 60, winSize.height - 387);
    coins3GetItMenu.tag = 4444;
    [coins3 addChild:coins3GetItMenu];
    
    
    ////////////////////////
    
    coinScrollLayer = [[CCScrollLayer alloc] initWithLayers:[NSMutableArray arrayWithObjects: coins1, coins2, coins3, nil] widthOffset:0];
    coinScrollLayer.showPagesIndicator = NO;
        [self addChild:coinScrollLayer z:800];
    }else{
        CGSize winSize = [CCDirector sharedDirector].winSize;
        dialogLayer = [[CCLayer alloc] init];
        CCSprite *dialogBox = [CCSprite spriteWithFile:@"dialog_bg.png"];
        dialogBox.position = ccp(winSize.width/2, winSize.height/2);
        [dialogLayer addChild:dialogBox];
        
        CCLabelTTF *purchase = [CCLabelBMFont labelWithString:@"You need to connect to the internet to buy coins!" fntFile:@"uni_16_white_no_shadow.fnt" width:220 alignment:UITextAlignmentCenter];
        purchase.anchorPoint = ccp(0.5f, 0.5f);
        purchase.position = ccp(winSize.width/2, winSize.height/2 + 35);
        [dialogLayer addChild:purchase];
        
        CCMenuItemImage *cancel = [CCMenuItemImage itemFromNormalImage:@"continue_btn.png" selectedImage:@"continue_btn.png" target:self selector:@selector(hideDialog)];
        CCMenu *dialogMenu = [CCMenu menuWithItems: cancel, nil];
        dialogMenu.position = ccp(winSize.width/2, winSize.height/2 - 35);
        [dialogMenu alignItemsHorizontallyWithPadding:12.0f];
        [dialogLayer addChild:dialogMenu];
        dialogUP = YES;
        [self addChild:dialogLayer z:999];
    }
}

-(void)back: (id)sender{
    if([selected isEqualToString:@"home"]){
        CGSize winSize = [CCDirector sharedDirector].winSize;
        [[SettingsManager sharedSettingsManager] save];
        id slideAction = [CCMoveTo actionWithDuration:.6 position:ccp(0, -winSize.height)];
        id ease = [CCEaseIn actionWithAction:slideAction rate:2];
        id parentRemove = [CCCallBlock actionWithBlock:^{
            [self.parent removeChild:self cleanup:YES];
        }];
        CCSequence *cleanSeq = [CCSequence actions:ease, parentRemove, nil];
        [self runAction:cleanSeq];
        overlay.opacity = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideStore" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }else if([selected isEqualToString:@"character"]){
        [self removeChild:characterScrollLayer cleanup:YES];
        [self removeChild:labelBG cleanup:YES];
        [self removeChild:labelHeader cleanup:YES];
        [self addChild:homeLayer];
        selected = @"home";
    }else if([selected isEqualToString:@"equipment"]){
        [self removeChild:equipmentScrollLayer cleanup:YES];
        [self removeChild:labelBG cleanup:YES];
        [self removeChild:labelHeader cleanup:YES];
        [self addChild:homeLayer];
        selected = @"home";
    }else if([selected isEqualToString:@"powerup"]){
        [self removeChild:powerupScrollerLayer cleanup:YES];
        [self removeChild:labelBG cleanup:YES];
        [self removeChild:labelHeader cleanup:YES];
        [self addChild:homeLayer];
        selected = @"home";
    }else if([selected isEqualToString:@"coins"]){
        [self removeChild:coinScrollLayer cleanup:YES];
        [self removeChild:labelBG cleanup:YES];
        [self removeChild:labelHeader cleanup:YES];
        [self addChild:homeLayer];
        selected = @"home";
    }
}

-(void)characterSelect: (id)sender{
    selected = @"character";
    [self removeChild:homeLayer cleanup:NO];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    labelBG = [CCSprite spriteWithFile:@"label_background.png"];
    labelBG.position = ccp(winSize.width/2 + 2, winSize.height - 188);
    [self addChild:labelBG];
    
    labelHeader = [CCLabelBMFont labelWithString:@"MYTHICAL CREATURES" fntFile:@"uni_16_white_no_shadow.fnt" width:180 alignment:UITextAlignmentCenter];
    labelHeader.position = ccp(winSize.width/2, winSize.height-188);
    [self addChild:labelHeader z:800];
    
    ////////YETI/////////////////
    
    yetiLayer = [[CCLayer alloc] init];
    
    CCSprite *rightButton = [CCSprite spriteWithFile:@"left_right_button.png"];
    rightButton.flipX = YES;
    rightButton.position = ccp(winSize.width - 40, winSize.height-270);
    [yetiLayer addChild:rightButton];
    
    CCMenuItemImage *yeti = [CCMenuItemImage itemFromNormalImage:@"yetiTurning01.png" selectedImage:@"yetiTurning01.png" target:self selector:nil];
    CCMenu *yetiMenu = [CCMenu menuWithItems: yeti, nil];
    yeti.scale = 2;
    yetiMenu.position =ccp(winSize.width/2, winSize.height - 280);
    [yetiLayer addChild:yetiMenu];
    
    /*CCLabelTTF *yetiCost = [CCLabelBMFont labelWithString:@"10000" fntFile:@"uni_16_white_no_shadow.fnt" width:100 alignment:UITextAlignmentCenter];
    yetiCost.anchorPoint = ccp(0.0f, 1.0f);
    yetiCost.position = ccp(65, winSize.height-372);
    [yetiLayer addChild:yetiCost z:800];
    
    CCSprite *yetiCoinIcon = [CCSprite spriteWithFile:@"store_coin.png"];
    yetiCoinIcon.anchorPoint = ccp(0.0f, 1.0f);
    yetiCoinIcon.position = ccp(70, winSize.height-380);
    [yetiLayer addChild:yetiCoinIcon z:800];*/
    
    CCLabelTTF *yetiName = [CCLabelBMFont labelWithString:@"YETI" fntFile:@"uni_16_white_no_shadow.fnt" width:100 alignment:UITextAlignmentCenter];
    yetiName.anchorPoint = ccp(0.0f, 1.0f);
    yetiName.position = ccp(40, winSize.height-392);
    [yetiLayer addChild:yetiName z:800];
    
    CCLabelTTF *yetiDescription = [CCLabelBMFont labelWithString:@"He's 8 feet tall, bashful, and an excellent hider. When he's not on Mythic Mountain, you can find him... nevermind. You can't find him." fntFile:@"cc_13pt_white.fnt" width:250 alignment:UITextAlignmentLeft];
    yetiDescription.anchorPoint = ccp(0.0f, 1.0f);
    yetiDescription.position = ccp(40, winSize.height-420);
    [yetiLayer addChild:yetiDescription z:800];
    
    CCMenuItemImage *getIt = [CCMenuItemImage itemFromNormalImage:@"useit_button.png" selectedImage:@"useit_button.png" target:self selector:@selector(selectYeti:)];
    CCMenu *yetiGetItMenu = [CCMenu menuWithItems: getIt, nil];
    yetiMenu.anchorPoint = ccp(0.0f, 1.0f);
    yetiGetItMenu.position =ccp(winSize.width - 60, winSize.height - 387);
    yetiGetItMenu.tag = 4444;
    [yetiLayer addChild:yetiGetItMenu];
    
    /////////UNICORN////////////////
    
    unicornLayer = [[CCLayer alloc] init];
    
    CCSprite *leftButton = [CCSprite spriteWithFile:@"left_right_button.png"];
    leftButton.flipX = NO;
    leftButton.position = ccp(40, winSize.height-270);
    [unicornLayer addChild:leftButton];
    
    rightButton = [CCSprite spriteWithFile:@"left_right_button.png"];
    rightButton.flipX = YES;
    rightButton.position = ccp(winSize.width - 40, winSize.height-270);
    [unicornLayer addChild:rightButton];
    
    CCMenuItemImage *unicorn = [CCMenuItemImage itemFromNormalImage:@"unicorn_store.png" selectedImage:@"unicorn_store.png" target:self selector:nil];
    CCMenu *unicornMenu = [CCMenu menuWithItems: unicorn, nil];
    unicorn.scale = 2;
    unicornMenu.position =ccp(winSize.width/2, winSize.height - 285);
    [unicornLayer addChild:unicornMenu];
    
    if(![[[SettingsManager sharedSettingsManager] getArray:@"purchases"] containsObject:@"unicorn"]){
    
        CCLabelTTF *uniCost = [CCLabelBMFont labelWithString:@"10000" fntFile:@"uni_16_white_no_shadow.fnt" width:100 alignment:UITextAlignmentCenter];
        uniCost.anchorPoint = ccp(0.0f, 1.0f);
        uniCost.position = ccp(65, winSize.height-372);
        uniCost.tag = 2222;
        [unicornLayer addChild:uniCost z:800];
    
        CCSprite *uniCoinIcon = [CCSprite spriteWithFile:@"store_coin.png"];
        uniCoinIcon.anchorPoint = ccp(0.0f, 1.0f);
        uniCoinIcon.position = ccp(40, winSize.height-370);
        uniCoinIcon.tag = 3333;
        [unicornLayer addChild:uniCoinIcon z:800];
    
        CCMenuItemImage *uniGetIt = [CCMenuItemImage itemFromNormalImage:@"buy_button.png" selectedImage:@"buy_button.png" target:self selector:@selector(selectunicorn:)];
        CCMenu *unicornGetItMenu = [CCMenu menuWithItems: uniGetIt, nil];
        unicornMenu.anchorPoint = ccp(1.0f, 1.0f);
        unicornGetItMenu.position =ccp(winSize.width - 60, winSize.height - 387);
        unicornGetItMenu.tag = 4444;
        uniGetIt.tag = 5555;
        [unicornLayer addChild:unicornGetItMenu];
    }else{
        CCMenuItemImage *uniGetIt = [CCMenuItemImage itemFromNormalImage:@"useit_button.png" selectedImage:@"useit_button.png" target:self selector:@selector(selectunicorn:)];
        CCMenu *unicornGetItMenu = [CCMenu menuWithItems: uniGetIt, nil];
        unicornMenu.anchorPoint = ccp(1.0f, 1.0f);
        unicornGetItMenu.position =ccp(winSize.width - 60, winSize.height - 387);
        unicornGetItMenu.tag = 4444;
        [unicornLayer addChild:unicornGetItMenu];
    }
    
    CCLabelTTF *uniName = [CCLabelBMFont labelWithString:@"UNICORN" fntFile:@"uni_16_white_no_shadow.fnt" width:100 alignment:UITextAlignmentCenter];
    uniName.anchorPoint = ccp(0.0f, 1.0f);
    uniName.position = ccp(40, winSize.height-392);
    [unicornLayer addChild:uniName z:800];
    
    CCLabelTTF *uniDescription = [CCLabelBMFont labelWithString:@"The fabled horse with a golden horn. He once stirred the imaginations of kings and scholars. These days, little girls think he's pretty." fntFile:@"cc_13pt_white.fnt" width:250 alignment:UITextAlignmentLeft];
    uniDescription.anchorPoint = ccp(0.0f, 1.0f);
    uniDescription.position = ccp(40, winSize.height-420);
    [unicornLayer addChild:uniDescription z:800];
    
    //////////MERMAID//////////////
    
    mermaidLayer = [[CCLayer alloc] init];
    
    leftButton = [CCSprite spriteWithFile:@"left_right_button.png"];
    leftButton.flipX = NO;
    leftButton.position = ccp(40, winSize.height-270);
    [mermaidLayer addChild:leftButton];
    
    CCMenuItemImage *mermaid = [CCMenuItemImage itemFromNormalImage:@"mermaid_store.png" selectedImage:@"mermaid_store.png" target:self selector:nil];
    CCMenu *mermaidMenu = [CCMenu menuWithItems: mermaid, nil];
    mermaid.scale = 2;
    mermaidMenu.position =ccp(winSize.width/2, winSize.height - 285);
    [mermaidLayer addChild:mermaidMenu];
    
    if(![[[SettingsManager sharedSettingsManager] getArray:@"purchases"] containsObject:@"mermaid"]){
        
        CCLabelTTF *merCost = [CCLabelBMFont labelWithString:@"10000" fntFile:@"uni_16_white_no_shadow.fnt" width:100 alignment:UITextAlignmentCenter];
        merCost.anchorPoint = ccp(0.0f, 1.0f);
        merCost.position = ccp(65, winSize.height-372);
        merCost.tag = 2222;
        [mermaidLayer addChild:merCost z:800];
        
        CCSprite *merCoinIcon = [CCSprite spriteWithFile:@"store_coin.png"];
        merCoinIcon.anchorPoint = ccp(0.0f, 1.0f);
        merCoinIcon.position = ccp(40, winSize.height-370);
        merCoinIcon.tag = 3333;
        [mermaidLayer addChild:merCoinIcon z:800];
        
        CCMenuItemImage *merGetIt = [CCMenuItemImage itemFromNormalImage:@"buy_button.png" selectedImage:@"buy_button.png" target:self selector:@selector(selectmermaid:)];
        CCMenu *mermaidGetItMenu = [CCMenu menuWithItems: merGetIt, nil];
        mermaidMenu.anchorPoint = ccp(1.0f, 1.0f);
        mermaidGetItMenu.position =ccp(winSize.width - 60, winSize.height - 387);
        mermaidGetItMenu.tag = 4444;
        merGetIt.tag = 5555;
        [mermaidLayer addChild:mermaidGetItMenu];
    }else{
        CCMenuItemImage *merGetIt = [CCMenuItemImage itemFromNormalImage:@"useit_button.png" selectedImage:@"useit_button.png" target:self selector:@selector(selectmermaid:)];
        CCMenu *mermaidGetItMenu = [CCMenu menuWithItems: merGetIt, nil];
        mermaidMenu.anchorPoint = ccp(1.0f, 1.0f);
        mermaidGetItMenu.position =ccp(winSize.width - 60, winSize.height - 387);
        mermaidGetItMenu.tag = 4444;
        [mermaidLayer addChild:mermaidGetItMenu];
    }
    
    CCLabelTTF *merName = [CCLabelBMFont labelWithString:@"MERMAID" fntFile:@"uni_16_white_no_shadow.fnt" width:100 alignment:UITextAlignmentCenter];
    merName.anchorPoint = ccp(0.0f, 1.0f);
    merName.position = ccp(40, winSize.height-392);
    [mermaidLayer addChild:merName z:800];
    
    CCLabelTTF *merDescription = [CCLabelBMFont labelWithString:@"Out of her element? Sure. But snow is made of water, after all. She dreams of having legs and opening a multinational coffee chain." fntFile:@"cc_13pt_white.fnt" width:250 alignment:UITextAlignmentLeft];
    merDescription.anchorPoint = ccp(0.0f, 1.0f);
    merDescription.position = ccp(40, winSize.height-420);
    [mermaidLayer addChild:merDescription z:800];
    
    ///////////////////////////////
    
    
    uniplat = [CCSprite spriteWithFile:@"platform1.png"];
    uniplat.position = ccp(winSize.width/2, winSize.height - 290);
    uniplat.scale = 2;
    
    NSMutableArray *platArray = [NSMutableArray array];
    for(int i = 1; i <= 4; ++i) {
        [platArray addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"platform%d.png", i]]];
    }
    
    CCAnimation *platAn = [CCAnimation animationWithFrames:platArray delay:0.1f];
    [uniplat runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:platAn restoreOriginalFrame:NO]]];
    
    if([[[SettingsManager sharedSettingsManager] getString:@"character"] isEqualToString:@"unicorn"]){
        [unicornLayer addChild:uniplat z:800];
        [unicornLayer getChildByTag:4444].visible = NO;
    }else if([[[SettingsManager sharedSettingsManager] getString:@"character"] isEqualToString:@"yeti"]){
        [yetiLayer addChild:uniplat z:800];
        [yetiLayer getChildByTag:4444].visible = NO;
    }else if([[[SettingsManager sharedSettingsManager] getString:@"character"] isEqualToString:@"mermaid"]){
        [mermaidLayer addChild:uniplat z:800];
        [mermaidLayer getChildByTag:4444].visible = NO;
    }
    
    characterScrollLayer = [[CCScrollLayer alloc] initWithLayers:[NSMutableArray arrayWithObjects: yetiLayer, unicornLayer, mermaidLayer, nil] widthOffset:0];
    characterScrollLayer.showPagesIndicator = NO;
    [self addChild:characterScrollLayer z:800];
}

-(void)equipmentSelect:(id)sender{
    selected = @"equipment";
    [self removeChild:homeLayer cleanup:NO];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    labelBG = [CCSprite spriteWithFile:@"label_background.png"];
    labelBG.position = ccp(winSize.width/2 + 2, winSize.height - 188);
    [self addChild:labelBG];
    
    labelHeader = [CCLabelBMFont labelWithString:@"TOOLS OF LORE" fntFile:@"uni_16_white_no_shadow.fnt" width:180 alignment:UITextAlignmentCenter];
    labelHeader.position = ccp(winSize.width/2, winSize.height-188);
    [self addChild:labelHeader z:800];
    
    ////////EXCALIBUR////////////////
    
    excaliburLayer = [[CCLayer alloc] init];
    
    CCSprite *rightButton = [CCSprite spriteWithFile:@"left_right_button.png"];
    rightButton.flipX = YES;
    rightButton.position = ccp(winSize.width - 40, winSize.height-270);
    [excaliburLayer addChild:rightButton];
    
    CCMenuItemImage *excalibur = [CCMenuItemImage itemFromNormalImage:@"excalibur_store.png" selectedImage:@"excalibur_store.png" target:self selector:nil];
    CCMenu *excaliburMenu = [CCMenu menuWithItems: excalibur, nil];
    //excalibur.scale = 2;
    excaliburMenu.position =ccp(winSize.width/2, winSize.height - 280);
    [excaliburLayer addChild:excaliburMenu];
    
    if(![[[SettingsManager sharedSettingsManager] getArray:@"purchases"] containsObject:@"sword"]){
        CCLabelTTF *excaliburCost = [CCLabelBMFont labelWithString:@"2500" fntFile:@"uni_16_white_no_shadow.fnt" width:100 alignment:UITextAlignmentCenter];
        excaliburCost.anchorPoint = ccp(0.0f, 1.0f);
        excaliburCost.position = ccp(65, winSize.height-372);
        excaliburCost.tag = 2222;
        [excaliburLayer addChild:excaliburCost z:800];
        
        CCSprite *excaliburCoinIcon = [CCSprite spriteWithFile:@"store_coin.png"];
        excaliburCoinIcon.anchorPoint = ccp(0.0f, 1.0f);
        excaliburCoinIcon.position = ccp(40, winSize.height-370);
        excaliburCoinIcon.tag = 3333;
        [excaliburLayer addChild:excaliburCoinIcon z:800];
        
        CCMenuItemImage *getIt = [CCMenuItemImage itemFromNormalImage:@"buy_button.png" selectedImage:@"buy_button.png" target:self selector:@selector(selectsword:)];
        CCMenu *excaliburGetItMenu = [CCMenu menuWithItems: getIt, nil];
        excaliburMenu.anchorPoint = ccp(1.0f, 1.0f);
        excaliburGetItMenu.tag = 4444;
        getIt.tag = 5555;
        excaliburGetItMenu.position =ccp(winSize.width - 60, winSize.height - 387);
        [excaliburLayer addChild:excaliburGetItMenu];
    }else{
        CCMenuItemImage *getIt = [CCMenuItemImage itemFromNormalImage:@"useit_button.png" selectedImage:@"useit_button.png" target:self selector:@selector(selectsword:)];
        CCMenu *excaliburGetItMenu = [CCMenu menuWithItems: getIt, nil];
        excaliburMenu.anchorPoint = ccp(1.0f, 1.0f);
        excaliburGetItMenu.tag = 4444;
        excaliburGetItMenu.position =ccp(winSize.width - 60, winSize.height - 387);
        [excaliburLayer addChild:excaliburGetItMenu];
    }
    
    CCLabelTTF *excaliburName = [CCLabelBMFont labelWithString:@"EXCALIBUR" fntFile:@"uni_16_white_no_shadow.fnt" width:120 alignment:UITextAlignmentCenter];
    excaliburName.anchorPoint = ccp(0.0f, 1.0f);
    excaliburName.position = ccp(40, winSize.height-392);
    [excaliburLayer addChild:excaliburName z:800];
    
    CCLabelTTF *excaliburDescription = [CCLabelBMFont labelWithString:@"The legendary sword of King Arthur, given to him by the Lady of the Lake. Swing it to chop down everything within reach." fntFile:@"cc_13pt_white.fnt" width:250 alignment:UITextAlignmentLeft];
    excaliburDescription.anchorPoint = ccp(0.0f, 1.0f);
    excaliburDescription.position = ccp(40, winSize.height-420);
    [excaliburLayer addChild:excaliburDescription z:800];

    
    ////////////////////////
    
    mjolnirLayer = [[CCLayer alloc] init];
    
    CCSprite *mrightButton = [CCSprite spriteWithFile:@"left_right_button.png"];
    mrightButton.flipX = YES;
    mrightButton.position = ccp(winSize.width - 40, winSize.height-270);
    [mjolnirLayer addChild:mrightButton];
    
    CCSprite *leftButton = [CCSprite spriteWithFile:@"left_right_button.png"];
    leftButton.flipX = NO;
    leftButton.position = ccp(40, winSize.height-270);
    [mjolnirLayer addChild:leftButton];
    
    CCMenuItemImage *mjolnir = [CCMenuItemImage itemFromNormalImage:@"mjolnir_store.png" selectedImage:@"mjolnir_store.png" target:self selector:nil];
    CCMenu *mjolnirMenu = [CCMenu menuWithItems: mjolnir, nil];
    //mjolnir.scale = 2;
    mjolnirMenu.position =ccp(winSize.width/2, winSize.height - 280);
    [mjolnirLayer addChild:mjolnirMenu];
    
    if(![[[SettingsManager sharedSettingsManager] getArray:@"purchases"] containsObject:@"hammer"]){
        CCLabelTTF *mjolnirCost = [CCLabelBMFont labelWithString:@"2500" fntFile:@"uni_16_white_no_shadow.fnt" width:100 alignment:UITextAlignmentCenter];
        mjolnirCost.anchorPoint = ccp(0.0f, 1.0f);
        mjolnirCost.position = ccp(65, winSize.height-372);
        mjolnirCost.tag = 2222;
        [mjolnirLayer addChild:mjolnirCost z:800];
        
        CCSprite *mjolnirCoinIcon = [CCSprite spriteWithFile:@"store_coin.png"];
        mjolnirCoinIcon.anchorPoint = ccp(0.0f, 1.0f);
        mjolnirCoinIcon.position = ccp(40, winSize.height-370);
        mjolnirCoinIcon.tag = 3333;
        [mjolnirLayer addChild:mjolnirCoinIcon z:800];
        
        CCMenuItemImage *mjolnirGetIt = [CCMenuItemImage itemFromNormalImage:@"buy_button.png" selectedImage:@"buy_button.png" target:self selector:@selector(selecthammer:)];
        CCMenu *mjolnirGetItMenu = [CCMenu menuWithItems: mjolnirGetIt, nil];
        mjolnirMenu.anchorPoint = ccp(0.0f, 1.0f);
        mjolnirGetItMenu.position =ccp(winSize.width - 60, winSize.height - 387);
        mjolnirGetItMenu.tag = 4444;
        mjolnirGetIt.tag = 5555;
        [mjolnirLayer addChild:mjolnirGetItMenu];
    }else{
        CCMenuItemImage *mjolnirGetIt = [CCMenuItemImage itemFromNormalImage:@"useit_button.png" selectedImage:@"useit_button.png" target:self selector:@selector(selecthammer:)];
        CCMenu *mjolnirGetItMenu = [CCMenu menuWithItems: mjolnirGetIt, nil];
        mjolnirMenu.anchorPoint = ccp(0.0f, 1.0f);
        mjolnirGetItMenu.position =ccp(winSize.width - 60, winSize.height - 387);
        mjolnirGetItMenu.tag = 4444;
        [mjolnirLayer addChild:mjolnirGetItMenu];
    }
    
    
    
    CCLabelTTF *mjolnirName = [CCLabelBMFont labelWithString:@"MJOLNIR" fntFile:@"uni_16_white_no_shadow.fnt" width:120 alignment:UITextAlignmentCenter];
    mjolnirName.anchorPoint = ccp(0.0f, 1.0f);
    mjolnirName.position = ccp(40, winSize.height-392);
    [mjolnirLayer addChild:mjolnirName z:800];
    
    CCLabelTTF *mjolnirDescription = [CCLabelBMFont labelWithString:@"The magical hammer of Thor, forged by dwarves. Flies from your hand, destroys every rock and tree in its path, and returns to you." fntFile:@"cc_13pt_white.fnt" width:250 alignment:UITextAlignmentLeft];
    mjolnirDescription.anchorPoint = ccp(0.0f, 1.0f);
    mjolnirDescription.position = ccp(40, winSize.height-420);
    [mjolnirLayer addChild:mjolnirDescription z:800];
    
    ////////////////////////
    
    icarusLayer = [[CCLayer alloc] init];
    
    CCSprite *irightButton = [CCSprite spriteWithFile:@"left_right_button.png"];
    irightButton.flipX = YES;
    irightButton.position = ccp(winSize.width - 40, winSize.height-270);
    [icarusLayer addChild:irightButton];
    
    CCSprite *ileftButton = [CCSprite spriteWithFile:@"left_right_button.png"];
    ileftButton.flipX = NO;
    ileftButton.position = ccp(40, winSize.height-270);
    [icarusLayer addChild:ileftButton];
    
    CCMenuItemImage *icarus = [CCMenuItemImage itemFromNormalImage:@"icarus_store.png" selectedImage:@"icarus_store.png" target:self selector:nil];
    CCMenu *icarusMenu = [CCMenu menuWithItems: icarus, nil];
    //icarus.scale = 2;
    icarusMenu.position =ccp(winSize.width/2, winSize.height - 280);
    [icarusLayer addChild:icarusMenu];
    
    if(![[[SettingsManager sharedSettingsManager] getArray:@"purchases"] containsObject:@"wings"]){
        CCLabelTTF *icarusCost = [CCLabelBMFont labelWithString:@"5000" fntFile:@"uni_16_white_no_shadow.fnt" width:100 alignment:UITextAlignmentCenter];
        icarusCost.anchorPoint = ccp(0.0f, 1.0f);
        icarusCost.position = ccp(65, winSize.height-372);
        icarusCost.tag = 2222;
        [icarusLayer addChild:icarusCost z:800];
        
        CCSprite *icarusCoinIcon = [CCSprite spriteWithFile:@"store_coin.png"];
        icarusCoinIcon.anchorPoint = ccp(0.0f, 1.0f);
        icarusCoinIcon.position = ccp(40, winSize.height-370);
        icarusCoinIcon.tag = 3333;
        [icarusLayer addChild:icarusCoinIcon z:800];
        
        CCMenuItemImage *icarusGetIt = [CCMenuItemImage itemFromNormalImage:@"buy_button.png" selectedImage:@"buy_button.png" target:self selector:@selector(selectwings:)];
        CCMenu *icarusGetItMenu = [CCMenu menuWithItems: icarusGetIt, nil];
        icarusMenu.anchorPoint = ccp(1.0f, 1.0f);
        icarusGetItMenu.tag = 4444;
        icarusGetIt.tag = 5555;
        icarusGetItMenu.position =ccp(winSize.width - 60, winSize.height - 387);
        [icarusLayer addChild:icarusGetItMenu];
    }else{
        CCMenuItemImage *icarusGetIt = [CCMenuItemImage itemFromNormalImage:@"useit_button.png" selectedImage:@"useit_button.png" target:self selector:@selector(selectwings:)];
        CCMenu *icarusGetItMenu = [CCMenu menuWithItems: icarusGetIt, nil];
        icarusMenu.anchorPoint = ccp(1.0f, 1.0f);
        icarusGetItMenu.tag = 4444;
        icarusGetIt.tag = 5555;
        icarusGetItMenu.position =ccp(winSize.width - 60, winSize.height - 387);
        [icarusLayer addChild:icarusGetItMenu];
    }
    
    CCLabelTTF *icarusName = [CCLabelBMFont labelWithString:@"WINGS OF ICARUS" fntFile:@"uni_16_white_no_shadow.fnt" width:200 alignment:UITextAlignmentCenter];
    icarusName.anchorPoint = ccp(0.0f, 1.0f);
    icarusName.position = ccp(40, winSize.height-392);
    [icarusLayer addChild:icarusName z:800];
    
    CCLabelTTF *icarusDescription = [CCLabelBMFont labelWithString:@"Wings constructed for Icarus by his father, from feathers and wax. Fly with them for a short distance before falling back to earth." fntFile:@"cc_13pt_white.fnt" width:250 alignment:UITextAlignmentLeft];
    icarusDescription.anchorPoint = ccp(0.0f, 1.0f);
    icarusDescription.position = ccp(40, winSize.height-420);
    [icarusLayer addChild:icarusDescription z:800];
    
    ////////////////////////
    
    midasLayer = [[CCLayer alloc] init];
    
    CCSprite *mileftButton = [CCSprite spriteWithFile:@"left_right_button.png"];
    mileftButton.flipX = NO;
    mileftButton.position = ccp(40, winSize.height-270);
    [midasLayer addChild:mileftButton];
    
    CCMenuItemImage *midas = [CCMenuItemImage itemFromNormalImage:@"midas_store.png" selectedImage:@"midas_store.png" target:self selector:nil];
    CCMenu *midasMenu = [CCMenu menuWithItems: midas, nil];
    //midas.scale = 2;
    midasMenu.position =ccp(winSize.width/2, winSize.height - 280);
    [midasLayer addChild:midasMenu];
    
    if(![[[SettingsManager sharedSettingsManager] getArray:@"purchases"] containsObject:@"midas"]){
        CCLabelTTF *midasCost = [CCLabelBMFont labelWithString:@"7500" fntFile:@"uni_16_white_no_shadow.fnt" width:100 alignment:UITextAlignmentCenter];
        midasCost.anchorPoint = ccp(0.0f, 1.0f);
        midasCost.position = ccp(65, winSize.height-372);
        midasCost.tag = 2222;
        [midasLayer addChild:midasCost z:800];
        
        CCSprite *midasCoinIcon = [CCSprite spriteWithFile:@"store_coin.png"];
        midasCoinIcon.anchorPoint = ccp(0.0f, 1.0f);
        midasCoinIcon.position = ccp(40, winSize.height-370);
        midasCoinIcon.tag = 3333;
        [midasLayer addChild:midasCoinIcon z:800];
        
        CCMenuItemImage *midasGetIt = [CCMenuItemImage itemFromNormalImage:@"buy_button.png" selectedImage:@"buy_button.png" target:self selector:@selector(selectmidas:)];
        CCMenu *midasGetItMenu = [CCMenu menuWithItems: midasGetIt, nil];
        midasMenu.anchorPoint = ccp(1.0f, 1.0f);
        midasGetItMenu.position =ccp(winSize.width - 60, winSize.height - 387);
        midasGetItMenu.tag = 4444;
        midasGetIt.tag = 5555;
        [midasLayer addChild:midasGetItMenu];
    }else{
        CCMenuItemImage *midasGetIt = [CCMenuItemImage itemFromNormalImage:@"useit_button.png" selectedImage:@"useit_button.png" target:self selector:@selector(selectmidas:)];
        CCMenu *midasGetItMenu = [CCMenu menuWithItems: midasGetIt, nil];
        midasMenu.anchorPoint = ccp(1.0f, 1.0f);
        midasGetItMenu.position =ccp(winSize.width - 60, winSize.height - 387);
        midasGetItMenu.tag = 4444;
        [midasLayer addChild:midasGetItMenu];
    }
    
    CCLabelTTF *midasName = [CCLabelBMFont labelWithString:@"MIDAS TOUCH" fntFile:@"uni_16_white_no_shadow.fnt" width:180 alignment:UITextAlignmentCenter];
    midasName.anchorPoint = ccp(0.0f, 1.0f);
    midasName.position = ccp(40, winSize.height-392);
    [midasLayer addChild:midasName z:800];
    
    CCLabelTTF *midasDescription = [CCLabelBMFont labelWithString:@"The power - or is it a curse - to transform everything you touch into gold. While active, every tree and rock you hit will turn into coins." fntFile:@"cc_13pt_white.fnt" width:250 alignment:UITextAlignmentLeft];
    midasDescription.anchorPoint = ccp(0.0f, 1.0f);
    midasDescription.position = ccp(40, winSize.height-420);
    [midasLayer addChild:midasDescription z:800];
    
    ////////////////////////
    
    uniplat = [CCSprite spriteWithFile:@"platform1.png"];
    uniplat.position = ccp(winSize.width/2, winSize.height - 290);
    uniplat.scale = 2;
    
    NSMutableArray *platArray = [NSMutableArray array];
    for(int i = 1; i <= 4; ++i) {
        [platArray addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"platform%d.png", i]]];
    }
    
    CCAnimation *platAn = [CCAnimation animationWithFrames:platArray delay:0.1f];
    [uniplat runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:platAn restoreOriginalFrame:NO]]];
    
    if([[[SettingsManager sharedSettingsManager] getString:@"equipment"] isEqualToString:@"sword"]){
        [excaliburLayer addChild:uniplat z:800];
        [excaliburLayer getChildByTag:4444].visible = NO;
    }else if([[[SettingsManager sharedSettingsManager] getString:@"equipment"] isEqualToString:@"hammer"]){
        [mjolnirLayer addChild:uniplat z:800];
        [mjolnirLayer getChildByTag:4444].visible = NO;
    }else if([[[SettingsManager sharedSettingsManager] getString:@"equipment"] isEqualToString:@"wings"]){
        [icarusLayer addChild:uniplat z:800];
        [icarusLayer getChildByTag:4444].visible = NO;
    }else if([[[SettingsManager sharedSettingsManager] getString:@"equipment"] isEqualToString:@"midas"]){
        [midasLayer addChild:uniplat z:800];
        [midasLayer getChildByTag:4444].visible = NO;
    }
    
    
    equipmentScrollLayer = [[CCScrollLayer alloc] initWithLayers:[NSMutableArray arrayWithObjects: excaliburLayer, mjolnirLayer, icarusLayer, midasLayer, nil] widthOffset:0];
    equipmentScrollLayer.showPagesIndicator = NO;
    [self addChild:equipmentScrollLayer z:800];
}

-(void)powerUpSelect: (id)sender{
    selected = @"powerup";
    [self removeChild:homeLayer cleanup:NO];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    labelBG = [CCSprite spriteWithFile:@"label_background.png"];
    labelBG.position = ccp(winSize.width/2 + 2, winSize.height - 188);
    [self addChild:labelBG];
    
    labelHeader = [CCLabelBMFont labelWithString:@"POWER-UPS" fntFile:@"uni_16_white_no_shadow.fnt" width:180 alignment:UITextAlignmentCenter];
    labelHeader.position = ccp(winSize.width/2, winSize.height-188);
    [self addChild:labelHeader z:800];
    
    ////////GRIFFIN/////////////////
    
    griffinLayer = [[CCLayer alloc] init];
    
    CCSprite *rightButton = [CCSprite spriteWithFile:@"left_right_button.png"];
    rightButton.flipX = YES;
    rightButton.position = ccp(winSize.width - 40, winSize.height-270);
    [griffinLayer addChild:rightButton];
    
    CCMenuItemImage *griffin = [CCMenuItemImage itemFromNormalImage:@"griffin1.png" selectedImage:@"griffin1.png" target:self selector:nil];
    CCMenu *griffinMenu = [CCMenu menuWithItems: griffin, nil];
    griffin.scale = 2;
    griffinMenu.position =ccp(winSize.width/2, winSize.height - 280);
    [griffinLayer addChild:griffinMenu];
    
    if(![[[SettingsManager sharedSettingsManager] getString:@"powerup"] isEqualToString:@"griffin"]){
        CCLabelTTF *griffinCost = [CCLabelBMFont labelWithString:@"500" fntFile:@"uni_16_white_no_shadow.fnt" width:100 alignment:UITextAlignmentCenter];
        griffinCost.anchorPoint = ccp(0.0f, 1.0f);
        griffinCost.position = ccp(65, winSize.height-372);
        [griffinLayer addChild:griffinCost z:800];
        
        CCSprite *griffinCoinIcon = [CCSprite spriteWithFile:@"store_coin.png"];
        griffinCoinIcon.anchorPoint = ccp(0.0f, 1.0f);
        griffinCoinIcon.position = ccp(40, winSize.height-370);
        [griffinLayer addChild:griffinCoinIcon z:800];
        
        CCMenuItemImage *getIt = [CCMenuItemImage itemFromNormalImage:@"buy_button.png" selectedImage:@"buy_button.png" target:self selector:@selector(selectgriffin:)];
        CCMenu *griffinGetItMenu = [CCMenu menuWithItems: getIt, nil];
        griffinMenu.anchorPoint = ccp(0.0f, 1.0f);
        griffinGetItMenu.position =ccp(winSize.width - 60, winSize.height - 387);
        griffinGetItMenu.tag = 4444;
        [griffinLayer addChild:griffinGetItMenu];
    }else{
        
    }
    
    CCLabelTTF *griffinName = [CCLabelBMFont labelWithString:@"GRYPHON" fntFile:@"uni_16_white_no_shadow.fnt" width:100 alignment:UITextAlignmentCenter];
    griffinName.anchorPoint = ccp(0.0f, 1.0f);
    griffinName.position = ccp(40, winSize.height-392);
    [griffinLayer addChild:griffinName z:800];
    
    CCLabelTTF *griffinDescription = [CCLabelBMFont labelWithString:@"Part powerful lion, part majestic eagle. Buy this power-up to be carried a great distance down the mountain on your next run." fntFile:@"cc_13pt_white.fnt" width:250 alignment:UITextAlignmentLeft];
    griffinDescription.anchorPoint = ccp(0.0f, 1.0f);
    griffinDescription.position = ccp(40, winSize.height-420);
    [griffinLayer addChild:griffinDescription z:800];
    
    /////////PHOENIX////////////////
    
    phoenixLayer = [[CCLayer alloc] init];
    
    CCSprite *leftButton = [CCSprite spriteWithFile:@"left_right_button.png"];
    leftButton.flipX = NO;
    leftButton.position = ccp(40, winSize.height-270);
    [phoenixLayer addChild:leftButton];
    
    CCMenuItemImage *phoenix = [CCMenuItemImage itemFromNormalImage:@"pheonix1.png" selectedImage:@"pheonix1.png" target:self selector:nil];
    CCMenu *phoenixMenu = [CCMenu menuWithItems: phoenix, nil];
    phoenix.scale = 2;
    phoenixMenu.position =ccp(winSize.width/2, winSize.height - 285);
    [phoenixLayer addChild:phoenixMenu];
    
    if(![[[SettingsManager sharedSettingsManager] getString:@"powerup"] isEqualToString:@"pheonix"]){
        CCLabelTTF *uniCost = [CCLabelBMFont labelWithString:@"500" fntFile:@"uni_16_white_no_shadow.fnt" width:100 alignment:UITextAlignmentCenter];
        uniCost.anchorPoint = ccp(0.0f, 1.0f);
        uniCost.position = ccp(65, winSize.height-372);
        uniCost.tag = 2222;
        [phoenixLayer addChild:uniCost z:800];
        
        CCSprite *uniCoinIcon = [CCSprite spriteWithFile:@"store_coin.png"];
        uniCoinIcon.anchorPoint = ccp(0.0f, 1.0f);
        uniCoinIcon.position = ccp(40, winSize.height-370);
        uniCoinIcon.tag = 3333;
        [phoenixLayer addChild:uniCoinIcon z:800];
        
        CCMenuItemImage *uniGetIt = [CCMenuItemImage itemFromNormalImage:@"buy_button.png" selectedImage:@"buy_button.png" target:self selector:@selector(selectpheonix:)];
        CCMenu *phoenixGetItMenu = [CCMenu menuWithItems: uniGetIt, nil];
        phoenixMenu.anchorPoint = ccp(1.0f, 1.0f);
        phoenixGetItMenu.position =ccp(winSize.width - 60, winSize.height - 387);
        phoenixGetItMenu.tag = 4444;
        [phoenixLayer addChild:phoenixGetItMenu];
    }else{
        
    }
    
    CCLabelTTF *uniName = [CCLabelBMFont labelWithString:@"PHOENIX" fntFile:@"uni_16_white_no_shadow.fnt" width:100 alignment:UITextAlignmentCenter];
    uniName.anchorPoint = ccp(0.0f, 1.0f);
    uniName.position = ccp(40, winSize.height-392);
    [phoenixLayer addChild:uniName z:800];
    
    CCLabelTTF *uniDescription = [CCLabelBMFont labelWithString:@"A mythical bird that lives, burns, and is reborn from its ashes. Buy this power-up to get a second chance the next time you crash." fntFile:@"cc_13pt_white.fnt" width:250 alignment:UITextAlignmentLeft];
    uniDescription.anchorPoint = ccp(0.0f, 1.0f);
    uniDescription.position = ccp(40, winSize.height-420);
    [phoenixLayer addChild:uniDescription z:800];
    
        
    ////////////////////////
    
    uniplat = [CCSprite spriteWithFile:@"platform1.png"];
    uniplat.position = ccp(winSize.width/2, winSize.height - 290);
    uniplat.scale = 2;
    
    NSMutableArray *platArray = [NSMutableArray array];
    for(int i = 1; i <= 4; ++i) {
        [platArray addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"platform%d.png", i]]];
    }
    
    CCAnimation *platAn = [CCAnimation animationWithFrames:platArray delay:0.1f];
    [uniplat runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:platAn restoreOriginalFrame:NO]]];
    
    if([[[SettingsManager sharedSettingsManager] getString:@"powerup"] isEqualToString:@"phoenix"]){
        [phoenixLayer addChild:uniplat z:800];
        [phoenixLayer getChildByTag:4444].visible = NO;
        [griffinLayer getChildByTag:4444].visible = NO;
    }else if([[[SettingsManager sharedSettingsManager] getString:@"powerup"] isEqualToString:@"griffin"]){
        [griffinLayer addChild:uniplat z:800];
        [phoenixLayer getChildByTag:4444].visible = NO;
        [griffinLayer getChildByTag:4444].visible = NO;
    }
    
    powerupScrollerLayer = [[CCScrollLayer alloc] initWithLayers:[NSMutableArray arrayWithObjects: griffinLayer, phoenixLayer, nil] widthOffset:0];
    powerupScrollerLayer.showPagesIndicator = NO;
    [self addChild:powerupScrollerLayer z:800];
}

-(void)selecthammer: (id)sender{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    if([[[SettingsManager sharedSettingsManager] getArray:@"purchases"] containsObject:@"hammer"]){
    if(![[[SettingsManager sharedSettingsManager] getString:@"equipment"] isEqualToString:@"hammer"]){
        [[SettingsManager sharedSettingsManager] setStringValue:@"hammer" name:@"equipment"];
        [excaliburLayer removeChild:uniplat cleanup:NO];
        [midasLayer removeChild:uniplat cleanup:NO];
        [icarusLayer removeChild:uniplat cleanup:NO];
        [uniplat setOpacity:0];
        [uniplat runAction:[CCFadeIn actionWithDuration:1]];
        [mjolnirLayer addChild:uniplat z:800];
        equipmentItem = [CCMenuItemImage itemFromNormalImage:@"mjolnir_store.png" selectedImage:@"mjolnir_store.png" target:self selector:@selector(equipmentSelect:)];
        equipmentItem.scale = .5;
        [homeLayer removeChild:menu4 cleanup:YES];
        menu4 = [CCMenu menuWithItems: equipmentItem, nil];
        menu4.position = ccp(winSize.width - 110, winSize.height-245);
        [menu4 alignItemsHorizontally];
        [homeLayer addChild:menu4];
        [icarusLayer getChildByTag:4444].visible = YES;
        [excaliburLayer getChildByTag:4444].visible = YES;
        [midasLayer getChildByTag:4444].visible = YES;
        [mjolnirLayer getChildByTag:4444].visible = NO;
        NSDictionary *purchaseParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"Item", @"Hammer", // Capture user status
         nil];
        
        [Flurry logEvent:@"Select Item" withParameters:purchaseParams];
    }
    }else{
        purchaseAmount = 2500;
        purchaseString = @"hammer";
        purchaseLayer = mjolnirLayer;
        
        [self performSelector:@selector(showDialog)];
    }
}

-(void)selectmidas: (id)sender{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    if([[[SettingsManager sharedSettingsManager] getArray:@"purchases"] containsObject:@"midas"]){
    if(![[[SettingsManager sharedSettingsManager] getString:@"equipment"] isEqualToString:@"midas"]){
        [[SettingsManager sharedSettingsManager] setStringValue:@"midas" name:@"equipment"];
        [excaliburLayer removeChild:uniplat cleanup:NO];
        [icarusLayer removeChild:uniplat cleanup:NO];
        [mjolnirLayer removeChild:uniplat cleanup:NO];
        [uniplat setOpacity:0];
        [uniplat runAction:[CCFadeIn actionWithDuration:1]];
        [midasLayer addChild:uniplat z:800];
        equipmentItem = [CCMenuItemImage itemFromNormalImage:@"midas_store.png" selectedImage:@"midas_store.png" target:self selector:@selector(equipmentSelect:)];
        equipmentItem.scale = .5;
        [homeLayer removeChild:menu4 cleanup:YES];
        menu4 = [CCMenu menuWithItems: equipmentItem, nil];
        menu4.position = ccp(winSize.width - 110, winSize.height-245);
        [menu4 alignItemsHorizontally];
        [homeLayer addChild:menu4];
        [icarusLayer getChildByTag:4444].visible = YES;
        [excaliburLayer getChildByTag:4444].visible = YES;
        [midasLayer getChildByTag:4444].visible = NO;
        [mjolnirLayer getChildByTag:4444].visible = YES;
        NSDictionary *purchaseParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"Item", @"Midas", // Capture user status
         nil];
        
        [Flurry logEvent:@"Select Item" withParameters:purchaseParams];
    }
    }else{
        purchaseAmount = 7500;
        purchaseString = @"midas";
        purchaseLayer = midasLayer;
        
        [self performSelector:@selector(showDialog)];
    }
}

-(void)selectsword: (id)sender{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    if([[[SettingsManager sharedSettingsManager] getArray:@"purchases"] containsObject:@"sword"]){
    
    if(![[[SettingsManager sharedSettingsManager] getString:@"equipment"] isEqualToString:@"sword"]){
        [[SettingsManager sharedSettingsManager] setStringValue:@"sword" name:@"equipment"];
        [icarusLayer removeChild:uniplat cleanup:NO];
        [midasLayer removeChild:uniplat cleanup:NO];
        [mjolnirLayer removeChild:uniplat cleanup:NO];
        [uniplat setOpacity:0];
        [uniplat runAction:[CCFadeIn actionWithDuration:1]];
        [excaliburLayer addChild:uniplat z:800];
        equipmentItem = [CCMenuItemImage itemFromNormalImage:@"excalibur_store.png" selectedImage:@"excalibur_store.png" target:self selector:@selector(equipmentSelect:)];
        equipmentItem.scale = .5;
        [homeLayer removeChild:menu4 cleanup:YES];
        menu4 = [CCMenu menuWithItems: equipmentItem, nil];
        menu4.position = ccp(winSize.width - 110, winSize.height-245);
        [menu4 alignItemsHorizontally];
        [homeLayer addChild:menu4];
        [icarusLayer getChildByTag:4444].visible = YES;
        [excaliburLayer getChildByTag:4444].visible = NO;
        [midasLayer getChildByTag:4444].visible = YES;
        [mjolnirLayer getChildByTag:4444].visible = YES;
        NSDictionary *purchaseParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"Item", @"Sword", // Capture user status
         nil];
        
        [Flurry logEvent:@"Select Item" withParameters:purchaseParams];
    }
    }else{
        purchaseAmount = 2500;
        purchaseString = @"sword";
        purchaseLayer = excaliburLayer;
        
        [self performSelector:@selector(showDialog)];
    }
}

-(void)selectwings: (id)sender{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    if([[[SettingsManager sharedSettingsManager] getArray:@"purchases"] containsObject:@"wings"]){
    if(![[[SettingsManager sharedSettingsManager] getString:@"equipment"] isEqualToString:@"wings"]){
        [[SettingsManager sharedSettingsManager] setStringValue:@"wings" name:@"equipment"];
        [excaliburLayer removeChild:uniplat cleanup:NO];
        [midasLayer removeChild:uniplat cleanup:NO];
        [mjolnirLayer removeChild:uniplat cleanup:NO];
        [uniplat setOpacity:0];
        [uniplat runAction:[CCFadeIn actionWithDuration:1]];
        [icarusLayer addChild:uniplat z:800];
        equipmentItem = [CCMenuItemImage itemFromNormalImage:@"icarus_store.png" selectedImage:@"icarus_store.png" target:self selector:@selector(equipmentSelect:)];
        equipmentItem.scale = .5;
        [homeLayer removeChild:menu4 cleanup:YES];
        menu4 = [CCMenu menuWithItems: equipmentItem, nil];
        menu4.position = ccp(winSize.width - 110, winSize.height-245);
        [menu4 alignItemsHorizontally];
        [homeLayer addChild:menu4];
        [icarusLayer getChildByTag:4444].visible = NO;
        [excaliburLayer getChildByTag:4444].visible = YES;
        [midasLayer getChildByTag:4444].visible = YES;
        [mjolnirLayer getChildByTag:4444].visible = YES;
        NSDictionary *purchaseParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"Item", @"Wings", // Capture user status
         nil];
        
        [Flurry logEvent:@"Select Item" withParameters:purchaseParams];
    }
    }else{
        purchaseAmount = 5000;
        purchaseString = @"wings";
        purchaseLayer = icarusLayer;
        
        [self performSelector:@selector(showDialog)];
    }
}

-(void)selectYeti: (id)sender{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    if([[[SettingsManager sharedSettingsManager] getArray:@"purchases"] containsObject:@"yeti"]){
    if(![[[SettingsManager sharedSettingsManager] getString:@"character"] isEqualToString:@"yeti"]){
        NSLog(@"Let's play yeti style");
        [[SettingsManager sharedSettingsManager] setStringValue:@"yeti" name:@"character"];
        [unicornLayer removeChild:uniplat cleanup:NO];
        [mermaidLayer removeChild:uniplat cleanup:NO];
        [uniplat setOpacity:0];
        [uniplat runAction:[CCFadeIn actionWithDuration:1]];
        [yetiLayer addChild:uniplat z:800];
        [homeLayer removeChild:menu3 cleanup:YES];
        characterItem = [CCMenuItemImage itemFromNormalImage:@"yetiTurning01.png" selectedImage:@"yetiTurning01.png" target:self selector:@selector(characterSelect:)];
        menu3 = [CCMenu menuWithItems: characterItem, nil];
        menu3.position = ccp(120, winSize.height-245);
        [menu3 alignItemsHorizontally];
        [homeLayer addChild:menu3];
        [unicornLayer getChildByTag:4444].visible = YES;
        [mermaidLayer getChildByTag:4444].visible = YES;
        [yetiLayer getChildByTag:4444].visible = NO;
        NSDictionary *purchaseParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"Character", @"Yeti", // Capture user status
         nil];
        
        [Flurry logEvent:@"Select Character" withParameters:purchaseParams];
    }
    }else{
        NSLog(@"PURCHASSSSE");
    }
    
   
}

-(void)selectunicorn: (id)sender{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    if([[[SettingsManager sharedSettingsManager] getArray:@"purchases"] containsObject:@"unicorn"]){
    if(![[[SettingsManager sharedSettingsManager] getString:@"character"] isEqualToString:@"unicorn"]){
        NSLog(@"SeXy horn on me");
        [[SettingsManager sharedSettingsManager] setStringValue:@"unicorn" name:@"character"];
        [yetiLayer removeChild:uniplat cleanup:NO];
        [mermaidLayer removeChild:uniplat cleanup:NO];
        [uniplat setOpacity:0];
        [uniplat runAction:[CCFadeIn actionWithDuration:1]];
        [unicornLayer addChild:uniplat z:800];
        [homeLayer removeChild:menu3 cleanup:YES];
        characterItem = [CCMenuItemImage itemFromNormalImage:@"unicorn_store.png" selectedImage:@"unicorn_store.png" target:self selector:@selector(characterSelect:)];
        menu3 = [CCMenu menuWithItems: characterItem, nil];
        menu3.position = ccp(120, winSize.height-245);
        [menu3 alignItemsHorizontally];
        [homeLayer addChild:menu3];
        [unicornLayer getChildByTag:4444].visible = NO;
        [yetiLayer getChildByTag:4444].visible = YES;
        [mermaidLayer getChildByTag:4444].visible = YES;
        NSDictionary *purchaseParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"Character", @"Unicorn", // Capture user status
         nil];
        
        [Flurry logEvent:@"Select Character" withParameters:purchaseParams];
    }
    }else{
        purchaseAmount = 10000;
        purchaseString = @"unicorn";
        purchaseLayer = unicornLayer;
        
        [self performSelector:@selector(showDialog)];
    }
    
    
}

-(void)selectmermaid: (id)sender{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    if([[[SettingsManager sharedSettingsManager] getArray:@"purchases"] containsObject:@"mermaid"]){
        if(![[[SettingsManager sharedSettingsManager] getString:@"character"] isEqualToString:@"mermaid"]){
            NSLog(@"SeXy tail on me");
            [[SettingsManager sharedSettingsManager] setStringValue:@"mermaid" name:@"character"];
            [yetiLayer removeChild:uniplat cleanup:NO];
            [unicornLayer removeChild:uniplat cleanup:NO];
            [uniplat setOpacity:0];
            [uniplat runAction:[CCFadeIn actionWithDuration:1]];
            [mermaidLayer addChild:uniplat z:800];
            [homeLayer removeChild:menu3 cleanup:YES];
            characterItem = [CCMenuItemImage itemFromNormalImage:@"mermaid_store.png" selectedImage:@"mermaid_store.png" target:self selector:@selector(characterSelect:)];
            menu3 = [CCMenu menuWithItems: characterItem, nil];
            menu3.position = ccp(120, winSize.height-245);
            [menu3 alignItemsHorizontally];
            [homeLayer addChild:menu3];
            [mermaidLayer getChildByTag:4444].visible = NO;
            [yetiLayer getChildByTag:4444].visible = YES;
            [unicornLayer getChildByTag:4444].visible = YES;
            NSDictionary *purchaseParams =
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"Character", @"Mermaid", // Capture user status
             nil];
            
            [Flurry logEvent:@"Select Character" withParameters:purchaseParams];
        }
    }else{
        purchaseAmount = 10000;
        purchaseString = @"mermaid";
        purchaseLayer = mermaidLayer;
        
        [self performSelector:@selector(showDialog)];
    }
}

-(void)showDialog{
    if(!dialogUP){
    CGSize winSize = [CCDirector sharedDirector].winSize;
    dialogLayer = [[CCLayer alloc] init];
    CCSprite *dialogBox = [CCSprite spriteWithFile:@"dialog_bg.png"];
    dialogBox.position = ccp(winSize.width/2, winSize.height/2);
    [dialogLayer addChild:dialogBox];
    
    int totalCoins = [[SettingsManager sharedSettingsManager] getInt:@"coins"];
    if(totalCoins - purchaseAmount >= 0){
        CCLabelTTF *purchase = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Spend %i coins to buy this item?", purchaseAmount] fntFile:@"uni_16_white_no_shadow.fnt" width:220 alignment:UITextAlignmentCenter];
        purchase.anchorPoint = ccp(0.5f, 0.5f);
        purchase.position = ccp(winSize.width/2, winSize.height/2 + 35);
        [dialogLayer addChild:purchase];
        
        CCMenuItemImage *confirm = [CCMenuItemImage itemFromNormalImage:@"buy_button.png" selectedImage:@"buy_button.png" target:self selector:@selector(confirmDialog)];
        CCMenuItemImage *cancel = [CCMenuItemImage itemFromNormalImage:@"cancel_btn.png" selectedImage:@"cancel_btn.png" target:self selector:@selector(hideDialog)];
        CCMenu *dialogMenu = [CCMenu menuWithItems: cancel, confirm, nil];
        dialogMenu.position = ccp(winSize.width/2, winSize.height/2 - 35);
        [dialogMenu alignItemsHorizontallyWithPadding:12.0f];
        [dialogLayer addChild:dialogMenu];
    }else{
        CCLabelTTF *purchase = [CCLabelBMFont labelWithString:@"You need to collect more coins to buy this item." fntFile:@"uni_16_white_no_shadow.fnt" width:220 alignment:UITextAlignmentCenter];
        purchase.anchorPoint = ccp(0.5f, 0.5f);
        purchase.position = ccp(winSize.width/2, winSize.height/2 + 35);
        [dialogLayer addChild:purchase];
        
        CCMenuItemImage *cancel = [CCMenuItemImage itemFromNormalImage:@"continue_btn.png" selectedImage:@"continue_btn.png" target:self selector:@selector(hideDialog)];
        CCMenu *dialogMenu = [CCMenu menuWithItems: cancel, nil];
        dialogMenu.position = ccp(winSize.width/2, winSize.height/2 - 35);
        [dialogMenu alignItemsHorizontallyWithPadding:12.0f];
        [dialogLayer addChild:dialogMenu];
    }
    dialogUP = YES;
    [self addChild:dialogLayer z:999];
    }else{
        
    }
}

-(void)confirmDialog{
    if([purchaseString isEqualToString:@"unicorn"] || [purchaseString isEqualToString:@"mermaid"]){
        [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:kAchievementsAdoption percentComplete:100.0];
    }else if([purchaseString isEqualToString:@"hammer"] || [purchaseString isEqualToString:@"sword"] || [purchaseString isEqualToString:@"midas"] || [purchaseString isEqualToString:@"wings"]){
        [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:kAchievementsNewGear percentComplete:100.0];
    }
    
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    int totalCoins = [[SettingsManager sharedSettingsManager] getInt:@"coins"];
    totalCoins = totalCoins - purchaseAmount;
    [[SettingsManager sharedSettingsManager] setIntValue:totalCoins name:@"coins"];
    
    [coinScoreLabel setString:[NSString stringWithFormat:@"%i\nCOINS", totalCoins]];
    
    NSMutableArray *purchases = [[SettingsManager sharedSettingsManager] getArray:@"purchases"];
    NSMutableArray *purch = [NSMutableArray arrayWithArray:purchases];
    [purch addObject:purchaseString];
    [[SettingsManager sharedSettingsManager] setArrayValue:purch name:@"purchases"];
    [[SettingsManager sharedSettingsManager] save];
    SEL aSelector = NSSelectorFromString([NSString stringWithFormat:@"select%@:", purchaseString]);
    [self performSelector:aSelector];
    
    [purchaseLayer getChildByTag:2222].visible = NO;
    [purchaseLayer getChildByTag:3333].visible = NO;
    [purchaseLayer getChildByTag:4444].visible = NO;
    [purchaseLayer removeChild:[purchaseLayer getChildByTag:4444] cleanup:YES];
    CCMenuItemImage *getIt = [CCMenuItemImage itemFromNormalImage:@"useit_button.png" selectedImage:@"useit_button.png" target:self selector:aSelector];
    CCMenu *getItMenu = [CCMenu menuWithItems: getIt, nil];
    getItMenu.anchorPoint = ccp(0.0f, 1.0f);
    getItMenu.position =ccp(winSize.width - 60, winSize.height - 387);
    getItMenu.tag = 4444;
    [purchaseLayer addChild:getItMenu];
    getItMenu.visible = NO;
    
    [self removeChild:dialogLayer cleanup:YES];
    dialogUP = NO;
    
    NSDictionary *purchaseParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"Item", purchaseString, // Capture user status
     nil];
    
    [Flurry logEvent:@"Item Purchase" withParameters:purchaseParams];
}

-(void)hideDialog{
    [self removeChild:dialogLayer cleanup:YES];
    dialogUP = NO;
}

-(void)selectgriffin: (id)sender{
    if(!dialogUP){
        CGSize winSize = [CCDirector sharedDirector].winSize;
        dialogLayer = [[CCLayer alloc] init];
        CCSprite *dialogBox = [CCSprite spriteWithFile:@"dialog_bg.png"];
        dialogBox.position = ccp(winSize.width/2, winSize.height/2);
        [dialogLayer addChild:dialogBox];
        
        int totalCoins = [[SettingsManager sharedSettingsManager] getInt:@"coins"];
        if(totalCoins - 500 >= 0){
            CCLabelTTF *purchase = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Spend %i coins to equip this power up for your next run?", 500] fntFile:@"uni_16_white_no_shadow.fnt" width:220 alignment:UITextAlignmentCenter];
            purchase.anchorPoint = ccp(0.5f, 0.5f);
            purchase.position = ccp(winSize.width/2, winSize.height/2 + 35);
            [dialogLayer addChild:purchase];
            
            CCMenuItemImage *confirm = [CCMenuItemImage itemFromNormalImage:@"buy_button.png" selectedImage:@"buy_button.png" target:self selector:@selector(confirmGriffin)];
            CCMenuItemImage *cancel = [CCMenuItemImage itemFromNormalImage:@"cancel_btn.png" selectedImage:@"cancel_btn.png" target:self selector:@selector(hideDialog)];
            CCMenu *dialogMenu = [CCMenu menuWithItems: cancel, confirm, nil];
            dialogMenu.position = ccp(winSize.width/2, winSize.height/2 - 35);
            [dialogMenu alignItemsHorizontallyWithPadding:12.0f];
            [dialogLayer addChild:dialogMenu];
        }else{
            CCLabelTTF *purchase = [CCLabelBMFont labelWithString:@"You need to collect more coins to buy this power-up!" fntFile:@"uni_16_white_no_shadow.fnt" width:220 alignment:UITextAlignmentCenter];
            purchase.anchorPoint = ccp(0.5f, 0.5f);
            purchase.position = ccp(winSize.width/2, winSize.height/2 + 35);
            [dialogLayer addChild:purchase];
            
            CCMenuItemImage *cancel = [CCMenuItemImage itemFromNormalImage:@"continue_btn.png" selectedImage:@"continue_btn.png" target:self selector:@selector(hideDialog)];
            CCMenu *dialogMenu = [CCMenu menuWithItems: cancel, nil];
            dialogMenu.position = ccp(winSize.width/2, winSize.height/2 - 35);
            [dialogMenu alignItemsHorizontallyWithPadding:12.0f];
            [dialogLayer addChild:dialogMenu];
        }
        dialogUP = YES;
        [self addChild:dialogLayer z:999];
    }
}

-(void)confirmGriffin{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    int totalCoins = [[SettingsManager sharedSettingsManager] getInt:@"coins"];
    totalCoins = totalCoins - 500;
    [[SettingsManager sharedSettingsManager] setIntValue:totalCoins name:@"coins"];
    
    [coinScoreLabel setString:[NSString stringWithFormat:@"%i\nCOINS", totalCoins]];
    
    [[SettingsManager sharedSettingsManager] setStringValue:@"griffin" name:@"powerup"];
    [[SettingsManager sharedSettingsManager] save];
    [self removeChild:dialogLayer cleanup:YES];
    dialogUP = NO;
    
    [griffinLayer getChildByTag:2222].visible = NO;
    [griffinLayer getChildByTag:3333].visible = NO;
    [griffinLayer getChildByTag:4444].visible = NO;
    [phoenixLayer getChildByTag:4444].visible = NO;
    
    [griffinLayer addChild:uniplat];
    [uniplat setOpacity:0];
    [uniplat runAction:[CCFadeIn actionWithDuration:1]];
    
    [homeLayer removeChild:menu2 cleanup:YES];
    powerupItem = [CCMenuItemImage itemFromNormalImage:@"griffin1.png" selectedImage:@"griffin1.png" target:self selector:@selector(powerUpSelect:)];
    menu2 = [CCMenu menuWithItems: powerupItem, nil];
    menu2.position = ccp(winSize.width - 110, winSize.height-375);
    [menu2 alignItemsHorizontally];
    [homeLayer addChild:menu2];
    
    NSDictionary *purchaseParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"Griffin", @"Powerup", // Capture user status
     nil];
    
    [Flurry logEvent:@"Powerup Purchase" withParameters:purchaseParams];
}

-(void)selectpheonix: (id)sender{
    if(!dialogUP){
        CGSize winSize = [CCDirector sharedDirector].winSize;
        dialogLayer = [[CCLayer alloc] init];
        CCSprite *dialogBox = [CCSprite spriteWithFile:@"dialog_bg.png"];
        dialogBox.position = ccp(winSize.width/2, winSize.height/2);
        [dialogLayer addChild:dialogBox];
        
        int totalCoins = [[SettingsManager sharedSettingsManager] getInt:@"coins"];
        if(totalCoins - 500 >= 0){
            CCLabelTTF *purchase = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Spend %i coins to equip this power up for your next run?", 500] fntFile:@"uni_16_white_no_shadow.fnt" width:220 alignment:UITextAlignmentCenter];
            purchase.anchorPoint = ccp(0.5f, 0.5f);
            purchase.position = ccp(winSize.width/2, winSize.height/2 + 35);
            [dialogLayer addChild:purchase];
            
            CCMenuItemImage *confirm = [CCMenuItemImage itemFromNormalImage:@"buy_button.png" selectedImage:@"buy_button.png" target:self selector:@selector(confirmPheonix:)];
            CCMenuItemImage *cancel = [CCMenuItemImage itemFromNormalImage:@"cancel_btn.png" selectedImage:@"cancel_btn.png" target:self selector:@selector(hideDialog)];
            CCMenu *dialogMenu = [CCMenu menuWithItems: cancel, confirm, nil];
            dialogMenu.position = ccp(winSize.width/2, winSize.height/2 - 35);
            [dialogMenu alignItemsHorizontallyWithPadding:12.0f];
            [dialogLayer addChild:dialogMenu];
        }else{
            CCLabelTTF *purchase = [CCLabelBMFont labelWithString:@"You need to collect more coins to buy this power-up!" fntFile:@"uni_16_white_no_shadow.fnt" width:220 alignment:UITextAlignmentCenter];
            purchase.anchorPoint = ccp(0.5f, 0.5f);
            purchase.position = ccp(winSize.width/2, winSize.height/2 + 35);
            [dialogLayer addChild:purchase];
            
            CCMenuItemImage *cancel = [CCMenuItemImage itemFromNormalImage:@"continue_btn.png" selectedImage:@"continue_btn.png" target:self selector:@selector(hideDialog)];
            CCMenu *dialogMenu = [CCMenu menuWithItems: cancel, nil];
            dialogMenu.position = ccp(winSize.width/2, winSize.height/2 - 35);
            [dialogMenu alignItemsHorizontallyWithPadding:12.0f];
            [dialogLayer addChild:dialogMenu];
        }
        dialogUP = YES;
        [self addChild:dialogLayer z:999];
    }
}

-(void)confirmPheonix: (id)sender{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    int totalCoins = [[SettingsManager sharedSettingsManager] getInt:@"coins"];
    totalCoins = totalCoins - 500;
    [[SettingsManager sharedSettingsManager] setIntValue:totalCoins name:@"coins"];
    
    [coinScoreLabel setString:[NSString stringWithFormat:@"%i\nCOINS", totalCoins]];
    
    [[SettingsManager sharedSettingsManager] setStringValue:@"pheonix" name:@"powerup"];
    [[SettingsManager sharedSettingsManager] save];
    [self removeChild:dialogLayer cleanup:YES];
    dialogUP = NO;
    
    [phoenixLayer getChildByTag:2222].visible = NO;
    [phoenixLayer getChildByTag:3333].visible = NO;
    [phoenixLayer getChildByTag:4444].visible = NO;
    [griffinLayer getChildByTag:4444].visible = NO;
    
    [phoenixLayer addChild:uniplat];
    [uniplat setOpacity:0];
    [uniplat runAction:[CCFadeIn actionWithDuration:1]];
    
    [homeLayer removeChild:menu2 cleanup:YES];
    powerupItem = [CCMenuItemImage itemFromNormalImage:@"pheonix1.png" selectedImage:@"pheonix1.png" target:self selector:@selector(powerUpSelect:)];
    menu2 = [CCMenu menuWithItems: powerupItem, nil];
    menu2.position = ccp(winSize.width - 110, winSize.height-375);
    [menu2 alignItemsHorizontally];
    [homeLayer addChild:menu2];
    
    NSDictionary *purchaseParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"Pheonix", @"Powerup", // Capture user status
     nil];
    
    [Flurry logEvent:@"Powerup Purchase" withParameters:purchaseParams];
}


- (void) dealloc
{
    [super dealloc];
    
}
@end
