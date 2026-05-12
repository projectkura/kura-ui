# kura-ui

`kura-ui` is the shared NUI layer for Project Kura.

It currently ships:

- a single always-loaded UI runtime
- a shared overlay registry for multiple resources
- reusable controls hints like `ESC Back`
- client ownership cleanup on resource stop
- server relay helpers for target-player HUD overlays

## Requirements

- FXServer / FiveM
- `kura-lib`
- `kura-core`
- Bun, if you are building from source

## Installation

Do not use GitHub's source ZIP for server installs. Use the packaged release instead.

1. Download the latest release from the repository releases page.
2. Extract it into your `resources` directory.
3. Ensure the folder is named `kura-ui`.
4. Add it to your `server.cfg` after `kura-core`.

```cfg
ensure kura-lib
ensure kuradb
ensure kura-core
ensure kura-ui
```

## Usage

For Kura-native resources, add this to your `fxmanifest.lua`:

```lua
shared_scripts {
    '@kura-core/init.lua',
}
```

Then use `kura.ui` in your resource:

```lua
local ui <const> = kura.ui

if not ui then
    return
end

ui.controls.show({
    id = 'garage:navigation',
    anchor = 'bottom-right',
    items = {
        { input = 'ESC', label = 'Back' },
        { input = 'ENTER', label = 'Select' },
    },
})
```

The current public API is:

- `ui.controls.show(data)`
- `ui.controls.update(id, patch)`
- `ui.controls.hide(id)`
- `ui.controls.clear()`
- `ui.controls.exists(id)`
- `ui.controls.showFor(targets, data)`
- `ui.controls.updateFor(targets, id, patch)`
- `ui.controls.hideFor(targets, id)`
- `ui.controls.clearFor(targets)`

## Build From Source

```sh
bun install
bun run build
```

Useful local commands:

```sh
bun run lint
bun run check
bun run dev:web
bun run dev:game
```

## Documentation

Full docs:

- https://kura.walteria.net/docs/kura-ui
- https://kura.walteria.net/docs/kura-ui/controls
