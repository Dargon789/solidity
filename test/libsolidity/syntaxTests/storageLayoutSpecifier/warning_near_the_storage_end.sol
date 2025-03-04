contract A layout at 2**256 - 2**64 {}
contract C layout at 2**256 - 2**65 {
    uint[2**63] x;
    uint[2**63] y;
}
// ----
