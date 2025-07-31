{
    let x := calldataload(3)

    // this should yield calldataload(88) directly
    switch 1
    case 0 {
        x := calldataload(77)
    }
    case 1 {
        x := calldataload(88)
    }
    default {
        x := calldataload(99)
    }

    // this should yield the default case
    switch 55
    case 0 {
        x := calldataload(77)
    }
    case 1 {
        x := calldataload(88)
    }
    default {
        x := calldataload(99)
    }

    // this should be skipped entirely
    switch 66
    case 0 {
        x := calldataload(77)
    }
    case 1 {
        x := calldataload(88)
    }
    sstore(x, 0)
}
// ----
// digraph SSACFG {
// nodesep=0.7;
// graph[fontname="DejaVu Sans"]
// node[shape=box,fontname="DejaVu Sans"];
//
// Entry0 [label="Entry"];
// Entry0 -> Block0_0;
// Block0_0 [label="\
// Block 0; (0, max 0)\nLiveIn: \l\
// LiveOut: \l\nv1 := calldataload(3)\l\
// v4 := calldataload(88)\l\
// v7 := calldataload(99)\l\
// sstore(0, v7)\l\
// "];
// Block0_0Exit [label="MainExit"];
// Block0_0 -> Block0_0Exit;
// }
