pragma solidity >=0.4.22 <0.6.0;

import "./IERC721.sol";
import "./SafeMath.sol";


contract ERC721 is IERC721, ERC165 {
    
    
    using SafeMath for uint256;
    
    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
    
    mapping (uint256 => address) internal _tokenOwner;
    mapping (uint256 => address) internal _tokenApprovals;
    mapping (address => mapping (address => bool)) internal _operatorApprovals;
    mapping (address => uint256) internal _ownedTokenCount;

    
    constructor () public {
        _registerInterface(_INTERFACE_ID_ERC721);
    }
    
    
    modifier NotZeroAddr(address addr){
        require(addr != address(0), "ERC721: Address is zero"); 
        _;
    }
    
    modifier ExistingToken(uint256 tokenId){
        address owner = _tokenOwner[tokenId];
        require(owner != address(0), "ERC721: Nonexistent token");
        _;
    }
    
    modifier NotExistingToken(uint256 tokenId){
        address owner = _tokenOwner[tokenId];
        require(owner == address(0), "ERC721: Already existing token");
        _;
    }
    
    modifier TokenAllowedTo(uint256 tokenId, address addr){
        address owner = _tokenOwner[tokenId];
        require(
            _isApprovedOrOwner(addr, tokenId), 
            "ERC721: No token allowance or Not owner"
            );
        _;
    }
    
    // Make new coin for the address to
    function _mint(address to, uint256 tokenId) internal NotZeroAddr(to) NotExistingToken(tokenId) {
        
        _tokenOwner[tokenId] = to;
        _ownedTokenCount[to] = _ownedTokenCount[to].incr();

        emit Transfer(address(0), to, tokenId);
    }
    
    // Remove ExistingToken 
    function _burn(address owner, uint256 tokenId) internal TokenAllowedTo(tokenId, owner){
        
        _clearApproval(tokenId);

        _ownedTokenCount[owner] = _ownedTokenCount[owner].decr();
        _tokenOwner[tokenId] = address(0);

        emit Transfer(owner, address(0), tokenId);
    }
    
    function _burn(uint256 tokenId) internal {
        _burn(_tokenOwner[tokenId], tokenId);
    }

    function balanceOf(address owner) external view NotZeroAddr(owner) returns (uint256){
        return _ownedTokenCount[owner];    
    }
    
    function ownerOf(uint256 tokenId) external view ExistingToken(tokenId) returns (address){
        address owner = _tokenOwner[tokenId];
        return owner;
    }
    
    function approve(address to, uint256 tokenId) 
        external NotZeroAddr(to) ExistingToken(tokenId) TokenAllowedTo(tokenId, msg.sender){
        // should be owner of the token or approved by the owner 
        
        address owner = this.ownerOf(tokenId);
        // target address should not be token owner 
        require(to != owner);

        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }
    
    function getApproved(uint256 tokenId) external view ExistingToken(tokenId) returns (address operator){
        return _tokenApprovals[tokenId];
    }
    
    // Set approve all the coins of msg.sender to operator
    function setApprovalForAll(address operator, bool _approved) NotZeroAddr(operator) external{
        
        // operator should not be msg.sender 
        require(operator != msg.sender);
    
        _operatorApprovals[msg.sender][operator] = _approved;
        emit ApprovalForAll(msg.sender, operator, _approved);
        
    }
    // Check approval of all the coins of msg.sender to operator
    function isApprovedForAll(address owner, address operator) 
        external view NotZeroAddr(owner) NotZeroAddr(operator) returns (bool){
        
        return _operatorApprovals[owner][operator];    
    }
    
    function _isApprovedOrOwner(address spender, uint256 tokenId) private ExistingToken(tokenId) view returns (bool) {
        address owner = this.ownerOf(tokenId);
        // should be owner of the token or approved token or approved user
        return (
            spender == owner 
            || this.getApproved(tokenId) == spender 
            || this.isApprovedForAll(owner, spender)
            );
    }
    
    function transferFrom(address _from, address to, uint256 tokenId) 
        external NotZeroAddr(_from) NotZeroAddr(to) ExistingToken(tokenId) TokenAllowedTo(tokenId, msg.sender){
        // addresses should not be zero
        // token should be ExistingToken and allowed to address _from
        
        // set token clear for the new owner
        _clearApproval(tokenId);

        // Using safeMath to increase or decrease uint256
        _ownedTokenCount[_from] = _ownedTokenCount[_from].decr();
        _ownedTokenCount[to] = _ownedTokenCount[to].incr();

        _tokenOwner[tokenId] = to;

        emit Transfer(_from, to, tokenId);
    
    }
    
    function _clearApproval(uint256 tokenId) private{
        _tokenApprovals[tokenId] = address(0);
    }
    
    function safeTransferFrom(address _from, address to, uint256 tokenId) public {
        safeTransferFrom(_from, to, tokenId, "");
    }

    function safeTransferFrom(address _from, address to, uint256 tokenId, bytes memory _data) public {
        require(_checkOnERC721Received(_from, to, tokenId, _data), 
            "ERC721: transfer to non ERC721Receiver contract");
        
        this.transferFrom(_from, to, tokenId);
    }
    
    function _checkOnERC721Received(address _from, address to, uint256 tokenId, bytes memory _data)
        internal returns (bool){
        // check whether contract or not
        if (!isContract(to)) {
            return true;
        }
        // check whether ERC721Receiver is implemented or not 
        bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, _from, tokenId, _data);
        return (retval == _ERC721_RECEIVED);
    }
    
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        // If there is a contract in an address
        // than to check the size of the code at that address.
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }
    
}
