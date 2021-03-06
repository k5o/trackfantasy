﻿/** @jsx React.DOM */

/*
   Griddle - Simple Grid Component for React
   https://github.com/DynamicTyped/Griddle
   Copyright (c) 2014 Ryan Lanciaux | DynamicTyped

   See License / Disclaimer https://raw.githubusercontent.com/DynamicTyped/Griddle/master/LICENSE
*/

var GridFilter = React.createClass({
    getDefaultProps: function(){
      return {
        "placeholderText": ""
      }
    },
    handleChange: function(event){
        value = event.target.value
        this.props.changeFilter(event.target.value);

        if (value.length > 0) {
          toggleTotalRow('hide');
        }
        else {
          toggleTotalRow('show');
        }
    },
    render: function(){
        return <div className="row filter-container"><input type="text" name="filter" placeholder={this.props.placeholderText} className="form-control" onChange={this.handleChange} /></div>
    }
});
