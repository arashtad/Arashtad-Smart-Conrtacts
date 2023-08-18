// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ReputationSystem {
    struct User{
        uint256 id;
        string name;
        uint256 reputationScore;
    }

    uint256 public userCount;

    mapping(address => User) public users;
    mapping(address => mapping(address => bool)) public hasUpdatedReputation;
    mapping(address => bool) public hasRegistered;

    event UserRegistered(uint256 id, address user, string name);
    event ReputationUpdated(address user, uint256 reputationScore, string comment);


    function registerUser(string memory _name) public {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(!hasRegistered[msg.sender], "Already registered");

        userCount ++;
        hasRegistered[msg.sender] = true;

        users[msg.sender] = User({
            id: userCount,
            name: _name,
            reputationScore: 0
        });

        emit UserRegistered(userCount, msg.sender, _name);
    }

    function updateReputation(address _user, uint256 _reputationScore, string memory _comment) public {
        require(_user != address(0), "Invalid user address");
        require(!hasUpdatedReputation[msg.sender][_user], "You have already given score to this user");
        require(_reputationScore >= 0, "Reputation Score must be non-negative");
        require(_reputationScore <= 10, "Reputation Score must not be greater than 10");

        users[_user].reputationScore += _reputationScore;
        hasUpdatedReputation[msg.sender][_user] = true;

        emit ReputationUpdated(_user, users[_user].reputationScore, _comment);
    }

    function getUser(address _user) public view returns(
        uint256 id,
        string memory name,
        uint256 reputationScore
    ){
        require(_user != address(0), "Invalid user address");

        User storage user = users[_user];

        return(
            user.id,
            user.name,
            user.reputationScore
        );
    }
}