module Moon
  # Mixin for defining special shared, class-attributes
  # These attributes are available down the class line, and each child can
  # add their own values to the attribute, without breaking the parent.
  # prototype attributes are however, collective, they are an Array or Hash
  # of values that can be merged to together to form one collection.
  module Prototype
    # Patches options given to a prototype_attr method
    # @param [Hash<Symbol, Object>] options
    # @return [Hash<Symbol, Object>]
    # @api private
    def self.adjust_options(options)
      result = options.dup
      # if no type was given, assume that its an Array
      unless result.key?(:type)
        result[:type] = Array
      end

      # If a type was given, but no default, create a default using the type
      if result.key?(:type) && !result.key?(:default)
        result[:default] = proc { result[:type].new }
      end

      # obtain the default value
      v = result[:default]
      # create default proc
      result[:default] = v.is_a?(Proc) ? v : (proc { v })

      result
    end

    # @param [String, Symbol] singular_name
    # @return [Symbol]
    # @api private
    def self.plural_sym(singular_name)
      singular_name.to_s.pluralize.to_sym
    end

    # @param [String, Symbol] singular_name
    # @return [Symbol]
    # @api private
    def self.varname_sym(singular_name)
      "@__prototype_#{plural_sym(singular_name)}__".to_sym
    end

    # @param [String, Symbol] singular_name
    # @return [Symbol]
    # @api private
    def self.collective_sym(singular_name)
      #"my_#{plural_sym(singular_name)}".to_sym
      # originally I planned to name each instance level attr as my_<name>,
      # but it seems unusual on the userside of things.
      "#{plural_sym(singular_name)}".to_sym
    end

    # @param [String, Symbol] singular_name
    # @return [Symbol]
    # @api private
    def self.enum_sym(singular_name)
      "each_#{singular_name}".to_sym
    end

    # @param [String, Symbol] singular_name
    # @return [Symbol]
    # @api private
    def self.all_sym(singular_name)
      "all_#{plural_sym(singular_name)}"
    end

    # @param [Hash, Array] target
    # @param [Array] value
    # Utility method for concat-ing arrays or hashes together
    def self.conj!(target, values)
      if target.is_a?(Hash)
        values.each do |value|
          target[value[0]] = value[1]
        end
      else
        target.concat(values)
      end
    end

    # @param [Symbol] singular_name
    # @param [Hash<Symbol, Object>] options
    # @return [Symbol]
    # @api private
    private def define_prototype_enum(singular_name, options)
      my_name = Prototype.collective_sym singular_name
      enum_name = Prototype.enum_sym singular_name

      define_method enum_name do |&block|
        # if the block given is invalid, return an Enumerator instead
        return to_enum __method__ unless block
        # call each instance prototype_attr
        prototype_call my_name do |objs|
          objs.each do |*a|
            block.call(*a)
          end
        end
      end
    end

    # @param [Symbol] singular_name
    # @param [Hash<Symbol, Object>] options
    # @return [Symbol]
    # @api private
    private def define_prototype_instance_collection(singular_name, options)
      plural_name = Prototype.plural_sym singular_name
      variable_name = Prototype.varname_sym singular_name
      my_name = Prototype.collective_sym singular_name

      default = options.fetch(:default)
      define_method my_name do
        var = instance_variable_get variable_name
        if var.nil?
          var = default.call
          instance_variable_set variable_name, var
        end
        var
      end
    end

    private def define_prototype_all_collection(singular_name, options)
      # all prototype attributes
      all_name = Prototype.all_sym singular_name
      enum_name = Prototype.enum_sym singular_name
      type = options.fetch(:type)
      define_method all_name do
        result = type.new
        send(enum_name).each do |*a|
          Prototype.conj!(result, a)
        end
        result
      end
    end

    # Calls `method` on each ancestor and yields the result of the method.
    # The ancestor is skipped if it does not respond_to? +method+
    #
    # @param [String, Symbol] method
    # @yieldparam [Object] result from call
    def prototype_call(method)
      return to_enum :prototype_call, method unless block_given?

      ancestors.reverse_each do |klass|
        yield klass.send(method) if klass.respond_to?(method)
      end
    end

    # Prototype attributes are Arrays (by default) of values which belong
    # to a set of classes.
    # They are not class variables which are shared by the entire ancestor line.
    # Several methods are created when a prototype_attr is created.
    # A pluralized form of the given `singular_name` is created to denote
    # the current class values.
    # all_<plural> for all values in the current class line
    # each_<singular> for iterating all values
    #
    # @param [String, Symbol] singular_name
    # @param [Hash<Symbol, Object>] options
    # @option options [Class] :type  what type of prototype_attr is this?
    # @option options [Proc, Object] :default  default constructor for new prototypes
    # @return [void]
    #
    # @example
    #   prototype_attr :field
    #   fields     #=> []
    #   all_fields #=> []
    #   each_field do |f|
    #     # do stuff
    #   end
    def prototype_attr(singular_name, options = {})
      options = Prototype.adjust_options(options)
      define_prototype_instance_collection singular_name, options
      define_prototype_enum singular_name, options
      define_prototype_all_collection singular_name, options
    end
  end
end
