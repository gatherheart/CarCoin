pragma solidity >=0.4.22 <0.6.0;

contract ERC721XReceiver {
  /**
    * @dev Magic value to be returned upon successful reception of an amount of ERC721X tokens
    *  Equals to `bytes4(keccak256("onERC721XReceived(address,uint256,bytes)"))`,
    *  which can be also obtained as `ERC721XReceiver(0).onERC721XReceived.selector`
    */
  bytes4 constant ERC721X_RECEIVED = 0x660b3370;
  bytes4 constant ERC721X_BATCH_RECEIVE_SIG = 0xe9e5be6a;

  function onERC721XReceived(address _operator, address _from, uint256 tokenId, uint256 amount, bytes memory data) public returns(bytes4);

  /**
   * @dev Handle the receipt of multiple fungible tokens from an MFT contract. The ERC721X smart contract calls
   * this function on the recipient after a `batchTransfer`. This function MAY throw to revert and reject the
   * transfer. Return of other than the magic value MUST result in the transaction being reverted.
   * Returns `bytes4(keccak256("onERC721XBatchReceived(address,address,uint256[],uint256[],bytes)"))` unless throwing.
   * @notice The contract address is always the message sender. A wallet/broker/auction application
   * MUST implement the wallet interface if it will accept safe transfers.
   * @param _operator The address which called `safeTransferFrom` function.
   * @param _from The address from which the token was transfered from.
   * @param _types Array of types of token being transferred (where each type is represented as an ID)
   * @param _amounts Array of amount of object per type to be transferred.
   * @param _data Additional data with no specified format.
   */
  function onERC721XBatchReceived(
          address _operator,
          address _from,
          uint256[] memory _types,
          uint256[] memory _amounts,
          bytes memory _data
          )
      public
      returns(bytes4);
}


contract IERC721X {
    
  function implementsERC721X() external pure returns (bool);
  function ownerOf(uint256 _tokenId) external view returns (address);
  function balanceOf(address _owner) external view returns (uint256);
  function balanceOf(address _owner, uint256 tokenId) external view returns (uint256);
  function tokensOwned(address _owner) external view returns (uint256[] memory, uint256[] memory);

  function transfer(address to, uint256 tokenId, uint256 quantity) external;
  function transferFrom(address from, address to, uint256 tokenId, uint256 quantity) external;

  // Fungible Safe Transfer From
  function safeTransferFrom(address from, address to, uint256 tokenId, uint256 quantity) external;
  function safeTransferFrom(address from, address to, uint256 tokenId, uint256 quantity, bytes calldata data) external;

  // Batch Safe Transfer From
  function safeBatchTransferFrom(address _from, address _to, 
    uint256[] calldata tokenIds, uint256[] calldata quantities, bytes calldata _data) external;

  function name() external pure returns (string memory);
  function symbol() external pure returns (string memory);

  // Required Events
  event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
  event TransferWithQuantity(address indexed from, address indexed to, uint256 indexed tokenId, uint256 quantity);
  event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
  event BatchTransfer(address indexed from, address indexed to, uint256[] tokenTypes, uint256[] amounts);
}