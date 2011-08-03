require 'ostruct'

class DesignController < ApplicationController

  def index
    @layer_name = (params[:layer] || 'text')
    layer_source = view_context.lookup_context.find("_layer_"+@layer_name,'design').source # hack hack hack
    all_params = layer_source.scan(/@params\[['"](\w+)['"]\]/).flatten # hack hack 2

    @params = {}
    p all_params

    all_params.each do |k|
      unless params[k].blank?
        @params[k] = params[k]
      else
        @params[k] = nil
      end
    end
  end

end
