#encoding: utf-8

require 'ostruct'

class DesignController < ApplicationController

  def index
    process_params
  end

  def live
    process_params
    @layer_url = "/design/layer?" + @params.map { |k,v| "#{k}=#{CGI.escape(v)}" }.join('&')
    @layer_url += '&layer='+params[:layer]
    render :foxnews, :layout => false
  end

  def layer
    process_params
    render :partial => "layer_" + @layer_name, :layout => false
  end

  protected

  def process_params
    @layer_name = (params[:layer] || 'text')
    layer_source = view_context.lookup_context.find("_layer_"+@layer_name,'design').source # hack hack hack
    all_params = layer_source.scan(/@params\[['"](\w+)['"]\]/).flatten # hack hack 2

    @params = {}

    all_params.each do |k|
      unless params[k].blank?

        if k =~ /file$/
          # we got a file we need to save
          file = params[k]
          filename = '/upload/' + file.original_filename
          FileUtils.copy(file.tempfile, Rails.root.to_s + '/public' + filename)

          #point UI at saved file
          @params[k] = filename
        else
          @params[k] = params[k]
        end
      else
        @params[k] = nil
      end
    end
  end
end
