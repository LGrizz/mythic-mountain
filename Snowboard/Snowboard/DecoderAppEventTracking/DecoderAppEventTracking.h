//
//  DecoderAppEventTracking.h
//
// pushes sales event information to central webservice
//

#import <Foundation/Foundation.h>

@interface DecoderAppEventTracking : NSObject

// submit information to webservice (fire and forget!)
// Example:
//  [DecoderAppEventTracking trackEventWithDescription:@"Purchased Product 123" amount:1.99 amountDescription:@"$1.99" sourceAppDescription:@"PopQuizShow"];

+ (void)trackEventWithDescription:(NSString *)eventDescription amount:(float)amount amountDescription:(NSString *)amountDescription sourceAppDescription:(NSString *)sourceAppDescription;

@end
