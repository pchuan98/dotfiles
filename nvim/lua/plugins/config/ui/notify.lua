return {
    -- DEBUG ERROR INFO TRACE WARN OFF
    level = vim.log.levels.DEBUG,
    timeout = 1000,

    max_height = function()
        return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
        return math.floor(vim.o.columns * 0.75)
    end,

    -- default | minimal | simple | compact | wrapped-compact
    render = "default",

    -- fade_in_slide_out | fade | slide | static
    stages = "fade",

    background_colour = "#000000",
    top_down = true,
    fps = 60
}
