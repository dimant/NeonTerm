# NeonTerm

This is a serial terminal which when used protects you mistreating the Neon816 serial port. Currently the serial port on the Neon816s
starts skipping characters when you send text to it. This may happen if you are copy&pasting code for example. The terminal buffers 
text which is put into the console and sends it to the serial port at a slower rate. Another thing the terminal does is it bails out
if it recognizes a failure on the Neon816. The reason for this is that if your paste caused an error, you want to stop pasting 
immediately.

## Setup
The terminal is written in dotnet core so it should work on all platforms but it was tested only on Windows. The recommended workflow
is:
1. Install the [.Net Core SDK](https://dotnet.microsoft.com/download)
2. Build NeonTerm by typing `dotnet build` in the folder containing `NeonTerm.sln`
3. Get [Visual Studio Code](https://code.visualstudio.com/)
4. Get the [Macros](https://marketplace.visualstudio.com/items?itemName=geddski.macros) extension.
5. Setup a macros to send single lines and selections to the VSCode terminal window.
6. Optionally install [Fort syntax highlighting](https://marketplace.visualstudio.com/items?itemName=fttx.language-forth)

My "send line" macro looks like this:

```
    "macros": {
        "execCurLn": [
            "expandLineSelection",
            "workbench.action.terminal.runSelectedText",
            "cancelSelection"
        ]
    },
```

Put this in your VSCode `settings.json` file (File | Preferences | Settings | Open Settings JSON - top right corner).

A few keybindings make interacting with the terminal a little more convenient:

```
    {
        "key": "ctrl+enter",
          "command": "workbench.action.terminal.runSelectedText",
            "when": "editorTextFocus && editorHasSelection"
    },
    {
        "key": "ctrl+enter",
          "command": "macros.execCurLn",
            "when": "editorTextFocus && !editorHasSelection"
    },
    { "key": "ctrl+`", "command": "workbench.action.terminal.focus"},
    { "key": "ctrl+`", "command": "workbench.action.focusActiveEditorGroup", "when": "terminalFocus"}
```

These go in the VSCode `keybindings.json` file (File | Preferences | Keyboard Shortcuts | Open Keyboard Shortcuts JSON - top right corner.)

You can open a VSCode terminal window either by going to View | Terminal or by pressing Ctrl + `.