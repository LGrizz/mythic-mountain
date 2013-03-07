//
//  AboutLayer.m
//  Snowboard
//
//  Created by Kyle Langille on 2013-01-28.
//
//

#import "AboutLayer.h"

@implementation AboutLayer{
    CCSprite *legendText;
    CCLayer *creditsLayer;
}

-(id)init{
    if ((self = [super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *bg = [CCSprite spriteWithFile:@"about_controls_bg.png"];
        bg.anchorPoint = ccp(0.5f, 1.0f);
        bg.position = ccp(winSize.width/2, winSize.height + 15);
        [self addChild:bg];
        
        CCMenuItemImage *legend = [CCMenuItemImage itemFromNormalImage:@"legend_btn.png" selectedImage:@"legend_btn.png" target:self selector:@selector(legend)];
        CCMenuItemImage *credits = [CCMenuItemImage itemFromNormalImage:@"credits_btn.png" selectedImage:@"credits_btn.png" target:self selector:@selector(credits)];
        
        CCMenu *topMenu = [CCMenu menuWithItems:legend, credits, nil];
        [topMenu alignItemsHorizontallyWithPadding:15];
        topMenu.position = ccp(winSize.width/2, winSize.height - 70);
        [self addChild:topMenu];
        
        CCMenuItemImage *close = [CCMenuItemImage itemFromNormalImage:@"about_controls_close_btn.png" selectedImage:@"about_controls_close_btn.png" target:self selector:@selector(close)];
        
        CCMenu *bottomMenu = [CCMenu menuWithItems:close, nil];
        bottomMenu.position = ccp(winSize.width/2, winSize.height - 430);
        [self addChild:bottomMenu];
        
        legendText = [CCSprite spriteWithFile:@"about_legend_txt.png"];
        //legendText.anchorPoint = ccp(0.5, 1.0f);
        legendText.position = ccp(winSize.width/2 + 5, winSize.height - 245);
        [self addChild:legendText];
        
        creditsLayer = [[CCLayer alloc] init];
        
        CCSprite *decoderLogo = [CCSprite spriteWithFile:@"decoder_logo.png"];
        decoderLogo.position = ccp(85, winSize.height - 110);
        [creditsLayer addChild:decoderLogo];
        CCLabelTTF *decoderName = [CCLabelBMFont labelWithString:@"DECODER" fntFile:@"uni_8_white_no_shadow.fnt" width:100 alignment:UITextAlignmentCenter];
        //legendText.anchorPoint = ccp(0.5, 1.0f);
        decoderName.position = ccp(155, winSize.height - 105);
        [creditsLayer addChild:decoderName];
        CCLabelTTF *decoderText = [CCLabelBMFont labelWithString:@"www.decoderhq.com\n\nDecoder is a startup that builds killer apps for mobile devices and tablets. We build our own products and we're interested in working with you." fntFile:@"cc_13pt_white.fnt" width:120 alignment:UITextAlignmentCenter];
        decoderText.anchorPoint = ccp(0.0, 1.0f);
        decoderText.position = ccp(128, winSize.height - 108);
        [creditsLayer addChild:decoderText];
        
        CCLabelTTF *devText = [CCLabelBMFont labelWithString:@"Development: Kyle Langille" fntFile:@"cc_13pt_white.fnt" width:150 alignment:UITextAlignmentCenter];
        devText.anchorPoint = ccp(0.0, 1.0f);
        devText.position = ccp(128, winSize.height - 227);
        [creditsLayer addChild:devText];

        
        CCSprite *upLogo = [CCSprite spriteWithFile:@"uppercut_logo.png"];
        upLogo.position = ccp(85, winSize.height - 280);
        [creditsLayer addChild:upLogo];
        CCLabelTTF *upName = [CCLabelBMFont labelWithString:@"UPPERCUT" fntFile:@"uni_8_white_no_shadow.fnt" width:100 alignment:UITextAlignmentCenter];
        //legendText.anchorPoint = ccp(0.5, 1.0f);
        upName.position = ccp(160, winSize.height - 260);
        [creditsLayer addChild:upName];
        CCLabelTTF *upText = [CCLabelBMFont labelWithString:@"www.madebyuppercut.com\n\nUppercut is a creative agency that produces award-winning marketing campaigns, highly acclaimed brands, and successful e-commerce websites." fntFile:@"cc_13pt_white.fnt" width:120 alignment:UITextAlignmentCenter];
        upText.anchorPoint = ccp(0.0, 1.0f);
        upText.position = ccp(128, winSize.height - 225);
        [creditsLayer addChild:upText];
        
        CCLabelTTF *artText = [CCLabelBMFont labelWithString:@"Design: Daniel Parry" fntFile:@"cc_13pt_white.fnt" width:150 alignment:UITextAlignmentCenter];
        artText.anchorPoint = ccp(0.0, 1.0f);
        artText.position = ccp(128, winSize.height - 382);
        [creditsLayer addChild:artText];
        
        [self addChild:creditsLayer];
        
        for( CCNode *node in [creditsLayer children] )
        {
            if( [node conformsToProtocol:@protocol( CCRGBAProtocol)] )
            {
                [(id<CCRGBAProtocol>) node setOpacity: 0];
            }
        }
        
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

-(void)credits{
    [legendText runAction:[CCFadeOut actionWithDuration:.5]];
    for( CCNode *node in [creditsLayer children] )
    {
        if( [node conformsToProtocol:@protocol( CCRGBAProtocol)] )
        {
            [node runAction:[CCFadeTo actionWithDuration:.5 opacity: 255]];
        }
    }
}

-(void)legend{
    [legendText runAction:[CCFadeIn actionWithDuration:.5]];
    for( CCNode *node in [creditsLayer children] )
    {
        if( [node conformsToProtocol:@protocol( CCRGBAProtocol)] )
        {
           [node runAction:[CCFadeTo actionWithDuration:.5 opacity: 0]];
        }
    }
}

-(void)close{
    for( CCNode *node in [creditsLayer children] )
    {
        if( [node conformsToProtocol:@protocol( CCRGBAProtocol)] )
        {
            [(id<CCRGBAProtocol>) node setOpacity: 0];
        }
    } 
    [self setOpacity:0];
    id callback = [CCCallBlock actionWithBlock:^{
        [self.parent removeChild:self cleanup:YES];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideAbout" object:nil];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.8], callback, nil]];
}

- (void)mainmenuTapped:(id)sender {
    if([[CCDirector sharedDirector] isPaused]){
        [[CCDirector sharedDirector] resume];
    }
    //[[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[MainMenuScene scene]]];
}

@end
