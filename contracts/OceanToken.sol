// /contracts/OceanToken.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

// ERC20Capped already inherits from ERC20
contract OceanToken is ERC20Capped, ERC20Burnable {

    address payable public owner;
    uint256 public blockReward;
    bool public isDisabled;

    constructor(uint256 cap, uint256 reward) ERC20("OceanToken", "OCT") ERC20Capped(cap * (10 ** decimals())) {
        owner = payable(msg.sender);
        _mint(msg.sender, 70000000 * (10 ** decimals()));
        blockReward = reward * (10 ** decimals());
    }

    // Adding this func to override the _mint func which is creating conflicts
    function _mint(address account, uint256 amount) internal virtual override(ERC20Capped, ERC20) {
        require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }

    function _mintMinerReward() internal {
        _mint(block.coinbase, blockReward);
    }

    // The _beforeTokenTransfer function was replaced with _update in the latest version of OpenZeppelin
    function _beforeTokenTransfer(address from, address to, uint256 value) internal virtual override {
        if(from != address(0) && to != block.coinbase && block.coinbase != address(0) && ERC20.totalSupply() + blockReward <= cap()) {
            _mintMinerReward();
        }
        super._beforeTokenTransfer(from, to, value);
    }

    function setBlockReward(uint256 reward) public onlyOwner {
        blockReward = reward * (10 ** decimals());
    }

    function destroy() public onlyOwner {
        // selfdestruct(owner); // it is deprecated, may create security issues
         isDisabled = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // We can use this in the transfer functions
    modifier whenNotDisabled() {
        require(!isDisabled, "Contract is disabled");
        _;
    }

    
}