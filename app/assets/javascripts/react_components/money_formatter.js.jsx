/** @jsx React.DOM */

var MoneyFormatter = React.createClass({
  render: function() {
    var figure = this.props.data.toString() || "N/A";

    if (figure && figure[0] === "-"){
      var klass = 'in-the-red';
      figure = '-$' + figure.substr(1);
    }
    else {
      var klass = 'in-the-black';
      figure = '$' + figure;
    }

    var length = figure.length;

    if (figure.indexOf('.') < 0) {
      figure = figure + ".00";
    }
    else if (length - figure.indexOf('.') === 2) {
      figure = figure + "0";
    }

    return <span className={ klass }>{ figure }</span>
  }
});