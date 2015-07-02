S.log('[SLATE]: loading config');

// reference .slate files
// https://github.com/dmac/dotfiles/blob/master/.slate
// https://github.com/jigish/dotfiles/blob/master/slate.js


// ==================
// Global config
// ==================

S.cfga({
  'defaultToCurrentScreen': true,
  'secondsBetweenRepeat': 0.1,
  'checkDefaultsOnLoad': true,
  'focusCheckWidthMax': 3000,
  'orderScreensLeftToRight': false,
  'modalEscapeKey': 'esc',
  'windowHintsFontSize': 60,
  'windowHintsShowIcons': false,
  'windowHintsDuration': 5,
  'windowHintsSpread': true,
  'windowHintsIgnoreHiddenWindows' : false,
  'windowHintsShowIcons': true,
  'windowHintsSpreadPadding': 20,
  'repeatOnHoldOps': true,
  'secondsBeforeRepeat': 0.1,

  // NOTE: this is buggy, some apps are focused, while other are skipped
  // see layoutWithFocus() below as a workaround
  'layoutFocusOnActivate': false
});
var resizeDelta = '5%';
var moveDelta = '5%';
var currentScreenConf = null;

// mbp 15 retina
var thisLaptopScreenRes = {
  width: 1440,
  height: 900
};

// ==================
// Functions
// ==================


// screen configuration declaration, used for crafting different layouts
// assumes at most 2 monitors
function ScreenConf(name){
  this.name = name;

  // assumes orderScreensLeftToRight = false
  // laptop - 0
  // external mon - 1
  this.mainScreen = '0';
  this.secondaryScreen = '1';

  this.isLaptopOnly = function() {
    return this.name === 'laptop';
  }

  this.getScreenCount = function() {
    return this.name === 'laptop' || this.name === 'monitor' ? 1 : 2;
  }
}

ScreenConf.laptopOnly = function() {
  return new ScreenConf('laptop');
};

ScreenConf.laptopAndMonitor = function() {
  return new ScreenConf('laptop+monitor');
};

ScreenConf.monitorOnly = function() {
  return new ScreenConf('monitor');
};

ScreenConf.twoMonitors = function() {
  return new ScreenConf('monitorx2');
};

// iterate through screens
function getNextScreen(win){
  // FIXME: screen().id() does not regard "orderScreensLeftToRight: false"
  // and returns ids according to left to right ordering
  // according to OSX ordering, laptop - 0, monitor - 1
  // according to left-to-right order: laptop - 1, monitor - 0 (specific to my workdesk)

  // this workaround will work as soon as secondary monitor is the leftmost
  // yes, this is very ugly
  return S.screenForRef(S.window().screen().id());
};

// toggle fullscreen and be able to revert back to original position
function getToggleFullscreenAction(){
  var appPosition = {};

  return function(win){
    var appName = win.app().name();

    // see if we have previous location saved, and revert to it
    if (appPosition[appName]) {
      win.doOperation(S.op('move', appPosition[appName]));
      delete appPosition[appName];
    }

    // store location and toggle fullscreen
    else {
      appPosition[appName] = win.rect();
      win.doOperation(fullScreen);
    }
  }
}

// '5%' -> 5
// '5.5%' -> 5.5
// '124' -> 124
function parseDeltaAsFloat(value){
  return {
    value: parseFloat(value.match(/\d+(\.\d+)?/)[0]),
    isRelativeUnits: /%$/.test(value)
  }
}

// resize window evenly on all edges
// when reach screen rect, stop resizing
// NOTE: does not respect 'resizePercentOf' setting, always calculate relative units against screenRect
function getResizeWindowAction(op){
  var delta = parseDeltaAsFloat(resizeDelta);

  return function(win){
    var rect = win.rect();
    var screenRect = win.screen().rect();

    var xDelta = (delta.isRelativeUnits ? screenRect.width * (delta.value * 0.01) / 2 : delta.value / 2);
    var yDelta = (delta.isRelativeUnits ? screenRect.height * (delta.value * 0.01) / 2 : delta.value / 2);
    var widthDelta = (delta.isRelativeUnits ? screenRect.width * (delta.value * 0.01) : delta.value);
    var heightDelta = (delta.isRelativeUnits ? screenRect.height * (delta.value * 0.01) : delta.value);

    if (op === '+') {
      var x = rect.x - xDelta;
      var y = rect.y - yDelta;
      var width = rect.width + widthDelta;
      var height = rect.height + heightDelta;

      win.doOperation(S.op('move', {
        x: x < 0 ? 0 : x,
        y: y < 0 ? 0 : y,
        width: width > screenRect.width ? screenRect.width : width ,
        height: height > screenRect.height ? screenRect.height : height
      }));
    }
    else if (op === '-') {
      win.doOperation(S.op('move', {
        x: rect.x + xDelta,
        y: rect.y + yDelta,
        width: rect.width - widthDelta,
        height: rect.height - heightDelta
      }));
    }
  }
}

