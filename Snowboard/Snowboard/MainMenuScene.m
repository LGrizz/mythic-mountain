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
#import "SimpleAudioEngine.h"
#import <Social/Social.h>
#import "Flurry.h"

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
        CCLabelTTF *store = [CCLabelBMFont labelWithString:@"SHOP" fntFile:@"main_uni24pt_white.fnt"];
        CCLabelTTF *about = [CCLabelBMFont labelWithString:@"ABOUT" fntFile:@"main_uni24pt_white.fnt"];
        CCLabelTTF *leaderboard = [CCLabelBMFont labelWithString:@"GAMECENTER" fntFile:@"main_uni24pt_white.fnt"];
        CCLabelTTF *settings = [CCLabelBMFont labelWithString:@"SETTINGS" fntFile:@"main_uni24pt_white.fnt"];
        CCLabelTTF *control = [CCLabelBMFont labelWithString:@"CONTROLS" fntFile:@"main_uni24pt_white.fnt"];
        CCMenuItemLabel *startButton = [CCMenuItemLabel itemWithLabel:go target:self selector:@selector(startGame:)];
        CCMenuItemLabel *aboutButton = [CCMenuItemLabel itemWithLabel:about target:self selector:@selector(showAbout:)];
        CCMenuItemLabel *storeButton = [CCMenuItemLabel itemWithLabel:store target:self selector:@selector(showStore:)];
        CCMenuItemLabel *leaderButton = [CCMenuItemLabel itemWithLabel:leaderboard target:self selector:@selector(showLeaderboard:)];
        CCMenuItemLabel *settingsButton = [CCMenuItemLabel itemWithLabel:settings target:self selector:@selector(showSettings:)];
        CCMenuItemLabel *controlButton = [CCMenuItemLabel itemWithLabel:control target:self selector:@selector(showControls:)];
        
        mainmenu = [CCMenu menuWithItems: startButton, storeButton, aboutButton, leaderButton, settingsButton, controlButton, nil];
        [mainmenu alignItemsVerticallyWithPadding:6.0f];
        mainmenu.position = ccp(winSize.width/2, winSize.height - 310);
        [menuLayer addChild: mainmenu];
        
        CCMenuItemSprite *fb = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"facebook.png"] selectedSprite:[CCSprite spriteWithFile:@"facebook.png"] target:self selector:@selector(shareFacebook)];
        
        CCMenuItemSprite *twitter = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"twitter.png"] selectedSprite:[CCSprite spriteWithFile:@"twitter.png"] target:self selector:@selector(shareTwitter)];
        
        CCMenu *shareButtons = [CCMenu menuWithItems:fb,twitter, nil];
        shareButtons.position = ccp(winSize.width/2, winSize.height - 433);
        [shareButtons alignItemsHorizontallyWithPadding:13];
        [self addChild:shareButtons z:997];
        
        CCParticleSystemQuad *snowEffect = [CCParticleSystemQuad particleWithFile:@"snow1.plist"];
        snowEffect.position = ccp(winSize.width/2, winSize.height + 10);

        [self addChild:snowEffect z:999];
        
        if([[[SettingsManager sharedSettingsManager] getString:@"audio"] isEqualToString:@"on"]){
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"main_screen_audio.mp3" loop:YES];
            [SimpleAudioEngine sharedEngine].backgroundMusicVolume = .7;
        }
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
    [Flurry logEvent:@"Start Game"];
    StoryLayer *story = [[StoryLayer alloc] init];
    
    [self addChild:story z:999];
    
    self.isTouchEnabled = NO;
    mainmenu.isTouchEnabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideStore) name:@"hideStory" object:nil];
}

- (void)showLeaderboard: (id)sender{
    [Flurry logEvent:@"Gamecenter"];
    [[GameKitHelper sharedGameKitHelper] showGamecenter];
}

- (void)showAbout: (id)sender{
    [Flurry logEvent:@"Show About"];
    AboutLayer *about = [[AboutLayer alloc] init];
    
    [self addChild:about z:999];
    
    self.isTouchEnabled = NO;
    mainmenu.isTouchEnabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideStore) name:@"hideAbout" object:nil];
}

- (void)showControls: (id)sender{
    [Flurry logEvent:@"Show Controls"];
    ControlsLayer *control = [[ControlsLayer alloc] init];
    
    [self addChild:control z:999];
    
    self.isTouchEnabled = NO;
    mainmenu.isTouchEnabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideStore) name:@"hideControls" object:nil];
}

- (void)showSettings: (id)sender{
    [Flurry logEvent:@"Show Settings"];
    SettingsLayer *settings = [[SettingsLayer alloc] init];
    
    [self addChild:settings z:999];
    
    self.isTouchEnabled = NO;
    mainmenu.isTouchEnabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideStore) name:@"hideSettings" object:nil];
}

- (void)showAchievements: (id)sender{
    [Flurry logEvent:@"Gamecenter"];
    [[GameKitHelper sharedGameKitHelper] showAchievements];
}

-(void)showStore: (id)sender{
    [Flurry logEvent:@"Show Store"];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideStory" object:nil];
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
        
        [fbController setInitialText:[NSString stringWithFormat:@"I'm playing Mythic Mountain, a snowboarding game full of legendary creatures and epic weapons. Get it free at http://mythicmtn.com"]];
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
        
        [twitController setInitialText:[NSString stringWithFormat:@"I'm playing Mythic Mountain, a snowboarding game full of legendary creatures and epic weapons. Get it free at http://mythicmtn.com"]];
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


- (void) dealloc
{
    
    [super dealloc];
}
@end
