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
  'windowHintsDuration': 5,
  'windowHintsSpread': true,
  'windowHintsIgnoreHiddenWindows' : false,
  'windowHintsShowIcons': true,
  'windowHintsSpreadPadding': 20,
  'repeatOnHoldOps': true,
  'secondsBeforeRepeat': 0.1,

  // NOTE: this is buggy, some apps are focused, while other are skipped
  'layoutFocusOnActivate': false
});
var resizeDelta = '5%';
var moveDelta = '5%';

// ==================
// Functions
// ==================

// iterate through screens
function getNextScreen(win){
  // FIXME: screen().id() does not regard "orderScreensLeftToRight: false"
  // and returns ids according to left to right ordering
  // according to OSX ordering, laptop - 0, monitor - 1
  // according to left-to-right order: laptop - 1, monitor - 0 (specific to my workdesk)

  // this workaround will work as soon as secondary monitor is the leftmost
  // yes, this is very ugly
  return S.screenForRef(S.window().screen().id());
}

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
  };
}

// '5%' -> 5
// '5.5%' -> 5.5
// '124' -> 124
function parseDeltaAsFloat(value){
  return {
    value: parseFloat(value.match(/\d+(\.\d+)?/)[0]),
    isRelativeUnits: /%$/.test(value)
  };
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
  };
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
// Keystroke bindings
// ==================

// macbook keyboard without numpad
S.bnda({

  // resize
  '1:cmd,f4' : bottomLeftCorner,
  '2:cmd,f4': bottomHalf,
  'down:cmd,f4': bottomHalf,
  '3:cmd,f4' : bottomRightCorner,
  '4:cmd,f4': leftHalf,
  'left:cmd,f4': leftHalf,
  '5:cmd,f4' : centerScreen,
  '6:cmd,f4': rightHalf,
  'right:cmd,f4': rightHalf,
  '7:cmd,f4' : topLeftCorner,
  '8:cmd,f4': topHalf,
  'up:cmd,f4': topHalf,
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

  // toggle fullscreen
  'return:ctrl': getToggleFullscreenAction(),

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

  '`:cmd,`': S.op('throw', { 'screen' : getNextScreen }),

  // not clear why this switcher is better
    // 'e:cmd': S.op('switch'),

  // Window Hints
  'esc:cmd' : S.op('hint', {
    "characters" : '1234567890QWERTYUIOP'
  })
});

// add some bindings for PC keyboard with numpad
S.bnda({

  // basic layout ops
  'pad1:cmd,padClear' : bottomLeftCorner,
  'pad2:cmd,padClear' : bottomHalf,
  'pad3:cmd,padClear' : bottomRightCorner,

  'pad4:cmd,padClear' : leftHalf,
  'pad5:cmd,padClear' : centerScreen,
  'pad6:cmd,padClear' : rightHalf,

  'pad7:cmd,padClear' : topLeftCorner,
  'pad8:cmd,padClear' : topHalf,
  'pad9:cmd,padClear' : topRightCorner,

  // show grid
  'padClear:cmd,padClear' : S.op('grid', {
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
  })
});

S.log('[SLATE]: done loading config');
