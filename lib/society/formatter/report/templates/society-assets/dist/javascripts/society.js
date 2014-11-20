
var margin = {top: 200, right: 0, bottom: 10, left: 200},
    width = 800,
    height = 800;

var x = d3.scale.ordinal().rangeBands([0, width]),
    z = d3.scale.linear().domain([0, 4]).clamp(true),
    c = d3.scale.category10().domain(d3.range(10));

var coOccurrenceSvg = d3.select("#heatmap").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .style("margin-left", -margin.left + "px")
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

d3.json(heatmapPath, function(analysis) {
  var matrix = [],
      nodes = analysis.nodes,
      n = nodes.length;

  // Compute index per node.
  nodes.forEach(function(node, i) {
    node.index = i;
    node.count = 0;
    matrix[i] = d3.range(n).map(function(j) { return {x: j, y: i, z: 0}; });
  });

  // Convert links to matrix; count character occurrences.
  analysis.links.forEach(function(link) {
    matrix[link.source][link.target].z += link.value;
    matrix[link.target][link.source].z += link.value;
    matrix[link.source][link.source].z += link.value;
    matrix[link.target][link.target].z += link.value;
    nodes[link.source].count += link.value;
    nodes[link.target].count += link.value;
  });

  // Precompute the orders.
  var orders = {
    name: d3.range(n).sort(function(a, b) { return d3.ascending(nodes[a].name, nodes[b].name); }),
    count: d3.range(n).sort(function(a, b) { return nodes[b].count - nodes[a].count; }),
    group: d3.range(n).sort(function(a, b) { return nodes[b].group - nodes[a].group; })
  };

  // The default sort order.
  x.domain(orders.name);

  coOccurrenceSvg.append("rect")
      .attr("class", "background")
      .attr("width", width)
      .attr("height", height);

  var row = coOccurrenceSvg.selectAll(".row")
      .data(matrix)
    .enter().append("g")
      .attr("class", "row")
      .attr("transform", function(d, i) { return "translate(0," + x(i) + ")"; })
      .each(row);

  row.append("line")
      .attr("x2", width);

  row.append("text")
      .attr("x", -6)
      .attr("y", x.rangeBand() / 2)
      .attr("dy", ".32em")
      .attr("text-anchor", "end")
      .text(function(d, i) { return nodes[i].name; });

  var column = coOccurrenceSvg.selectAll(".column")
      .data(matrix)
    .enter().append("g")
      .attr("class", "column")
      .attr("transform", function(d, i) { return "translate(" + x(i) + ")rotate(-90)"; });

  column.append("line")
      .attr("x1", -width);

  column.append("text")
      .attr("x", 6)
      .attr("y", x.rangeBand() / 2)
      .attr("dy", ".32em")
      .attr("text-anchor", "start")
      .text(function(d, i) { return nodes[i].name; });

  function row(row) {
    var cell = d3.select(this).selectAll(".cell")
        .data(row.filter(function(d) { return d.z; }))
      .enter().append("rect")
        .attr("class", "cell")
        .attr("x", function(d) { return x(d.x); })
        .attr("width", x.rangeBand())
        .attr("height", x.rangeBand())
        .style("fill-opacity", function(d) { return z(d.z); })
        .style("fill", function(d) { return nodes[d.x].group == nodes[d.y].group ? c(nodes[d.x].group) : null; })
        .on("mouseover", mouseover)
        .on("mouseout", mouseout);
  }

  function mouseover(p) {
    d3.selectAll(".row text").classed("active", function(d, i) { return i == p.y; });
    d3.selectAll(".column text").classed("active", function(d, i) { return i == p.x; });
  }

  function mouseout() {
    d3.selectAll("text").classed("active", false);
  }

  d3.select("#order").on("change", function() {
    order(this.value);
  });

  function order(value) {
    x.domain(orders[value]);

    var t = coOccurrenceSvg.transition().duration(2500);

    t.selectAll(".row")
        .delay(function(d, i) { return x(i) * 4; })
        .attr("transform", function(d, i) { return "translate(0," + x(i) + ")"; })
      .selectAll(".cell")
        .delay(function(d) { return x(d.x) * 4; })
        .attr("x", function(d) { return x(d.x); });

    t.selectAll(".column")
        .delay(function(d, i) { return x(i) * 4; })
        .attr("transform", function(d, i) { return "translate(" + x(i) + ")rotate(-90)"; });
  }
});

var diameter = 1200,
    radius = diameter / 2,
    innerRadius = radius - 260;

var cluster = d3.layout.cluster()
    .size([360, innerRadius])
    .sort(null)
    .value(function(d) { return d.size; });

var bundle = d3.layout.bundle();

var line = d3.svg.line.radial()
    .interpolate("bundle")
    .tension(.85)
    .radius(function(d) { return d.y; })
    .angle(function(d) { return d.x / 180 * Math.PI; });

var edgeBundlingSvg = d3.select("#network").append("svg")
    .attr("width", diameter)
    .attr("height", diameter)
    .append("g")
    .attr("transform", "translate(" + radius + "," + radius + ")");

var linkAnchor = edgeBundlingSvg.append("g");
var nodeAnchor = edgeBundlingSvg.append("g");

