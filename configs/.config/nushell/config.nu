# Nushell Configuration
$env.EDITOR = "nvim"

# Core Settings
$env.config = {
    show_banner: false
    edit_mode: "vi"
    buffer_editor: "nvim"
    use_ansi_coloring: true
    bracketed_paste: true
    render_right_prompt_on_last_line: false

    # File operations
    rm: {
        always_trash: true
    }

    # Built-in ls/cd behavior
    ls: {
        use_ls_colors: true
        clickable_links: true
    }
    cd: {
        abbreviations: true
    }

    # Completion engine
    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
        external: {
            enable: true
            max_results: 200
            completer: null
        }
    }

    # Table/view defaults for large dev outputs
    table: {
        mode: rounded
        index_mode: auto
        show_empty: true
        padding: { left: 1, right: 1 }
        trim: {
            methodology: wrapping
            wrapping_try_keep_words: true
            truncating_suffix: "..."
        }
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

    # Better defaults for scripts/output
    filesize: {
        metric: true
        format: "auto"
    }
}
