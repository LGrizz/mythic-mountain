//
//  MoveSineAction.m
//  MooDefense
//
//  Created by Robert Blackwood on 3/5/10.
//  Copyright 2010 Mobile Bros. All rights reserved.
//

#import "MoveSineAction.h"


@implementation MoveSineAction

+(id) actionWithDuration:(ccTime)t  length:(float)len //also amp, freq, etc
{
	return [[[self alloc] initWithDuration:t length:len] autorelease];
}


+(id) actionWithDuration:(ccTime)t length:(float)len amplitude:(float)a frequency:(float)f
{
	return [[[self alloc] initWithDuration:t length:len amplitude:a frequency:f] autorelease];
}

-(id) initWithDuration:(ccTime)t length:(float)len //also amp, freq, etc
{
    [super initWithDuration: t];
    _len = len;
	_amplitude = 30.0f;
	_frequency = 0.15f;
	
    return self;
}

-(id) initWithDuration:(ccTime)t length:(float)len amplitude:(float)a frequency:(float)f
{
	[super initWithDuration: t];
    _len = len;
	_amplitude = a;
	_frequency = f;	
	
    return self;
}

-(void) startWithTarget:(id)aTarget
{	
    [super startWithTarget:aTarget];
	
	_start = [target_ position];
}

-(id) copyWithZone: (NSZone*) zone
{
	CCAction *copy = [[[self class] allocWithZone: zone] initWithDuration:[self duration] length:_len];
	return copy;
}

-(void) update: (ccTime) t
{
	float x, y;
	
	y = _start.y - (_len * t);
    x = _start.x + (_amplitude * sin(_frequency * y));
	
    [target_ setPosition:ccp(x,y)];
}

@end