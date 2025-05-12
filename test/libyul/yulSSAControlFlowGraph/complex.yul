{
    function f(a, b) -> c {
        for { let x := 42 } lt(x, a) {
            x := add(x, 1)
            if calldataload(x)
            {
                sstore(0, x)
                leave
                sstore(0x01, 0x0101)
            }
            sstore(0xFF, 0xFFFF)
        }
        {
            switch mload(x)
            case 0 {
                sstore(0x02, 0x0202)
                break
                sstore(0x03, 0x0303)
            }
            case 1 {
                sstore(0x04, 0x0404)
                leave
                sstore(0x05, 0x0505)
            }
            case 2 {
                sstore(0x06, 0x0606)
                revert(0, 0)
                sstore(0x07, 0x0707)
            }
            case 3 {
                sstore(0x08, 0x0808)
            }
            default {
                if mload(b) {
                    return(0, 0)
                    sstore(0x09, 0x0909)
                }
                    sstore(0x0A, 0x0A0A)
            }
            sstore(0x0B, 0x0B0B)
        }
        sstore(0x0C, 0x0C0C)
    }
    pop(f(1,2))
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
// LiveOut: \l\nv2 := f(2, 1)\l\
// pop(v2)\l\
// "];
// Block0_0Exit [label="MainExit"];
// Block0_0 -> Block0_0Exit;
// FunctionEntry_f_0 [label="function f:
//  c := f(v0, v1)"];
// FunctionEntry_f_0 -> Block1_0;
// Block1_0 [label="\
// Block 0; (0, max 17)\nLiveIn: v0,v1\l\
// LiveOut: v0,v1,v4\l\nv4 := 42\l\
// "];
// Block1_0 -> Block1_0Exit [arrowhead=none];
// Block1_0Exit [label="Jump" shape=oval];
// Block1_0Exit -> Block1_1 [style="solid"];
// Block1_1 [label="\
// Block 1; (1, max 17)\nLiveIn: v0,v1,v6\l\
// LiveOut: v0,v1,v6\l\nv6 := φ(\l\
// 	Block 0 => v4,\l\
// 	Block 21 => v44\l\
// )\l\
// v7 := lt(v0, v6)\l\
// "];
// Block1_1 -> Block1_1Exit;
// Block1_1Exit [label="{ If v7 | { <0> Zero | <1> NonZero }}" shape=Mrecord];
// Block1_1Exit:0 -> Block1_4 [style="solid"];
// Block1_1Exit:1 -> Block1_2 [style="solid"];
// Block1_2 [label="\
// Block 2; (2, max 17)\nLiveIn: v0,v1,v6\l\
// LiveOut: v0,v1,v6,v8\l\nv8 := mload(v6)\l\
// v9 := eq(0, v8)\l\
// "];
// Block1_2 -> Block1_2Exit;
// Block1_2Exit [label="{ If v9 | { <0> Zero | <1> NonZero }}" shape=Mrecord];
// Block1_2Exit:0 -> Block1_7 [style="solid"];
// Block1_2Exit:1 -> Block1_6 [style="solid"];
// Block1_4 [label="\
// Block 4; (4, max 4)\nLiveIn: \l\
// LiveOut: \l\nsstore(3084, 12)\l\
// "];
// Block1_4Exit [label="FunctionReturn[0]"];
// Block1_4 -> Block1_4Exit;
// Block1_6 [label="\
// Block 6; (3, max 4)\nLiveIn: \l\
// LiveOut: \l\nsstore(514, 2)\l\
// "];
// Block1_6 -> Block1_6Exit [arrowhead=none];
// Block1_6Exit [label="Jump" shape=oval];
// Block1_6Exit -> Block1_4 [style="solid"];
// Block1_7 [label="\
// Block 7; (5, max 17)\nLiveIn: v0,v1,v6,v8\l\
// LiveOut: v0,v1,v6,v8\l\nv14 := eq(1, v8)\l\
// "];
// Block1_7 -> Block1_7Exit;
// Block1_7Exit [label="{ If v14 | { <0> Zero | <1> NonZero }}" shape=Mrecord];
// Block1_7Exit:0 -> Block1_10 [style="solid"];
// Block1_7Exit:1 -> Block1_9 [style="solid"];
// Block1_9 [label="\
// Block 9; (6, max 6)\nLiveIn: \l\
// LiveOut: \l\nsstore(1028, 4)\l\
// "];
// Block1_9Exit [label="FunctionReturn[0]"];
// Block1_9 -> Block1_9Exit;
// Block1_10 [label="\
// Block 10; (7, max 17)\nLiveIn: v0,v1,v6,v8\l\
// LiveOut: v0,v1,v6,v8\l\nv21 := eq(2, v8)\l\
// "];
// Block1_10 -> Block1_10Exit;
// Block1_10Exit [label="{ If v21 | { <0> Zero | <1> NonZero }}" shape=Mrecord];
// Block1_10Exit:0 -> Block1_13 [style="solid"];
// Block1_10Exit:1 -> Block1_12 [style="solid"];
// Block1_12 [label="\
// Block 12; (8, max 8)\nLiveIn: \l\
// LiveOut: \l\nsstore(1542, 6)\l\
// revert(0, 0)\l\
// "];
// Block1_12Exit [label="Terminated"];
// Block1_12 -> Block1_12Exit;
// Block1_13 [label="\
// Block 13; (9, max 17)\nLiveIn: v0,v1,v6,v8\l\
// LiveOut: v0,v1,v6\l\nv26 := eq(3, v8)\l\
// "];
// Block1_13 -> Block1_13Exit;
// Block1_13Exit [label="{ If v26 | { <0> Zero | <1> NonZero }}" shape=Mrecord];
// Block1_13Exit:0 -> Block1_16 [style="solid"];
// Block1_13Exit:1 -> Block1_15 [style="solid"];
// Block1_15 [label="\
// Block 15; (10, max 14)\nLiveIn: v0,v1,v6\l\
// LiveOut: v0,v1,v6\l\nsstore(2056, 8)\l\
// "];
// Block1_15 -> Block1_15Exit [arrowhead=none];
// Block1_15Exit [label="Jump" shape=oval];
// Block1_15Exit -> Block1_5 [style="solid"];
// Block1_16 [label="\
// Block 16; (15, max 17)\nLiveIn: v0,v1,v6\l\
// LiveOut: v0,v1,v6\l\nv30 := mload(v1)\l\
// "];
// Block1_16 -> Block1_16Exit;
// Block1_16Exit [label="{ If v30 | { <0> Zero | <1> NonZero }}" shape=Mrecord];
// Block1_16Exit:0 -> Block1_18 [style="solid"];
// Block1_16Exit:1 -> Block1_17 [style="solid"];
// Block1_5 [label="\
// Block 5; (11, max 14)\nLiveIn: v0,v1,v6\l\
// LiveOut: v0,v1,v6\l\nsstore(2827, 11)\l\
// "];
// Block1_5 -> Block1_5Exit [arrowhead=none];
// Block1_5Exit [label="Jump" shape=oval];
// Block1_5Exit -> Block1_3 [style="solid"];
// Block1_17 [label="\
// Block 17; (16, max 16)\nLiveIn: \l\
// LiveOut: \l\nreturn(0, 0)\l\
// "];
// Block1_17Exit [label="Terminated"];
// Block1_17 -> Block1_17Exit;
// Block1_18 [label="\
// Block 18; (17, max 17)\nLiveIn: v0,v1,v6\l\
// LiveOut: v0,v1,v6\l\nsstore(2570, 10)\l\
// "];
// Block1_18 -> Block1_18Exit [arrowhead=none];
// Block1_18Exit [label="Jump" shape=oval];
// Block1_18Exit -> Block1_5 [style="solid"];
// Block1_3 [label="\
// Block 3; (12, max 14)\nLiveIn: v0,v1,v6\l\
// LiveOut: v0,v1,v44\l\nv44 := add(1, v6)\l\
// v45 := calldataload(v44)\l\
// "];
// Block1_3 -> Block1_3Exit;
// Block1_3Exit [label="{ If v45 | { <0> Zero | <1> NonZero }}" shape=Mrecord];
// Block1_3Exit:0 -> Block1_21 [style="solid"];
// Block1_3Exit:1 -> Block1_20 [style="solid"];
// Block1_20 [label="\
// Block 20; (13, max 13)\nLiveIn: v44\l\
// LiveOut: \l\nsstore(v44, 0)\l\
// "];
// Block1_20Exit [label="FunctionReturn[0]"];
// Block1_20 -> Block1_20Exit;
// Block1_21 [label="\
// Block 21; (14, max 14)\nLiveIn: v0,v1,v44\l\
// LiveOut: v0,v1,v44\l\nsstore(65535, 255)\l\
// "];
// Block1_21 -> Block1_21Exit [arrowhead=none];
// Block1_21Exit [label="Jump" shape=oval];
// Block1_21Exit -> Block1_1 [style="dashed"];
// }
