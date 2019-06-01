pragma solidity >=0.4.22 <0.6.0;
import "./IERC721.sol";
import "./SafeMath.sol";
import "./ArrayUtils.sol";

contract ERC721XTokenNFT is IERC721, ERC165 {
    
    using SafeMath for uint256;
    using ArrayUtils for uint256[];
    using ArrayUtils for address[];
    
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    
    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
    
    uint256[] internal allTokens;
    //mapping owner's address to tokenId to balances
    mapping(address => mapping(uint256 => uint256)) internal tokenBalance;
    //mapping owner's address to owned tokens 
    mapping(address => uint256 []) internal ownedTokenList;
    mapping(uint256 => uint256) public tokenType;
    
    mapping(uint256 => address) private tokenOwner;
    // first address allow second address to use first address's tokens 
    mapping(address => mapping(address => bool)) internal _operatorApprovals;
    mapping (uint256 => address) internal _tokenApprovals;
    
    uint256 constant NFT = 1;
    uint256 constant FT = 2;
    
    constructor () public {
        _registerInterface(_INTERFACE_ID_ERC721);
    }
    
    modifier NotZeroAddr(address addr){
        require(addr != address(0), "ERC721: Address is zero"); 
        _;
    }
    
    modifier ExistingToken(uint256 tokenId){
        address owner = tokenOwner[tokenId];
        require(owner != address(0), "ERC721: Nonexistent token");
        _;
    }
    
    modifier NotExistingToken(uint256 tokenId){
        address owner = tokenOwner[tokenId];
        require(owner == address(0), "ERC721: Already existing token");
        _;
    }
    
    modifier TokenAllowedTo(uint256 tokenId, address addr){
        address owner = tokenOwner[tokenId];
        require(
            _isApprovedOrOwner(addr, tokenId), 
            "ERC721: No token allowance or Not owner"
            );
        _;
    }
    
    function totalSupply() public view returns (uint256) {
        return allTokens.length;
    }
    
    function name() external pure returns (string memory) {
        return "ERC721XTokenNFT";
    }

    function symbol() external pure returns (string memory) {
        return "ERC721X";
    }

    function exists(uint256 _tokenId) public view returns (bool) {
        return tokenType[_tokenId] != 0;
    }

    function implementsERC721() public pure returns (bool) {
        return true;
    }

    function tokenByIndex(uint256 _index) public view returns (uint256) {
        require(_index < allTokens.length);
        return allTokens[_index];
    }
    
    function ownerOf(uint256 _tokenId) external view ExistingToken(_tokenId) returns (address){
        address owner = tokenOwner[_tokenId];
        return owner;
    }
    
    // return all tokens and balances owner has 
    function tokensOwned(address _owner) public view returns (uint256[] memory listOfToken, uint256[] memory balanceOftoken) {
        
        uint256[] memory tokenList = ownedTokenList[_owner];
        uint256[] memory balances = new uint256[](tokenList.length);
        for(uint256 i = 0; i < tokenList.length; i++){
            balances[i] = this.balanceOf(_owner, tokenList[i]);   
        }
        
        return (tokenList, balances);
    }
    
    function balanceOf(address _owner, uint256 tokenId) external view returns (uint256){
        return tokenBalance[_owner][tokenId];
    }

    function balanceOf(address _owner) external view returns (uint256) {
        return ownedTokenList[_owner].length;
    }


    function safeTransferFrom(address _from, address to, uint256 tokenId) external {
        this.safeTransferFrom(_from, to, tokenId, "");
    }

    function safeTransferFrom(address _from, address to, uint256 tokenId, bytes calldata _data) external {
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

    
    function transferFrom(address _from, address to, uint256 tokenId) 
        external NotZeroAddr(_from) NotZeroAddr(to) ExistingToken(tokenId) TokenAllowedTo(tokenId, msg.sender){
        // addresses should not be zero
        // token should be ExistingToken and allowed to address _from
        // token type should be NFT
        require(tokenType[tokenId] == NFT);
        
        // set token clear for the new owner
        _clearApproval(tokenId);
        
        tokenOwner[tokenId] = to;
        ownedTokenList[_from].removeItem(tokenId);
        
        require(!ownedTokenList[to].exist(tokenId));
        ownedTokenList[to].push(tokenId);
        
        emit Transfer(_from, to, tokenId);
        
    }
    
    // set token approval cleared
    function _clearApproval(uint256 tokenId) private{
        _tokenApprovals[tokenId] = address(0);
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
    
    function approve(address to, uint256 tokenId) 
        external NotZeroAddr(to) ExistingToken(tokenId) TokenAllowedTo(tokenId, msg.sender){
        // should be owner of the token or approved by the owner 
        
        address owner = this.ownerOf(tokenId);
        // target address should not be token owner 
        require(to != owner);

        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    // Make new coin for the address to
    function _mint(address to, uint256 tokenId) internal NotZeroAddr(to) NotExistingToken(tokenId) {
        
        tokenOwner[tokenId] = to;
        tokenType[tokenId] = NFT;
        tokenBalance[to][tokenId] = 1;
        
        ownedTokenList[to].push(tokenId);
        allTokens.push(tokenId);
        
        emit Transfer(address(this), to, tokenId);
    }
    
    // Remove ExistingToken 
    function _burn(address owner, uint256 tokenId) internal TokenAllowedTo(tokenId, msg.sender){
        
        _clearApproval(tokenId);

        tokenOwner[tokenId] = address(0);
        tokenType[tokenId] = 0;
        tokenBalance[owner][tokenId] = 0;
        
        ownedTokenList[owner].removeItem(tokenId);
        allTokens.removeItem(tokenId);
        
        emit Transfer(owner, address(0), tokenId);
    }
    
    function _burn(uint256 tokenId) internal {
        _burn(tokenOwner[tokenId], tokenId);
    }
    
}