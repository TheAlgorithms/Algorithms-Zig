const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const op = b.option([]const u8, "algorithm", "choice algoritm to build.") orelse return;

    // Sort algorithms
    if (std.mem.eql(u8, op, "sort/quicksort"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "quickSort.zig",
            .category = "sort",
        });
    if (std.mem.eql(u8, op, "sort/bubblesort"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "bubbleSort.zig",
            .category = "sort",
        });
    if (std.mem.eql(u8, op, "sort/radixsort"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "radixSort.zig",
            .category = "sort",
        });
    if (std.mem.eql(u8, op, "sort/mergesort"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "mergeSort.zig",
            .category = "sort",
        });
    if (std.mem.eql(u8, op, "sort/insertsort"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "insertionSort.zig",
            .category = "sort",
        });

    // Search algorithms
    if (std.mem.eql(u8, op, "search/bSearchTree"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "binarySearchTree.zig",
            .category = "search",
        });
    if (std.mem.eql(u8, op, "search/rb"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "redBlackTrees.zig",
            .category = "search",
        });

    // Data Structures algorithms
    if (std.mem.eql(u8, op, "ds/trie"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "trie.zig",
            .category = "dataStructures",
        });
    if (std.mem.eql(u8, op, "ds/linkedlist"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "linkedList.zig",
            .category = "dataStructures",
        });
    if (std.mem.eql(u8, op, "ds/doublylinkedlist"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "doublyLinkedList.zig",
            .category = "dataStructures",
        });
    if (std.mem.eql(u8, op, "ds/lrucache"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "lruCache.zig",
            .category = "dataStructures",
        });
    if (std.mem.eql(u8, op, "ds/stack"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "stack.zig",
            .category = "dataStructures",
        });

    // Dynamic Programming algorithms
    if (std.mem.eql(u8, op, "dp/coinChange"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "coinChange.zig",
            .category = "dynamicProgramming",
        });
    if (std.mem.eql(u8, op, "dp/knapsack"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "knapsack.zig",
            .category = "dynamicProgramming",
        });
    if (std.mem.eql(u8, op, "dp/longestIncreasingSubsequence"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "longestIncreasingSubsequence.zig",
            .category = "dynamicProgramming",
        });
    if (std.mem.eql(u8, op, "dp/editDistance"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "editDistance.zig",
            .category = "dynamicProgramming",
        });

    // Math algorithms
    if (std.mem.eql(u8, op, "math/ceil"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "ceil.zig",
            .category = "math",
        });
    if (std.mem.eql(u8, op, "math/crt"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "chineseRemainderTheorem.zig",
            .category = "math",
        });
    if (std.mem.eql(u8, op, "math/fibonacci"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "fibonacciRecursion.zig",
            .category = "math",
        });
    if (std.mem.eql(u8, op, "math/primes"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "primes.zig",
            .category = "math",
        });
    if (std.mem.eql(u8, op, "math/euclidianGCDivisor"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "euclidianGreatestCommonDivisor.zig",
            .category = "math",
        });
    if (std.mem.eql(u8, op, "math/gcd"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "gcd.zig",
            .category = "math",
        });
    if (std.mem.eql(u8, op, "math/factorial"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "factorial.zig",
            .category = "math",
        });

    // Concurrent
    if (std.mem.eql(u8, op, "threads/threadpool"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "ThreadPool.zig",
            .category = "concurrency/threads",
        });

    // Web
    if (std.mem.eql(u8, op, "web/httpClient"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "client.zig",
            .category = "web/http",
        });
    if (std.mem.eql(u8, op, "web/httpServer"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "server.zig",
            .category = "web/http",
        });
    if (std.mem.eql(u8, op, "web/tls1_3"))
        build_algorithm(b, .{
            .optimize = optimize,
            .target = target,
            .name = "X25519+Kyber768Draft00.zig",
            .category = "web/tls",
        });
}

fn build_algorithm(b: *std.Build, info: BInfo) void {
    const src = std.mem.concat(b.allocator, u8, &.{
        info.category,
        "/",
        info.name,
    }) catch @panic("concat error");

    const runner = b.dependency("runner", .{}).path("test_runner.zig");

    const exe_tests = b.addTest(.{
        .name = info.name,
        .target = info.target,
        .optimize = info.optimize,
        .root_source_file = b.path(src),
        .test_runner = runner,
    });

    const descr = b.fmt("Test the {s} algorithm", .{info.name});
    const run_exe_tests = b.addRunArtifact(exe_tests);
    const test_step = b.step("test", descr);
    test_step.dependOn(&run_exe_tests.step);
}

const BInfo = struct {
    optimize: std.builtin.OptimizeMode,
    target: std.Build.ResolvedTarget,
    name: []const u8,
    category: []const u8,
};
