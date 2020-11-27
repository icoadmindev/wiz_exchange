pragma solidity ^0.7.0;

abstract contract Token_interface {
    function owner() public view virtual returns (address);
    function decimals() public view virtual returns (uint8);
    function balanceOf(address who) public view virtual returns (uint256);
    
    function transfer(address _to, uint256 _value) public virtual returns (bool);
    function allowance(address _owner, address _spender) public virtual returns (uint);
    function transferFrom(address _from, address _to, uint _value) public virtual returns (bool);
}
