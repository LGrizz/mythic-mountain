//
//  StoreScene.h
//  Snowboard
//
//  Created by Kyle Langille on 2013-01-15.
//
//

#import "cocos2d.h"
#import "CCScrollLayer.h"
#import "OpaqueLayer.h"

@interface StoreScene : CCLayer <CCTargetedTouchDelegate>
{
    CCLabelTTF *coinScoreLabel;
    
    CCLayer *homeLayer;
    
    CCScrollLayer *characterScrollLayer;
    CCScrollLayer *equipmentScrollLayer;
    CCScrollLayer *powerupScrollerLayer;
    CCScrollLayer *coinScrollLayer;
    
    CCLayer *unicornLayer;
    CCLayer *yetiLayer;
    CCLayer *mermaidLayer;
    CCSprite *uniplat;
    
    CCLayer *excaliburLayer;
    CCLayer *mjolnirLayer;
    CCLayer *midasLayer;
    CCLayer *icarusLayer;
    
    CCLayer *phoenixLayer;
    CCLayer *griffinLayer;
    
    CCLayer *coins1;
    CCLayer *coins2;
    CCLayer *coins3;
    
    CCSprite *labelBG;
    CCLabelTTF *labelHeader;
    
    NSString *selected;
    CCMenuItemImage *equipmentItem;
    CCMenuItemImage *characterItem;
    CCMenuItemImage *powerupItem;
    
    CCMenu *menu4;
    CCMenu *menu3;
    CCMenu *menu2;
    
    CCLayer *dialogLayer;
    
    NSString *purchaseString;
    int purchaseAmount;
    CCLayer *purchaseLayer;
    
    BOOL dialogUP;
}

//+(id) scene;

@end
