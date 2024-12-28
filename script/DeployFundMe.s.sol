// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {FundMe} from "../src/FundMe.sol";
import {console} from "forge-std/Test.sol";

contract DeployFundMe is Script {
	function run() external returns (FundMe) {
		HelperConfig helperConfig = new HelperConfig();
		(address priceFeedEthUsd, uint256 version) = helperConfig.activeNetworkconfig();
		vm.startBroadcast();
		// console.log("SENDER ADDRESS:", msg.sender);
		FundMe contractFundMe = new FundMe(priceFeedEthUsd, version);
		// console.log("CONTRACT DEPLOYED ADDRESS:", address(contractFundMe));
		vm.stopBroadcast();
		return contractFundMe;
	}
}