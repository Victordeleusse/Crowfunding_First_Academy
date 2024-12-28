// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
	
	FundMe fundMeContract;
	address USER = makeAddr("user");
	address USER2 = makeAddr("user2");
	uint256 constant STARTING_BALANCE = 10 ether;

	modifier sendFund() {
        vm.prank(USER); // set the next transcation's sender to USER
		fundMeContract.fund{value: 1e17}();
        _;
    }

	function setUp() external {
		// console.log("TESTER ADDRESS:", address(this));
		DeployFundMe deployFundMe = new DeployFundMe();
		// console.log("DEPLOYER ADDRESS:", address(deployFundMe));
		fundMeContract = deployFundMe.run();
		// console.log("CONTRACT ADDRESS AFTER RUN:", address(fundMeContract));
		vm.deal(USER, STARTING_BALANCE);
		vm.deal(USER2, STARTING_BALANCE);
	}

	function testMinAmount() public view {
		assertEq(fundMeContract.MINIMUM_USD(), 5 * 10 ** 18);
	}

	function testOwner() public view {
		// assertEq(fundMeContract.i_owner(), address(this));
		assertEq(fundMeContract.getOwnerAddress(), msg.sender);
	}

	function testVersionPriceFeed() public view {
		assertEq(fundMeContract.getVersion(), 0);
	}

	function testFundFailsBecauseNotEnoughAmount() public {
		vm.expectRevert();
		fundMeContract.fund();
	}

	function testUpdatesAfterFunding() public {
		fundMeContract.fund{value: 1e17}();
		address firstFunder = fundMeContract.getFunderAddress(0);
		// console.log(firstFunder);
		// console.log(address(this));
		uint256 amountFirstFunderEth = fundMeContract.getAmountByFunder(firstFunder);
		console.log(amountFirstFunderEth);
	}

	function testUserFunding() public sendFund {
		address firstFunder = fundMeContract.getFunderAddress(0);
		assertEq(firstFunder, USER);
	}

	function testOnlyOwnerWithdraw() public sendFund {
		uint256 balanceOwner = fundMeContract.getOwnerAddress().balance;
		uint256 balanceContract = address(fundMeContract).balance;
		
		vm.prank(fundMeContract.getOwnerAddress());
		fundMeContract.withdraw();

		require(fundMeContract.getOwnerAddress().balance == balanceOwner + balanceContract, "An error occured when withdrawing the funds.");
		require(address(fundMeContract).balance == 0, "An error occured after withdrawing the funds.");
	}
}