pragma solidity >=0.4.22 <0.6.0;
import "./CarCoinDatabase.sol";

contract CarCoinControl is CarCoinDatabase {
    
    bool public paused = false;
    mapping (address => uint8) permission; // pepermission for database
    // 1th-> read 2th-> write 3th-> execution  
    // 001 -> OnlyRead 011 -> ReadWrite 111-> all permission
    
    modifier NotZeroAddr(address addr){
        require(addr != address(0));
        _;
    }
    
    constructor() public {
        permission[ceoAddress] = 7;
    }
    
    function setCEO(address _newCEO) external OnlyCEO NotZeroAddr(_newCEO){
        require(ceoAddress != _newCEO);
        permission[ceoAddress] = 0;
        ceoAddress = _newCEO;
        permission[_newCEO] = 7;
    }
    
    function setPermission(address target, uint8 permit) public AllPermitted NotZeroAddr(target){
        require(target != msg.sender
               && permit <= 4);
               
        permission[target] = permit;
    }
    
    function permitAll(address target) public OnlyCEO NotZeroAddr(target){
        require(target != msg.sender);
        
        permission[target] = 7;
    }
    modifier OnlyCEO {
        require(msg.sender == ceoAddress);
        _;
    }
    
    // Access modifier
    modifier OnlyRead {
        require(permission[msg.sender] >= 1);
        _;
    }
    
    modifier ReadWrite {
        require(permission[msg.sender] >= 4);
        _;
    }
    
    modifier AllPermitted{
        require(permission[msg.sender] >= 7);
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
    