pragma solidity >=0.4.22 <0.6.0;
import "./CarCoinDatabase.sol";

contract CarCoinControl is CarCoinDatabase {
    
    bool public paused = false;
    
    function setCEO(address _newCEO) external OnlyCEO NotZeroAddr(_newCEO){
        require(ceoAddress != _newCEO);
        ceoAddress = _newCEO;
    }
    
    // Access modifier for CEO-only functionality
    modifier OnlyCEO() {
        require(msg.sender == ceoAddress);
        _;
    }
    

    /*** Pausable functionality adapted from OpenZeppelin ***/

    /// @dev Modifier to allow actions only when the contract IS NOT paused
    modifier whenNotPaused {
        require(!paused);
        _;
    }

    /// @dev Modifier to allow actions only when the contract IS paused
    modifier whenPaused {
        require(paused);
        _;
    }

    function pause() external OnlyCEO whenNotPaused {
        paused = true;
    }

    function unpause() public OnlyCEO whenPaused {
        paused = false;
    }
    
    
}
    