class PolyTreeNode
    def initialize(value)
        @value = value
        @parent = nil
        @children = []
    end

    def inspect
        {"value" => @value, "parent" => parent.value, "children" => @children}.inspect
    end

    def parent
        @parent
    end

    def children
        @children
    end

    def value
        @value
    end

    def parent=(node)
        if @parent != nil
            @parent.children.reject! {|child| child == self}
        end
        @parent = node
        node.children << self if @parent != nil
    end

    def add_child(child_node)
        child_node.parent = self
    end    
        
    def remove_child(child_node)
        if self.children.include?(child_node)
            child_node.parent = nil
        else
            raise ArgumentError.new("Not a child")
        end
    end

    def dfs(target)
        return self if self.value == target
        self.children.each do |child|
            result = child.dfs(target)
            return result unless result == nil
        end
        nil
    end

    def bfs(target)
        queue = []
        queue.push(self)
        until queue.empty?
            check = queue.shift
            return check if check.value == target
            check.children.each {|child| queue.push(child)}
        end
    end
end