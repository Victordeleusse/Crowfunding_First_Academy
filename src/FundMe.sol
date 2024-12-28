// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Note: The AggregatorV3Interface might be at a different location than what was in the video!
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConvertor} from "./PriceConvertor.sol";
import {console} from "forge-std/Test.sol";

error error__NotOwner();

contract FundMe {
    using PriceConvertor for uint256;

    mapping(address => uint256) private s_addressToAmountFunded;
    address[] private s_funders;
	uint256 private s_version;
	AggregatorV3Interface private s_priceFeed;
    address private immutable i_owner;
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;

    constructor(address priceFeed, uint256 version) {
        i_owner = msg.sender;
		// console.log("OWNER OF THE CONTRACT: ", i_owner);
		s_priceFeed = AggregatorV3Interface(priceFeed);
		s_version = version;
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert error__NotOwner();
        _;
    }
    
	function fund() public payable {
		console.log("SENDER FUNDER ADDRESS", msg.sender);
		require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "You need to spend more ETH!");
		s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    function withdraw() public onlyOwner {
		uint256 fundersListLength = s_funders.length; 
        for (uint256 funderIndex = 0; funderIndex < fundersListLength; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }
   
    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

	// GETTERS -> view pure functions

	function getVersion() public view returns (uint256) {
        // return s_priceFeed.version();
		return s_version;
    }

	function getAmountByFunder(address funderAddress) external view returns (uint256) {
		return s_addressToAmountFunded[funderAddress];
	}

	function getFunderAddress(uint256 indexFunder) external view returns (address) {
		return s_funders[indexFunder];
	}

	function getOwnerAddress() external view returns (address) {
		return i_owner;
	}
}