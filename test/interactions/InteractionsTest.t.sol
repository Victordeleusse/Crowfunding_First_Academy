// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundFundMe} from "../../script/Interaction.s.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";


contract InteractionsTest is Test {

	FundMe fundMeContract;
	FundFundMe fundFundMe;

	address USER = makeAddr("user");
	uint256 constant STARTING_BALANCE = 10 ether;
	uint256 constant SEND_VALUE = 0.01 ether;

	function setUp() external {
		// DeployFundMe deployFundMe = new DeployFundMe();
		// fundMeContract = deployFundMe.run();
		vm.deal(USER, STARTING_BALANCE);
		fundFundMe = new FundFundMe();
		// fundFundMe.run(address(fundMeContract));
	}

	function testUserSendingFund() public {
		// console.log("User balance before transaction:", USER.balance);
		// console.log("USER", USER);
		vm.prank(USER);
		fundFundMe.run();
		// address funder = fundMeContract.getFunderAddress(0);
		// console.log("Address of the funder", funder);
		// console.log("Address of the USER", USER);
	}

}