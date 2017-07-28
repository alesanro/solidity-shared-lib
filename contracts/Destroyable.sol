pragma solidity ^0.4.8;

/**
 * @title Common pattern for destroyable contracts
 */
contract Destroyable {
    address public hammer;

    /**
     * @dev Hammer setter
     * @param _hammer New hammer address
     */
    function setHammer(address _hammer) onlyHammer {
        hammer = _hammer;
    }

    /**
     * @dev Destroy contract and scrub a data
     * @notice Only hammer can call it
     */
    function destroy() onlyHammer {
        suicide(msg.sender);
    }

    /**
     * @dev Hammer check modifier
     */
    modifier onlyHammer {
      if (msg.sender != hammer) {
          throw;
      }

      _;
    }
}
