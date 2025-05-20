$env.config = {
  hooks: {
    pre_prompt: [{ ||
      if (which direnv | is-empty) {
        return
      }

      direnv export json | from json | default {} | load-env
      if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
        $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
      }
    }]
  }
}

let pywal_bg = sys | get env.color0
let pywal_fg = sys | get env.color7
let pywal_red = sys | get env.color1
let pywal_green = sys | get env.color2
let pywal_yellow = sys | get env.color3
let pywal_blue = sys | get env.color4
let pywal_magenta = sys | get env.color5
let pywal_cyan = sys | get env.color6
let pywal_light_black = sys | get env.color8
let pywal_light_red = sys | get env.color9
let pywal_light_green = sys | get env.color10
let pywal_light_yellow = sys | get env.color11
let pywal_light_blue = sys | get env.color12
let pywal_light_magenta = sys | get env.color13
let pywal_light_cyan = sys | get env.color14
let pywal_white = sys | get env.color15

$env.config = {
  # Base colors
  background: $pywal_bg.value.to_string,
  foreground: $pywal_fg.value.to_string,

  # Accent colors
  red: $pywal_red.value.to_string,
  green: $pywal_green.value.to_string,
  blue: $pywal_blue.value.to_string,
  yellow: $pywal_yellow.value.to_string,
  magenta: $pywal_magenta.value.to_string,
  cyan: $pywal_cyan.value.to_string,
  gray: $pywal_light_black.value.to_string, # You might adjust this
  light_gray: $pywal_white.value.to_string, # You might adjust this

  # Theme settings for various elements
  table: {
    frame: $pywal_light_black.value.to_string,
    separator: $pywal_light_black.value.to_string,
    header: {
      text: $pywal_light_blue.value.to_string,
      style: bold
    },
    row_index: {
      text: $pywal_green.value.to_string,
      style: ""
    },
  },
  # ... other theme configurations (e.g., prompt, menu, etc.) ...
}