// toggle current
// when window is restored back, focus it
function getToggleAction(){
  var lastHiddenApp;

  return function(win){
    if (!lastHiddenApp) {
      lastHiddenApp = win.app().name();
      S.op('hide', { app: 'current' }).run();
    }
    else {
      showAndFocusApp(lastHiddenApp);
      lastHiddenApp = null;
    }
  }
}

function isAppOpened(appName){
  return !!getApp(appName);
}

function getApp(appName){
  var result = null;

  S.eachApp(function(app){
    if(app.name() === appName){
      result = app;
    }
  });

  return result;
}

function showAndFocusApp(appName){
  S.op('sequence', {
    operations: [
      S.op('show', { app: appName }),
      S.op('focus', { app: appName })
    ]
  }).run();
}

// open iTerm if not opened
// focus iTerm, if already opened
// if Iterm is current window, hide it
function getOpenOrFocusITermAction() {

  return function(win) {
    var appName = win.app().name();

    if (appName === 'iTerm') {
      S.op('hide', { app: 'current' }).run();
    }
    else {
      if (isAppOpened('iTerm')) {
        showAndFocusApp('iTerm')
      }
      else{
        S.op('layout', { name: 'terminal' }).run();
      }
    }
  }
}

// S.layout() decorator, which focus all apps in description in order, optionally skipping some of them
// this is workaround to buggy 'layoutFocusOnActivate' global config settings
// anyway, I would like for some layouts to focus apps
// while for other just to settle app position, w/o changing focus
// this function makes it possible as opposite to 'layoutFocusOnActivate' settings, which is applied globally
S.layoutWithFocus = function(name, description){
  var apps = Object.keys(description);

  // prepare ordered list of focus ops
  var focusOps = [];
  for(var i = 0; i < apps.length; i++){
    if(description[apps[i]].skipFocus || apps[i] === '_before_' || apps[i] === '_after_') continue;
    focusOps.push(S.op('focus', { app: apps[i] }));
  }

  // run each focus op on next event loop
  // NOTE: runnig focus ops in the same loop leads to unpredictable results
  // some apps are focused, while other are skipped
  description['_after_'] = {
    operations: [ function(){
      var i = 0;

      function nextFocus(){
        window.setTimeout(function(){
          focusOps[i++].run();
          if(i < focusOps.length) nextFocus();
        }, 0);
      }

      nextFocus();
    }]
  };

  return S.layout(name, description);
};

function openAppOp(appPath) {
  return S.op('shell', {
    command: '/usr/bin/open ' + appPath + '',
    wait: true
  });
}

function ensureOpenedApps() {
  var ops = [];
  for(var i = 0; i < arguments.length; i++) {
    ops.push(openAppOp(arguments[i]));
  }
  return { operations: ops };
}

function delayOp(delay) {
  return S.op('shell', {
    command: '/bin/sleep ' + delay,
    wait: true
  });
}

function workspaceOp(name) {
  return function(){
    S.log('activate layout' + name + '@' + currentScreenConf.name);
    S.op('layout', { name: name + '@' + currentScreenConf.name }).run();
  }
}

function hasLaptopNow() {
  var rect = S.screenForRef(thisLaptopScreenRes.width + 'x' + thisLaptopScreenRes.height).rect();
  return rect.width === thisLaptopScreenRes.width && rect.height === thisLaptopScreenRes.height;
}

// ==================
// Common operations
// ==================

var topLeftCorner = S.op('corner', { 'width' : 'screenSizeX/2', 'height': 'screenSizeY/2', direction: 'top-left' });
var topRightCorner = topLeftCorner.dup({ direction: 'top-right' });
var bottomRightCorner = topLeftCorner.dup({ direction: 'bottom-right' });
var bottomLeftCorner = topLeftCorner.dup({ direction: 'bottom-left' });

var leftHalf = S.op('move', {
  x: 'screenOriginX',
  y: 'screenOriginY',
  width: 'screenSizeX/2',
  height: 'screenSizeY'
});
var rightHalf = leftHalf.dup({
  x: 'screenOriginX+screenSizeX/2',
});
var topHalf = leftHalf.dup({
  width: 'screenSizeX',
  height: 'screenSizeY/2'
});
var bottomHalf = topHalf.dup({
  y: 'screenOriginY+screenSizeY/2'
});

