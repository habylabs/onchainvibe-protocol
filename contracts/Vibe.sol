// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract Vibe is ERC20, Ownable, ERC20Permit {
    address public constant DROPPER = 0x000000000000000000000000000000000000dEaD; // Address that will airdrop tokens to holders
    uint256 public constant DROPPER_BASE_SUPPLY = 189_000_000 ether;
    uint256 public constant DROPPER_BASE_FEE = 21_000_000 ether;
    uint256 public constant LP_SUPPLY = 2_100_000_000 ether;

    uint256 public dropsCount; // Number of airdrops made

    event Drop(address indexed dropper, uint256 dropCount, uint256 amount);

    constructor(address _owner)
        ERC20("Vibe", "VIBE")
        Ownable(_owner)
        ERC20Permit("VIBE")
    {
      dropsCount = 1;

      _mint(DROPPER, DROPPER_BASE_SUPPLY);
      _mint(_owner, DROPPER_BASE_FEE + LP_SUPPLY);
    }

    function getDropCount() public view returns (uint256) {
      return dropsCount;
    }

    function drop() public onlyOwner {
      dropsCount += 1;
      _mint(DROPPER, DROPPER_BASE_SUPPLY * dropsCount);
      _mint(owner(), DROPPER_BASE_FEE * dropsCount);

      emit Drop(DROPPER, dropsCount, DROPPER_BASE_SUPPLY * dropsCount);
    }
}