# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @emails = Email.all
  end
end
