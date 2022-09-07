// SPDX-License-Identifier: None

pragma solidity ^0.8.16;

contract OligarchFari {
    struct Case {
        address owner;
        string name;
        string description;
        uint256 deposit;
        uint256 startDate;
        uint256 endDate;
        bool isOpened;
        Report[] reports;
    }

    struct Report {
        address reporter;
        string description;
        string urlProofs;
        bool isApproved;
    }

    Case[] private _cases;

    function createCase(
        string calldata name_,
        string calldata description_,
        uint256 endDate_
    ) external payable {
        require(bytes(name_).length != 0, "Empty name!");
        require(bytes(description_).length != 0, "Empty description!");
        require(msg.value > 0, "Invalid deposit!");
        require(endDate_ > block.timestamp, "Invalid end date!");

        _cases.push(
            Report({
                owner: msg.sender,
                name: name_,
                description: description_,
                deposit: msg.value,
                startDate: block.timestamp,
                endDate: endDate_,
                isOpened: true
            })
        );
    }

    function report(string calldata description_, string calldata urlProofs) external {
        // Creates new reporter info with proofs to case
    }

    function approve(
        uint256 caseIndex_,
        uint256 reportIndex_,
        uint256 amount_
    ) {
        // Approve report by owner of case
    }

    function refund(uint256 caseIndex_) {
        // Retreive refund for owner if deposit is not empty
    }
}
