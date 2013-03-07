//
//  StoryLayer.m
//  Snowboard
//
//  Created by Kyle Langille on 2013-01-28.
//
//

#import "StoryLayer.h"
#import "HelloWorldLayer.h"

@implementation StoryLayer{
    //CCLabelTTF *legendText;
    int page;
    CCSprite *storyImage1;
    CCSprite *storyImage2;
    
    CCLabelTTF *storyText1;
    CCLabelTTF *storyText2;
    NSArray *text;
    
    CCMenuItemSprite *prev;
    
    CCLayer *controller;
}

-(id)init{
    if ((self = [super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        //pauseLayer = [CCLayer node];
        
        page = 1;
        
        CCSprite *bg = [CCSprite spriteWithFile:@"about_controls_bg.png"];
        bg.anchorPoint = ccp(0.5f, 1.0f);
        bg.position = ccp(winSize.width/2, winSize.height + 15);
        [self addChild:bg];
        
        prev = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"prev_button.png"] selectedSprite:[CCSprite spriteWithFile:@"prev_button.png"] target:self selector:@selector(prev:)];
        
        CCMenuItemSprite *next = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"next_button.png"] selectedSprite:[CCSprite spriteWithFile:@"next_button.png"] target:self selector:@selector(next:)];
        
        CCMenuItemSprite *skip = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"skip_button.png"] selectedSprite:[CCSprite spriteWithFile:@"skip_button.png"] target:self selector:@selector(skip:)];
        
        storyImage1 = [CCSprite spriteWithFile:@"slide1.png"];
        storyImage1.anchorPoint = ccp(0.5f, 1.0f);
        storyImage1.position = ccp(winSize.width/2 + 1, winSize.height - 50);
        [self addChild:storyImage1];
        
        storyImage2 = [CCSprite spriteWithFile:@"slide2.png"];
        storyImage2.anchorPoint = ccp(0.5f, 1.0f);
        storyImage2.position = ccp(winSize.width/2 + 1, winSize.height - 50);
        [storyImage2 setOpacity:0];
        [self addChild:storyImage2];
        
        text = [[NSArray alloc] initWithObjects:@"Mythic Mountain is the perfect place for a little getaway with friends.", @"Especially if your friends are the sort who tend to avoid crowds. ", @"But not everyone who comes here has the best intentions.", @"For some, the lure of wealth and fame can inspire a terrible greed.", @"And that's when 'getaway' takes on an entirely different meaning.", nil];
        
        
        
        storyText1 = [CCLabelBMFont labelWithString:[text objectAtIndex:0] fntFile:@"uni_16_thin_white.fnt" width:250 alignment:UITextAlignmentCenter];
        //legendText.anchorPoint = ccp(0.5, 1.0f);
        storyText1.position = ccp(winSize.width/2, winSize.height - 360);
        [self addChild:storyText1];
        
        storyText2 = [CCLabelBMFont labelWithString:[text objectAtIndex:1] fntFile:@"uni_16_thin_white.fnt" width:250 alignment:UITextAlignmentCenter];
        //legendText.anchorPoint = ccp(0.5, 1.0f);
        storyText2.position = ccp(winSize.width/2, winSize.height - 360);
        [self addChild:storyText2];
        [storyText2 setOpacity:0];
        
        CCMenu *controls = [CCMenu menuWithItems:prev,next, nil];
        controls.position = ccp(winSize.width/2 - 50, winSize.height - 433);
        [controls alignItemsHorizontallyWithPadding:12];
        [self addChild:controls z:998];
        
        controller = [[CCLayer alloc] init];
        
        CCLabelTTF *header = [CCLabelBMFont labelWithString:@"Controls" fntFile:@"uni_16_white_no_shadow.fnt" width:120 alignment:UITextAlignmentCenter];
        header.position = ccp(winSize.width/2, winSize.height - 80);
        [controller addChild:header];
        
        CCSprite *tiltIcon = [CCSprite spriteWithFile:@"titl_icon.png"];
        tiltIcon.position = ccp(winSize.width - 60, winSize.height - 150);
        [controller addChild:tiltIcon];
        
        CCLabelTTF *tiltText = [CCLabelBMFont labelWithString:@"Tilt to steer." fntFile:@"uni_16_thin_white.fnt"];
        tiltText.anchorPoint = ccp(0.0f, 0.5f);
        tiltText.position = ccp(40, winSize.height - 150);
        [controller addChild:tiltText];
        
        CCSprite *slideIcon = [CCSprite spriteWithFile:@"slide_icon.png"];
        slideIcon.position = ccp(winSize.width - 60, winSize.height - 230);
        [controller addChild:slideIcon];
        
        CCLabelTTF *swipeText = [CCLabelBMFont labelWithString:@"Swipe up to jump." fntFile:@"uni_16_thin_white.fnt"];
        swipeText.anchorPoint = ccp(0.0f, 0.5f);
        swipeText.position = ccp(40, winSize.height - 230);
        [controller addChild:swipeText];
        
        CCSprite *tapIcon = [CCSprite spriteWithFile:@"tilt_icon.png"];
        tapIcon.position = ccp(winSize.width - 60, winSize.height - 310);
        [controller addChild:tapIcon];
        
        CCLabelTTF *tapText = [CCLabelBMFont labelWithString:@"Tap to use equipment." fntFile:@"uni_16_thin_white.fnt"];
        tapText.anchorPoint = ccp(0.0f, 0.5f);
        tapText.position = ccp(40, winSize.height - 310);
        [controller addChild:tapText];
        
        for( CCNode *node in [controller children] )
        {
            if( [node conformsToProtocol:@protocol( CCRGBAProtocol)] )
            {
                    [(id<CCRGBAProtocol>) node setOpacity: 0];
            }
        }
        [self addChild:controller];

        
        CCMenu *skipper = [CCMenu menuWithItems:skip, nil];
        skipper.position = ccp(winSize.width/2 + 95, winSize.height - 433);
        [self addChild:skipper z:998];
        
        [self setOpacityBlank:0];
        [self setOpacity:255];
        
        [prev setOpacity:0];
        
    }
    return self;
}

