module React
  module PropsConverters
    def lower_camelize(snake_cased_word)
      %x{
        var words = snake_cased_word.split("_");
        if (words.length == 1) { return words[0]; }

        var other_words = words.slice(1, words.length);
        var other_length = other_words.length;
        for (var i = 0; i < other_length; i++) {
          other_words[i] = other_words[i].charAt(0).toUpperCase() + other_words[i].slice(1);
        }
        return words[0] + other_words.join("");
      }
    end

    def to_native_react_props(ruby_style_props)
      %x{
        var result = {};
        var keys = ruby_style_props.$keys();
        var keys_length = keys.length;
        for (var i = 0; i < keys_length; i++) {
          if (keys[i].startsWith("on_")) {
            result[#{lower_camelize(`keys[i]`)}] = #{@native.JS[ruby_style_props[`keys[i]`]]};
          } else if (keys[i].startsWith("aria_")) {
            result[keys[i].replace("_", "-")] = #{ruby_style_props[`keys[i]`]};
          } else {
            result[#{lower_camelize(`keys[i]`)}] = #{ruby_style_props[`keys[i]`]};
          }
        }
        return result;
      }
    end
  end
end
