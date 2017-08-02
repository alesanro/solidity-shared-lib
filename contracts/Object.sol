pragma solidity ^0.4.8;

import './Owned.sol';
import "./ERC20Interface.sol";

/**
 * @title Generic owned destroyable contract
 */
contract Object is Owned {
    /**
    *  Common result code. Means everything is fine.
    */
    uint constant OK = 1;

    function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {
        uint balance;
        for (uint i = 0; i < tokens.length; i++) {
            address token = tokens[i];
            balance = ERC20Interface(token).balanceOf(this);
            if (balance != 0) {
                ERC20Interface(token).transfer(_to, balance);
            }
        }
        return OK;
    }
}