-(void)prev:(id)sender{
    if(page > 1){
        page--;
        switch (page) {
            case 1:
                //[prev runAction:[CCFadeOut actionWithDuration:1]];
                [storyImage1 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide1.png"]]texture]];
                [storyImage2 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide2.png"]]texture]];
                [storyImage2 runAction:[CCFadeOut actionWithDuration:1]];
                [storyImage1 runAction:[CCFadeIn actionWithDuration:1]];
                
                [storyText1 setString:[text objectAtIndex:0]];
                [storyText2 setString:[text objectAtIndex:1]];
                [storyText2 runAction:[CCFadeOut actionWithDuration:1]];
                [storyText1 runAction:[CCFadeIn actionWithDuration:1]];
                
                break;
            case 2:
                [storyImage1 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide3.png"]]texture]];
                [storyImage2 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide2.png"]]texture]];
                [storyImage1 runAction:[CCFadeOut actionWithDuration:1]];
                [storyImage2 runAction:[CCFadeIn actionWithDuration:1]];
                
                [storyText1 setString:[text objectAtIndex:2]];
                [storyText2 setString:[text objectAtIndex:1]];
                [storyText1 runAction:[CCFadeOut actionWithDuration:1]];
                [storyText2 runAction:[CCFadeIn actionWithDuration:1]];
                break;
            case 3:
                [storyImage1 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide3.png"]]texture]];
                [storyImage2 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide4.png"]]texture]];
                [storyImage2 runAction:[CCFadeOut actionWithDuration:1]];
                [storyImage1 runAction:[CCFadeIn actionWithDuration:1]];
                
                [storyText1 setString:[text objectAtIndex:2]];
                [storyText2 setString:[text objectAtIndex:3]];
                [storyText2 runAction:[CCFadeOut actionWithDuration:1]];
                [storyText1 runAction:[CCFadeIn actionWithDuration:1]];
                break;
            case 4:
                [storyImage1 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide5.png"]]texture]];
                [storyImage2 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide4.png"]]texture]];
                [storyImage1 runAction:[CCFadeOut actionWithDuration:1]];
                [storyImage2 runAction:[CCFadeIn actionWithDuration:1]];
                
                [storyText1 setString:[text objectAtIndex:4]];
                [storyText2 setString:[text objectAtIndex:3]];
                [storyText1 runAction:[CCFadeOut actionWithDuration:1]];
                [storyText2 runAction:[CCFadeIn actionWithDuration:1]];
                break;
            case 5:
                //[storyImage1 runAction:[CCFadeOut actionWithDuration:1]];
                [storyImage1 runAction:[CCFadeIn actionWithDuration:1]];
                [storyText1 runAction:[CCFadeIn actionWithDuration:1]];
                //[storyText1 runAction:[CCFadeOut actionWithDuration:1]];
                
                for( CCNode *node in [controller children] )
                {
                    if( [node conformsToProtocol:@protocol( CCRGBAProtocol)] )
                    {
                        [node runAction:[CCFadeTo actionWithDuration:.5 opacity:0]];
                    }
                }
                break;
                break;
            default:
                break;
        }
        //[storyImage1 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide%d.png", page]]texture]];
    }else{
        [self close];
    }
}

-(void)next:(id)sender{
    if(page < 6 ){
        page++;
        switch (page) {
            case 1:
                
                break;
            case 2:
                //[prev runAction:[CCFadeIn actionWithDuration:1]];
                
                [storyImage1 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide1.png"]]texture]];
                [storyImage2 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide2.png"]]texture]];
                [storyImage1 runAction:[CCFadeOut actionWithDuration:1]];
                [storyImage2 runAction:[CCFadeIn actionWithDuration:1]];
                
                [storyText1 setString:[text objectAtIndex:0]];
                [storyText2 setString:[text objectAtIndex:1]];
                [storyText1 runAction:[CCFadeOut actionWithDuration:1]];
                [storyText2 runAction:[CCFadeIn actionWithDuration:1]];
                break;
            case 3:
                [storyImage1 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide3.png"]]texture]];
                [storyImage2 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide2.png"]]texture]];
                [storyImage2 runAction:[CCFadeOut actionWithDuration:1]];
                [storyImage1 runAction:[CCFadeIn actionWithDuration:1]];
                
                [storyText1 setString:[text objectAtIndex:2]];
                [storyText2 setString:[text objectAtIndex:1]];
                [storyText2 runAction:[CCFadeOut actionWithDuration:1]];
                [storyText1 runAction:[CCFadeIn actionWithDuration:1]];
                break;
            case 4:
                [storyImage1 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide3.png"]]texture]];
                [storyImage2 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide4.png"]]texture]];
                [storyImage1 runAction:[CCFadeOut actionWithDuration:1]];
                [storyImage2 runAction:[CCFadeIn actionWithDuration:1]];
                
                [storyText1 setString:[text objectAtIndex:2]];
                [storyText2 setString:[text objectAtIndex:3]];
                [storyText1 runAction:[CCFadeOut actionWithDuration:1]];
                [storyText2 runAction:[CCFadeIn actionWithDuration:1]];
                break;
            case 5:
                [storyImage1 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide5.png"]]texture]];
                [storyImage2 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide4.png"]]texture]];
                [storyImage2 runAction:[CCFadeOut actionWithDuration:1]];
                [storyImage1 runAction:[CCFadeIn actionWithDuration:1]];
                
                [storyText1 setString:[text objectAtIndex:4]];
                [storyText2 setString:[text objectAtIndex:3]];
                [storyText2 runAction:[CCFadeOut actionWithDuration:1]];
                [storyText1 runAction:[CCFadeIn actionWithDuration:1]];
                break;
            case 6:
                //[storyImage2 runAction:[CCFadeOut actionWithDuration:1]];
                [storyImage1 runAction:[CCFadeOut actionWithDuration:1]];
                //[storyText2 runAction:[CCFadeOut actionWithDuration:1]];
                [storyText1 runAction:[CCFadeOut actionWithDuration:1]];
                
                for( CCNode *node in [controller children] )
                {
                    if( [node conformsToProtocol:@protocol( CCRGBAProtocol)] )
                    {
                        [node runAction:[CCFadeTo actionWithDuration:.5 opacity:255]];
                    }
                }
                break;
            default:
                break;
        }
    }else{
        [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];
    }
}

-(void)skip:(id)sender{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];
}

// Set the opacity of all of our children that support it
-(void) setOpacity: (GLubyte) opacity
{
    for( CCNode *node in [self children] )
    {
        if( [node conformsToProtocol:@protocol( CCRGBAProtocol)] )
        {
            if(node != storyImage2 && node != storyText2 && node != prev)
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideStory" object:nil];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.8], callback, nil]];
}

@end
