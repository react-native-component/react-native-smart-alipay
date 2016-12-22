package com.reactnativecomponent.alipay;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;

import com.alipay.sdk.app.PayTask;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.util.Map;


public class RCTAlipayModule extends ReactContextBaseJavaModule {
    private static final int SDK_PAY_FLAG = 1;
    ReactApplicationContext context;


    public RCTAlipayModule(ReactApplicationContext reactContext) {
        super(reactContext);
        context = reactContext;
    }

    @Override
    public String getName() {
        return "AliPay";
    }

    @ReactMethod
    public void payOrder(ReadableMap params) {
        Activity currentActivity = context.getCurrentActivity();
        final String orderText = params.getString("orderText");
        payV2(currentActivity, orderText);
    }

    private void payV2(final Activity activity, final String orderText) {
        activity.runOnUiThread(new Runnable() {
            public void run() {
                @SuppressLint("HandlerLeak")
                final Handler mHandler = new Handler() {
                    @SuppressWarnings("unused")
                    public void handleMessage(Message msg) {
                        switch (msg.what) {
                            case SDK_PAY_FLAG: {
                                @SuppressWarnings("unchecked")
                                PayResult payResult = new PayResult((Map<String, String>) msg.obj);
                                /**
                                 对于支付结果，请商户依赖服务端的异步通知结果。同步通知结果，仅作为支付结束的通知。
                                 */
                                WritableMap resultMap = setResultMap(payResult);
//                                String resultInfo = payResult.getResult();// 同步返回需要验证的信息, // 该笔订单是否真实支付成功/失败，需要依赖服务端的异步通知。
//                                String resultStatus = payResult.getResultStatus();

                                context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                        .emit("alipay.mobile.securitypay.pay.onPaymentResult", resultMap);
                                break;
                            }
                            default:
                                break;
                        }
                    };
                };

                Runnable payRunnable = new Runnable() {

                    @Override
                    public void run() {
                        PayTask alipay = new PayTask(activity);
                        Map<String, String> result = alipay.payV2(orderText, true);
                        Message msg = new Message();
                        msg.what = SDK_PAY_FLAG;
                        msg.obj = result;
                        mHandler.sendMessage(msg);
                    }
                };

                Thread payThread = new Thread(payRunnable);
                payThread.start();

            }
        });
    }

    private WritableMap setResultMap(PayResult payResult) {
        WritableMap resultMap = Arguments.createMap();

        if (null != payResult) {
            resultMap.putString("resultStatus", payResult.getResultStatus());
            resultMap.putString("result", payResult.getResult());
            resultMap.putString("memo", payResult.getMemo());
        }

        return resultMap;
    }
}
