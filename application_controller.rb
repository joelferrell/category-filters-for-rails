class ApplicationController < ActionController::Base

...

  #process selected filters and add/remove any selected by user
  def selected_filter_conditions(filter_class)

    @conditions = ""
    @included = []

    #pass in existing filters
    if params[:selected_filters]
      @selected_filters = params[:selected_filters] 
    else    
      @selected_filters = {} 
    end

    #intialise hashes to store filters
    filter_class.filters.each do |j_f|
      @selected_filters[j_f] = {} if !defined?(@selected_filters[j_f]) || @selected_filters[j_f] == nil 
    end

    @filtered = params[:filter]

    #new filter passed in - add or remove from existing as needed
    if @filtered

      if params[:remove]
        @selected_filters[@filtered].delete(params[:id])
      else
        @filter_id = params[:id]
        @filter_name = params[:name]
        @selected_filters[@filtered] = {params[:id] => params[:name]}
      end

    end

    #build up list of conditions to filter results
    if @selected_filters != {}
        @selected_filters.each do |filter, values|

          if values != {}
	    @included << filter.to_sym
            @conditions += " AND " if @conditions != ""
            @ids = []
            
            values.each do | v | 
               @ids << v[0]
            end
          
            @conditions += "#{filter}.id IN (#{@ids})"
	  end 
        end
     end

  end


  #generate filters for class/array that are passed in
  def filter_headings(filter_class, filter_collection)
   @filters = {}
    filter_class.filters.each do |f| 
    @filter = {}
    
    @filter = filter_collection.group_by(& f.to_sym) 
    
       #re-arrange hash into a usable form
       #===
       if @filter != {}   

         @sorted = {}

         @filter.each do |keys, values|
           keys.each do |key|
             values.each do |value|
               @sorted[[ key ]] ||= [ ]
               @sorted[[ key ]] << value
             end
           end

          @sorted[[ ]] = values if keys.empty?
     
         end

      @filters[f.to_sym] = @sorted

      end 
      #===

    end

  end


...

end
