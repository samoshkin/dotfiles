S.log('[SLATE]: loading config');

// reference .slate files
// https://github.com/dmac/dotfiles/blob/master/.slate
// https://github.com/jigish/dotfiles/blob/master/slate.js

// TODO: add multiple monitors support

// global configs
S.cfga({
  'defaultToCurrentScreen': true,
  'secondsBetweenRepeat': 0.1,
  'checkDefaultsOnLoad': true,
  'focusCheckWidthMax': 3000,
  'orderScreensLeftToRight': true,
	'modalEscapeKey': 'esc',
  'windowHintsFontSize': 60,
  'windowHintsShowIcons': false,
  'windowHintsDuration': 5,
  'windowHintsSpread': true,
  'windowHintsIgnoreHiddenWindows' : false,
  'windowHintsShowIcons': true,
  'windowHintsSpreadPadding': 20,
  'repeatOnHoldOps': true,
  'secondsBeforeRepeat': 0.1
});
var resizeDelta = '5%';
var moveDelta = '5%';
var screens = [];
var thisScreenConf = '0';

// detect monitors
function detectScreens(){
  var laptop = S.screenr(thisScreenConf);
  screens = [laptop];

  S.escreen(function(screen){
    if(screen.id() !== laptop.id()){
      screens.push(screen);
    }
  });
}

detectScreens();


// NOTE: maybe we don't need it
// S.on('screenConfigurationChanged', function(){
//   detectScreens();
// });

// iterate through screens
function getNextScreen(){
  return (S.window().screen().id() + 1) % S.screenCount();
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
      showAndFocus(lastHiddenApp);
      lastHiddenApp = null;
    }
  }
}

function isAppOpened(appName){
  var result = false;

  S.eachApp(function(app){
    if(app.name() === appName){
      result = true;
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
        S.sh('/usr/bin/open /Applications/iTerm.app', true);
      }
    }
  }
}

// get screen layout for current screen configuration
function getCurrentScreenLayoutName(){

  // assumes only per screen count configuration, and only two monitors
  return S.screenCount() === 1 ? 'oneMonitor' : 'twoMonitor';
}

// common operations
var topLeftCorner = S.op('corner', { 'width' : 'screenSizeX/2', 'height': 'screenSizeY/2', direction: 'top-left' });
var topRightCorner = topLeftCorner.dup({ direction: 'top-right' });
var bottomRightCorner = topLeftCorner.dup({ direction: 'bottom-right' });
var bottomLeftCorner = topLeftCorner.dup({ direction: 'bottom-left' });

// NOTE: is there any difference between using push or move operations?
// var leftHalf = S.op('push', { style: 'bar', direction: 'left', style: 'bar-resize:screenSizeX/2' });
// var topHalf = S.op('push', { style: 'bar', direction: 'top', style: 'bar-resize:screenSizeY/2' });
// var rightHalf = S.op('push', { style: 'bar', direction: 'right', style: 'bar-resize:screenSizeX/2' });
// var bottomHalf = S.op('push', { style: 'bar', direction: 'bottom', style: 'bar-resize:screenSizeY/2' });

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

// key bindings
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

  // universal predefined layout
  'f3:cmd,f3' : function(){
    S.op('layout', { name: getCurrentScreenLayoutName() }).run();
  },

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

  // throw to next screen
  // TODO: check on external monitor later
  // 'f4:cmd,alt':  S.op('throw', { 'screen' : getNextScreen(), 'width': 'screenSizeX', 'height': 'screenSizeY' }),

  // show grid
  // TODO: define grid size for external monitor
  'f4:cmd,f4' : S.op('grid', {
    'grids' : {

      // macbook pro 15' retina 16:10 aspect ratio
      '0' : {
        "width" : 16,
        "height" : 10
      }
    }
  }),

  // not clear why this switcher is better
  // 'e:cmd': S.op('switch'),

  // Window Hints
  'esc:cmd' : S.op('hint', {
		"characters" : '1234567890QWERTYUIOP'
	}),

  // global shortcut to open/focus iTerm
  // NOTE: make sure to disable global hotkey setting in iTerm
  // in this way ctrl,` can also open iTerm if not opened yet
  '`:ctrl': getOpenOrFocusITermAction()
});

// layouts
S.layout('oneMonitor', {
  'iTerm' : {
    operations: [leftHalf],
    repeat: true,
    'ignore-fail': true
  },
  'Google Chrome': {
    operations: [fullScreen],
    repeat: true,
    'ignore-fail': true
  },
  'Atom': {
    operations: [rightHalf, leftHalf],
    repeat: true,
    'ingore-fail': true
  },
  'MacPass': {
    operations: [bottomLeftCorner]
  },
  'Skype': {
    operations: [leftHalf]
  },
  'Slack': {
    operations: [leftHalf]
  },
  'uTorrent': {
    operations: [topHalf]
  }
});

S.layout('twoMonitor', {
  // TODO: define
});

// default layouts for different monitor configuration
S.default(1, 'oneMonitor');
S.default(2, 'twoMonitor');

// move iterm to lefthalf by default
// NOTE: slate might crash when trying to apply operation for just opened app
S.on('appOpened', function(event, app) {
  if(app.name() === 'iTerm'){
    app.mainWindow().doOperation(leftHalf);
  }
});

S.log('[SLATE]: done loading config');
