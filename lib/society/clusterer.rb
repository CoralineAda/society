# This file has been translated from the `minimcl` perl script, which was
# sourced from the MCL-edge library, release 14-137. The homepage for MCL-edge
# is http://micans.org/mcl
#
# The original copyright for `minimcl` is as follows:
#
#   (C) Copyright 2006, 2007, 2008, 2009 Stijn van Dongen
#
#   This file is part of MCL.  You can redistribute and/or modify MCL under the
#   terms of the GNU General Public License; either version 3 of the License or
#   (at your option) any later version.  You should have received a copy of the
#   GPL along with MCL, in the file COPYING.

module Society
  class Clusterer

    def initialize(params={})
      @params = DEFAULT_PARAMS.merge(params)
    end

    # returns an array of arrays of nodes
    def cluster(graph)
      m = matrix_from(graph)
      clusters = mcl(m)
      clusters.map { |index, members| members.keys }
              .sort_by(&:size).reverse
    end

    private

    attr_reader :params

    DEFAULT_PARAMS = {
      inflation: 2.0
    }

    # TODO: "weights" are ignored right now, but soon will be an attribute of
    #       the edge
    def matrix_from(graph)
      matrix = SparseMatrix.new
      graph.edges.each do |edge|
        a = edge.from
        b = edge.to
        matrix[a][b] = 1
        matrix[b][a] = 1
      end
      matrix
    end

    def mcl(matrix)
      matrix_add_loops(matrix)
      matrix_make_stochastic(matrix)
      chaos = 1.0
      while (chaos > 0.001) do
        sq = matrix_square(matrix)
        chaos = matrix_inflate(sq)
        matrix = sq
      end
      matrix_interpret(matrix)
    end

    def matrix_square(matrix)
      squared = SparseMatrix.new
      matrix.each do |node, vector|
        squared[node] = matrix_multiply_vector(matrix, vector)
      end
      squared
    end

    def matrix_multiply_vector(matrix, vector)
      result_vec = SparseVector.new
      vector.each do |entry, val|
        matrix[entry].each do |f, matrix_val|
          result_vec[f] += val * matrix_val
        end
      end
      result_vec
    end

    def matrix_make_stochastic(matrix)
      matrix_inflate(matrix, 1)
    end

    def matrix_add_loops(matrix)
      matrix.each do |key,_|
        matrix[key][key] = 1.0
        matrix[key][key] = vector_max(matrix[key])
      end
    end

    def vector_max(vector)
      vector.values.max || 0.0
    end

    def vector_sum(vector)
      vector.values.reduce(&:+) || 0.0
    end

    # prunes small elements as well
    def matrix_inflate(matrix, inflation = params[:inflation])
      chaos = 0.0
      matrix.each do |node, vector|
        sum = 0.0
        sumsq = 0.0
        max = 0.0
        vector.each do |node2, value|
          vector.delete node2 and next if value < 0.00001

          inflated = value ** inflation
          vector[node2] = inflated
          sum += inflated
        end
        if sum > 0.0
          vector.each do |node2, value|
            vector[node2] /= sum
            sumsq += vector[node2] ** 2
            max = [vector[node2], max].max
          end
        end
        chaos = [max - sumsq, chaos].max
      end
      chaos  # only meaningful if input is stochastic
    end

    # assumes but does not check doubly idempotent matrix.
    # can handle attractor systems of size < 10.
    # recognizes/preserves overlap.
    def matrix_interpret(matrix)
      clusters = SparseMatrix.new
      attrid = {}
      clid = 0

      # crude removal of small elements
      matrix.each do |n, vec|
        vec.each do |nb, val|
          matrix[n].delete nb if val < 0.1
        end
      end

      attr = {}
      matrix.each_key do |key|
        attr[key] = 1 if matrix[key].key? key
      end

      attr.each_key do |a|
        next if attrid.key?(a)
        aa = [a]
        while aa.size > 0 do
          bb = []
          aa.each do |aaa|
            attrid[aaa] = clid
            matrix[aaa].each_key { |akey| bb.push(akey) if attr.key? akey }
          end
          aa = bb.select { |b| !attrid.key?(b) }
        end
        clid += 1
      end

      matrix.each do |n, val|
        if !attr.key?(n)
          val.keys.select { |x| attr.key? x }.each do |a|
            clusters[attrid[a]][n] += 1
          end
        else
          clusters[attrid[n]][n] += 1
        end
      end

      clusters
    end


    module SparseMatrix
      def self.new
        Hash.new do |hash, key|
          hash[key] = SparseVector.new
        end
      end
    end

    module SparseVector
      def self.new
        Hash.new(0.0)
      end
    end
  end
end

