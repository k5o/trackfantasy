/** @jsx React.DOM */

var MoneyFormatter = React.createClass({
  render: function() {
    var figure = this.props.data || "N/A";
    var moneyClass = figure && figure[0] === "-" ? "in-the-red" : "in-the-black"

    return <span className={ moneyClass }>{ figure }</span>
  }
});