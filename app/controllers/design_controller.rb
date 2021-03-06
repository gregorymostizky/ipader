#encoding: utf-8

require 'ostruct'
require 'net/smtp'


class DesignController < ApplicationController

  def index
    process_params
  end

  def live
    process_params
    @layer_url = "/design/layer?" + @params.map { |k, v| "#{k}=#{CGI.escape(v || '')}" }.join('&')
    @layer_url += '&layer='+params[:layer] + "&mode=live"
    page = :cnn
    page = :kake_sport if params[:layer] =~ /mobile/
    render page, :layout => false
  end

  def email
    process_params
    @layer_url = "http://" + request.ip
    @layer_url += ":#{request.port}" if request.port
    @layer_url += "/design/live?" + @params.map { |k, v| "#{k}=#{CGI.escape(v || '')}" }.join('&')
    @layer_url += '&layer='+params[:layer]

    email = params[:email] || 'gregory.mostizky@kontera.com'
    Notifier.welcome_email(@layer_url, email).deliver

    render 'index'
  end

  def layer
    process_params
    @mode = :live if params[:mode]
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

