//
//  SettingsLayer.m
//  Snowboard
//
//  Created by Kyle Langille on 2013-01-28.
//
//

#import "SettingsLayer.h"
#import "SettingsManager.h"
#import "SimpleAudioEngine.h"
#import "MainMenuScene.h"
#import "PauseLayer.h"
#import "GameOverLayer.h"

@implementation SettingsLayer{
    CCMenuItemImage *sfx;
    CCMenuItemImage *music;
}

-(id)init{
    if ((self = [super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *dialogBox = [CCSprite spriteWithFile:@"dialog_bg.png"];
        dialogBox.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:dialogBox];
        
        CCLabelTTF *header = [CCLabelBMFont labelWithString:@"Settings" fntFile:@"uni_16_white_no_shadow.fnt" width:120 alignment:UITextAlignmentCenter];
        header.position = ccp(winSize.width/2 - 5, winSize.height/2 + 60);
        [self addChild:header];
        
        CCMenuItemImage *cancel = [CCMenuItemImage itemFromNormalImage:@"continue_btn.png" selectedImage:@"continue_btn.png" target:self selector:@selector(close)];
        CCMenu *dialogMenu = [CCMenu menuWithItems: cancel, nil];
        dialogMenu.position = ccp(winSize.width/2 - 5, winSize.height/2 - 55);
        [self addChild:dialogMenu];
        
        music = [CCMenuItemImage itemFromNormalImage:@"off_btn_state.png" selectedImage:@"on_btn_state.png" target:self selector:@selector(toggleAudio)];
        sfx = [CCMenuItemImage itemFromNormalImage:@"off_btn_state.png" selectedImage:@"on_btn_state.png" target:self selector:@selector(toggleSfx)];
        
        if([[[SettingsManager sharedSettingsManager] getString:@"sfx"] isEqualToString:@"on"]){
           [sfx selected];
        }else{
           [sfx unselected];
        }
        
        if([[[SettingsManager sharedSettingsManager] getString:@"audio"] isEqualToString:@"on"]){
            [music selected];
        }else{
            [music unselected];
        }
        
        CCMenu *menu = [CCMenu menuWithItems:music, sfx, nil];
        menu.position = ccp(winSize.width/2 + 60, winSize.height/2 + 10);
        [menu alignItemsVerticallyWithPadding:30];
        [self addChild:menu];
        
        CCLabelTTF *musicText = [CCLabelBMFont labelWithString:@"Audio" fntFile:@"uni_16_white_no_shadow.fnt"];
        musicText.anchorPoint = ccp(0.0f, 0.5f);
        musicText.position = ccp(winSize.width/2 - 100, winSize.height/2+27);
        [self addChild:musicText];
        
        CCLabelTTF *sfxText = [CCLabelBMFont labelWithString:@"Sound Fx" fntFile:@"uni_16_white_no_shadow.fnt"];
        sfxText.anchorPoint = ccp(0.0f, 0.5f);
        sfxText.position = ccp(winSize.width/2 - 100, winSize.height/2-7);
        [self addChild:sfxText];
        
        [self setOpacityBlank:0];
        [self setOpacity:255];
        
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
            [node runAction:[CCFadeTo actionWithDuration:.5 opacity:opacity]];
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

-(void)toggleAudio{
    if([[[SettingsManager sharedSettingsManager] getString:@"audio"] isEqualToString:@"on"]){
        [[SettingsManager sharedSettingsManager] setStringValue:@"off" name:@"audio"];
        [music unselected];
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    }else{
        [[SettingsManager sharedSettingsManager] setStringValue:@"on" name:@"audio"];
        [music selected];
        
        if([self.parent isKindOfClass:[MainMenuScene class]]){
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"main_screen_audio.mp3" loop:YES];
            [SimpleAudioEngine sharedEngine].backgroundMusicVolume = .7;
        }else if([self.parent isKindOfClass:[PauseLayer class]]){
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"gameplay_audio.mp3" loop:YES];
            [SimpleAudioEngine sharedEngine].backgroundMusicVolume = .7;
        }else if([self.parent isKindOfClass:[GameOverLayer class]]){
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"gameover.mp3" loop:YES];
            [SimpleAudioEngine sharedEngine].backgroundMusicVolume = .7;
        }
    }
}

-(void)toggleSfx{
    if([[[SettingsManager sharedSettingsManager] getString:@"sfx"] isEqualToString:@"on"]){
        [[SettingsManager sharedSettingsManager] setStringValue:@"off" name:@"sfx"];
        [sfx unselected];
        
    }else{
        [[SettingsManager sharedSettingsManager] setStringValue:@"on" name:@"sfx"];
        [sfx selected];
    }
}

-(void)close{
    [self setOpacity:0];
    id callback = [CCCallBlock actionWithBlock:^{
        [self.parent removeChild:self cleanup:YES];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSettings" object:nil];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.8], callback, nil]];
}

@end

