// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';

contract ERC721Enumberable is ERC721 {

  uint256[] private _allTokens;

  // mapping from tokenId to position in _allTokens array
  mapping(uint256 => uint256) private _allTokensIndex;

  // mapping of owner to list of all owner token ids
  mapping(address => uint256[]) private _ownedTokens;

  // mapping from tokenId to index of the owner tokens list
  mapping(uint256 => uint256) private _ownedTokensIndex;

  /// @notice Count NFTs tracked by this contract
  /// @return A count of valid NFTs tracked by this contract, where each one of
  ///  them has an assigned and queryable owner not equal to the zero address
  function totalSupply() public view returns (uint256) {
    return _allTokens.length;
  }

  /// @notice Enumerate valid NFTs
  /// @dev Throws if `_index` >= `totalSupply()`.
  /// @param _index A counter less than `totalSupply()`
  /// @return The token identifier for the `_index`th NFT,
  ///  (sort order not specified)
  function tokenByIndex(uint256 _index) public view returns(uint256) {
    require(_index < totalSupply(), 'global index is out of bounds');
    return _allTokens[_index];
  }


  /// @notice Enumerate NFTs assigned to an owner
  /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
  ///  `_owner` is the zero address, representing invalid NFTs.
  /// @param _owner An address where we are interested in NFTs owned by them
  /// @param _index A counter less than `balanceOf(_owner)`
  /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
  ///   (sort order not specified)
    function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns(uint256) {
    require(_index < balanceOf(_owner), 'owner index is out of bounds');
    return _ownedTokens[_owner][_index];
  }

  function _mint(address to, uint256 tokenId) internal override(ERC721) {
    super._mint(to, tokenId);
  
    _addTokensToAllTokenEnumeration(tokenId);
    _addTokensToOwnerEnumeration(to, tokenId);
  }

  function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
    _allTokens.push(tokenId);
    _allTokensIndex[tokenId] = _allTokens.length - 1;
  }

  function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
    _ownedTokens[to].push(tokenId);
    _ownedTokensIndex[tokenId] = _ownedTokens[to].length - 1;
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
}
