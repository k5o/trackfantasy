/** @jsx React.DOM */

var MoneyFormatterPlain = React.createClass({
  render: function() {
    var figure = this.props.data.toString() || "N/A";
    var length = figure.length;

    if (figure.indexOf('.') < 0) {
      figure = figure + ".00";
    }
    else if (length - figure.indexOf('.') === 2) {
      figure = figure + "0";
    }

    return <span>${ figure }</span>
  }
});