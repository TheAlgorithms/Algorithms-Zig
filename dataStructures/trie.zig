const std = @import("std");
const Allocator = std.mem.Allocator;
const HashMap = std.AutoArrayHashMap;

const TrieError = error{
    InvalidNode,
};

pub fn TrieNode(comptime T: type) type {
    return struct {
        const Self = @This();
        node_data: T,
        children: HashMap(u8, *Self),
        parent: ?*Self,

        fn init(node_data: T, allocator: Allocator, parent: ?*Self) TrieNode(T) {
            return TrieNode(T){
                .node_data = node_data,
                .children = HashMap(u8, *Self).init(allocator),
                .parent = parent,
            };
        }
    };
}

/// Interface to traverse the trie
fn TrieIterator(comptime T: type) type {
    return struct {
        const Self = @This();
        const NodeType = TrieNode(T);
        /// Can be dereferenced to modify node data
        node_at_iterator: *NodeType,
        fn init(node_ptr: *NodeType) Self {
            return Self{
                .node_at_iterator = node_ptr,
            };
        }

        /// Returns an optional iterator pointing to the child following the `char` edge
        pub fn go_to_child(self: Self, char: u8) ?Self {
            if (self.node_at_iterator.children.get(char)) |new_ptr| {
                return Self{
                    .node_at_iterator = new_ptr,
                };
            } else {
                return null;
            }
        }

        /// Returns an optional iterator pointing to the parent
        pub fn go_to_parent(self: Self) ?Self {
            if (self.node_at_iterator.parent) |new_ptr| {
                return Self{
                    .node_at_iterator = new_ptr,
                };
            } else {
                return null;
            }
        }
    };
}

pub fn Trie(comptime T: type) type {
    return struct {
        const Self = @This();
        const NodeType = TrieNode(T);
        const IteratorType = TrieIterator(T);
        trie_root: *NodeType,
        allocator: Allocator,

        /// Allocate a new node and return its pointer
        fn new_node(self: Self, node_data: T, parent: ?*NodeType) !*NodeType {
            const node_ptr = try self.allocator.create(NodeType);
            node_ptr.* = NodeType.init(
                node_data,
                self.allocator,
                parent,
            );
            return node_ptr;
        }

        pub fn init(root_data: T, allocator: Allocator) !Self {
            const node_ptr = try allocator.create(NodeType);
            node_ptr.* = NodeType.init(root_data, allocator, null);
            return Self{
                .trie_root = node_ptr,
                .allocator = allocator,
            };
        }

        /// Returns an iterator pointing to the root
        pub fn get_root_iterator(self: Self) IteratorType {
            return IteratorType.init(self.trie_root);
        }

        /// Add a string to the trie, assigning newly created node's data with `new_value`
        pub fn add_string(self: Self, new_string: []const u8, new_value: T) !IteratorType {
            var iterator = self.get_root_iterator();
            for (new_string) |char| {
                if (iterator.go_to_child(char)) |new_iterator| {
                    iterator = new_iterator;
                } else {
                    const node = try self.new_node(
                        new_value,
                        iterator.node_at_iterator,
                    );
                    try iterator.node_at_iterator.children.put(char, node);
                    iterator = iterator.go_to_child(char).?;
                }
            }
            return iterator;
        }

        /// traverse and write u8 to `output_buffer` for each edge traversed in dfs order
        pub fn traverse(self: Self, iterator: IteratorType, output_buffer: []u8) usize {
            var it = iterator.node_at_iterator.children.iterator();
            var write_position: usize = 0;
            while (it.next()) |entry| {
                output_buffer[write_position] = entry.key_ptr.*;
                write_position += 1;
                write_position += self.traverse(
                    IteratorType.init(entry.value_ptr.*),
                    output_buffer[write_position..output_buffer.len],
                );
            }
            return write_position;
        }

        /// Apply a function to every node in the trie.
        /// If `top_down = true`, apply the function before applying to children, and vice versa.
        pub fn apply(
            self: Self,
            iterator: IteratorType,
            func: ?*fn (node: *NodeType) void,
            top_down: bool,
        ) void {
            if (func) |f| {
                if (top_down) {
                    f(iterator.node_at_iterator);
                } else {
                    defer f(iterator.node_at_iterator);
                }
            }
            var it = iterator.node_at_iterator.children.iterator();
            while (it.next()) |entry| {
                self.apply(
                    IteratorType.init(entry.value_ptr.*),
                    func,
                    top_down,
                );
            }
        }

        fn recursive_free(self: Self, iterator: IteratorType) void {
            var it = iterator.node_at_iterator.children.iterator();
            while (it.next()) |entry| {
                self.recursive_free(IteratorType.init(entry.value_ptr.*));
            }
            iterator.node_at_iterator.children.deinit();
            self.allocator.destroy(iterator.node_at_iterator);
        }

        pub fn deinit(self: Self) void {
            self.recursive_free(self.get_root_iterator());
        }
    };
}

test "basic traverse" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const debug_allocator = gpa.allocator();
    const trie = try Trie(i32).init(0, debug_allocator);
    defer trie.deinit();
    _ = try trie.add_string("aaa", 0);
    _ = try trie.add_string("abb", 0);
    _ = try trie.add_string("abc", 0);
    //     a
    //    / \
    //   a   b
    //  /   / \
    // a   b   c
    const answer = "aaabbc";
    var buffer: [6]u8 = undefined;
    _ = trie.traverse(trie.get_root_iterator(), buffer[0..6]);
    try std.testing.expectEqualSlices(u8, buffer[0..6], answer[0..6]);
}

test "iterator traverse" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const debug_allocator = gpa.allocator();
    const trie = try Trie(i32).init(0, debug_allocator);
    defer trie.deinit();
    var it = try trie.add_string("abc", 0); // "abc"
    try std.testing.expectEqual(null, it.go_to_child('a'));
    it = it.go_to_parent().?; // "ab"
    it = it.go_to_parent().?; // "a"
    it = it.go_to_parent().?; // ""
    try std.testing.expectEqual(null, it.go_to_parent());
    const it2 = try trie.add_string("ae", 0); // "ae"
    it = it.go_to_child('a').?; // "a"
    it = it.go_to_child('e').?; // "ae"
    try std.testing.expectEqual(it, it2);
}
