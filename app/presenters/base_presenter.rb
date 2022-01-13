# frozen_string_literal: true

class BasePresenter
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActionView::Helpers
  include Rails.application.routes.url_helpers

  attr_reader :args

  def initialize(template, **args)
    @template = template
    @object = args[:object] if args[:object]
    @args = args
  end

  class << self
    private

    def presents(name)
      define_method(name) do
        @object
      end
    end
  end

  private

  def h
    @template
  end

  def method_missing(...)
    @template.send(...)
  end

  def respond_to_missing?(...)
    @template.send(...)
  end

  def current_user
    @current_user ||= args[:current_user]
  end

  def params
    @params ||= args[:params]
  end
end
