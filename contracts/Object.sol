pragma solidity ^0.4.8;

import './Owned.sol';
import './Destroyable.sol';

/**
 * @title Generic owned destroyable contract
 */
contract Object is Owned, Destroyable {
    /**
    *  Common result code. Means everything is fine.
    */
    uint constant OK = 1;

    function Object() Owned() {
        hammer = msg.sender;
    }
}
