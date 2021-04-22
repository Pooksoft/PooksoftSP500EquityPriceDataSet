### A Pluto.jl notebook ###
# v0.14.2

using Markdown
using InteractiveUtils

# ╔═╡ 35e17eb8-a2f9-11eb-177b-d3861019871c
begin
	
	# what is my current DIR -
	_PATH_TO_ROOT = pwd()
	_PATH_TO_CONFIG = joinpath(_PATH_TO_ROOT, "config")
	_PATH_TO_DATA = joinpath(_PATH_TO_ROOT, "data")
	_PATH_TO_DALIY = joinpath(_PATH_TO_ROOT, "daily_adjusted")
	
	# activate me -
	import Pkg
	Pkg.activate(_PATH_TO_ROOT)
	Pkg.instantiate()

	# load external packages that I depend upon -
	using DataFrames
	using CSV
	using TOML
	using JSON
	using Dates
	using PooksoftAlphaVantageDataStore
	
	# should the download execute?
	_SHOULD_DOWNLOAD_EXECUTE = false
end

# ╔═╡ 216c8d63-1c67-4df3-9f4a-2a328866fced
html"""<style>
main {
    max-width: 1200px;
  	width: 70%;
	margin: auto;
}
"""

# ╔═╡ 958ca47b-4a52-4734-a93a-956c1c0a7035
begin
	
	# load the data containing the information about the SP500 companies -
	path_to_SP500_file = joinpath(_PATH_TO_DATA, "constituents.csv")
	df_SP500 = CSV.read(path_to_SP500_file, DataFrame)
end

# ╔═╡ ed933902-67e4-4a61-9f59-71bb9eccee28
begin
	
	# create a user object (we need this for the API call) -
	# note: you'll need to provide your own Configuration.json of the form:
	# {
	# 	"user_data":{
	# 		"alpha_vantage_api_email":"<YOUR EMAIL HERE>",
	# 		"alpha_vantage_api_key":"<YOUR API KEY HERE>"
	# 	}
	# }
	path_to_config_file = joinpath(_PATH_TO_CONFIG,"Configuration.json")
	
	# build the api user model -
	user_model_result = build_api_user_model(path_to_config_file)
	user_model = checkresult(user_model_result)
	
	# return nothing from this block -
	nothing
end

# ╔═╡ a1ae583c-2d7d-414b-9c74-498893a1b841
begin
	
	# let's download the daliy adjusted values for the ticker symbols in the constituents.csv file -
	# we wrap the download operation so it doesn't always execute -
	if (_SHOULD_DOWNLOAD_EXECUTE == true)
	
		# what is the current date?
		timestamp_value = "2021-04-21"
	
		# setup call -
		data_type = :csv
		outputsize = :full
	
		# get list of ticker symbols -
		list_of_ticker_symbols = df_SP500[:,1]
		for ticker_symbol in list_of_ticker_symbols
	
			# make a call to the API -
			df = execute_sts_adjusted_daily_api_call(user_model, ticker_symbol; 
				data_type = data_type, outputsize = outputsize, logger=nothing) |> checkresult
		
			# dump to the result to disk -
			results_file_name = "DA-$(ticker_symbol)-T-$(timestamp_value).csv"
			path_to_results_file = joinpath(_PATH_TO_DALIY,results_file_name)
			CSV.write(path_to_results_file, df)
		
			# because of API limitations - we need to sleep a little bit here
			sleep(30)
		end
	end
end

# ╔═╡ 04f477a8-8e29-4726-a32f-aa31f19c11e4


# ╔═╡ f2f0de67-0388-4c91-ac87-5e8f1667928f


# ╔═╡ 9ad49f6f-61a3-4f6a-84f3-fc333a670fd1


# ╔═╡ e91ac071-2dfe-4b53-8262-4516da27f87c


# ╔═╡ 6535be62-000f-4b3a-abfd-b71ad8e344c2


# ╔═╡ Cell order:
# ╟─216c8d63-1c67-4df3-9f4a-2a328866fced
# ╠═35e17eb8-a2f9-11eb-177b-d3861019871c
# ╠═958ca47b-4a52-4734-a93a-956c1c0a7035
# ╠═ed933902-67e4-4a61-9f59-71bb9eccee28
# ╠═a1ae583c-2d7d-414b-9c74-498893a1b841
# ╟─04f477a8-8e29-4726-a32f-aa31f19c11e4
# ╟─f2f0de67-0388-4c91-ac87-5e8f1667928f
# ╟─9ad49f6f-61a3-4f6a-84f3-fc333a670fd1
# ╟─e91ac071-2dfe-4b53-8262-4516da27f87c
# ╟─6535be62-000f-4b3a-abfd-b71ad8e344c2
