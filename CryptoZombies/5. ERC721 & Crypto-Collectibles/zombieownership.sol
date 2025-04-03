//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import "./zombieattack.sol";
import "./erc721.sol";

/// @title A contract that manages transferring zombie ownership
/// @author jr-dev1001
/// @dev Complaint with Openzeppelin's implementation of ERC721 spec draft
contract ZombieOwnership is ZombieAttack, ERC721 {

  function balanceOf(address _owner) external override view returns (uint256) {
    return ownerZombieCount(_owner);
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    return zombieToOwner(_tokenId);
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerZombieCount[_to]++;
    ownerZombieCount[_from]--;
    zombieToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
    require (zombieToOwner[_tokenId] == msg.sender || zombieApprovals[_tokenId] == msg.sender);
    _transfer(_from, _to, _tokenId);
  }

  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
    zombieApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }
}
