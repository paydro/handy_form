module HandyForm
  class Builder < ::ActionView::Helpers::FormBuilder
    (
      # select tags need reworking - 3rd argument is specific to select
      ["select", "date_select", "datetime_select"] +
      field_helpers -
      ["form_for", "fields_for", "apply_form_for_options!",
      "label", "hidden_field"]
    ).each do |selector|
      define_method(selector) do |method, *args|
        options = args.extract_options!

        # Remove the handy-related options from the above options
        # This will keep the handy_options from being displayed when the
        # field is composed below.
        handy_options = extract_handy_options!(options)

        # Build the field as if it weren't modified, allowing HandyForm to use
        # whatever Rails decides is the representation of the current field.
        # This allows Rails to be upgraded without HandyForm breaking.
        field = super(method, *(args << options))

        # Build the label for the field as well. Again, we let Rails handle
        # this.
        field_label = build_label(method, handy_options.delete(:label))

        # If checkbox or radio, place input first
        if field_first?(selector) && !handy_options.has_key?(:input_first)
          handy_options[:input_first] = true
        end

        # Add the selector (input type) to the wrapper so that
        # CSS rules can target the whole row.
        add_selector_to_wrapper_class!(selector, handy_options)

        # Add any error messages to handy options.
        if object.errors[method.to_s].any?
          add_errors!(method, handy_options)
        end

        # Now combine everything!
        @template.handy_field_wrapper(field, field_label, handy_options)
      end
    end

    # Allows this all handy_form_for objects to behave like the normal form
    # builder in partials.
    #
    # e.g., this will use the "_form.html.erb" partial in the current view
    # directory.
    #   <%= handy_form_for(@user) do |f| %>
    #     <%= render :partial => f %>
    #   <% end %>
    #
    def self.model_name
      @model_name ||= Struct.new(:partial_path).new("form")
    end

    def extract_handy_options!(options)
      options.extract!(:error, :hint, :label, :wrapper, :input_first)
    end

    # Build's a label for the given ActiveModel method
    #
    # When options = false, then no label is built
    # When options is a string, then the value for the label is the string
    # When options is a hash, hash[:text] will become the value for the label
    # and all other options are passed into Rails' label builder.
    # Otherwise, the label is built off of the method.
    def build_label(method, options)
      return "" if options == false

      text = nil
      label_options = {}

      text = method.to_s.humanize
      case options
      when String
        text = options
      when Hash
        if !options[:text].blank?
          text = options.delete(:text)
        end
        label_options = options
      end

      label(method, text, label_options)
    end
    alias_method :label_for, :build_label

    def errors_for(method, options = {})
      return "" unless object.errors[method.to_s].any?
      add_errors!(method, options)
      @template.error_tag(options[:error])
    end

    def hint(method, options = {})
      @template.hint_tag(options)
    end

    protected

      def field_first?(selector)
        ["check_box", "radio_button"].include?(selector.to_s)
      end

      def add_selector_to_wrapper_class!(selector, options = {})
        options[:wrapper] ||= {}

        # This allows for CSS targeting for selector types
        options[:wrapper][:class] = "#{selector}_row " +
                                    "#{options[:wrapper][:class]}"

        options[:wrapper][:class].strip!
      end

      def add_errors!(method, options)
        return if object.errors[method.to_s].empty?

        options[:wrapper] ||= {}
        options[:wrapper][:class] = "error #{options[:wrapper][:class]}".strip

        case options[:error]
        when nil
          options[:error] = {}
          options[:error][:text] = object.errors[method.to_s]
        when Hash
          options[:error][:text] = object.errors[method.to_s]
        when String
          options[:error] = {:text => [options[:error]]}
        when Array
          options[:error] = {:text => options[:error]}
        else
          raise "Unknown error type #{options[:error].inspect} " +
                "for :error option"
        end
        options[:error] ||= {}
      end
  end
end
