// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {MockV3Aggregator} from "../test/mock/MockV3Aggregator.sol";

contract HelperConfig is Script {

	NetworkConfig public activeNetworkconfig;

	uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

	struct NetworkConfig {
		address priceFeed;
		uint256 version;
	}

	constructor () {
		if (block.chainid == 11155111) {
			activeNetworkconfig = getSepoliaEthConfig();
		} 
		else if (block.chainid == 1) {
			activeNetworkconfig = getMainnetEthConfig();
		}
		else {
			activeNetworkconfig = getOrCreateAnvilEthConfig();
		}
	}

	function getSepoliaEthConfig() public view returns(NetworkConfig memory) {
		// a function we need to return everything we could need from Sepolia
		address adPriceFeed = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
		NetworkConfig memory sepoliaNetworkConfig = NetworkConfig({priceFeed: adPriceFeed, version: AggregatorV3Interface(adPriceFeed).version()});
		return sepoliaNetworkConfig;
	}

	function getMainnetEthConfig() public view returns(NetworkConfig memory) {
		// a function we need to return everything we could need from Sepolia
		address adPriceFeed = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;
		NetworkConfig memory ethNetworkConfig = NetworkConfig({priceFeed: adPriceFeed, version: AggregatorV3Interface(adPriceFeed).version()});
		return ethNetworkConfig;
	}

	function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
		// if a network is already activated we don t want to deploy a new one !
		if (activeNetworkconfig.priceFeed != address(0)) {
            return activeNetworkconfig;
        }

		vm.startBroadcast();
		MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
		vm.stopBroadcast();

		NetworkConfig memory localNetworkConfig = NetworkConfig({priceFeed: address(mockPriceFeed), version: 0});
		return localNetworkConfig;
	}
}