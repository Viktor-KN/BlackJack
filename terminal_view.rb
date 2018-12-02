class TerminalView
  def render(data)
    type = "render_#{data[:type]}".to_sym
    if data.key?(:params)
      send type, data[:params]
    else
      send type
    end
  end

  def render_variants(variants)
    rendered_data = ''
    variants.each.with_index(1) do |var, index|
      rendered_data += "#{index}.\t#{var[:title]}\n"
    end
    rendered_data
  end

  private

  def render_new_round
    "\n\n----------------- new round ----------------------"
  end

  def render_end_round
    "----------------- round end ----------------------"
  end

  def render_player_info(params)
    format("%<player>s\n  Cards: %<cards>-12sPoints: %<points>-4sBet: %<bet>-6s" \
           "Balance: %<balance>s\n", **params)
  end
end
