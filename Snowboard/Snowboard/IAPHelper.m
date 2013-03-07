//
//  IAPHelper.m
//  Snowboard
//
//  Created by Kyle Langille on 2013-01-18.
//
//

#import "IAPHelper.h"

@implementation IAPHelper

// Under @implementation
@synthesize productIdentifiers = _productIdentifiers;
@synthesize products = _products;
@synthesize purchasedProducts = _purchasedProducts;
@synthesize request = _request;

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";

// In dealloc
- (void)dealloc
{
    [_productIdentifiers release];
    _productIdentifiers = nil;
    [_products release];
    _products = nil;
    [_purchasedProducts release];
    _purchasedProducts = nil;
    [_request release];
    _request = nil;
    [super dealloc];
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    if ((self = [super init])) {
        
        // Store product identifiers
        _productIdentifiers = [productIdentifiers retain];
        
        // Check for previously purchased products
        NSMutableSet * purchasedProducts = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [purchasedProducts addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            }
            NSLog(@"Not purchased: %@", productIdentifier);
        }
        self.purchasedProducts = purchasedProducts;
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)requestProducts {
    
    self.request = [[[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers] autorelease];
    _request.delegate = self;
    [_request start];
    
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Received products results...");
    self.products = response.products;
    self.request = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedNotification object:_products];
}

- (void)recordTransaction:(SKPaymentTransaction *)transaction {
    // Optional: Record the transaction on the server side...
}

- (void)provideContent:(NSString *)productIdentifier {
    
    NSLog(@"Toggling flag for: %@", productIdentifier);
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_purchasedProducts addObject:productIdentifier];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedNotification object:productIdentifier];
    
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"completeTransaction...");
    
    [self recordTransaction: transaction];
    [self provideContent: transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"restoreTransaction...");
    
    [self recordTransaction: transaction];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:transaction];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    NSString *eventName = @"purchase";
    
    for (SKPaymentTransaction * transaction in transactions) {
        
        SKProduct *product;
        if([transaction.payment.productIdentifier isEqualToString:@"coins1"]){
            product = (SKProduct *)([_products objectAtIndex:0]);
        }else if([transaction.payment.productIdentifier isEqualToString:@"coins2"]){
            product = (SKProduct *)([_products objectAtIndex:1]);
        }else if([transaction.payment.productIdentifier isEqualToString:@"coins4"]){
            product = (SKProduct *)([_products objectAtIndex:2]);
        }
        
        NSString *currencyCode = [product.priceLocale objectForKey:NSLocaleCurrencyCode];
        if(nil != product)
        {
            // extract transaction product quantity
            int quantity = transaction.payment.quantity;
            // extract unit price of the product
            float unitPrice = [product.price floatValue];
            // assign revenue generated from the current product
            float revenue = unitPrice * quantity;
            // create MAT tracking event item
            NSDictionary *dictItem = @{ @"item" : product.localizedTitle,
                                        @"unit_price" : [NSString stringWithFormat:@"%f", unitPrice],
                                        @"quantity" : [NSString stringWithFormat:@"%d", quantity],
                                        @"revenue" : [NSString stringWithFormat:@"%f", revenue]
                                        };
            NSArray *arrEventItems = @[ dictItem ];
            BOOL shouldTrackEvent = FALSE;
        
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                shouldTrackEvent = true;
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
        }
    };
}

- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [self.purchasedProducts containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product {
    
    NSLog(@"Buying %@...", product.productIdentifier);
    
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    
    [self.purchasedProducts addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
    
}




@end
