module HandyForm
  module Helpers
    def handy_form_for(record_or_name_or_array, *args, &proc)
      raise ArgumentError, "Missing block" unless block_given?
      options = args.extract_options!
      merge_builder_options! options
      form_for(record_or_name_or_array, *(args << options), &proc)
    end

    def merge_builder_options!(options)
      options.merge!(:builder => HandyForm::Builder)
      options[:html] ||= {}
      options[:html][:class] = "handy-form #{options[:html][:class]}".strip
      options[:html][:novalidate] = true unless options[:html].key?(:novalidate)
    end

    def handy_field_wrapper(field, field_label, options = {})
      options[:wrapper] ||= {}
      merge_option_strings!(options[:wrapper], :class, "row")

      hint = hint_tag(options.delete(:hint))
      error = error_tag(options.delete(:error))

      unless options.delete(:input_first)
        content_tag(:div, (
          field_label.html_safe + field.html_safe +
          hint.html_safe + error.html_safe
        ), options[:wrapper]).html_safe
      else
        content_tag(:div, (field.html_safe + field_label.html_safe + hint.html_safe + error.html_safe), options[:wrapper]).html_safe
      end
    end

    def hint_tag(options)
      return "" if options.nil?
      case options
      when String
        text = options
        options = {:class => "hint"}
      when Hash
        text = options.delete(:text)
        merge_option_strings!(options, :class, "error-message")
      end

      content_tag(:div, text, options)
    end

    def error_tag(options)
      return "" if options.nil?
      case options
      when String
        text = options
        options = {:class => "error-message"}
      when Hash
        text = build_error_string(options.delete(:text))
        merge_option_strings!(options, :class, "error-message")
      end

      content_tag(:div, text, options)
    end

    protected

      def build_error_string(messages)
        if messages.size == 1
          messages.first.html_safe
        else
          content_tag :ul do
            items = "".html_safe
            messages.each do |message|
              items << content_tag(:li, message.html_safe)
            end
            items
          end
        end
      end

      def merge_option_strings!(hash, key, str)
        hash[key] = "#{str} #{hash[key]}".strip
      end
  end
end
