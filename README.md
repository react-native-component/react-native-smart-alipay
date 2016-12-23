# react-native-smart-alipay

[![npm](https://img.shields.io/npm/v/react-native-smart-alipay.svg)](https://www.npmjs.com/package/react-native-smart-alipay)
[![npm](https://img.shields.io/npm/dm/react-native-smart-alipay.svg)](https://www.npmjs.com/package/react-native-smart-alipay)
[![npm](https://img.shields.io/npm/dt/react-native-smart-alipay.svg)](https://www.npmjs.com/package/react-native-smart-alipay)
[![npm](https://img.shields.io/npm/l/react-native-smart-alipay.svg)](https://github.com/react-native-component/react-native-smart-alipay/blob/master/LICENSE)


react-native 支付宝SDK 插件, 支持ios与android,
关于使用支付宝SDK, 申请支付宝帐号等详细信息请点击[这里][1]

## 预览

![react-native-smart-alipay-preview-ios][2]

## 安装

```
npm install react-native-smart-alipay --save
```

## 安装 (iOS)

* 将RCTAliPay.xcodeproj作为Library拖进你的Xcode里的project中.

* 将RCTAliPay目录里Frameworks, AliPayResouces目录拖进主project目录下, 选择copy items if needed, create groups, 另外add to target不要忘记选择主project.

* 点击你的主project, 选择Build Phases -> Link Binary With Libraries, 将RCTAliPay.xcodeproj里Product目录下的libRCTAliPay.a拖进去.

* 同上位置, 选择Add items, 将系统库libc++.tbd加入.

* 同上位置, 选择Add items, 将系统库libz.tbd加入.

* 同上位置, 选择Add items, 将系统库SystemConfiguration.framework加入.

* 同上位置, 选择Add items, 将系统库CoreTelephony.framework加入.

* 同上位置, 选择Add items, 将系统库QuartzCore.framework加入.

* 同上位置, 选择Add items, 将系统库CoreText.framework加入.

* 同上位置, 选择Add items, 将系统库CoreGraphics.framework加入.

* 同上位置, 选择Add items, 将系统库UIKit.framework加入.

* 同上位置, 选择Add items, 将系统库Foundation.framework加入.

* 同上位置, 选择Add items, 将系统库CFNetwork.framework加入.

* 同上位置, 选择Add items, 将系统库CoreMotion.framework加入.

* 同上位置, 选择Add items, 将系统库AlipaySDK.framework加入.

* 找到AlipaySDK.framework -> Headers -> AlipaySDK.h, 加入`#import <UIKit/UIKit.h>`

* 选择Build Settings, 找到Header Search Paths, 确认其中包含$(SRCROOT)/../../../react-native/React, 模式为recursive.

* 同上位置, 找到Framework Search Paths, 加入$(PROJECT_DIR)/Frameworks.

* 点击在Libraries下已拖进来的RCTAliPay.xcodeproj, 选择Build Settings, 找到Framework Search Paths, 将$(SRCROOT)/../../../ios/Frameworks替换成$(SRCROOT)/../../../../ios/Frameworks.

* 点击你的主project, 选择Build Phases -> Info, 在URL Types中增加一个数据, 并设置URL Schemes的值(对应插件里调用支付宝支付接口中传的appScheme参数, 会影响支付成功后是否能正确的返回app)

* 在`AppDelegate.m`中

```

...
#import <AlipaySDK/AlipaySDK.h> //导入支付宝SDK库
#import "RCTAliPay.h" //import interface
...
//alipay-sdk 支付结果回调
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

  if ([url.host isEqualToString:@"safepay"]) {
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
      //NSLog(@"processOrderWithPaymentResult result = %@",resultDic);
      RCTAliPay *rctAlipay = [[RCTAliPay alloc] initBySingleton];
      [rctAlipay processOrderWithPaymentResult:resultDic];
    }];
  }
  return YES;
}

//alipay-sdk 支付结果回调 NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
  if ([url.host isEqualToString:@"safepay"]) {
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
      //NSLog(@"processOrderWithPaymentResult result = %@",resultDic);
      RCTAliPay *rctAlipay = [[RCTAliPay alloc] initBySingleton];
      [rctAlipay processOrderWithPaymentResult:resultDic];
    }];
  }
  return YES;
}
...

```

## 安装 (Android)

* 在`android/settings.gradle`中

```
...
include ':react-native-smart-alipay'
project(':react-native-smart-alipay').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-smart-alipay/android')
```

* 在`android/app/build.gradle`中

```
...
dependencies {
    ...
    // From node_modules
    compile project(':react-native-smart-alipay')
}
```

* 在`MainApplication.java`中

```
...
import com.reactnativecomponent.amaplocation.RCTAlipayPackage;    //import package
...
/**
 * A list of packages used by the app. If the app uses additional views
 * or modules besides the default ones, add more packages here.
 */
@Override
protected List<ReactPackage> getPackages() {
    return Arrays.<ReactPackage>asList(
        new MainReactPackage(),
        new RCTAlipayPackage()  //register Module
    );
}
...

```

* 在`AndroidManifest.xml`中, application标签内加入

```

...
    <!-- 支付宝 sdk h5-activity 开始 -->
        <activity
            android:name="com.alipay.sdk.app.H5PayActivity"
            android:configChanges="orientation|keyboardHidden|navigation|screenSize"
            android:exported="false"
            android:screenOrientation="behind"
            android:windowSoftInputMode="adjustResize|stateHidden" >
        </activity>
    <!-- 支付宝 sdk h5-activity 结束 -->
...

```

## 完整示例

点击这里 [ReactNativeComponentDemos][0]

## 使用简介

Install the package from npm with `npm install react-native-smart-alipay --save`.
Then, require it from your app's JavaScript files with `import Barcode from 'react-native-smart-alipay'`.

```js

import React, {
    Component,
} from 'react'
import {
    StyleSheet,
    Text,
    View,
    ScrollView,
    TouchableOpacity,
    NativeModules,
    NativeAppEventEmitter,
    Alert,
    ProgressBarAndroid,
    ActivityIndicatorIOS,
    ActivityIndicator,
} from 'react-native'

import AppEventListenerEnhance from 'react-native-smart-app-event-listener-enhance'
import Button from 'react-native-smart-button'
import AliPay from 'react-native-smart-alipay'

class PaymentDemo extends Component {

    constructor (props) {
        super(props)
        this.state = {}

        this._xhr = null
    }

    componentWillMount () {
        this.addAppEventListener(
            NativeAppEventEmitter.addListener('alipay.mobile.securitypay.pay.onPaymentResult', this._onPaymentResult) //alipay
        )
    }

    render () {
        return (
            <ScrollView style={{flex: 1, marginTop: 20 + 44, }}>
                <Button
                    ref={ component => this._button_alipay = component }
                    touchableType={Button.constants.touchableTypes.fade}
                    style={{margin: 10, height: 40, backgroundColor: 'red', borderRadius: 3, borderWidth: StyleSheet.hairlineWidth, borderColor: 'red', justifyContent: 'center',}}
                    textStyle={{fontSize: 17, color: 'white'}}
                    loadingComponent={
                        <View style={{flexDirection: 'row', alignItems: 'center'}}>
                            {this._renderActivityIndicator()}
                            <Text style={{fontSize: 17, color: 'white', fontWeight: 'bold', fontFamily: '.HelveticaNeueInterface-MediumP4',}}>正在支付...</Text>
                        </View>
                    }
                    onPress={ this._getAlipayParams }>
                    支付宝支付
                </Button>
            </ScrollView>
        )
    }

    componentWillUnmount () {
        this._xhr && this._xhr.abort();
    }

    _getAlipayParams = () => {
        this._button_alipay.setState({
            loading: true,
        })

        //http请求服务获取支付参数及RSA数字签名信息
        this._xhr && this._xhr.abort()

        var xhr = this._xhr || new XMLHttpRequest()
        this._xhr = xhr

        xhr.onerror = ()=> {
            this._button_alipay.setState({
                loading: false,
            })
            Alert.alert(
                '请求出错',
                `状态码: ${xhr.status}, 错误信息: ${xhr.responseText}`
            )
        }

        xhr.ontimeout = () => {
            this._button_alipay.setState({
                loading: false,
            })
            Alert.alert(
                '',
                '请求超时'
            )
        }

        //let server_api_url = '获取支付宝参数信息的服务器接口url地址'
        //let params = '提交的参数, 例如订单号信息'
        //let appScheme = 'ios对应URL Types中的URL Schemes的值, 会影响支付成功后是否能正确的返回app'
        let server_api_url = 'http://f154876m19.imwork.net:16374/nAdvanceOrder/payAli'  //内部测试地址, 需自行修改
        let params = 'oid=3428a92f55bff7920155c2e4cc790060' //提交参数, 需自行修改
        let appScheme = 'reactnativecomponent'

        xhr.open('POST', server_api_url)
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded')
        xhr.onload = () => {
            if (xhr.status !== 200) {
                this._button_alipay.setState({
                    loading: false,
                })
                Alert.alert(
                    '请求失败',
                    `HTTP状态码: ${xhr.status}`
                )
                return
            }
            if (!xhr.responseText) {
                this._button_alipay.setState({
                    loading: false,
                })
                Alert.alert(
                    '请求失败',
                    '没有返回信息'
                )
                return
            }
            let responseJSON = JSON.parse(xhr.responseText)
            let orderText = decodeURIComponent(responseJSON.result)
            console.log(`响应信息: ${xhr.responseText}`)
            /*
             * 服务端获取支付宝SDK快捷支付功能所需参数字串示例(对应下面的orderText)
             * partner="2088021133166364"&seller_id="koa@sh-defan.net"&out_trade_no="160707414842102"&subject="到途订单-160707414842102"&body="营养快线水果酸奶饮品（椰子味）,500ml,4;正宗凉茶,310ML,4;原味味奶茶,80g,6;"&total_fee="0.01"&notify_url="http://f154876m19.imwork.net:16374/pay/paymentCompletion"&service="mobile.securitypay.pay"&payment_type="1"&_input_charset="utf-8"&it_b_pay="-644885m"&return_url="m.alipay.com"&sign="iW5aK2dEsIj8nGg%2BEOOlMcyL081oX%2F2zHNcoJRrlO3qWmoVkXJM%2B2cHH9rSDyGYAeKxRD%2BYwrZK3H3QYb%2Fxi6Jl%2BxJVcvguluXbKvmpKjuuBv2gcOyqtydUMHwpdAVN%2BTwbQ6Zt8LU9xLweua7n%2FLuTFdjyePwf5Zb72r21v5dw%3D"&sign_type="RSA"
             */
            console.log(`获取支付宝参数成功, decodeURIComponent -> orderText = ${orderText}`);
            AliPay.payOrder({
                orderText,
                appScheme,
            });

        }

        xhr.timeout = 30000
        xhr.send(params)
    }

    _onPaymentResult = (result) => {
        //console.log(`result -> `)
        //console.log(result)
        console.log(`result.resultStatus = ${result.resultStatus}`)
        console.log(`result.memo = ${result.memo}`)
        console.log(`result.result = ${result.result}`)
        this._button_alipay.setState({
            loading: false,
        })
        Alert.alert(
            '',
            `${result.resultStatus == 9000 ? '支付成功' : '支付失败'} `
        )
    }

    _renderActivityIndicator() {
        return ActivityIndicator ? (
            <ActivityIndicator
                style={{margin: 10,}}
                animating={true}
                color={'#fff'}
                size={'small'}/>
        ) : Platform.OS == 'android' ?
            (
                <ProgressBarAndroid
                    style={{margin: 10,}}
                    color={'#fff'}
                    styleAttr={'Small'}/>

            ) :  (
            <ActivityIndicatorIOS
                style={{margin: 10,}}
                animating={true}
                color={'#fff'}
                size={'small'}/>
        )


    }

}


export default AppEventListenerEnhance(PaymentDemo)
```

## 支付传参
* payOptions.orderText  调用支付宝接口所需的服务器返回的订单信息文本, 还包括签名串等信息

## 支付传参 (ios)
* payOptions.appScheme  调用支付宝接口支付后会依据这个值来返回app

## 方法

* payOrder
  * 描述: 支付订单
  * 参数: payOptions 类型: Object

## 事件监听

* 全局事件: alipay.mobile.securitypay.pay.onPaymentResult
    * 描述: 监听并获取支付完成返回的结果信息

[0]: https://github.com/cyqresig/ReactNativeComponentDemos
[1]: https://doc.open.alipay.com/
[2]: http://cyqresig.github.io/img/react-native-smart-alipay-preview-ios-v1.0.0.gif