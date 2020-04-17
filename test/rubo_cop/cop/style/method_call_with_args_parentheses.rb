module RuboCop
  module Cop
    module Style
      class MethodCallWithArgsParentheses < Cop
        private

        # Only skip checking ignored methods if they are macros or not within any class/module
        alias _add_offense_for_require_parentheses add_offense_for_require_parentheses
        def add_offense_for_require_parentheses(node)
          return if ignored_method?(node.method_name) &&
            (node.macro? || node.parent_module_name == Object.name)
          return if matches_ignored_pattern?(node.method_name)
          return if eligible_for_parentheses_omission?(node)
          return unless node.arguments? && !node.parenthesized?

          add_offense(node)
        end

        # Always check macros in blocks (unless the method is ignored)
        alias _ignored_macro? ignored_macro?
        def ignored_macro?(node)
          if node.parent_module_name.nil?
            false
          else
            _ignored_macro?(node)
          end
        end
      end
    end
  end
end
