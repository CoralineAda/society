(function (window, factory) {
  if (typeof define === 'function' && define.amd) {
    define(['d3'], factory);
  } else if (typeof module === 'object' && module.exports) {
    module.exports = function(d3) {
      Society = factory(d3);
      return Society;
    }
  } else {
    if (!window.Society) {
      window.Society = factory(window.d3);
    }
  }
}(this, function (d3) {

  var NetworkGraph = function(element, data) {
    this.diameter = 1200;
    this.radius = this.diameter / 2;
    this.innerRadius = this.radius - 260;

    this.element = element;
    this.data = this.transformData(data);
    this.includeIsolatedNodes = true;
    this.depsFiltered = false;
  };

  NetworkGraph.prototype.transformData = function(data) {
    return(Object.keys(data).map(function(node) {
      return {
        name: node,
        relations: Object.keys(data[node]).filter(function(edge) {
          return(Object.keys(data).indexOf(edge) != -1);
        })
      };
    }));
  };

  NetworkGraph.prototype.init = function() {
    var label = this.element.append('label')
      .attr('class', 'society-network-toggle')
    label.append('input')
      .attr('type', 'checkbox')
      .attr('checked', 'checked')
      .on('click', this.toggleIsolatedNodes.bind(this));
    label.append('span').text('Show isolated nodes')
    this.svg = this.element.append('svg')
      .attr('class', 'society-graph')
      .attr('width', this.diameter)
      .attr('height', this.diameter)
      .append('g')
      .attr('transform', 'translate(' + this.radius + ',' + this.radius + ')');
    this.linkAnchor = this.svg.append('g');
    this.nodeAnchor = this.svg.append('g');
    this.render();
    d3.select(self.frameElement).style('height', this.diameter + 'px');
  };

  NetworkGraph.prototype.toggleIsolatedNodes = function() {
    this.includeIsolatedNodes = !this.includeIsolatedNodes;
    this.render();
  };

  NetworkGraph.prototype.hideIsolatedNodes = function() {
    this.includeIsolatedNodes = false;
    this.render();
  };

  NetworkGraph.prototype.showIsolatedNodes = function() {
    this.includeIsolatedNodes = true;
    this.render();
  };

  NetworkGraph.prototype.getData = function() {
    if (this.includeIsolatedNodes) {
      return this.data;
    } else {
      return filterIsolatedNodes(this.data);
    }
  };

  NetworkGraph.prototype.render = function() {
    var nodeAnchor = this.nodeAnchor;
    var linkAnchor = this.linkAnchor;
    var cluster = d3.layout.cluster()
      .size([360, this.innerRadius])
      .sort(null)
      .value(function(d) { return d.size; });
    var nodes = cluster.nodes(getPackageHierarchy(this.getData()));
    var edges = getEdges(nodes);
    var bundle = d3.layout.bundle();
    var line = d3.svg.line.radial()
      .interpolate("bundle")
      .tension(.85)
      .radius(function(d) { return d.y; })
      .angle(function(d) { return d.x / 180 * Math.PI; });

    var link = this.linkAnchor.selectAll(".society-link").data(bundle(edges), function(d) {
      return d.length == 3 ? d[0].name + " - " + d[2].name : d[0].name;
    });

    var filteredNodes = nodes.filter(function(n) { return !n.children; });
    var node = this.nodeAnchor.selectAll(".society-node").data(filteredNodes, function(d) { return d.name; });

    var mouseovered = function (d) {
      var node = nodeAnchor.selectAll(".society-node");
      var link = linkAnchor.selectAll(".society-link");
      node
        .each(function(n) { n.target = n.source = false; });

      link
        .classed("society-link--target", function(l) { if (l.target === d) return l.source.source = true; })
        .classed("society-link--source", function(l) { if (l.source === d) return l.target.target = true; })
        .filter(function(l) { return l.target === d || l.source === d; })
        .each(function() { this.parentNode.appendChild(this); });

      node
        .classed("society-node--target", function(n) { return n.target; })
        .classed("society-node--source", function(n) { return n.source; })
        .classed("society-node--faded", function(n) { return !n.target && !n.source && n !== d; });
    };

    var mouseouted = function (d) {
      var node = nodeAnchor.selectAll(".society-node");
      var link = linkAnchor.selectAll(".society-link");
      link
          .classed("society-link--target", false)
          .classed("society-link--source", false);
      node
          .classed("society-node--faded", false)
          .classed("society-node--target", false)
          .classed("society-node--source", false);
    };

    var toggleFilterOnlyDeps = function(d) {
      if (this.depsFiltered == false) {
  nodeAnchor.selectAll(".society-node--faded")
    .style("visibility", "hidden");
  linkAnchor.selectAll(".society-link")
    .filter(":not(.society-link--source)")
    .filter(":not(.society-link--target)")
    .style("visibility", "hidden");
  this.depsFiltered = true;
      } else {
  d3
    .selectAll(".society-node")
    .style("visibility", "visible");
  d3
    .selectAll(".society-link")
    .style("visibility", "visible");
  this.depsFiltered = false;
      }
    };

    document.onkeydown = function(evt) {
      evt = evt || window.event;
      if (evt.keyCode == 27) {
        d3
          .selectAll(".society-node")
          .style("visibility", "visible");
        d3
          .selectAll(".society-link")
          .style("visibility", "visible");
      }
    };

    var newNodes = node.enter().append("text")
      .attr("opacity", 0)
      .attr("transform", function(d) { return "rotate(" + (d.x - 90) + ")translate(" + (d.y + 64) + ",0)" + (d.x < 180 ? "" : "rotate(180)"); })
      .style("text-anchor", function(d) { return d.x < 180 ? "start" : "end"; })
      .attr("class", "society-node")
      .attr("dy", ".31em")
      .text(function(d) { return d.key; })
      .on("mouseover", mouseovered)
      .on("mouseout", mouseouted)
      .on("click", toggleFilterOnlyDeps);

    link.enter().append("path")
      .attr("opacity", 0)
      .attr("class", "society-link");
    link.transition().duration(1000)
      .attr("opacity", 1)
      .each(function(d) { d.source = d[0], d.target = d[d.length - 1]; })
      .attr("d", line);
    link.exit().transition().duration(250).attr("opacity", 0).remove();

    node.transition().duration(1000)
      .attr("transform", function(d) { return "rotate(" + (d.x - 90) + ")translate(" + (d.y + 8) + ",0)" + (d.x < 180 ? "" : "rotate(180)"); })
      .style("text-anchor", function(d) { return d.x < 180 ? "start" : "end"; });

    newNodes.transition().duration(1000)
        .attr("transform", function(d) { return "rotate(" + (d.x - 90) + ")translate(" + (d.y + 8) + ",0)" + (d.x < 180 ? "" : "rotate(180)"); })
        .attr("opacity", 1);

    node.exit().transition().duration(250)
        .attr("transform", function(d) { return "rotate(" + (d.x - 90) + ")translate(" + (d.y + 32) + ",0)" + (d.x < 180 ? "" : "rotate(180)"); })
        .attr("opacity", 0).remove();
  };

  // Return a list of edges for the given array of nodes.
  function getEdges(nodes) {
    var map = {};
    var edges = [];
    nodes.forEach(function(d) { map[d.name] = d; });
    nodes.forEach(function(d) {
      if (d.relations) d.relations.forEach(function(i) {
        edges.push({source: map[d.name], target: map[i]});
      });
    });
    return edges;
  };

  // Lazily construct the package hierarchy from class names.
  function getPackageHierarchy(classes) {
    var map = {};

    function find(name, data) {
      var node = map[name], i;
      if (!node) {
        node = map[name] = data || { name: name, children: [] };
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
  };


  function filterIsolatedNodes(data) {
    var json = data.slice();
    var filtered = [];
    var names = json.map(function(klass) {
      return klass.name;
    });
    json.forEach(function(klass) {
      klass.relations.forEach(function(edge) {
        if (klass.name === edge) return;
        var i = names.indexOf(edge);
        json[i]._HAS_INCOMING_ = true;
      });
    });

    json.forEach(function(klass) {
      var notSelfReference = function(edge) {
        return edge !== klass.name;
      };
      if (klass.relations.filter(notSelfReference).length || klass._HAS_INCOMING_) {
        filtered.push(klass);
      }
    });
    return filtered;
  }

  var Heatmap = function(element, data) {
    this.element = element;
    this.data = this.transformData(data);

    this.margin = {top: 200, right: 0, bottom: 10, left: 200};
    this.width = 800;
    this.height = 800;
  };

  Heatmap.prototype.transformData = function(data) {
    var _findCluster = function(nodeIndex) {
      var clusterId = null, i;
      for (i = 0; i < data.clusters.length; i++) {
        if (data.clusters[i].indexOf(nodeIndex) != -1) {
          clusterId = i;
          break;
        }
      }
      return clusterId;
    };

    var findCluster = data.clusters ? _findCluster : function() { return 0; };
    var dataKeys = Object.keys(data);

    return {
      nodes: dataKeys.map(function(node, index) {
        return { name: node, group: findCluster(index) };
      }),
      links: dataKeys.reduce(function(edges, node, source) {
        var new_edges = Object.keys(data[node]).filter(function(edge) {
          return(Object.keys(data).indexOf(edge) != -1);
        }).map(function(edge) {
          return { source: source, target: dataKeys.indexOf(edge), value: data[node][edge] };
        });
        return(edges.concat(new_edges));
      }, [])
    };
  };

  Heatmap.prototype.init = function() {
    var x = d3.scale.ordinal().rangeBands([0, this.width]),
        z = d3.scale.linear().domain([0, 4]).clamp(true),
        c = d3.scale.category10().domain(d3.range(10));

    var controls = this.element.append('div')
      .attr('class', 'society-heatmap-controls');

    var orderSelectLabel = controls.append('label')
      .attr("for", "society-heatmap-select")
      .attr('class', 'society-heatmap-select-label')
      .text('Order by:');

    var orderSelect = controls.append('select')
      .attr('class', 'society-heatmap-select')
    orderSelect.append('option').text('Name').attr('value', 'name');
    orderSelect.append('option').text('Frequency').attr('value', 'count');
    orderSelect.append('option').text('Cluster').attr('value', 'group');
    orderSelect.on('change', function() {
      order(this.value);
    });

    var coOccurrenceSvg = this.element.append("svg")
      .attr("width", this.width + this.margin.left + this.margin.right)
      .attr("class", "society-graph")
      .attr("height", this.height + this.margin.top + this.margin.bottom)
      .append("g")
      .attr("transform", "translate(" + this.margin.left + "," + this.margin.top + ")");

    var matrix = [],
        nodes = this.data.nodes,
        n = nodes.length;

    // Compute index per node.
    nodes.forEach(function(node, i) {
      node.index = i;
      node.count = 0;
      matrix[i] = d3.range(n).map(function(j) { return {x: j, y: i, z: 0}; });
    });

    // Convert links to matrix; count character occurrences.
    this.data.links.forEach(function(link) {
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
      .attr("class", "society-heatmap-bg")
      .attr("width", this.width)
      .attr("height", this.height);

    var row = coOccurrenceSvg.selectAll(".society-row")
      .data(matrix)
      .enter().append("g")
        .attr("class", "society-row")
        .attr("transform", function(d, i) { return "translate(0," + x(i) + ")"; })
        .each(row);

    row.append("line")
        .attr("class", "society-cell-outline")
        .attr("x2", this.width);

    row.append("text")
        .attr("x", -6)
        .attr("y", x.rangeBand() / 2)
        .attr("dy", ".32em")
        .attr("text-anchor", "end")
        .text(function(d, i) { return nodes[i].name; });

    var column = coOccurrenceSvg.selectAll(".society-column")
        .data(matrix)
      .enter().append("g")
        .attr("class", "society-column")
        .attr("transform", function(d, i) { return "translate(" + x(i) + ")rotate(-90)"; });

    column.append("line")
        .attr("class", "society-cell-outline")
        .attr("x1", -this.width);

    column.append("text")
        .attr("x", 6)
        .attr("y", x.rangeBand() / 2)
        .attr("dy", ".32em")
        .attr("text-anchor", "start")
        .text(function(d, i) { return nodes[i].name; });

    function row(row) {
      var cell = d3.select(this).selectAll(".society-cell")
          .data(row.filter(function(d) { return d.z; }))
          .enter().append("rect")
            .attr("class", "society-cell")
            .attr("x", function(d) { return x(d.x); })
            .attr("width", x.rangeBand())
            .attr("height", x.rangeBand())
            .style("fill-opacity", function(d) { return z(d.z); })
            .on("mouseover", mouseover)
            .on("mouseout", mouseout);
    }

    function mouseover(p) {
      d3.selectAll(".society-row text").classed("active", function(d, i) { return i == p.y; });
      d3.selectAll(".society-column text").classed("active", function(d, i) { return i == p.x; });
    }

    function mouseout() {
      d3.selectAll("text").classed("active", false);
    }

    function order(value) {
      x.domain(orders[value]);

      var t = coOccurrenceSvg.transition().duration(1000);

      t.selectAll(".society-row")
          .delay(function(d, i) { return x(i) * 0.4; })
          .attr("transform", function(d, i) { return "translate(0," + x(i) + ")"; })
        .selectAll(".society-cell")
          .delay(function(d) { return x(d.x) * 0.4; })
          .attr("x", function(d) { return x(d.x); });

      t.selectAll(".society-column")
          .delay(function(d, i) { return x(i) * 0.4; })
          .attr("transform", function(d, i) { return "translate(" + x(i) + ")rotate(-90)"; });
    }

  };

  var Society = {};
  Society.generate = function(selector, options) {
    options = options || {};

    var data = options.data || {};
    var element = d3.select(selector);
    var type = options.type || "network";

    var makeGraph = function(type, element, json) {
      var graph;
      if (type === "heatmap") {
        graph = new Heatmap(element, json);
      } else {
        graph = new NetworkGraph(element, json);
      }
      graph.init();
      return graph;
    };

    if (element.size()) {

      if (data.url) {
        json = d3.json(data.url, function(error, json) {
          return makeGraph(type, element, json);
        });
      } else if (data.json) {
        return makeGraph(type, element, data.json);
      } else {
        throw "Society.generate: no data supplied.";
      }

    } else {
      throw "Society.generate: no element found for selector: " + selector;
    }

  };

  return Society;
}));
