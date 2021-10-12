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

  mapping(uint256 => address) private _tokenOwner;
  mapping(address => uint256) private _ownedTokensCount;


  function _exists(uint256 tokenId) internal view returns(bool) {
    address owner = _tokenOwner[tokenId];
    return owner != address(0);
  }

  function _mint(address to, uint256 tokenId) internal {
    require(to != address(0), 'ERC721: minting to the zero address');
    require(!_exists(tokenId), 'ERC721: token already minted');
    _tokenOwner[tokenId] = to;
    _ownedTokensCount[to] += 1;

    emit Transfer(address(0), to, tokenId);
  } 

}
