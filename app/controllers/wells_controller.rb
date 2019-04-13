class WellsController < ApplicationController


def index
  @wells = Well.all
  redirect_to new_well_path
end

def new
  @well = Well.new
end

def create
  # @toptvd = params[:toptvd]
  # @bottomtvd = params[:bottomtvd]
  # @gasgradient = params[:gasgradient]
  # @influxtvd = params[:influxtvd]
  # @influxpressure = params[:influxpressure]

  calculate(well_params)
end

def calculate(well_params)
  require 'uri'
  require 'net/http'

  url = URI("https://loadcasepressures.azurewebsites.net/api/v1/DisplaceToGas")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE # You should use VERIFY_PEER in production

  request = Net::HTTP::Post.new(url)
  request["Content-Type"] = 'application/json'
  request["cache-control"] = 'no-cache'
  request["Postman-Token"] = 'ab9a22c5-88a9-4e4e-a312-84d507aaf782'
  request.body = "{\r\n   \"toptvd\": \"#{well_params[:toptvd]}\",\r\n   \"bottomtvd\": \"#{well_params[:bottomtvd]}\",\r\n   
    \"gasgradient\": \"#{well_params[:gasgradient]}\",\r\n   \"influxtvd\": \"#{well_params[:influxtvd]}\",\r\n   
    \"influxpressure\": \"#{well_params[:influxpressure]}\"\r\n}\r\n"

  @response = http.request(request).body
  flash.notice = @response
  redirect_back fallback_location: new_well_path
end
#helper_method :calculate

private

def well_params
  params.require(:well).permit(:toptvd, :bottomtvd, :gasgradient, :influxtvd, :influxpressure)
end

end

