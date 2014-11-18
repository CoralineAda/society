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
    if (d.edges) d.edges.forEach(function(i) {
      edges.push({source: map[d.name], target: map[i]});
    });
  });
  return edges;
}
