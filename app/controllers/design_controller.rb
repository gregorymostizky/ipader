require 'ostruct'

class DesignController < ApplicationController

  def index
    @layer_name = (params[:layer] || 'text')
    layer_source = view_context.lookup_context.find("_layer_"+@layer_name,'design').source # hack hack hack
    all_params = layer_source.scan(/@params\[['"](.*)['"]\]/).flatten # hack hack 2

    @params = {}
    all_params.each do |k|
      @params[k] = params[k] || ''
    end
  end

end
