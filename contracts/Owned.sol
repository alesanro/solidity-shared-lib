/**
 * Copyright 2017–2018, LaborX PTY
 * Licensed under the AGPL Version 3 license.
 */

pragma solidity ^0.4.21;


import "./ERC20Interface.sol";


/// @title Owned contract with safe ownership pass.
///
/// Note: all the non constant functions return false instead of throwing in case if state change
/// didn't happen yet.
contract Owned {

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    address public contractOwner;
    address public pendingContractOwner;

    modifier onlyContractOwner {
        if (msg.sender == contractOwner) {
            _;
        }
    }

    function Owned() public {
        contractOwner = msg.sender;
    }

    /// @notice Prepares ownership pass.
    /// Can only be called by current owner.
    /// @param _to address of the next owner.
    /// @return success.
    function changeContractOwnership(address _to) 
    onlyContractOwner 
    public 
    returns (bool) 
    {
        if (_to == 0x0) {
            return false;
        }
        pendingContractOwner = _to;
        return true;
    }

    /// @notice Finalize ownership pass.
    /// Can only be called by pending owner.
    /// @return success.
    function claimContractOwnership() 
    public 
    returns (bool) 
    {
        if (msg.sender != pendingContractOwner) {
            return false;
        }

        emit OwnershipTransferred(contractOwner, pendingContractOwner);
        contractOwner = pendingContractOwner;
        delete pendingContractOwner;
        return true;
    }

	/// @notice Allows the current owner to transfer control of the contract to a newOwner.
	/// @param newOwner The address to transfer ownership to.
    function transferOwnership(address newOwner) 
    onlyContractOwner 
    public 
    returns (bool) 
    {
        if (newOwner == 0x0) {
            return false;
        }

        emit OwnershipTransferred(contractOwner, newOwner);
        contractOwner = newOwner;
        return true;
    }

    /// @notice Withdraw given tokens from contract to owner.
    /// This method is only allowed for contact owner.
    function withdrawTokens(address[] tokens) 
    onlyContractOwner 
    public 
    {
        for (uint i = 0; i < tokens.length; i++) {
            ERC20Interface token = ERC20Interface(tokens[i]);
            uint balance = token.balanceOf(this);
            if (balance != 0) {
                token.transfer(msg.sender, balance);
            }
        }
    }

    /// @notice Withdraw ether from contract to owner.
    /// This method is only allowed for contact owner.
    function withdrawEther() 
    onlyContractOwner 
    external 
    {
        uint balance = address(this).balance;
        if (balance > 0)  {
            msg.sender.transfer(balance);
        }
    }
}
