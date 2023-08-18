// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract CrowdFunding {
    struct Project {
        uint id;
        string name;
        uint goalAmount;
        uint currentAmount;
        address payable creator;
        bool isFunded;
    }

    uint public projectCount;
    mapping(uint => Project) public projects;

    event ProjectCreated(uint id, string name, uint goalAmount, address creator);
    event ProjectFunded(uint id, string name, uint amount, address backer);

    constructor() {
        projectCount = 0;
    }

    function createProject(string memory _name, uint _goalAmount) public {
        projectCount ++;

        projects[projectCount] = Project(
            projectCount,
            _name,
            _goalAmount,
            0,
            payable(msg.sender),
            false
        );

        emit ProjectCreated(projectCount, _name, _goalAmount, msg.sender);
    }

    function fundProject(uint _id) public payable {
        require(_id > 0 && _id <= projectCount, "Project ID not Valid");

        Project storage project = projects[_id];
        require(!project.isFunded, "Project is already Funded");

        project.currentAmount += msg.value;

        if (project.currentAmount >= project.goalAmount) {
            project.isFunded = true;
        }

        emit ProjectFunded(_id, project.name, msg.value, msg.sender);
    }
    receive() external payable{
    }

    fallback() external payable{
    }

}