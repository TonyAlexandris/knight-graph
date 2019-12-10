require_relative "tree_node"
class KnightPathFinder
    attr_reader :root_node, :considered_positions
    def initialize(start_position)
        @root_node = PolyTreeNode.new(start_position)
        @considered_positions = [start_position]
        self.build_move_tree(root_node)
    end


    def self.valid_moves(node)
        moves = Array.new(8) {node.value}
        new_moves = []
        moves.each_with_index do |move, i|
            new_move = []
            if i == 0 || i == 1
                new_move << (move[0] + 2)
                i.even? ? (new_move << move[1] + 1) : (new_move << move[1] - 1)
            elsif i == 2 || i == 3
                new_move << (move[0] - 2)
                i.even? ? (new_move << move[1] + 1) : (new_move << move[1] - 1)
            elsif i == 4 || i == 5
                i.even? ? (new_move << move[0] + 1) : (new_move << move[0] - 1)
                new_move << (move[1] + 2)
            elsif i == 6 || i == 7
                i.even? ? (new_move << move[0] + 1) : (new_move << move[0] - 1)
                new_move << (move[1] - 2)
            end
            new_moves << new_move unless new_move.any? {|coord| coord > 7 || coord < 0 }
        end
        new_moves
    end

    def new_move_positions(pos)
        new_positions = KnightPathFinder.valid_moves(pos).select {|move| !considered_positions.include?(move)}
        considered_positions.concat(new_positions)
        new_positions
    end

    def build_move_tree(root_node)
        queue = []
        queue.push(root_node)
        until queue.empty?
            check = queue.shift
            self.new_move_positions(check).each do |move|
                new_node = PolyTreeNode.new(move)
                new_node.parent = check
            end
            check.children.each {|child| queue.push(child)}
        end
    end

    def find_path(end_pos, start = self.root_node)
        return start if start.value == end_pos
        start.children.each do |child|
            result = self.find_path(end_pos, child)
            return result unless result == nil
        end
        nil
    end

    def trace_path_back(target)
        node = self.find_path(target)
        path = [node]
        until path[-1] == root_node
            path << path[-1].parent
        end
        path.reverse.map {|node| node.value}
    end
end

#kpf = KnightPathFinder.new([0, 0])
#print kpf.trace_path_back([2, 1]) # => [[0, 0], [2, 1]]
#puts
#print kpf.trace_path_back([3, 3]) # => [[0, 0], [2, 1], [3, 3]]
#puts
#print kpf.trace_path_back([7, 6]) # => [[0, 0], [1, 2], [2, 4], [3, 6], [5, 5], [7, 6]]
#puts
#print kpf.trace_path_back([6, 2]) # => [[0, 0], [1, 2], [2, 0], [4, 1], [6, 2]]
#puts