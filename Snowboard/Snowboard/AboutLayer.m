//
//  AboutLayer.m
//  Snowboard
//
//  Created by Kyle Langille on 2013-01-28.
//
//

#import "AboutLayer.h"

@implementation AboutLayer{
    CCLabelTTF *legendText;
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
        bottomMenu.position = ccp(winSize.width/2, winSize.height - 420);
        [self addChild:bottomMenu];
        
        legendText = [CCLabelBMFont labelWithString:@"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.\n\nNeque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur?\n\nQuis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?" fntFile:@"uni_8_white_no_shadow.fnt" width:250 alignment:UITextAlignmentCenter];
        //legendText.anchorPoint = ccp(0.5, 1.0f);
        legendText.position = ccp(winSize.width/2, winSize.height - 220);
        [self addChild:legendText];
        
        creditsLayer = [[CCLayer alloc] init];
        
        CCSprite *decoderLogo = [CCSprite spriteWithFile:@"decoder_logo.png"];
        decoderLogo.position = ccp(100, winSize.height - 150);
        [creditsLayer addChild:decoderLogo];
        CCLabelTTF *decoderName = [CCLabelBMFont labelWithString:@"DECODER" fntFile:@"uni_8_white_no_shadow.fnt" width:100 alignment:UITextAlignmentCenter];
        //legendText.anchorPoint = ccp(0.5, 1.0f);
        decoderName.position = ccp(170, winSize.height - 145);
        [creditsLayer addChild:decoderName];
        CCLabelTTF *decoderText = [CCLabelBMFont labelWithString:@"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque." fntFile:@"uni_8_white_no_shadow.fnt" width:120 alignment:UITextAlignmentCenter];
        decoderText.anchorPoint = ccp(0.0, 1.0f);
        decoderText.position = ccp(145, winSize.height - 154);
        [creditsLayer addChild:decoderText];
        
        CCSprite *upLogo = [CCSprite spriteWithFile:@"uppercut_logo.png"];
        upLogo.position = ccp(100, winSize.height - 280);
        [creditsLayer addChild:upLogo];
        CCLabelTTF *upName = [CCLabelBMFont labelWithString:@"UPPERCUT" fntFile:@"uni_8_white_no_shadow.fnt" width:100 alignment:UITextAlignmentCenter];
        //legendText.anchorPoint = ccp(0.5, 1.0f);
        upName.position = ccp(175, winSize.height - 265);
        [creditsLayer addChild:upName];
        CCLabelTTF *upText = [CCLabelBMFont labelWithString:@"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque." fntFile:@"uni_8_white_no_shadow.fnt" width:120 alignment:UITextAlignmentCenter];
        upText.anchorPoint = ccp(0.0, 1.0f);
        upText.position = ccp(145, winSize.height - 274);
        [creditsLayer addChild:upText];
        
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
