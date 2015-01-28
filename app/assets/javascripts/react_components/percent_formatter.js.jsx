/** @jsx React.DOM */

var PercentFormatter = React.createClass({
  render: function() {
    var figure = this.props.data.toString() || "N/A";
    var klass = figure && figure[0] === "-" ? "in-the-red" : "in-the-black"
    var length = figure.length

    if (figure.indexOf('.') < 0) {
      figure = figure + ".00";
    }
    else if (length - figure.indexOf('.') === 2) {
      figure = figure + "0";
    }

    return <span className={ klass }>{ figure }%</span>
  }
});