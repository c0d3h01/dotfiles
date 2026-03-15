let has_direnv = not (which direnv | is-empty)
use std/config *

if $has_direnv {
    $env.config.hooks.env_change.PWD = ($env.config.hooks.env_change.PWD? | default [])
    $env.config.hooks.env_change.PWD ++= [{||
        direnv export json | from json | default {} | load-env
        $env.PATH = do (env-conversions).path.from_string $env.PATH
    }]
}
