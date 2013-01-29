#import "OpaqueLayer.h"


@implementation OpaqueLayer


- (id) initWithColor:(ccColor4B)color width:(GLfloat)w  height:(GLfloat) h
{
    if( (self=[super initWithColor:color width:w height:h]) ) {
        self.isTouchEnabled = YES;
    }
    return self;
}

-(void) registerWithTouchDispatcher
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

// just swallow any touches meant for us
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint point = [self convertTouchToNodeSpace:touch];
    CGRect rect = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    
    return CGRectContainsPoint(rect, point);
}


@end