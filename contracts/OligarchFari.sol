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
        uint256 reportCounter;
        mapping(uint256 => Report) reports;
    }

    struct Report {
        address reporter;
        string description;
        string urlProofs;
        bool isApproved;
    }

    uint256 private caseCounter;
    mapping(uint256 => Case) private cases;

    function createCase(
        string calldata name_,
        string calldata description_,
        uint256 startDate_,
        uint256 endDate_
    ) external payable {
        require(bytes(name_).length != 0, "Empty name!");
        require(bytes(description_).length != 0, "Empty description!");
        require(msg.value > 0, "Invalid deposit!");
        require(startDate_ > block.timestamp, "Invalid start date!");
        require(endDate_ > block.timestamp, "Invalid end date!");
        require(startDate_ < endDate_, "Start date is greater than end date!");

        Case storage _case = cases[caseCounter];
        _case.owner = msg.sender;
        _case.name = name_;
        _case.description = description_;
        _case.deposit = msg.value;
        _case.startDate = startDate_;
        _case.endDate = endDate_;
        caseCounter += 1;
    }

    function report(
        uint256 caseIndex_,
        string calldata description_,
        string calldata urlProofs_
    ) external {
        require(caseIndex_ < caseCounter, "Invalid case index!");
        Case storage _case = cases[caseIndex_];
        require(bytes(description_).length != 0, "Empty description!");
        require(bytes(urlProofs_).length != 0, "Empty url for proofs!");
        require(cases[caseIndex_].startDate <= block.timestamp, "Reporting not started yet!");

        Report storage _report = _case.reports[_case.reportCounter];
        _report.reporter = msg.sender;
        _report.description = description_;
        _report.urlProofs = urlProofs_;
        _case.reportCounter += 1;
    }

    function approve(
        uint256 caseIndex_,
        uint256 reportIndex_,
        uint256 amount_
    ) external {
        require(amount_ > 0, "Invalid amount!");
        require(caseIndex_ < caseCounter, "Invalid case index!");
        Case storage _case = cases[caseIndex_];
        require(msg.sender == _case.owner, "You are not the owner!");
        require(_case.deposit - amount_ >= 0, "Insuficient deposit balance!");
        require(reportIndex_ < _case.reportCounter, "Invalid report index!");
        Report storage _report = _case.reports[reportIndex_];
        require(!_report.isApproved, "Report already approved!");

        (bool success, ) = _report.reporter.call{value: amount_}("");
        require(success, "Failed to send reward!");

        _case.deposit -= amount_;
        _report.isApproved = true;
    }

    function refund(uint256 caseIndex_) external {
        require(caseIndex_ < caseCounter, "Invalid case index!");
        Case storage _case = cases[caseIndex_];
        require(msg.sender == _case.owner, "You are not the owner!");
        require(_case.deposit != 0, "Nothing to refund!");
        require(_case.endDate <= block.timestamp, "Case not ended yet!");

        (bool success, ) = msg.sender.call{value: _case.deposit}("");
        require(success, "Failed to send refund!");

        _case.deposit = 0;
    }
}
