#import "GameKitHelper.h"
#import "cocos2d.h"

@interface GameKitHelper ()
<GKGameCenterControllerDelegate> {
    BOOL _gameCenterFeaturesEnabled;
}
@end

@implementation GameKitHelper{
    
    NSMutableDictionary *achievementsDictionary;
}

#pragma mark Singleton stuff

+(id) sharedGameKitHelper {
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper =
        [[GameKitHelper alloc] init];
    });
    return sharedGameKitHelper;
}

-(id) init
{
    if( (self=[super init] )) {
        achievementsDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) loadAchievements
{
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error)
     {
         if (error == nil)
         {
             for (GKAchievement* achievement in achievements)
                 [achievementsDictionary setObject: achievement forKey: achievement.identifier];
         }
     }];
}

#pragma mark Player Authentication

-(void) authenticateLocalPlayer {
    
    GKLocalPlayer* localPlayer =
    [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler =
    ^(UIViewController *viewController,
      NSError *error) {
        
        [self setLastError:error];
        
        if ([CCDirector sharedDirector].isPaused)
            [[CCDirector sharedDirector] resume];
        
        if (localPlayer.authenticated) {
            _gameCenterFeaturesEnabled = YES;
            [self loadAchievements];
        } else if(viewController) {
            [[CCDirector sharedDirector] pause];
            [self presentViewController:viewController];
        } else {
            _gameCenterFeaturesEnabled = NO;
        }
    };
}

#pragma mark Property setters

-(void) setLastError:(NSError*)error {
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR: %@", [[_lastError userInfo]
                                           description]);
    }
}

#pragma mark UIViewController stuff

-(UIViewController*) getRootViewController {
    return [UIApplication
            sharedApplication].keyWindow.rootViewController;
}

-(void)presentViewController:(UIViewController*)vc {
    UIViewController* rootVC = [self getRootViewController];
    [rootVC presentViewController:vc animated:YES
                       completion:nil];
}

-(void) submitScore:(int64_t)score
           category:(NSString*)category {
    //1: Check if Game Center
    //   features are enabled
    if (!_gameCenterFeaturesEnabled) {
        CCLOG(@"Player not authenticated");
        return;
    }
    
    //2: Create a GKScore object
    GKScore* gkScore =
    [[GKScore alloc]
     initWithCategory:category];
    
    //3: Set the score value
    gkScore.value = score;
    
    //4: Send the score to Game Center
    [gkScore reportScoreWithCompletionHandler:
     ^(NSError* error) {
         
         [self setLastError:error];
         
         BOOL success = (error == nil);
         
         if ([_delegate
              respondsToSelector:
              @selector(onScoresSubmitted:)]) {
             
             [_delegate onScoresSubmitted:success];
         }
     }];
}

- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent
{
    if([self getAchievementForIdentifier:identifier] == nil){
        GKAchievement *achievementToSend = [[GKAchievement alloc] initWithIdentifier:identifier];
        achievementToSend.percentComplete = 100;
        achievementToSend.showsCompletionBanner = YES;
        [achievementToSend reportAchievementWithCompletionHandler:NULL];
        [achievementsDictionary setObject:achievementToSend forKey:achievementToSend.identifier];
    }
}

- (GKAchievement*) getAchievementForIdentifier: (NSString*) identifier
{
    GKAchievement *achievement = [achievementsDictionary objectForKey:identifier];
    return achievement;
}

- (void) showLeaderboard
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gameCenterController.leaderboardTimeScope = GKLeaderboardTimeScopeToday;
        gameCenterController.leaderboardCategory = kHighScoreLeaderboardCategory;
        UIViewController* rootVC = [self getRootViewController];
        [rootVC presentViewController:gameCenterController animated:YES
                           completion:nil];
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    UIViewController* rootVC = [self getRootViewController];
    [rootVC dismissViewControllerAnimated:YES completion:nil];
}

-(void) showAchievements{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateAchievements;
        UIViewController* rootVC = [self getRootViewController];
        [rootVC presentViewController:gameCenterController animated:YES
                           completion:nil];
    }
}

@end