//
//  MythicMtnIAPHelper.m
//  Snowboard
//
//  Created by Kyle Langille on 2013-01-18.
//
//

#import "MythicMtnIAPHelper.h"

@implementation MythicMtnIAPHelper

static MythicMtnIAPHelper * _sharedHelper;

+ (MythicMtnIAPHelper *) sharedHelper {
    
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[MythicMtnIAPHelper alloc] init];
    return _sharedHelper;
    
}

- (id)init {
    
    NSSet *productIdentifiers = [NSSet setWithObjects: @"coins1", nil];
    
    if ((self = [super initWithProductIdentifiers:productIdentifiers])) {                
        
    }
    return self;
    
}

@end
