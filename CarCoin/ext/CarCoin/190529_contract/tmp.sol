pragma solidity >=0.4.22 < 0.6.0;

contract tmp {
    // event
    
    modifier NotZeroAddr(){
        require(msg.sender == address(0));
        _;
    }
    
    function transferOwnership() public view NotZeroAddr returns(string memory) {
        return "HelloWorld";
    }   
}
  