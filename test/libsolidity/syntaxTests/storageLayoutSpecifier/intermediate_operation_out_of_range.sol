contract A layout at (2**256 + 1) * 2  - 2**256 - 3 {}
contract B layout at (2**2 - 2**3) * (2**5 - 2**8) {}
// ----
// Warning 3495: (11-51): This contract is very close to the end of storage. This limits its future upgradability.
