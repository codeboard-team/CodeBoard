class HomeController < ApplicationController
  def index
    unless session["login_type"]
      session["login_type"] = 'local'
    end
    puts session["login_type"]
  end
end
