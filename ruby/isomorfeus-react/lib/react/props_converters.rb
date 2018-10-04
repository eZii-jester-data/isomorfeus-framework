module React
  module PropsConverters
    def lower_camelize(snake_cased_word)
      `Opal.React.lower_camelize(snake_cased_word)`
    end

    def to_native_react_props(ruby_style_props)
      %x{
        var result = {};
        var keys = ruby_style_props.$keys();
        var keys_length = keys.length;
        for (var i = 0; i < keys_length; i++) {
          if (keys[i].startsWith("on_")) {
            result[Opal.React.lower_camelize(keys[i])] = #{@native.JS[ruby_style_props[`keys[i]`]]};
          } else if (keys[i].startsWith("aria_")) {
            result[keys[i].replace("_", "-")] = #{ruby_style_props[`keys[i]`]};
          } else {
            result[Opal.React.lower_camelize(keys[i])] = #{ruby_style_props[`keys[i]`]};
          }
        }
        return result;
      }
    end
  end
end
