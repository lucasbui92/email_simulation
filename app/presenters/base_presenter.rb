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

  private

  def self.presents(name)
    define_method(name) do
      @object
    end
  end

  def h
    @template
  end

  def method_missing(*args, &block)
    @template.send(*args, &block)
  end

  def current_user
    @current_user ||= args[:current_user]
  end

  def params
    @params ||= args[:params]
  end
end
