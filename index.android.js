/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  NativeModules,
  View,
  DeviceEventEmitter
} from 'react-native';
import LocalizedStrings from 'react-native-localization';


global.strings = new LocalizedStrings ({
    "en-US":{
        welcome:"Welcome to React Native!",
        get_started:"To get started, edit index.android.js",
        instructions:"Double tap R on your keyboard to reload,\n"+
                                "Shake or press menu button for dev menu"
    }
});

// Get strings at launch
NativeModules.SmartlingBridge.getStrings((locale, strings) => {
    updateStrings(locale, strings);
});

DeviceEventEmitter.addListener('SmartlingStringsUpdated', (map) => {
        updateStrings(map.locale, map.strings);
});

function updateStrings(locale, strings) {
    global.strings = new LocalizedStrings(strings);
    global.strings.setLanguage(locale);
    //TODO update current scene
    console.log(locale);
    console.log(global.strings);
}

class PropertyFinder extends Component {
  render() {
  console.log('Render');
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          {strings.welcome}
        </Text>
        <Text style={styles.instructions}>
          {strings.get_started}
        </Text>
        <Text style={styles.instructions}>
          {strings.instructions}
        </Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('PropertyFinder', () => PropertyFinder);
