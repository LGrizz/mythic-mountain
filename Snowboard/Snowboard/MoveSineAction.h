//
//  MoveSineAction.h
//  MooDefense
//
//  Created by Robert Blackwood on 3/5/10.
//  Copyright 2010 Mobile Bros. All rights reserved.
//

#import "cocos2d.h"


@interface MoveSineAction : CCActionInterval <NSCopying>
{
	float	_len;
	float	_amplitude;
	float	_frequency;
	CGPoint	_start;
}

+(id) actionWithDuration:(ccTime)t length:(float)len;
+(id) actionWithDuration:(ccTime)t length:(float)len amplitude:(float)a frequency:(float)f;
-(id) initWithDuration:(ccTime)t length:(float)len;
-(id) initWithDuration:(ccTime)t length:(float)len amplitude:(float)a frequency:(float)f;

@end