var rawJson;
var hideIsolatedNodes = false;

d3.json(networkPath, function(error, json) { rawJson = json; handleJson(rawJson); });

function handleJson(classes) {
  var nodes = cluster.nodes(nodesFrom(classes));
  var edges = edgesFrom(nodes);

  var link = linkAnchor.selectAll(".link").data(bundle(edges), function(d) {
    return d.length == 3 ? d[0].name + " - " + d[2].name : d[0].name;
  });
  var node = nodeAnchor.selectAll(".node").data(nodes.filter(function(n) { return !n.children; }),
      function(d) {
        return d.name;
  });

  link.enter().append("path")
      .attr("opacity", 0)
      .attr("class", "link");

  link.transition().duration(1000)
      .attr("opacity", 1)
      .each(function(d) { d.source = d[0], d.target = d[d.length - 1]; })
      .attr("d", line);

  link.exit().transition().duration(250).attr("opacity", 0).remove();

  var newNodes = node.enter().append("text")
      .attr("opacity", 0)
      .attr("transform", function(d) { return "rotate(" + (d.x - 90) + ")translate(" + (d.y + 64) + ",0)" + (d.x < 180 ? "" : "rotate(180)"); })
      .style("text-anchor", function(d) { return d.x < 180 ? "start" : "end"; })
      .attr("class", "node")
      .attr("dy", ".31em")
      .text(function(d) { return d.key; })
      .on("mouseover", mouseovered)
      .on("mouseout", mouseouted);

  node.transition().duration(1000)
      .attr("transform", function(d) { return "rotate(" + (d.x - 90) + ")translate(" + (d.y + 8) + ",0)" + (d.x < 180 ? "" : "rotate(180)"); })
      .style("text-anchor", function(d) { return d.x < 180 ? "start" : "end"; });

  newNodes.transition().duration(1000)
      .attr("transform", function(d) { return "rotate(" + (d.x - 90) + ")translate(" + (d.y + 8) + ",0)" + (d.x < 180 ? "" : "rotate(180)"); })
      .attr("opacity", 1);

  node.exit().transition().duration(250)
      .attr("transform", function(d) { return "rotate(" + (d.x - 90) + ")translate(" + (d.y + 32) + ",0)" + (d.x < 180 ? "" : "rotate(180)"); })
      .attr("opacity", 0).remove();
}

function toggleIsolated() {
  hideIsolatedNodes = !hideIsolatedNodes;
  if (!hideIsolatedNodes) handleJson(rawJson);
  else {
    // remove nodes without incoming or outgoing edges
    var json = rawJson.slice();
    var jsonFrd = [];
    var names = json.map(function(klass) { return klass.name; });
    json.forEach(function(klass) {
      klass.relations.forEach(function(edge) {
        if (klass.name === edge) return;
        var i = names.indexOf(edge);
        json[i]._HAS_INCOMING_ = true;
      });
    });

    json.forEach(function(klass) {
      var notSelfReference = function(edge) { return edge !== klass.name; };
      if (klass.relations.filter(notSelfReference).length || klass._HAS_INCOMING_) {
        jsonFrd.push(klass);
      }
    });

    handleJson(jsonFrd);
  }
}

d3.select("#network").append('button')
    .text('Toggle Isolated Nodes')
    .on('click', toggleIsolated);

function mouseovered(d) {
  var node = nodeAnchor.selectAll(".node");
  var link = linkAnchor.selectAll(".link");
  node
      .each(function(n) { n.target = n.source = false; });

  link
      .classed("link--target", function(l) { if (l.target === d) return l.source.source = true; })
      .classed("link--source", function(l) { if (l.source === d) return l.target.target = true; })
      .filter(function(l) { return l.target === d || l.source === d; })
      .each(function() { this.parentNode.appendChild(this); });

  node
      .classed("node--target", function(n) { return n.target; })
      .classed("node--source", function(n) { return n.source; })
      .classed("node--faded", function(n) { return !n.target && !n.source && n !== d; });
}

function mouseouted(d) {
  var node = nodeAnchor.selectAll(".node");
  var link = linkAnchor.selectAll(".link");
  link
      .classed("link--target", false)
      .classed("link--source", false);

  node
      .classed("node--faded", false)
      .classed("node--target", false)
      .classed("node--source", false);
}

d3.select(self.frameElement).style("height", diameter + "px");

// Lazily construct the package hierarchy from class names.
function nodesFrom(classes) {
  var map = {};

  function find(name, data) {
    var node = map[name], i;
    if (!node) {
      node = map[name] = data || {name: name, children: []};
      if (name.length) {
        node.parent = find("");
        node.parent.children.push(node);
        node.key = name;
      }
    }
    return node;
  }

  classes.forEach(function(d) {
    find(d.name, d);
  });

  return map[""];
}

// Return a list of edges for the given array of nodes.
function edgesFrom(nodes) {
  var map = {};
  var edges = [];
  nodes.forEach(function(d) { map[d.name] = d; });
  nodes.forEach(function(d) {
    if (d.relations) d.relations.forEach(function(i) {
      edges.push({source: map[d.name], target: map[i]});
    });
  });
  return edges;
}
