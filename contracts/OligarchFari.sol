// SPDX-License-Identifier: None

pragma solidity ^0.8.16;

contract OligarchFari {
    enum Status {
        Closed,
        Open,
        Finished
    }

    struct Case {
        address owner;
        string name;
        string description;
        uint256 deposit;
        uint256 startDate;
        uint256 endDate;
        Status status;
        Report[] reports;
    }

    struct Report {
        address reporter;
        string description;
        string urlProofs;
        bool isApproved;
    }

    uint256 private caseCounter;
    mapping(uint256 => Case) private cases;

    modifier timedTransition(uint256 caseIndex_) {
        require(caseIndex_ < caseCounter, "Invalid case index!");
        Case storage _case = cases[caseIndex_];
        if (_case.status == Status.Closed && block.timestamp >= _case.startDate && block.timestamp < _case.endDate) {
            _case.status = Status.Open;
        } else if ((_case.status == Status.Open || _case.status == Status.Closed) && block.timestamp >= _case.endDate) {
            _case.status = Status.Finished;
        }
        _;
    }

    function createCase(
        string calldata name_,
        string calldata description_,
        uint256 deposit_,
        uint256 startDate_,
        uint256 endDate_
    ) external payable {
        require(bytes(name_).length != 0, "Empty name!");
        require(bytes(description_).length != 0, "Empty description!");
        require(deposit_ > 0, "Insufficient deposit!");
        require(deposit_ == msg.value, "Deposit not equal to sended ether!");
        require(startDate_ > block.timestamp, "Invalid start date!");
        require(endDate_ > block.timestamp, "Invalid end date!");
        require(startDate_ < endDate_, "Start date is greater than end date!");

        Case storage _case = cases[caseCounter];
        _case.owner = msg.sender;
        _case.name = name_;
        _case.description = description_;
        _case.deposit = deposit_;
        _case.startDate = startDate_;
        _case.endDate = endDate_;
        caseCounter += 1;
    }

    function report(
        uint256 caseIndex_,
        string calldata description_,
        string calldata urlProofs_
    ) external timedTransition(caseIndex_) {
        require(bytes(description_).length != 0, "Empty description!");
        require(bytes(urlProofs_).length != 0, "Empty url for proofs!");

        Case storage _case = cases[caseIndex_];
        require(_case.status == Status.Open, "Case status in not Open!");

        Report memory _newReport;
        _newReport.reporter = msg.sender;
        _newReport.description = description_;
        _newReport.urlProofs = urlProofs_;
        _case.reports.push(_newReport);
    }

    function approve(
        uint256 caseIndex_,
        uint256 reportIndex_,
        uint256 amount_
    ) external timedTransition(caseIndex_) {
        require(amount_ > 0, "Invalid amount!");
        Case storage _case = cases[caseIndex_];
        require(msg.sender == _case.owner, "You are not the owner!");
        require(_case.deposit - amount_ >= 0, "Insuficient deposit balance!");
        require(reportIndex_ < _case.reports.length, "Invalid report index!");
        Report storage _report = _case.reports[reportIndex_];
        require(!_report.isApproved, "Report already approved!");

        (bool success, ) = _report.reporter.call{value: amount_}("");
        require(success, "Failed to send reward!");

        _case.deposit -= amount_;
        _report.isApproved = true;
    }

    function refund(uint256 caseIndex_) external timedTransition(caseIndex_) {
        Case storage _case = cases[caseIndex_];
        require(msg.sender == _case.owner, "You are not the owner!");
        require(_case.deposit != 0, "Nothing to refund!");
        require(_case.status == Status.Finished, "Case status is not Finished!");

        (bool success, ) = msg.sender.call{value: _case.deposit}("");
        require(success, "Failed to send refund!");

        _case.deposit = 0;
    }

    function finishCase(uint256 caseIndex_) external timedTransition(caseIndex_) {
        Case storage _case = cases[caseIndex_];
        require(msg.sender == _case.owner, "You are not the owner!");
        require(_case.status != Status.Finished, "Case status is already Finished!");
        _case.status = Status.Finished;
    }

    function getCase(uint256 caseIndex_)
        external
        view
        returns (
            address owner,
            string memory name,
            string memory description,
            uint256 deposit,
            uint256 startDate,
            uint256 endDate,
            Status status,
            Report[] memory reports
        )
    {
        require(caseIndex_ < caseCounter, "Invalid case index!");
        Case storage _case = cases[caseIndex_];
        owner = _case.owner;
        name = _case.name;
        description = _case.description;
        deposit = _case.deposit;
        startDate = _case.startDate;
        endDate = _case.endDate;
        status = _case.status;
        reports = _case.reports;
    }

    function getReport(uint256 caseIndex_, uint256 reportIndex_)
        external
        view
        returns (
            address reporter,
            string memory description,
            string memory urlProofs,
            bool isApproved
        )
    {
        require(caseIndex_ < caseCounter, "Invalid case index!");
        Case storage _case = cases[caseIndex_];
        require(reportIndex_ < _case.reports.length, "Invalid report index!");
        Report storage _report = _case.reports[reportIndex_];
        reporter = _report.reporter;
        description = _report.description;
        urlProofs = _report.urlProofs;
        isApproved = _report.isApproved;
    }
}
