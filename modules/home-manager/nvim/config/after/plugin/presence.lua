local function logo()
  return 'vim' .. math.random(0, 12)
end

require 'neocord'.setup {
  client_id        = "1186049908009074729",
  logo             = logo(),
  logo_tooltip     = "uwu",
  main_image       = "logo",
  show_time        = true,
  debounce_timeout = 2,
}
