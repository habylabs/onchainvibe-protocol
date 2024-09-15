// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract Vibe is ERC20, Ownable, ERC20Permit {
    address public constant DROPPER = 0x85D901Febe737963eD28dfA872bDCeCE8166d68c; // Address that will airdrop tokens to holders
    
    // Total tokens at launch is 420,000,000
    uint256 public constant DROPPER_BASE_SUPPLY = 39_900_000 ether;
    uint256 public constant DROPPER_BASE_FEE = 2_100_000 ether;
    uint256 public constant LP_SUPPLY = 378_000_000 ether;

    uint256 public dropsCount; // Number of airdrops made

    event Drop(address indexed dropper, uint256 dropCount, uint256 amount);
    event SendVibes(address indexed from, address indexed to, uint256 amount, string message);

    constructor(address _owner)
        ERC20("Vibe", "VIBE")
        Ownable(_owner)
        ERC20Permit("VIBE")
    {
      dropsCount = 1;

      _mint(DROPPER, DROPPER_BASE_SUPPLY);
      _mint(_owner, DROPPER_BASE_FEE + LP_SUPPLY);
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
      return _transferWithMessage(msg.sender, to, amount, "");
    }

    function transfer(address to, uint256 amount, string memory message) public virtual returns (bool) {
      return _transferWithMessage(msg.sender, to, amount, message);
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
      return _transferFromWithMessage(from, to, amount, "");
    }

    function transferFrom(address from, address to, uint256 amount, string memory message) public virtual returns (bool) {
      return _transferFromWithMessage(from, to, amount, message);
    }

    function _transferWithMessage(address from, address to, uint256 amount, string memory message) internal virtual returns (bool) {
      _transfer(from, to, amount);
      emit Transfer(from, to, amount);
      emit SendVibes(from, to, amount, message);
      return true;
    }

    function _transferFromWithMessage(address from, address to, uint256 amount, string memory message) internal virtual returns (bool) {
      address spender = _msgSender();
      _spendAllowance(from, spender, amount);
      _transfer(from, to, amount);
      emit Transfer(from, to, amount);
      emit SendVibes(from, to, amount, message);
      return true;
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