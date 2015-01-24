/** @jsx React.DOM */

var EntryFormatter = React.createClass({
  handleClick: function() {

  },

  render: function() {
    return <a href="#" onClick={ this.handleClick }>{ this.props.data }</a>
  }
});