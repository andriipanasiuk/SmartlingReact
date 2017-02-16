'use strict';

import React, { Component } from 'react'
import {
  StyleSheet,
  NavigatorIOS,
  AppRegistry,
  NativeModules,
  NativeEventEmitter
} from 'react-native';
import LocalizedStrings from 'react-native-localization';

var SearchPage = require('./SearchPage');

var styles = StyleSheet.create({
  container: {
    flex: 1
  }
});

// Smartling localization
global.localizedStrings = new LocalizedStrings({});

// Get strings at launch
NativeModules.SmartlingBridge.getLocalizedStrings((error, smartlingStrings) => {
  localizedStrings = new LocalizedStrings(smartlingStrings);
});

// Listen for strings updates
const myModuleEvt = new NativeEventEmitter(NativeModules.SmartlingEmitter);
myModuleEvt.addListener( 'SmartlingStringsUpdated', (smartlingStrings) => {
  localizedStrings = new LocalizedStrings(smartlingStrings);
  // force update current screen
});

class PropertyFinderApp extends Component {
  render() {
    return (
      <NavigatorIOS
        style={styles.container}
        initialRoute={{
          title: 'Property Finder',
          component: SearchPage,
        }}/>
    );
  }
}

AppRegistry.registerComponent('PropertyFinder', function() { return PropertyFinderApp });
