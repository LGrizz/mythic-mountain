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
    CCLabelTTF *legendText;
    int page;
    CCSprite *storyImage1;
    CCSprite *storyImage2;
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
        
        CCMenuItemSprite *prev = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"prev_button.png"] selectedSprite:[CCSprite spriteWithFile:@"prev_button.png"] target:self selector:@selector(prev:)];
        
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
        
        
        
        legendText = [CCLabelBMFont labelWithString:@"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit." fntFile:@"uni_8_white_no_shadow.fnt" width:250 alignment:UITextAlignmentCenter];
        //legendText.anchorPoint = ccp(0.5, 1.0f);
        legendText.position = ccp(winSize.width/2, winSize.height - 360);
        [self addChild:legendText];
        
        CCMenu *controls = [CCMenu menuWithItems:prev,next, nil];
        controls.position = ccp(winSize.width/2 - 50, winSize.height - 433);
        [controls alignItemsHorizontallyWithPadding:12];
        [self addChild:controls z:998];
        
        CCMenu *skipper = [CCMenu menuWithItems:skip, nil];
        skipper.position = ccp(winSize.width/2 + 95, winSize.height - 433);
        [self addChild:skipper z:998];
        
        [self setOpacityBlank:0];
        [self setOpacity:255];
        
    }
    return self;
}

-(void)prev:(id)sender{
    if(page > 1){
        page--;
        switch (page) {
            case 1:
                [storyImage1 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide1.png"]]texture]];
                [storyImage2 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide2.png"]]texture]];
                [storyImage2 runAction:[CCFadeOut actionWithDuration:1]];
                [storyImage1 runAction:[CCFadeIn actionWithDuration:1]];
                break;
            case 2:
                [storyImage1 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide3.png"]]texture]];
                [storyImage2 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide2.png"]]texture]];
                [storyImage1 runAction:[CCFadeOut actionWithDuration:1]];
                [storyImage2 runAction:[CCFadeIn actionWithDuration:1]];
                break;
            case 3:
                [storyImage1 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide3.png"]]texture]];
                [storyImage2 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide4.png"]]texture]];
                [storyImage2 runAction:[CCFadeOut actionWithDuration:1]];
                [storyImage1 runAction:[CCFadeIn actionWithDuration:1]];
                break;
            case 4:
                [storyImage1 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide5.png"]]texture]];
                [storyImage2 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide4.png"]]texture]];
                [storyImage1 runAction:[CCFadeOut actionWithDuration:1]];
                [storyImage2 runAction:[CCFadeIn actionWithDuration:1]];
                break;
            case 5:
                break;
            default:
                break;
        }
        //[storyImage1 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide%d.png", page]]texture]];
    }
}

-(void)next:(id)sender{
    if(page < 5 ){
        page++;
        switch (page) {
            case 1:
                
                break;
            case 2:
                [storyImage1 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide1.png"]]texture]];
                [storyImage2 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide2.png"]]texture]];
                [storyImage1 runAction:[CCFadeOut actionWithDuration:1]];
                [storyImage2 runAction:[CCFadeIn actionWithDuration:1]];
                break;
            case 3:
                [storyImage1 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide3.png"]]texture]];
                [storyImage2 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide2.png"]]texture]];
                [storyImage2 runAction:[CCFadeOut actionWithDuration:1]];
                [storyImage1 runAction:[CCFadeIn actionWithDuration:1]];
                break;
            case 4:
                [storyImage1 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide3.png"]]texture]];
                [storyImage2 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide4.png"]]texture]];
                [storyImage1 runAction:[CCFadeOut actionWithDuration:1]];
                [storyImage2 runAction:[CCFadeIn actionWithDuration:1]];
                break;
            case 5:
                [storyImage1 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide5.png"]]texture]];
                [storyImage2 setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"slide4.png"]]texture]];
                [storyImage2 runAction:[CCFadeOut actionWithDuration:1]];
                [storyImage1 runAction:[CCFadeIn actionWithDuration:1]];
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
            if(node != storyImage2)
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
