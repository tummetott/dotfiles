local M = {}

local color_aliases = {
    background      = { "base00" },
    darkest_grey    = { "base01" },
    dark_grey       = { "base02" },
    grey            = { "base03" },
    bright_grey     = { "base04" },
    foreground      = { "base05" },
    bright_white    = { "base06" },
    brightest_white = { "base07" },
    red             = { "base08" },
    bright_red      = { "base12", "base08" },
    orange          = { "base09" },
    yellow          = { "base0A" },
    bright_yellow   = { "base13", "base0A" },
    green           = { "base0B" },
    bright_green    = { "base14", "base0B" },
    cyan            = { "base0C" },
    bright_cyan     = { "base15", "base0C" },
    blue            = { "base0D" },
    bright_blue     = { "base16", "base0D" },
    purple          = { "base0E" },
    bright_purple   = { "base17", "base0E" },
    dark_red        = { "base0F" },
}

local function blend(fg, bg, a)
  local function c(x)
    return tonumber(x, 16)
  end

  local fr, fg_, fb = fg:match("^#(%x%x)(%x%x)(%x%x)$")
  local br, bg_, bb = bg:match("^#(%x%x)(%x%x)(%x%x)$")

  local function m(f, b)
    return math.floor(a * f + (1 - a) * b + 0.5)
  end

  return string.format(
    "#%02X%02X%02X",
    m(c(fr), c(br)),
    m(c(fg_), c(bg_)),
    m(c(fb), c(bb))
  )
end

local function darken(hex, amount, bg)
  return blend(hex, bg, 1 - math.abs(amount))
end

local function lighten(hex, amount, fg)
  return blend(hex, fg, 1 - math.abs(amount))
end

local function resolve_alias(name, palette)
    local keys = color_aliases[name]
    if not keys then
        return nil
    end

    for _, key in ipairs(keys) do
        local value = palette[key]
        if value then
            return value
        end
    end

    return nil
end

local function resolve_color(expr, palette)
    if type(expr) == "string" then
        return resolve_alias(expr, palette) or expr
    end

    if type(expr) == "table" then
        if expr.darken then
            local color = resolve_color(expr.darken, palette)
            return darken(color, expr.amount, palette.base00)
        end

        if expr.lighten then
            local color = resolve_color(expr.lighten, palette)
            return lighten(color, expr.amount, palette.base05)
        end
    end

    return expr
end

function M.resolve_hl(spec, palette)
    local out = {}
    for k, v in pairs(spec) do
        if k == "fg" or k == "bg" or k == "sp" then
            out[k] = resolve_color(v, palette)
        else
            out[k] = v
        end
    end
    return out
end

function M.collect_highlights()
    local plugins = require("lazy.core.config").plugins
    local res = {}
    for _, plugin in pairs(plugins) do
        if plugin.highlights then
            for group, spec in pairs(plugin.highlights) do
                res[group] = spec
            end
        end
    end
    return res
end

function M.load_alias_colors()
    local ok, tinted = pcall(require, "tinted-colorscheme")
    if not ok or not tinted or not tinted.colors then
        return false
    end
    local palette = tinted.colors
    local out = {}
    for alias, keys in pairs(color_aliases) do
        for _, key in ipairs(keys) do
            local color = palette[key]
            if color then
                out[alias] = color
                break
            end
        end
    end
    return out
end

return M
