# typed: strict
# frozen_string_literal: true

# This module is pulled from Interactor gem to standardize Service level
# communication.
#
# Key Differences:
# - Params must be an explicit named hash. Improves testing.
# - Removes rollback, Orchestration
#
# Similar:
# - Returns a context

# Potential Improvements:
# - Create a `.fail` method that does not immediately throw
# - Optional transaction wrapper which can handle .fail

module BaseService
  def self.included(base)
    base.class_eval do
      include ActiveModel::Validations
      extend Aspectable

      class << self
        def call(params = {})
          new(params).tap { |r| r.run(params) }.context
        end

        def call!(params = {})
          new(params).tap { |r| r.run!(params) }.context
        end
      end

      attr_reader :context
    end
  end

  # rubocop:disable Style/OpenStructUse
  class Context < OpenStruct
    def initialize
      @failure = false

      super
    end

    def success?
      !failure?
    end

    def failure?
      @failure
    end

    # rubocop:disable Style/RaiseArgs
    def fail!(data = {})
      before_fail

      data.each { |key, value| self[key] = value }
      @failure = true
      raise Failure.new(self)
    end

    # Rolls subservice calls together, and if there's a failure in a lower one, roll it higher
    def merge(subservice_context)
      subservice_context.each_pair do |k, v|
        self[k] = v
      end

      return unless subservice_context.failure?

      # We explicitly don't halt. Let .call! perform halts. Less magic, more explicit
      @failure = true
    end
    alias << merge

    def flash_msg(on_success:)
      if success?
        on_success
      else
        { error: self[:message] }
      end
    end
  end

  class Failure < StandardError
    attr_reader :context

    def initialize(context = nil)
      @context = context

      super
    end
  end

  def initialize(params = {})
    @context = Context.new
    params.each { |key, value| instance_attribute(key, value) }

    after_initialize
  end

  def after_initialize
    # Hook like method for binding instance listeners, Wisper.
  end

  def before_fail
    # Hook like method for binding instance listeners, Wisper.
  end

  def run(params = {})
    begin
      run!(params)
    rescue ActiveModel::ValidationError, ActiveRecord::RecordInvalid => e
      @context.message = e.message
      @context.fail!
    end
  rescue Failure => e
    ensure_failure_rollup(e)
    collect_error_message(e)

    self
  end

  def run!(params = {})
    if params.present?
      params.each { |k, v| @context[k] = v }

      validate_service! # We want context loaded with params

      call(**params)
    else
      validate_service!

      call
    end

    context_collect_ar_object_errors

    self
  end

  private

  def validate_service!
    return if valid?

    @context.message = errors.full_messages.to_sentence
    @context.fail!
  end

  def instance_attribute(key, value)
    raise 'Cannot use context as params' if key == :context

    self.class.send(:attr_reader, key)
    instance_variable_set("@#{key}", value)
  end

  # A failure was raised, but if it was not this level context, then it
  # came from a child and we need to merge contexts and roll the failure up.
  #
  # Example
  #   When a service calls another service via .call! and that sub-service performs .fail!
  def ensure_failure_rollup(error)
    return if @context.failure? == true

    # I purprosely didn't expose this. Right move?
    @context.instance_variable_set('@failure', true)

    # Merge contexts
    error.context.each_pair do |k, v|
      @context[k] = v
    end
  end

  # Checks if context items respond to .error & if there are any.
  # For ActiveRecord items only
  # TODO: Allow handling of [ARObject, ARObject]
  def context_collect_ar_object_errors
    has_failures = false
    ar_error_sentence = ''
    @context.each_pair do |_, obj|
      next if !obj.is_a?(ApplicationRecord) || obj.errors.blank?

      ar_error_sentence = join_messages([ar_error_sentence, obj.errors.full_messages.to_sentence])
      has_failures = true
    end

    return unless has_failures

    @context.ar_error_sentence = ar_error_sentence
    @context.fail!
  end

  def collect_error_message(error)
    @context.message = join_messages(
      [
        error.context.message,
        error.context.ar_error_sentence,
        @context.message
      ]
    )

    @context.error_message = @context.message
  end

  def join_messages(messages)
    messages.uniq.reject(&:blank?).join(' ')
  end
end
