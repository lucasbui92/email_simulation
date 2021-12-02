# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @presenter = presenter(object: Email.all, current_user: current_user)
  end
end
