pragma solidity >=0.4.22 <0.6.0;
import "./ERC721XNFT.sol";
import "./IERC721X.sol";
import "./Ownerable.sol";

contract ERC721XTokenFT is IERC721X, ERC721XTokenNFT, Ownerable{
    
    using SafeMath for uint256;
    using ArrayUtils for uint256[];
    using ArrayUtils for address[];
    
    bytes4 internal constant ERC721X_RECEIVED = 0x660b3370;
    bytes4 internal constant ERC721X_BATCH_RECEIVE_SIG = 0xe9e5be6a;
    
    mapping(uint256 => address []) public tokenOwners;
    address private tokenMaker; // the contract that mint coins -> carcoin contract

    uint256 zeroCoin = 0;

    constructor(address _owner, uint256 supply) public{
        
        uint256 tokenId = zeroCoin;
        tokenType[tokenId] = FT;
        allTokens.push(tokenId);
        
        // supply zero-coins for owner of this contract
        // zero-coins will be used for cryptocurrency
        // other coins will be just for proving the value 
        
        tokenBalance[_owner][tokenId] = tokenBalance[_owner][tokenId].add(supply);
        ownedTokenList[_owner].push(tokenId);
        tokenOwners[tokenId].push(_owner);
        
        emit Transfer(address(this), _owner, tokenId);
        
    }

    modifier TokenHolder(address _owner, uint256 tokenId){
        require(tokenOwners[tokenId].exist(_owner), "Not allowed token owner for the tokenId");
        _;
    }
    
    modifier TokenMaker(address addr){
        require(
            tokenMaker == addr
            || owner == addr,
            "Not allowed token maker");
        _;
    }
    
    // Events
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event TransferWithQuantity(address indexed from, address indexed to, uint256 indexed tokenId, uint256 quantity);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
    event BatchTransfer(address indexed from, address indexed to, uint256[] tokenTypes, uint256[] amounts);
    event QuantityApproval(address indexed from, address indexed, uint256, uint256);

    function implementsERC721X() public pure returns (bool){
        return true;
    }
    
    function setTokenMaker(address addr) public onlyOwner {
        if (tokenMaker != address(0))
            setApprovalForAll(tokenMaker, false);
        tokenMaker = addr;
        setApprovalForAll(addr, true);
    }
    
    
    function setApprovalForAll(address operator, bool _approved) NotZeroAddr(operator) public{
        
        // operator should not be msg.sender 
        require(operator != msg.sender);
    
        _operatorApprovals[msg.sender][operator] = _approved;
        emit ApprovalForAll(msg.sender, operator, _approved);
        
    }
    
    function setApprovalForTokenMaker(bool _approved) NotZeroAddr(tokenMaker) TokenMaker(msg.sender) external {
        
        // set approval for operator from tx.origin 
        require(tokenMaker != tx.origin);
        
        _operatorApprovals[tx.origin][tokenMaker] = _approved;
        emit ApprovalForAll(tx.origin, tokenMaker, _approved);
        
    }
    
    
    function balanceOf(address _owner, uint256 tokenId) public view returns (uint256){
        return tokenBalance[_owner][tokenId];
    }
  
    function _transferFrom(address _from, address to, uint256 tokenId, uint256 quantity) 
        public NotZeroAddr(_from) NotZeroAddr(to) {
        
        // check whether the amount of  token is allowed or not 
        if(_from != msg.sender){
            require(_operatorApprovals[_from][msg.sender]);
        }
        require(tokenType[tokenId] == FT);
        
        require(quantity <= this.balanceOf(_from, tokenId), "Quantity exceeds balance");
        
        if(!tokenOwners[tokenId].exist(to))
            tokenOwners[tokenId].push(to);
        
        tokenBalance[_from][tokenId] = tokenBalance[_from][tokenId].sub(quantity);
        tokenBalance[to][tokenId] = tokenBalance[to][tokenId].add(quantity);
        
        if(!ownedTokenList[to].exist(tokenId)){
            ownedTokenList[to].push(tokenId);
            tokenOwners[tokenId].push(to);
        }
        if(tokenBalance[_from][tokenId] == 0){
            ownedTokenList[_from].removeItem(tokenId);
            tokenOwners[tokenId].removeItem(_from);
        }
        emit TransferWithQuantity(_from, to, tokenId, quantity);
        
    }
    
    function transfer(address to, uint256 tokenId, uint256 quantity) public {
        _transferFrom(msg.sender, to, tokenId, quantity);
    }

    function transferFrom(address _from, address to, uint256 tokenId, uint256 quantity) public{
        _transferFrom(_from, to, tokenId, quantity);
    }

    // Fungible Safe Transfer From address from to address to
    function safeTransferFrom(address _from, address to, uint256 tokenId, uint256 quantity) public{
        safeTransferFrom(_from, to, tokenId, quantity, "");
    }
    function safeTransferFrom(address _from, address to, uint256 tokenId, uint256 quantity, bytes memory data) public{
        require(_checkOnERC721XReceived(_from, to, tokenId, quantity, data), 
            "ERC721X: transfer to non ERC721XReceiver contract");
            
        _transferFrom(_from, to, tokenId, quantity);
        
    }
    
    function _checkOnERC721XReceived(address _from, address to, uint256 tokenId, uint256 quantity, bytes memory _data)
        internal returns (bool){
        // check whether contract or not
        if (!isContract(to)) {
            return true;
        }
        // check whether ERC721XReceiver is implemented or not 
        bytes4 retval = ERC721XReceiver(to).onERC721XReceived(msg.sender, _from, tokenId, quantity, _data);
        return (retval == ERC721X_RECEIVED);
    }
    
    function _checkOnERC721BatchReceived(address _from, address to, uint256[] memory tokenIds, 
        uint256[] memory quantities, bytes memory data) internal returns (bool) {
        // check whether contract or not
        if (!isContract(to)) {
            return true;
        }
        // check whether ERC721XReceiver is implemented or not 
        bytes4 retval = ERC721XReceiver(to).onERC721XBatchReceived(msg.sender, _from, tokenIds, quantities, data);
        return (retval == ERC721X_BATCH_RECEIVE_SIG);
        
    }
    
    function _batchTransferFrom(address _from, address to, uint256[] memory tokenIds, uint256[] memory quantities)
        internal NotZeroAddr(_from) NotZeroAddr(to) {
        require(tokenIds.length == quantities.length, "Wrong Usage for batchTransfer");

        for(uint256 i = 0; i < tokenIds.length; i++){
            require(tokenType[ tokenIds[i] ] == FT);
        }
        
        for(uint256 i = 0; i < tokenIds.length; i++){
            // check whether the amount of  token is allowed or not 
            if(_from != msg.sender){
                require(_operatorApprovals[_from][msg.sender]);
            }
            _transferFrom(_from, to, tokenIds[i], quantities[i]);
        }
        
        emit BatchTransfer(_from, to, tokenIds, quantities);
        
    }

    function batchTransferFrom(address _from, address _to, uint256[] memory _tokenIds, uint256[] memory _amounts) public {
        // Batch Transfering
        _batchTransferFrom(_from, _to, _tokenIds, _amounts);
    }
    
    // Batch Safe Transfer From
    function safeBatchTransferFrom(address _from, address to, uint256[] memory tokenIds, 
        uint256[] memory quantities, bytes memory _data) public{
        
        require(_checkOnERC721BatchReceived(_from, to, tokenIds, quantities, _data), 
            "ERC721X: Batch transfer to non ERC721XReceiver contract");
            
        _batchTransferFrom(_from, to, tokenIds, quantities);
        
    }

    function safeBatchTransferFrom(address _from, address to, uint256[] memory tokenIds, 
        uint256[] memory quantities) public{
        
        require(_checkOnERC721BatchReceived(_from, to, tokenIds, quantities, ""), 
            "ERC721X: Batch transfer to non ERC721XReceiver contract");
            
        _batchTransferFrom(_from, to, tokenIds, quantities);
        
    }
    
    function _mint(uint256 tokenId, address to, uint256 supply) external TokenMaker(msg.sender) {
        
        require(
            !allTokens.exist(tokenId)
            || ((msg.sender == owner) && (tokenId == zeroCoin)), 
            "Already existing token, mint is not allowed");
        
        tokenType[tokenId] = FT;
        allTokens.push(tokenId);
        
        // update token status for user
        tokenBalance[to][tokenId] = tokenBalance[to][tokenId].add(supply);
        ownedTokenList[to].push(tokenId);
        tokenOwners[tokenId].push(to);
        
        emit Transfer(address(this), to, tokenId);
    }
    
    function burn(address _owner, uint256 tokenId) external TokenMaker(msg.sender) {
        
        require(tokenOwners[tokenId].exist(_owner), "owner(param1) is not a token holder for tokenId");
        require(_operatorApprovals[_owner][msg.sender], "all tokens should be allowed to operator");
        
        tokenOwners[tokenId].removeItem(_owner);
        
        // There is no more tokens for tokenId
        if(tokenOwners[tokenId].length == 0){
            tokenType[tokenId] = 0;
            allTokens.removeItem(tokenId);
        }
        
        tokenBalance[_owner][tokenId] = 0;
        tokenOwners[tokenId].removeItem(_owner);
        ownedTokenList[_owner].removeItem(tokenId);
    
        emit Transfer(_owner, address(0), tokenId);
    }
    
    function burn(uint256 tokenId) external TokenMaker(msg.sender) {
        _burn(msg.sender, tokenId);
    }
    
}