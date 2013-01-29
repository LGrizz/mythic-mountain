//
//  SettingsManager.m
//  Snowboard
//
//  Created by Kyle Langille on 2013-01-14.
//
//

#import "SettingsManager.h"

@implementation SettingsManager

static SettingsManager* _sharedSettingsManager = nil;

-(NSMutableArray *)getArray:(NSString*)value
{
	return [settings objectForKey:value];
}

-(NSString *)getString:(NSString*)value
{
	return [settings objectForKey:value];
}

-(int)getInt:(NSString*)value {
	return [[settings objectForKey:value] intValue];
}

-(void)setStringValue:(NSString*)value name:(NSString *)key{
	[settings setObject:value forKey:key];
}

-(void)setIntValue:(int)value name:(NSString *)key{
	[settings setObject:[NSString stringWithFormat:@"%i",value] forKey:key];
}

-(void)setArrayValue:(NSMutableArray *)value name:(NSString *)key{
    [settings setObject:value forKey:key];
}

-(void)save
{
    // NOTE: You should be replace "MyAppName" with your own custom application string.
    //
	[[NSUserDefaults standardUserDefaults] setObject:settings forKey:@"MythicMountain"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)load
{
    // NOTE: You should be replace "MyAppName" with your own custom application string.
    //
	[settings addEntriesFromDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"MythicMountain"]];
}

// Logging function great for checkin out what keys/values you have at any given time
//
-(void)logSettings
{
	for(NSString* item in [settings allKeys])
	{
		NSLog(@"[SettingsManager KEY:%@ - VALUE:%@]", item, [settings valueForKey:item]);
	}
}

+(SettingsManager*)sharedSettingsManager
{
	@synchronized([SettingsManager class])
	{
		if (!_sharedSettingsManager)
			[[self alloc] init];
        
		return _sharedSettingsManager;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([SettingsManager class])
	{
		NSAssert(_sharedSettingsManager == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedSettingsManager = [[super alloc] init];
		return _sharedSettingsManager;
	}
    
	return nil;
}

-(id)autorelease {
    return self;
}

-(id)init {
	settings = [[NSMutableDictionary alloc] initWithCapacity:5];
	return [super init];
}

@end
