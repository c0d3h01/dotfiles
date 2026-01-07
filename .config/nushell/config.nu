# Nushell Configuration
$env.EDITOR = "nvim"

# Core Settings
$env.config = {
    show_banner: false
    edit_mode: "vi"
    buffer_editor: "nvim"

    # File operations
    rm: {
        always_trash: true
    }

    # Shell Behavior
    shell_integration: {
        osc2: true
        osc7: true
        osc8: true
        osc9_9: false
        osc133: true
        osc633: true
        reset_application_mode: true
    }

    # Cursor Shape
    cursor_shape: {
        vi_insert: line
        vi_normal: block
        emacs: line
    }

    # History
    history: {
        max_size: 100000
        sync_on_enter: true
        file_format: "sqlite"
        isolation: false
    }
}