var leftThird = leftHalf.dup({
  width: 'screenSizeX/3'
});
var centerThird = leftHalf.dup({
  x: 'screenOriginX+screenSizeX/3',
  width: 'screenSizeX/3'
});
var rightThird = leftHalf.dup({
  x: 'screenOriginX+2*screenSizeX/3',
  width: 'screenSizeX/3'
});
var rightTwoThirds = leftHalf.dup({
  x: 'screenOriginX+screenSizeX/3',
  width: '2*screenSizeX/3'
});

var centerScreen = S.op('move', {
  x: 'screenOriginX+screenSizeX/6',
  y: 'screenOriginY+screenSizeY/6',
  width: '2*screenSizeX/3',
  height: '2*screenSizeY/3'
});
var fullScreen = S.op('move', {
  'x' : 'screenOriginX',
  'y' : 'screenOriginY',
  'width' : 'screenSizeX',
  'height' : 'screenSizeY'
});


// ==================
// Layouts
// ==================

function createBrowsingLayout(screenConf) {

  return S.layoutWithFocus('browsing@' + screenConf.name, {
    '_before_': ensureOpenedApps(
      '/Applications/Google_Chrome.app'),

    'Google Chrome': {

      operations: [fullScreen.dup({ screen: screenConf.mainScreen })],
      repeat: true,
      'ignore-fail': true
    }
  });
}

function createChatLayout(screenConf){

  return S.layoutWithFocus('chat@' + screenConf.name, {
    '_before_': ensureOpenedApps(
      '/Applications/Skype.app',
      '/Applications/Slack.app'),

    'Skype': {
      operations: [screenConf.isLaptopOnly()
        ? rightHalf.dup({ x: 768, width: 'screenSizeX-768', screen: screenConf.secondaryScreen })
        : rightHalf.dup({ screen : screenConf.secondaryScreen })],
      repeat: true,
      'ignore-fail': true
    },
    'Slack': {

      // Slack cannot be resized smaller than 768px
      // 768px < 1400px/2, so make this constraint explicit here
      operations: [screenConf.isLaptopOnly()
        ? leftHalf.dup({ width: 768, screen: screenConf.secondaryScreen })
        : leftHalf.dup({ screen: screenConf.secondaryScreen })],
      repeat: true,
      'ignore-fail': true
    }
  });
}
function createDevLayout(screenConf){

  if(screenConf.getScreenCount() === 1) {
    return S.layoutWithFocus('dev@' + screenConf.name, {
      '_before_': ensureOpenedApps(
        '/Applications/iTerm.app',
        '/Applications/Atom.app'),

      'iTerm': {
        operations: [
          leftThird.dup({ screen: screenConf.mainScreen })
        ],
        repeat: true,
        'ignore-fail': true
      },
      'Atom': {
        operations: [rightTwoThirds.dup({ screen: screenConf.mainScreen })],
        repeat: true,
        'ignore-fail': true
      }
    });
  } else {
    return S.layoutWithFocus('dev@' + screenConf.name, {
      '_before_': ensureOpenedApps(
        '/Applications/iTerm.app',
        '/Applications/Atom.app',
        '/Applications/Google_Chrome.app'),

      'iTerm': {
        operations: [
          leftThird.dup({ screen: screenConf.mainScreen })
        ],
        repeat: true,
        'ignore-fail': true
      },
      'Google Chrome': {
        operations: [fullScreen.dup({ screen: screenConf.secondaryScreen })],
        repeat: true,
        'ignore-fail': true
      },
      'Atom': {
        operations: [rightTwoThirds.dup({ screen : screenConf.mainScreen })],
        repeat: true,
        'ignore-fail': true
      }
    });
  }
}

S.layoutWithFocus('terminal', {
  '_before_': {
    operations: [
      openAppOp('/Applications/iTerm.app'),
      delayOp(0.2)
    ]
  },
  'iTerm': {
    operations: [leftHalf, rightHalf],
    repeat: true,
    'ignore-fail': true
  }
});

// create predefined layouts for each screen conf
createBrowsingLayout(ScreenConf.laptopOnly());
createBrowsingLayout(ScreenConf.laptopAndMonitor());
createBrowsingLayout(ScreenConf.monitorOnly());
createBrowsingLayout(ScreenConf.twoMonitors());

createChatLayout(ScreenConf.laptopOnly());
createChatLayout(ScreenConf.laptopAndMonitor());
createChatLayout(ScreenConf.monitorOnly());
createChatLayout(ScreenConf.twoMonitors());

createDevLayout(ScreenConf.laptopOnly());
createDevLayout(ScreenConf.laptopAndMonitor());
createDevLayout(ScreenConf.monitorOnly());
createDevLayout(ScreenConf.twoMonitors());

