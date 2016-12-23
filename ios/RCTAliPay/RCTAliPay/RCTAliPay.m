
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

RCT_EXPORT_METHOD(payOrder:(NSDictionary *)params){
    
    NSString *orderText = [params objectForKey:@"orderText"];
    NSString *appScheme = [params objectForKey:@"appScheme"];   //应用注册scheme, 对应需要在Info.plist定义URL types
    
    // NOTE: 调用支付结果开始支付, 如没有安装支付宝app，则会走h5页面，支付回调触发这里的callback
    [[AlipaySDK defaultService] payOrder:orderText fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//        NSLog(@"payOrder reslut = %@",resultDic);
        [self.bridge.eventDispatcher sendAppEventWithName:@"alipay.mobile.securitypay.pay.onPaymentResult"
                                                     body:resultDic];
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
