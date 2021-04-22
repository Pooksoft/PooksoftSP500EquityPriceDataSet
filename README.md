## Introduction
This repository holds price information for the stocks of the [Standard and Poor's 500](https://en.wikipedia.org/wiki/S%26P_500).

### Sources
The list of stocks that compose the SP500 was prepared by [Rufus
Pollock][rp] and the [Open Knowledge Foundation][okfn] and can be found [here][spgithub]. The price information was downloaded using the [PooksoftAlphaVantageDataStore.jl](https://github.com/Pooksoft/PooksoftAlphaVantageDataStore.jl.git) package which is a wrapper around the [AlphaVantage](https://www.alphavantage.co) financial data application programming interface (API). 

### Installation and Requirements
``PooksoftAlphaVantageDataStore.jl`` can be installed, updated, or removed using the [Julia package management system](https://docs.julialang.org/en/v1/stdlib/Pkg/). To access the package management interface, open the [Julia REPL](https://docs.julialang.org/en/v1/stdlib/REPL/), and start the package mode by pressing `]`.
While in package mode, to install ``PooksoftAlphaVantageDataStore.jl``, issue the command:

    (@v1.6) pkg> add PooksoftAlphaVantageDataStore

Alternatively, a [Pluto](https://github.com/fonsp/Pluto.jl) notebook for each type of data download has also been provided. Lastly, you'll need a free [API key from AlphaVantage](https://www.alphavantage.co/support/#api-key) if you want to download data yourself.  

### Data
The price data is provided as separate comma separated value (CSV) files where each ticker symbol appears in the filename. Each file has the columns: timestamp, open, high, low, close, adjusted_close, volume, dividend_amount and split_coefficient.

[pddl]: http://opendatacommons.org/licenses/pddl/1.0/
[rp]: http://rufuspollock.com/
[okfn]: http://okfn.org/
[spgithub]: https://github.com/datasets/s-and-p-500-companies