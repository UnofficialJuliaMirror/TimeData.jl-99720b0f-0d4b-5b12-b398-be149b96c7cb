#######################
## outer contructors ##
#######################

for t = (:Timedata, :Timenum, :Timematr)
    @eval begin
        ## no names or dates (just simulated values)
        function $(t)(vals::Array{Float64, 2})
            dates = DataArray(Date, size(vals, 1))
            $(t)(DataFrame(vals), dates)
        end
        
        ## from core elements
        function $(t)(vals::Array{Float64, 2},
                         names::Array{Union(UTF8String,ASCIIString),1},
                         dates::DataArray{Date{ISOCalendar}, 1})
            df = DataFrame(vals, names)
            return $(t)(df, dates)
        end
        
        ## comprehensive constructor: very general, all elements
        function $(t){T<:Array, K<:Array, S<:Array}(vals::T, names::K, dates::S) 
            df = DataFrame(vals)
            colnames!(df, names)
            return $(t)(df, DataArray(dates))
        end
        
        ## two inputs only, general form
        function $(t){T<:Array, S<:Array}(vals::T, names::S)
            if isa(names[1], Date)
                $(t)(DataFrame(vals), DataArray(names))
            else
                $(t)(DataFrame(vals, names))
            end
        end
        
        ## no dates
        function $(t)(vals::DataFrame)
            dates = DataArray(Date, size(vals, 1))
            tn = $(t)(vals, dates)
        end
        
        ## no names
        function $(t)(vals::Array{Float64, 2}, dates::DataArray)
            $(t)(DataFrame(vals), dates)
        end
    end
end
