
#import <AlipaySDK/AlipaySDK.h>
#import "RCTAliPay.h"
#import "RCTUtils.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"

@implementation RCTAliPay

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE(AliPay);

- (id)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processOrderWithPaymentResult:) name:@"RCTAliPay_Notification_processOrderWithPaymentResult" object:nil];
    }
    return self;
    
}

RCT_EXPORT_METHOD(payOrder:(NSDictionary *)params
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
    
    NSString *orderText = [params objectForKey:@"orderText"];
    NSString *appScheme = [params objectForKey:@"appScheme"];
    
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderText fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//        NSLog(@"payOrder reslut = %@",resultDic);
//        if(error) {
//            callback(@[RCTMakeError([NSString stringWithFormat:@"%d", error.code], nil, nil)]);
//        }
//        else {
//            callback(@[[NSNull null]]);
//        }
        resolve(resultDic);
        //reject(...)
    }];
}

- (void)processOrderWithPaymentResult:(NSNotification *)notification {
    NSDictionary *resultDic = notification.userInfo;
//    NSLog(@"RCTAliPay -> processOrderWithPaymentResult resultDic = %@", resultDic);
    [self.bridge.eventDispatcher sendAppEventWithName:@"alipay.mobile.securitypay.pay.onPaymentResult"
                                                 body:resultDic];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
