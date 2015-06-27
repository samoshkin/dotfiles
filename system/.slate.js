S.log('[SLATE]: loading config');

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
  'windowHintsSpreadPadding': 50,
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

var getNextScreen = function(){
  return (S.window().screen().id() + 1) % S.screenCount();
};


// operation protos
var cornerOp = S.op('corner', { 'width' : 'screenSizeX/2', 'height': 'screenSizeY/2', direction: 'top-left' });
var pushOp = S.op('push', { style: 'bar', direction: 'left' });
var fullScreenOp = S.op('move', {
  'x' : 'screenOriginX',
  'y' : 'screenOriginY',
  'width' : 'screenSizeX',
  'height' : 'screenSizeY'
});
var centerScreenOp = S.op('move', {
  x: 'screenSizeX/6',
  y: 'screenSizeY/6',
  width: '2*screenSizeX/3',
  height: '2*screenSizeY/3'
})

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
      win.doOperation(fullScreenOp);
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
      win.doOperation(S.op('hide', {
        app: 'current'
      }));
    }
    else {
      win.doOperation(S.op('sequence', {
        operations: [
          S.op('show', { app: lastHiddenApp }),
          S.op('focus', { app: lastHiddenApp }),
        ]
      }));
      lastHiddenApp = null;
    }
  }
}

// key bindings
S.bnda({

  // dock to sides, corners, center
  '1:cmd,f4' : cornerOp.dup({ direction: 'bottom-left' }),
  '2:cmd,f4' : S.op('push', { direction: 'bottom', style: 'bar-resize:screenSizeY/2' }),
  '3:cmd,f4' : cornerOp.dup({ direction: 'bottom-right' }),

  '4:cmd,f4' : S.op('push', { direction: 'left', style: 'bar-resize:screenSizeX/2' }),
  '5:cmd,f4' : centerScreenOp,
  '6:cmd,f4' : S.op('push', { direction: 'right', style: 'bar-resize:screenSizeX/2' }),

  '7:cmd,f4' : cornerOp.dup({ direction: 'top-left' }),
  '8:cmd,f4' : S.op('push', { direction: 'top', style: 'bar-resize:screenSizeY/2' }),
  '9:cmd,f4' : cornerOp.dup({ direction: 'top-right' }),

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

  // Window Hints
  'esc:cmd' : S.op('hint', {
		"characters" : '1234567890QWERTYUIOP'
	})
});

// TODO: define layouts and default layout for different screen configurations
// TODO: open iterm when ctrl,~ is fired, or detect when iterm is opened, and move at predefined position

// reference .slate files
// https://github.com/dmac/dotfiles/blob/master/.slate
// https://github.com/jigish/dotfiles/blob/master/slate.js

S.log('[SLATE]: done loading config');
