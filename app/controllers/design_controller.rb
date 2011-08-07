#encoding: utf-8

require 'ostruct'

class DesignController < ApplicationController

  def index
    process_params
  end

  def live
    process_params
    @layer_url = "/design/layer?" + @params.map { |k, v| "#{k}=#{CGI.escape(v)}" }.join('&')
    @layer_url += '&layer='+params[:layer]
    render :foxnews, :layout => false
  end

  def layer
    process_params
    render :partial => "layer_" + @layer_name, :layout => false
  end

  #### ihs
  def balls
    render 'balls', :layout => false
  end

  protected

  def process_params
    @layer_name = (params[:layer] || 'text')
    layer_source = view_context.lookup_context.find("_layer_"+@layer_name, 'design').source # hack hack hack
    all_params = layer_source.scan(/@params\[['"](\w+)['"]\]/).flatten # hack hack 2

    @params = {}

    all_params.each do |k|
      # do we need to provide a file ?
      if k =~ /_file$/

        # we actually have a file to save
        if params[k] && params[k].class != String
          file = params[k]
          filename = '/upload/' + file.original_filename
          FileUtils.copy(file.tempfile, Rails.root.to_s + '/public' + filename)

            #point UI at saved file
          @params[k] = filename

        # we have prev. uploaded file
        elsif params[k+'_uploaded'] || params[k].class == String
          file_url = params[k+'_uploaded'] || params[k]
          @params[k] = file_url
        end

        # normal (non-file) parameter
      else
        unless params[k].blank?
          @params[k] = params[k]
        else
          @params[k] = nil
        end
      end

    end

  end
end
