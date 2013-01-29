//
//  ControlsLayer.m
//  Snowboard
//
//  Created by Kyle Langille on 2013-01-28.
//
//

#import "ControlsLayer.h"

@implementation ControlsLayer

-(id)init{
    if ((self = [super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *bg = [CCSprite spriteWithFile:@"about_controls_bg.png"];
        bg.anchorPoint = ccp(0.5f, 1.0f);
        bg.position = ccp(winSize.width/2, winSize.height + 15);
        [self addChild:bg];
        
        CCMenuItemImage *close = [CCMenuItemImage itemFromNormalImage:@"about_controls_close_btn.png" selectedImage:@"about_controls_close_btn.png" target:self selector:@selector(close)];
        
        CCMenu *bottomMenu = [CCMenu menuWithItems:close, nil];
        bottomMenu.position = ccp(winSize.width/2, winSize.height - 420);
        [self addChild:bottomMenu];
        
        CCLabelTTF *header = [CCLabelBMFont labelWithString:@"Controls" fntFile:@"uni_16_white_no_shadow.fnt" width:120 alignment:UITextAlignmentCenter];
        header.position = ccp(winSize.width/2, winSize.height - 80);
        [self addChild:header];
        
        CCSprite *tiltIcon = [CCSprite spriteWithFile:@"titl_icon.png"];
        tiltIcon.position = ccp(winSize.width - 80, winSize.height - 150);
        [self addChild:tiltIcon];
        
        CCLabelTTF *tiltText = [CCLabelBMFont labelWithString:@"Tilt to steer." fntFile:@"uni_8_white_no_shadow.fnt"];
        tiltText.anchorPoint = ccp(0.0f, 0.5f);
        tiltText.position = ccp(60, winSize.height - 150);
        [self addChild:tiltText];
        
        CCSprite *slideIcon = [CCSprite spriteWithFile:@"slide_icon.png"];
        slideIcon.position = ccp(winSize.width - 80, winSize.height - 230);
        [self addChild:slideIcon];
        
        CCLabelTTF *swipeText = [CCLabelBMFont labelWithString:@"Swipe up to jump." fntFile:@"uni_8_white_no_shadow.fnt"];
        swipeText.anchorPoint = ccp(0.0f, 0.5f);
        swipeText.position = ccp(60, winSize.height - 230);
        [self addChild:swipeText];
        
        CCSprite *tapIcon = [CCSprite spriteWithFile:@"tilt_icon.png"];
        tapIcon.position = ccp(winSize.width - 80, winSize.height - 310);
        [self addChild:tapIcon];
        
        CCLabelTTF *tapText = [CCLabelBMFont labelWithString:@"Tap to use equipment." fntFile:@"uni_8_white_no_shadow.fnt"];
        tapText.anchorPoint = ccp(0.0f, 0.5f);
        tapText.position = ccp(60, winSize.height - 310);
        [self addChild:tapText];
        
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideControls" object:nil];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.8], callback, nil]];
}

@end
