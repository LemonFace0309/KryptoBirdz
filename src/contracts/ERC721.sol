// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

  /*

  building out the minting function
    1. nft to point to an address
    2. keep track of the token ids
    3. keep track of token owner addresses to token ids
    4. keep track of how many tokens an owner address has
    5. create an event that emits a transfer log - contract address, where it is being minted to, the id

  */

contract ERC721 {

  event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

  event Approval(
    address indexed owner,
    address indexed approved,
    uint256 indexed tokenId
  );

  mapping(uint256 => address) private _tokenOwner;
  mapping(address => uint256) private _ownedTokensCount;
  mapping(uint256 => address) private _tokenApprovals;

  /// @notice Count all NFTs assigned to an owner
  /// @dev NFTs assigned to the zero address are considered invalid, and this
  ///  function throws for queries about the zero address.
  /// @param _owner An address for whom to query the balance
  /// @return The number of NFTs owned by `_owner`, possibly zero
  function balanceOf(address _owner) public view returns (uint256) {
    require( _owner != address(0), 'owner query for non-existent token');
    return _ownedTokensCount[_owner];
  }

  /// @notice Find the owner of an NFT
  /// @dev NFTs assigned to zero address are considered invalid, and queries
  ///  about them do throw.
  /// @param _tokenId The identifier for an NFT
  /// @return The address of the owner of the NFT
  function ownerOf(uint256 _tokenId) public view returns (address) {
    address owner = _tokenOwner[_tokenId];
    require( owner != address(0), 'owner query for non-existent token');
    return owner;
  }


  function _exists(uint256 tokenId) internal view returns(bool) {
    address owner = _tokenOwner[tokenId];
    return owner != address(0);
  }

  function _mint(address to, uint256 tokenId) internal virtual {
    require(to != address(0), 'ERC721: minting to the zero address');
    require(!_exists(tokenId), 'ERC721: token already minted');
    _tokenOwner[tokenId] = to;
    _ownedTokensCount[to] += 1;

    emit Transfer(address(0), to, tokenId);
  }

  // /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
  // ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
  // ///  THEY MAY BE PERMANENTLY LOST
  // /// @dev Throws unless `msg.sender` is the current owner, an authorized
  // ///  operator, or the approved address for this NFT. Throws if `_from` is
  // ///  not the current owner. Throws if `_to` is the zero address. Throws if
  // ///  `_tokenId` is not a valid NFT.
  // /// @param _from The current owner of the NFT
  // /// @param _to The new owner
  // /// @param _tokenId The NFT to transfer
  // function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
  //   require(isApprovedOrOwner(msg.sender, _tokenId));
  // }

  // 1. require that the person approving is the owner
  // 2. we are approving an address to a token (tokenId)
  // 3. require that we can't approve sending tokens of the owner to the owner (current caller)
  // 4. update the map of the approval addresses
  function approve(address _to, uint256 tokenId) public {
    address owner = ownerOf(tokenId);
    require(msg.sender == owner, 'Current caller is not the owner');
    require(_to != owner, 'Error - approval to current owner');
    _tokenApprovals[tokenId] = _to;

    emit Approval(owner, _to, tokenId);
  }

  function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool) {
    require(_exists(tokenId), 'token does not exist');
    address owner = ownerOf(tokenId);
    // return(spender == owner || getApproved(tokenId) == spender);
    return(spender == owner);
  }
}
