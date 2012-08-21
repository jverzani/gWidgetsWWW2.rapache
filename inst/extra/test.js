// this is javascript
var x = 1;


$.ajax('http://mbostock.github.com/d3/d3.js?2.7.1',{
    dataType: 'script',
    type:'GET',
    cache: true,
    success: function(data, status, xhr) {
      alert("hi")
      //d3.select('#ogWidget_5_div').html('Look ma HTML');
    }
});