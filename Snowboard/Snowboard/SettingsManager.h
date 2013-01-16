//
//  SettingsManager.h
//  Snowboard
//
//  Created by Kyle Langille on 2013-01-14.
//
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject {
	NSMutableDictionary* settings;
}

-(NSString *)getString:(NSString*)value;
-(int)getInt:(NSString*)value;
-(void)setStringValue:(NSString*)value name:(NSString *)key;
-(void)setIntValue:(int)value name:(NSString *)key;
-(void)save;
-(void)load;
-(void)logSettings;

+(SettingsManager*)sharedSettingsManager;
@end
