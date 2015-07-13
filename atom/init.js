var path = require('path');
var childProcess = require('child_process');

// $PATH is not available on OSX GUI apps when not launched from CLI
// this is default behavior of any OSX GUI app
// see https://github.com/AtomLinter/Linter/issues/726
// see https://github.com/AtomLinter/Linter/issues/150

// manually fix missing path on OSX
if (process.platform === 'darwin') {
  process.env.PATH = childProcess.execFileSync(
    process.env.SHELL,
    ['-c', 'echo $PATH']).toString().trim();
}
