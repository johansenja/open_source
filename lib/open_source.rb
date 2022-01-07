# frozen_string_literal: true

require_relative "open_source/version"

module OpenSource
  class UnopenableError < StandardError; end
  class UnreachableError < StandardError; end
  class UnknownLocationError < StandardError; end
  class NoEditorError < StandardError; end

  module Public
    def open_source(obj)
      case obj.class
      when Class, Module
        case obj
        when String
          begin
            Utils.handle_constant! Object.const_get obj
          rescue NameError
            Utils.handle_method_or_name! obj
          end
        when Symbol
          Utils.handle_method_or_name! obj
        when Method, UnboundMethod
          Utils.handle_method_or_name! obj
        else
          Utils.handle_constant! obj
        end
      else
        raise UnopenableError, "Cannot open #{obj.inspect} (#{obj.class}) in an editor"
      end
    end

    # TODO: consider if any other aliases could be useful
    %i[oso].each { |m| alias_method m, :open_source }
  end

  module Utils
    module_function

    def handle_constant!(const)
      raise UnopenableError, "Cannot open an anonymous #{const.class}" unless const.class.name

      loc = Object.const_source_location const.to_s

      if !loc
        raise UnopenableError, "Cannot open #{const} in an editor"
      elsif loc.empty?
        raise UnknownLocationError, "Cannot find the location of #{const} - perhaps it is defined in native code."
      else
        open_location loc
      end
    end

    def handle_method_or_name!(meth)
      case meth
      when Symbol, String
        meth = method meth
      end

      loc = meth.source_location
      if loc
        open_location loc
      else
        raise UnknownLocationError, "Cannot find the location of #{meth} - perhaps it is defined in native code."
      end
    rescue NameError
      raise UnopenableError, "Cannot open #{meth.inspect} (#{meth.class}) in an editor"
    end

    def open_location(loc)
      file, line = loc
      command = Utils.get_command file, line
      Runner.run *command
    end

    def get_command(file, line)
      editor = ENV["EDITOR"]

      # different editors handle going to specific lines differently
      case editor
      when nil
        raise NoEditorError, "the EDITOR env variable must be set to use this feature"
      when /\s?n?vim?(\s|\z)/
        [editor, "+#{line}", file]
      when /\s?code(\s|\z)/
        [editor, "--goto", "#{file}:#{line}"]
      else
        # fallback - ignore line number
        # TODO: add support for other editors
        [editor, file]
      end
    end

    class Runner
      def self.run(*cmd)
        system *cmd
      end
    end
  end
end

include OpenSource::Public
