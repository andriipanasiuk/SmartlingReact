package com.propertyfinder;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.support.v4.content.LocalBroadcastManager;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule.RCTDeviceEventEmitter;
import com.smartling.android.sdk.Smartling;
import com.smartling.android.sdk.core.CoreImpl;
import com.smartling.android.sdk.core.LocaleResolver;
import com.smartling.android.sdk.core.dao.StringDaoImpl;
import com.smartling.android.sdk.ota.OTAService;
import com.smartling.android.shared.translate.SingleString;
import com.smartling.android.shared.translate.SmartlingStrings;

public class SmartlingBridge extends ReactContextBaseJavaModule {

    public SmartlingBridge(ReactApplicationContext reactContext) {
        super(reactContext);
        LocalBroadcastManager.getInstance(reactContext)
                .registerReceiver(new StringLoadedReceiver(), new IntentFilter(OTAService.STRINGS_LOADED_ACTION));
    }

    @Override
    public String getName() {
        return "SmartlingBridge";
    }

    @SuppressWarnings("unused")
    @ReactMethod
    public void getStrings(Callback callback) {
        LocaleResolver localeResolver = Smartling.createLocaleResolver(getReactApplicationContext(),
                CoreImpl.getInstance(getReactApplicationContext()));
        String locale = localeResolver.getLocale();
        SmartlingStrings strings = StringDaoImpl.getInstance(getReactApplicationContext()).getAll(locale);
        if (strings.isEmpty()) {
            return;
        }
        WritableMap localeMap = convertToJsMap(locale, strings);
        callback.invoke(locale, localeMap);
    }

    private class StringLoadedReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            LocaleResolver localeResolver = Smartling.createLocaleResolver(getReactApplicationContext(),
                    CoreImpl.getInstance(getReactApplicationContext()));
            String locale = localeResolver.getLocale();
            SmartlingStrings strings = StringDaoImpl.getInstance(getReactApplicationContext()).getAll(locale);
            if (strings.isEmpty()) {
                return;
            }
            WritableMap localeMap = convertToJsMap(locale, strings);
            WritableMap map = Arguments.createMap();
            map.putString("locale", locale);
            map.putMap("strings", localeMap);
            getReactApplicationContext().getJSModule(RCTDeviceEventEmitter.class).emit(
                    "SmartlingStringsUpdated", map);
        }
    }

    private WritableMap convertToJsMap(String locale, SmartlingStrings strings) {
        WritableMap localeMap = Arguments.createMap();
        WritableMap stringsMap = Arguments.createMap();
        for (SingleString singleString : strings.getSingleStrings()) {
            stringsMap.putString(singleString.getResourceName(), singleString.getUnescapedValue());
        }
        //TODO add support of plural strings
        localeMap.putMap(locale, stringsMap);
        return localeMap;
    }

}
