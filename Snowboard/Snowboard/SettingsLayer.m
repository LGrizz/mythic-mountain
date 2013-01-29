//
//  SettingsLayer.m
//  Snowboard
//
//  Created by Kyle Langille on 2013-01-28.
//
//

#import "SettingsLayer.h"

@implementation SettingsLayer

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
        
        
        
        CCMenuItemImage *sfx = [CCMenuItemImage itemFromNormalImage:@"off_btn_state.png" selectedImage:@"on_btn_state.png" target:self selector:@selector(close)];
        CCMenuItemImage *music = [CCMenuItemImage itemFromNormalImage:@"off_btn_state.png" selectedImage:@"on_btn_state.png" target:self selector:@selector(close)];
        
        CCMenu *menu = [CCMenu menuWithItems:sfx, music, nil];
        menu.position = ccp(winSize.width/2 + 60, winSize.height/2 + 10);
        [menu alignItemsVerticallyWithPadding:25];
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

-(void)close{
    [self setOpacity:0];
    id callback = [CCCallBlock actionWithBlock:^{
        [self.parent removeChild:self cleanup:YES];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSettings" object:nil];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.8], callback, nil]];
}

@end

