### A Pluto.jl notebook ###
# v0.14.4

using Markdown
using InteractiveUtils

# ╔═╡ 9770ad46-aa7b-11eb-3d74-3f168a479469
begin
	
	# what is my current DIR -
	_PATH_TO_ROOT = pwd()
	_PATH_TO_CONFIG = joinpath(_PATH_TO_ROOT, "config")
	_PATH_TO_DATA = joinpath(_PATH_TO_ROOT, "data")
	_PATH_TO_WEEKLY = joinpath(_PATH_TO_ROOT, "weekly_adjusted")
	
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
	
	# this block returns ...
	nothing
end

# ╔═╡ 08e679b8-2e69-42b2-8531-ca95ab8bf6b5
html"""<style>
main {
    max-width: 1200px;
  	width: 70%;
	margin: auto;
}
"""

# ╔═╡ f77c4667-5d7a-4f74-8f06-555424505957
md""" #### Create an Alphavantage USER object

We use the [Alphavantage.co](https://www.alphavantage.co) financial data API for pricing information. To use this API,
we need to create a user object which holds the credentials needed for the Alphavantage API call. We create this object using the `build_api_user_model` method which takes the path to a JSON configuration file e.g. `Configuration.json` of the form:

	{
		\"user_data\":{
			"alpha_vantage_api_email":"<YOUR EMAIL HERE>",
	 		"alpha_vantage_api_key":"<YOUR API KEY HERE>"
		}
	}


"""

# ╔═╡ 5a561360-4a64-4323-89ab-582d6bd45d36
begin

	# setup path to the Configuration.json -
	path_to_config_file = joinpath(_PATH_TO_CONFIG,"Configuration.json")
	
	# build the api user model -
	user_model_result = build_api_user_model(path_to_config_file)
	user_model = checkresult(user_model_result)
	
	# return nothing from this block -
	nothing
end

# ╔═╡ 03936477-775a-4246-b196-49d875513f67
md""" #### Make Alphavantage.co API calls

Now that we have the user model, we can make Alphavantage.co API calls to download the price data using the [PooksoftAlphaVantageDataStore](https://github.com/Pooksoft/PooksoftAlphaVantageDataStore.jl) package. The list of stocks that compose the SP500 was prepared by [Rufus Pollock](http://rufuspollock.com/) and the [Open Knowledge Foundation](http://okfn.org/) and can be found [here](https://github.com/datasets/s-and-p-500-companies). We load this list, and make an API call for each element, then save the data to disk:

"""

# ╔═╡ c312c22e-0478-4559-9f81-c639bfa4f22e
begin
	
	# load the data containing the information about the SP500 companies -
	path_to_SP500_file = joinpath(_PATH_TO_DATA, "constituents.csv")
	df_SP500 = CSV.read(path_to_SP500_file, DataFrame)
	
	# let's download the weekly adjusted values for the ticker symbols in the constituents.csv file -
	# we wrap the download operation so it doesn't always execute -
	if (_SHOULD_DOWNLOAD_EXECUTE == true)
	
		# what is the current date?
		timestamp_value = "2021-05-01"
	
		# setup call -
		data_type = :csv
		outputsize = :full
	
		# get list of ticker symbols -
		list_of_ticker_symbols = df_SP500[:,1]
		for ticker_symbol in list_of_ticker_symbols
	
			# make a call to the API -
			df = execute_sts_adjusted_weekly_api_call(user_model, ticker_symbol; 
				data_type = data_type, outputsize = outputsize, logger=nothing) |> checkresult
		
			# dump to the result to disk -
			results_file_name = "WA-$(ticker_symbol)-T-$(timestamp_value).csv"
			path_to_results_file = joinpath(_PATH_TO_WEEKLY,results_file_name)
			CSV.write(path_to_results_file, df)
		
			# because of API limitations - we need to sleep a little bit here -
			sleep(30)
		end
	end
end

# ╔═╡ Cell order:
# ╟─08e679b8-2e69-42b2-8531-ca95ab8bf6b5
# ╠═9770ad46-aa7b-11eb-3d74-3f168a479469
# ╟─f77c4667-5d7a-4f74-8f06-555424505957
# ╠═5a561360-4a64-4323-89ab-582d6bd45d36
# ╟─03936477-775a-4246-b196-49d875513f67
# ╠═c312c22e-0478-4559-9f81-c639bfa4f22e
