// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract Token{

    uint _totalSupply = 100000e14;

    mapping(address => uint) public _balanceOf;
    mapping(address => mapping(address => uint)) public _allowance; 
    mapping (address => bool) public blackList;

    address public owner;
    string public name = "Christmas";
    string public symbol = "XOXO";

    constructor() {
        owner = msg.sender;
    }

    function addToBlackList(address _addr) external returns (bool){
        require(owner == msg.sender, "Only the owner can add to the blacklist");
        require(!blackList[_addr], "The address is already blacklisted");
        blackList[_addr] = true;
        return true;
    }
    
    function removeFromBlackList(address _addr) external returns (bool){
        require(owner == msg.sender, "Only the owner can remove from the blacklist");
        require(blackList[_addr], "The address is not on the blacklist");
        blackList[_addr] = false;
        return true;
    }

    function totalSupply() external view returns(uint) {
        return _totalSupply;
    }  

    function balanceOf(address _account) external view returns(uint){
        return _balanceOf[_account];
    }

    function transfer(address _recipient, uint _amount) external returns(bool){
        require(!blackList[_recipient], "address is blacklisted");
        _balanceOf[msg.sender] -= _amount;
        _balanceOf[_recipient] += _amount;
        emit Transfer(msg.sender, _recipient, _amount);
        return true;
    }
    
    function allowance(address _owner, address _spender) external view returns(uint){
        return  _allowance[_owner][_spender];
    }

    function approve(address _spender, uint _amount) external  returns(bool){
        _allowance[msg.sender][_spender] = _amount;
        emit Approve(msg.sender, _spender, _amount);
        return true;
    }

    function mint() public {
         require(msg.sender == owner, "You are not an owner");
        _balanceOf[msg.sender] = 100e3;
    }

    function transferFrom(address _sender, address _recipient,uint _amount) external returns(bool){
        _allowance[_sender][_recipient] -= _amount;
        _balanceOf[_sender] -= _amount;
        _balanceOf[_recipient] += _amount;
        emit Transfer(_sender, _recipient, _amount);
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint amount);
    event Approve(address indexed from, address indexed to, uint amount);
}