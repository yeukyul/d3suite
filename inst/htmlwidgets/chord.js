HTMLWidgets.widget({

  name: 'chord',

  type: 'output',

  factory: function(el, width, height) {
     
      var colors = ["#D9753B", "#FFF0A5", "#FFB03B", "#B64926", "#8E2800", 
                     "#216B86", "#705D54", "#E0AA97", "#F1CBB6", "#F2908E",
                     "#D9A8AF", "#F2D3AC", "#BF5A36", "#C98686", "#D8BFAA",
                     "#C4A29E", "#FFD07B", "#95190C", "#A63C06", "#C36F09", 
                     "#FDB833", "#710000", "#9C3848"];

      var margin = 24;

      var outerRadius = Math.min(width, height) / 2 - 10,
            innerRadius = outerRadius - margin;

      var formatPercent = d3.format(".1%");

      var arc = d3.svg.arc()
                  .innerRadius(innerRadius)
                  .outerRadius(outerRadius);

      var layout = d3.layout.chord()
                  .padding(0.004)
                  .sortSubgroups(d3.descending)
                  .sortChords(d3.ascending);

      var path = d3.svg.chord()
                  .radius(innerRadius);

      var svg = d3.select(el).append("svg")
                  .attr("width", width)
                  .attr("height", height)
                  .append("g")
                  .attr("id", "circle")
                  .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

      svg.append("circle")
         .attr("r", outerRadius);
         
      console.log("Hello from mywidget.js!");

    return {

      renderValue: function(x) {

            var matrix = x.mat;
            var keys = x.keys;

            // Compute the chord layout.
            layout.matrix(matrix);

            // Add a group per neighborhood.
            var group = svg.selectAll(".group")
               .data(layout.groups)
               .enter().append("g")
               .attr("class", "group")
               .on("mouseover", mouseover);

            // Add a mouseover title.
            group.append("title").text(function(d, i) {
               return keys[i] + ": " + formatPercent(d.value) + " of origins";
            });

            // Add the group arc.
            var groupPath = group.append("path")
                              .attr("id", function(d, i) { return "group" + i; })
                              .attr("d", arc)
                              .style("fill", function(d, i) { return colors[i %colors.length]; });

            // Add a text label.
            var groupText = group.append("text")
                              .attr("x", 6)
                              .attr("dy", 15);

            groupText.append("textPath")
                     .attr("xlink:href", function(d, i) { return "#group" + i; })
                     .text(function(d, i) { return keys[i]; });

            // Remove the labels that don't fit. :(
            groupText.filter(function(d, i) { return groupPath[0][i].getTotalLength() / 2 - 16 < this.getComputedTextLength(); })
                     .remove();

            // Add the chords.
            var chord = svg.selectAll(".chord")
                           .data(layout.chords)
                           .enter().append("path")
                           .attr("class", "chord")
                           .style("fill", function(d) { return colors[d.source.index % colors.length]; })
                           .attr("d", path);

            // Add an elaborate mouseover title for each chord.
             chord.append("title").text(function(d) {
                return keys[d.source.index]
                   + " → " + keys[d.target.index]
                   + ": " + formatPercent(d.source.value)
                   + "\n" + keys[d.target.index]
                   + " → " + keys[d.source.index]
                   + ": " + formatPercent(d.target.value);
             });

            function mouseover(d, i) {
                  chord.classed("fade", function(p) {
                     return p.source.index != i
                     && p.target.index != i;
               });
            }


      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