// detect current screen conf
S.default(1, function() {
  currentScreenConf = hasLaptopNow()
    ? ScreenConf.laptopOnly()
    : ScreenConf.monitorOnly();

  S.log('detected screen configuration: ' + currentScreenConf.name);
});
S.default(2, function() {
  currentScreenConf = hasLaptopNow()
    ? ScreenConf.laptopAndMonitor()
    : ScreenConf.twoMonitors();

  S.log('detected screen configuration: ' + currentScreenConf.name);
});

// ==================
// Keystroke bindings
// ==================

S.bnda({

  // basic layout ops
  '1:cmd,f4' : bottomLeftCorner,
  '2:cmd,f4' : bottomHalf,
  '3:cmd,f4' : bottomRightCorner,

  '4:cmd,f4' : leftHalf,
  '5:cmd,f4' : centerScreen,
  '6:cmd,f4' : rightHalf,

  '7:cmd,f4' : topLeftCorner,
  '8:cmd,f4' : topHalf,
  '9:cmd,f4' : topRightCorner,

  // show grid
  'f4:cmd,f4' : S.op('grid', {
    'grids' : {

      // macbook pro 15' retina, 16:10 aspect ratio
      '1440x900' : {
        "width" : 16,
        "height" : 10
      },
      // dell u2412, 16:10
      '1920x1200' : {
        "width" : 16,
        "height" : 10
      }
    }
  }),

  // task-based layouts, aka workspaces
  '1:cmd,f3': workspaceOp('browsing'),
  '2:cmd,f3': workspaceOp('chat'),
  '3:cmd,f3': workspaceOp('dev'),

  // toggle fullscreen
  'return:ctrl': getToggleFullscreenAction(),

  // move around
  'up:cmd,f3:toggle': S.op('nudge', { x: '+0', y: '-' + moveDelta }),
  'down:cmd,f3:toggle': S.op('nudge', { x: '+0', y: '+' + moveDelta }),
  'left:cmd,f3:toggle': S.op('nudge', { x: '-' + moveDelta, y: '+0' }),
  'right:cmd,f3:toggle': S.op('nudge', { x: '+' + moveDelta, y: '+0' }),

  // focus
  'right:ctrl' : S.op('focus', { 'direction' : 'right' }),
  'left:ctrl' : S.op('focus', { 'direction' : 'left' }),
  'up:ctrl' : S.op('focus', { 'direction' : 'up' }),
  'down:ctrl' : S.op('focus', { 'direction' : 'down' }),
  'down:ctrl,shift' : S.op('focus', { 'direction' : 'behind' }),

  // resize bigger
  'left:cmd,alt,=:toggle' : S.op('resize', { 'width' : '+' + resizeDelta, 'height' : '+0', anchor : 'bottom-right' }),
  'right:cmd,alt,=:toggle' : S.op('resize', { 'width' : '+' + resizeDelta, 'height' : '+0' }),
  'up:cmd,alt,=:toggle' : S.op('resize', { 'width' : '+0', 'height' : '+' + resizeDelta, anchor : 'bottom-right' }),
  'down:cmd,alt,=:toggle' : S.op('resize', { 'width' : '+0', 'height' : '+' + resizeDelta }),
  '=:cmd,alt,=:toggle' : getResizeWindowAction('+'),

  // resize smaller
  'left:cmd,alt,-:toggle' : S.op('resize', { 'width' : '-' + resizeDelta, 'height' : '+0' }),
  'right:cmd,alt,-:toggle' : S.op('resize', { 'width' : '-' + resizeDelta, 'height' : '+0', 'anchor' : 'bottom-right' }),
  'up:cmd,alt,-:toggle' : S.op('resize', { 'width' : '+0', 'height' : '-' + resizeDelta }),
  'down:cmd,alt,-:toggle' : S.op('resize', { 'width' : '+0', 'height' : '-' + resizeDelta, 'anchor' : 'bottom-right' }),
  '-:cmd,alt,-:toggle' : getResizeWindowAction('-'),

  'h:cmd,shift' : getToggleAction(),

  'f3:cmd,f3': S.op('throw', { 'screen' : getNextScreen }),

  // not clear why this switcher is better
  // 'e:cmd': S.op('switch'),

  // Window Hints
  'esc:cmd' : S.op('hint', {
    "characters" : '1234567890QWERTYUIOP'
  }),

  // global shortcut to open/focus iTerm
  // NOTE: make sure to disable global hotkey setting in iTerm
  // in this way "ctrl,`" can also open iTerm if not opened yet
  '`:ctrl': getOpenOrFocusITermAction()
});

S.log('[SLATE]: done loading config');
