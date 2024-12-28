// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {

	function fundFundMe(address contractAddress, uint256 ethAmountSend) internal {
		FundMe contractFundMe = FundMe(payable(contractAddress));
		// vm.prank(msg.sender);
		contractFundMe.fund{value: ethAmountSend}();
	}

	function run() external {
		address contractAddress = vm.envAddress("CONTRACT_ADDRESS");
        uint256 ethAmountSend = vm.envUint("ETH_AMOUNT_SEND");      
		vm.startBroadcast();
		fundFundMe(contractAddress, ethAmountSend);
		vm.stopBroadcast();
		console.log("Successfully transfered funds.");
	}
}