module React
  module Component
    module Features
      def Fragment(props = `null`, &block)
        %x{
          var children = null;
          var block_result = null;
          var native_props = null;
          Opal.React.render_buffer.push([]);
          if (props) {
            native_props = #{to_native_react_props(props)};
          }
          if (block !== nil) {
            block_result = block.$call()
            if (block_result && (#{`block_result` != nil})) {
              Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(block_result);
            }
          }
          var react_element = React.createElement(React.Fragment, native_props, Opal.React.render_buffer.pop());
          Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(react_element);
          return null;
        }
      end

      def Portal(dom_node, &block)
        %x{
          var children = null;
          var block_result = null;

          Opal.React.render_buffer.push([]);
          if (block !== nil) {
            block_result = block.$call()
            if (block_result && (#{`block_result` != nil})) {
              Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(block_result);
            }
          }
          var react_element = React.createPortal(Opal.React.render_buffer.pop(), dom_node);
          Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(react_element);
          return null;
        }
      end

      def StrictMode(props = `null`, &block)
        %x{
          var children = null;
          var block_result = null;
          var native_props = null;
          Opal.React.render_buffer.push([]);
          if (props) {
            native_props = #{to_native_react_props(props)};
          }
          if (block !== nil) {
            block_result = block.$call()
            if (block_result && (#{`block_result` != nil})) {
              Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(block_result);
            }
          }
          var react_element = React.createElement(React.StrictMode, native_props, Opal.React.render_buffer.pop());
          Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(react_element);
          return null;
        }
      end
    end
  end
end
