class NodesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_node, only: [:show]

  # GET /nodes/1
  def show
  end

  private
    def set_node
      @node = Node.find(params[:id])
    end
end
