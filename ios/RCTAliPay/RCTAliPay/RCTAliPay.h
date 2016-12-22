

#import "RCTBridgeModule.h"

@interface RCTAliPay : NSObject <RCTBridgeModule>

- (void) processOrderWithPaymentResult:(NSDictionary *)resultDic;

@end

