//
//  DecoderAppEventTracking.m
//
// pushes sales event information to central webservice


#import "DecoderAppEventTracking.h"

@implementation DecoderAppEventTracking

+ (NSData *)encodeDictionary:(NSDictionary*)dictionary
{
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary)
    {
        NSString *encodedValue = @"";
        if ([[dictionary objectForKey:key] isKindOfClass:[NSNumber class]])
        {
            encodedValue = [[dictionary objectForKey:key] stringValue];
        }
        else
        {
            encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }

        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}


+ (void)trackEventWithDescription:(NSString *)eventDescription amount:(float)amount amountDescription:(NSString *)amountDescription sourceAppDescription:(NSString *)sourceAppDescription
{
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];  // becomes source app identifier
    NSURL *url = [NSURL URLWithString:@"http://appevents.decoderhq.com/trackevent"];

    if (!eventDescription)
    {
        eventDescription = @"";
    }
    if (!amountDescription)
    {
        amountDescription = @"";
    }
    if (!sourceAppDescription)
    {
        sourceAppDescription = @"";
    }

    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:bundleIdentifier, @"sourceApp",
                              sourceAppDescription, @"sourceAppDescription",
                              eventDescription, @"eventDescription",
                              [NSNumber numberWithFloat:amount], @"salesPrice",
                              amountDescription, @"salesPriceDescription", nil];
    NSData *postData = [self encodeDictionary:postDict];

    // Create the request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];

    dispatch_async(dispatch_get_main_queue(), ^{
        NSURLResponse *response;
        NSError *error = nil;
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (error) {
            // Deal with your error
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                NSLog(@"HTTP Error: %d %@", httpResponse.statusCode, error);
                return;
            }
            NSLog(@"Error %@", error);
            return;
        }

//        NSLog(@"DecoderAppEventTracking: Success!");
    });
}


@end
