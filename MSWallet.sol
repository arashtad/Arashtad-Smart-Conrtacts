// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MultiSignatureWallet {
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 public requiredSignatures;

    mapping(uint256 => mapping(address => bool)) public isApproved;

    mapping(uint256 => bool) public isTransactionExecuted;
    mapping(uint256 => uint256) public transactionAmounts;

    event Deposit(address sender, uint256 amount);
    event TransactionCreated(
        uint256 indexed transactionId, 
        address indexed sender, 
        address[] signers, 
        uint256[] amounts,
        address recipient
        );

    event TransactionExecuted(uint256 indexed transactionId, address indexed executor);

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Unauthorized");
        _;
    }

    constructor (address[] memory _owners, uint256 _requiredSignatures) {
        require(_owners.length > 0 ," Owners required");
        require(_requiredSignatures > 0 && _requiredSignatures <= _owners.length, "Invalid required signatures");

        for (uint256 i = 0; i < _owners.length; i++){
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner address");
            require(!isOwner[owner], "Duplicate owner address");

            owners.push(owner);
            isOwner[owner] = true;
        }

        requiredSignatures = _requiredSignatures;
    }

    function deposit() public payable {
        emit Deposit(msg.sender, msg.value);
    }

    function createTransaction(
            address[] memory _signers, 
            uint256[] memory _amounts, 
            address _recipient) public onlyOwner {
        require(_signers.length > 0, "Signers required");
        require(_amounts.length > 0, "Amounts requires");
        require(_signers.length == _amounts.length, "Invalid input length");

        uint256 transactionId = uint256(keccak256(abi.encodePacked(block.number, block.timestamp, _recipient)));

        for (uint256 i = 0; i < _amounts.length ; i++){
            address signer = _signers[i];
            require(isOwner[signer], "Onvalid signer");
            require(!isApproved[transactionId][signer], "Duplicate Signer");

            isApproved[transactionId][signer] = true;

        }

        for (uint256 i = 0; i < _amounts.length; i++){
            transactionAmounts[transactionId] += _amounts[i];
        }

        emit TransactionCreated(transactionId, msg.sender, _signers, _amounts, _recipient);
    }

    function executeTransaction(uint256 _transactionId) public payable onlyOwner{
        require(isTransactionApproved(_transactionId),"Transaction not approved");
        require(!isTransactionExecuted[_transactionId],"TRansaction already executed");

        isTransactionExecuted[_transactionId] = true;
        address payable recipient = payable(address(uint160(getTransactionRecipient(_transactionId))));
        uint256 amount = getTransactionAmount(_transactionId);

        recipient.transfer(amount);

        emit TransactionExecuted(_transactionId, msg.sender); 
    }

    function isTransactionApproved(uint256 _transactionId) public view returns (bool) {
        uint256 approvalCount = 0;

        for(uint256 i = 0; i < owners.length; i++){
            address owner = owners[i];
            if (isApproved[_transactionId][owner]){
                approvalCount ++;
            }
            
            if(approvalCount >= requiredSignatures){
                return true;
            }
        }
        return false;
    }

    function getTransactionRecipient(uint256 _transactionId) public pure returns (address) {
        bytes memory encodedData = abi.encode(_transactionId);
        bytes32 hashedData = keccak256(encodedData);
        address recipient = address(uint160(uint256(hashedData)));
        return recipient;
    }

    function getTransactionAmount(uint256 _transactionId) public view returns(uint256){
        return transactionAmounts[_transactionId];
    }

    receive() external payable {}
    fallback() external payable {}

}